Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab0EZL5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 07:57:34 -0400
Received: from ozlabs.org ([203.10.76.45]:57399 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab0EZL5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 07:57:32 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Regression] Crash in load_module() while freeing args
Date: Wed, 26 May 2010 21:27:24 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Brandon Philips <brandon@ifup.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
References: <201005252300.07739.rjw@sisk.pl> <alpine.LFD.2.00.1005251639420.3689@i5.linux-foundation.org> <201005261730.59058.rusty@rustcorp.com.au>
In-Reply-To: <201005261730.59058.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005262127.26235.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 05:30:58 pm Rusty Russell wrote:
> On Wed, 26 May 2010 09:17:32 am Linus Torvalds wrote:
> > 
> > On Wed, 26 May 2010, Rafael J. Wysocki wrote:
> > >
> > > I'm not able to reproduce the issue with the following commit reverted:
> > > 
> > > commit 480b02df3aa9f07d1c7df0cd8be7a5ca73893455
> > > Author: Rusty Russell <rusty@rustcorp.com.au>
> > > Date:   Wed May 19 17:33:39 2010 -0600
> > > 
> > >     module: drop the lock while waiting for module to complete initialization.
> > 
> > Hmm. That does seem to be buggy. We can't just drop and re-take the lock: 
> > that may make sense _internally_ as far as resolve_symbol() itself is 
> > concerned, but the caller will its own local variables, and some of those 
> > will no longer be valid if the lock was dropped. 
> 
> Well, yes, obviously I missed something :(  I'll look at it tonight after
> Arabella is asleep.

See if you can spot it (I acked the patch, so I can't point fingers):

 free_core:
	module_free(mod, mod->module_core);
	/* mod will be freed with core. Don't access it beyond this line! */
 free_percpu:
	percpu_modfree(mod);

Only a year after Masami fixed that and added the comment, too :(

I suspect that the increased parallelism enabled by this patch uncovered this
bug.  Does this fix it?

(Side note: the locking should be simplified.  No code before simplify_symbols
actually needs the lock, so we should grab it just for that, then again at the
end.  We use kobjects to protect us from multiple loads as a side-effect, but
we should move that registration to the end).

Subject: module: fix reference to mod->percpu after freeing module.

The comment about the mod being freed is self-explanatory, but neither
Tejun nor I read it.  This bug was introduced in 259354deaa, after it
had previously been fixed in 6e2b75740b.  How embarrassing.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>

diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2031,6 +2031,7 @@ static noinline struct module *load_modu
 	long err = 0;
 	void *ptr = NULL; /* Stops spurious gcc warning */
 	unsigned long symoffs, stroffs, *strmap;
+	void __percpu *percpu;
 
 	mm_segment_t old_fs;
 
@@ -2175,6 +2176,8 @@ static noinline struct module *load_modu
 			goto free_mod;
 		sechdrs[pcpuindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
 	}
+	/* Keep this around for failure path. */
+	percpu = mod_percpu(mod);
 
 	/* Determine total sizes, and put offsets in sh_entsize.  For now
 	   this is done generically; there doesn't appear to be any
@@ -2480,7 +2483,7 @@ static noinline struct module *load_modu
 	module_free(mod, mod->module_core);
 	/* mod will be freed with core. Don't access it beyond this line! */
  free_percpu:
-	percpu_modfree(mod);
+	free_percpu(percpu);
  free_mod:
 	kfree(args);
 	kfree(strmap);
