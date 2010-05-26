Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934783Ab0EZWzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 18:55:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45005 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934280Ab0EZWzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 18:55:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Regression] Crash in load_module() while freeing args
Date: Thu, 27 May 2010 00:56:25 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-tst; KDE/4.3.5; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Brandon Philips <brandon@ifup.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
References: <201005252300.07739.rjw@sisk.pl> <201005261730.59058.rusty@rustcorp.com.au> <201005262127.26235.rusty@rustcorp.com.au>
In-Reply-To: <201005262127.26235.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005270056.25748.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 May 2010, Rusty Russell wrote:
> On Wed, 26 May 2010 05:30:58 pm Rusty Russell wrote:
> > On Wed, 26 May 2010 09:17:32 am Linus Torvalds wrote:
> > > 
> > > On Wed, 26 May 2010, Rafael J. Wysocki wrote:
> > > >
> > > > I'm not able to reproduce the issue with the following commit reverted:
> > > > 
> > > > commit 480b02df3aa9f07d1c7df0cd8be7a5ca73893455
> > > > Author: Rusty Russell <rusty@rustcorp.com.au>
> > > > Date:   Wed May 19 17:33:39 2010 -0600
> > > > 
> > > >     module: drop the lock while waiting for module to complete initialization.
> > > 
> > > Hmm. That does seem to be buggy. We can't just drop and re-take the lock: 
> > > that may make sense _internally_ as far as resolve_symbol() itself is 
> > > concerned, but the caller will its own local variables, and some of those 
> > > will no longer be valid if the lock was dropped. 
> > 
> > Well, yes, obviously I missed something :(  I'll look at it tonight after
> > Arabella is asleep.
> 
> See if you can spot it (I acked the patch, so I can't point fingers):
> 
>  free_core:
> 	module_free(mod, mod->module_core);
> 	/* mod will be freed with core. Don't access it beyond this line! */
>  free_percpu:
> 	percpu_modfree(mod);
> 
> Only a year after Masami fixed that and added the comment, too :(
> 
> I suspect that the increased parallelism enabled by this patch uncovered this
> bug.  Does this fix it?

Since the commit has been reverted, do you still want me to test this patch?
Quite frankly I'd prefer to test a complete replacement for that commit on top
of current -git.

Rafael


> (Side note: the locking should be simplified.  No code before simplify_symbols
> actually needs the lock, so we should grab it just for that, then again at the
> end.  We use kobjects to protect us from multiple loads as a side-effect, but
> we should move that registration to the end).
> 
> Subject: module: fix reference to mod->percpu after freeing module.
> 
> The comment about the mod being freed is self-explanatory, but neither
> Tejun nor I read it.  This bug was introduced in 259354deaa, after it
> had previously been fixed in 6e2b75740b.  How embarrassing.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Masami Hiramatsu <mhiramat@redhat.com>
> 
> diff --git a/kernel/module.c b/kernel/module.c
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2031,6 +2031,7 @@ static noinline struct module *load_modu
>  	long err = 0;
>  	void *ptr = NULL; /* Stops spurious gcc warning */
>  	unsigned long symoffs, stroffs, *strmap;
> +	void __percpu *percpu;
>  
>  	mm_segment_t old_fs;
>  
> @@ -2175,6 +2176,8 @@ static noinline struct module *load_modu
>  			goto free_mod;
>  		sechdrs[pcpuindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
>  	}
> +	/* Keep this around for failure path. */
> +	percpu = mod_percpu(mod);
>  
>  	/* Determine total sizes, and put offsets in sh_entsize.  For now
>  	   this is done generically; there doesn't appear to be any
> @@ -2480,7 +2483,7 @@ static noinline struct module *load_modu
>  	module_free(mod, mod->module_core);
>  	/* mod will be freed with core. Don't access it beyond this line! */
>   free_percpu:
> -	percpu_modfree(mod);
> +	free_percpu(percpu);
>   free_mod:
>  	kfree(args);
>  	kfree(strmap);
> 
> 

