Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab0EaKXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 06:23:55 -0400
Received: from ozlabs.org ([203.10.76.45]:37458 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523Ab0EaKXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 06:23:54 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] module: fix reference to mod->percpu after freeing module.
Date: Mon, 31 May 2010 19:53:50 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Brandon Philips <brandon@ifup.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
References: <201005252300.07739.rjw@sisk.pl> <201005271456.20003.rusty@rustcorp.com.au> <201005272357.28141.rjw@sisk.pl>
In-Reply-To: <201005272357.28141.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005311953.51694.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael sees a sometimes crash at precpu_modfree from kernel/module.c; it
only occurred with another (since-reverted) patch, but that patch simply
changed timing to uncover this bug, it was otherwise unrelated.

The comment about the mod being freed is self-explanatory, but neither
Tejun nor I read it.  This bug was introduced in 259354deaa, after it
had previously been fixed in 6e2b75740b.  How embarrassing.

Reported-by: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Tested-by: "Rafael J. Wysocki" <rjw@sisk.pl>
---
 kernel/module.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

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
