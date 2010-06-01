Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab0FAX4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 19:56:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48298 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751635Ab0FAX4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 19:56:34 -0400
Date: Tue, 1 Jun 2010 16:51:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Brandon Philips <brandon@ifup.org>
cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module
 libcrc32c"
In-Reply-To: <20100601232430.GC10332@jenkins.ifup.org>
Message-ID: <alpine.LFD.2.00.1006011638540.8175@i5.linux-foundation.org>
References: <201005252300.07739.rjw@sisk.pl> <201006011051.25636.rusty@rustcorp.com.au> <alpine.LFD.2.00.1005312011490.3637@i5.linux-foundation.org> <201006011452.06843.rusty@rustcorp.com.au> <alpine.LFD.2.00.1006010722160.3637@i5.linux-foundation.org>
 <alpine.LFD.2.00.1006011052340.8175@i5.linux-foundation.org> <20100601232430.GC10332@jenkins.ifup.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 1 Jun 2010, Brandon Philips wrote:
> 
> When I tested a Kernel with Rusty's modules branch pulled onto
> 2.6.35-rc1 I got duplicate sysfs path errors:

Hmm. Yeah, the module_mutex used to be held across the whole "find -> add" 
state, but isn't any more.

> To fix this we need to make sure that we only have one copy of a module
> going through load_module at a time.  Patch suggestion follows which
> boots without errors. I am sure there is a better way to do what it does
>    ;)

I think Rusty may have made the lock a bit _too_ finegrained there, and 
didn't add it to some places that needed it. It looks, for example, like 
PATCH 1/2 actually drops the lock in places where it's needed 
("find_module()" is documented to need it, but now load_module() didn't 
hold it at all when it did the find_module()).

Rather than adding a new "module_loading" list, I think we should be able 
to just use the existing "modules" list, and just fix up the locking a 
bit.

In fact, maybe we could just move the "look up existing module" a bit 
later - optimistically assuming that the module doesn't exist, and then 
just undoing the work if it turns out that we were wrong, just before 
adding ourselves to the list.

A patch something like the appended (TOTALLY UNTESTED!)

		Linus
---
 kernel/module.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index a1f46a5..21f7ffa 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2198,11 +2198,6 @@ static noinline struct module *load_module(void __user *umod,
 		goto free_mod;
 	}
 
-	if (find_module(mod->name)) {
-		err = -EEXIST;
-		goto free_mod;
-	}
-
 	mod->state = MODULE_STATE_COMING;
 
 	/* Allow arches to frob section contents and sizes.  */
@@ -2486,6 +2481,13 @@ static noinline struct module *load_module(void __user *umod,
 	 * The mutex protects against concurrent writers.
 	 */
 	mutex_lock(&module_mutex);
+
+	if (find_module(mod->name)) {
+		err = -EEXIST;
+		/* This will also unlock the mutex */
+		goto already_exists;
+	}
+
 	list_add_rcu(&mod->list, &modules);
 	mutex_unlock(&module_mutex);
 
@@ -2511,6 +2513,7 @@ static noinline struct module *load_module(void __user *umod,
 	mutex_lock(&module_mutex);
 	/* Unlink carefully: kallsyms could be walking list. */
 	list_del_rcu(&mod->list);
+ already_exists:
 	mutex_unlock(&module_mutex);
 	synchronize_sched();
 	module_arch_cleanup(mod);
