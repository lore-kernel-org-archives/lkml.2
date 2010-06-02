Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab0FBEj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 00:39:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751795Ab0FBEjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 00:39:55 -0400
Date: Tue, 1 Jun 2010 21:35:10 -0700 (PDT)
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
In-Reply-To: <20100602021029.GD10332@jenkins.ifup.org>
Message-ID: <alpine.LFD.2.00.1006012039570.8175@i5.linux-foundation.org>
References: <201005252300.07739.rjw@sisk.pl> <201006011051.25636.rusty@rustcorp.com.au> <alpine.LFD.2.00.1005312011490.3637@i5.linux-foundation.org> <201006011452.06843.rusty@rustcorp.com.au> <alpine.LFD.2.00.1006010722160.3637@i5.linux-foundation.org>
 <alpine.LFD.2.00.1006011052340.8175@i5.linux-foundation.org> <20100601232430.GC10332@jenkins.ifup.org> <alpine.LFD.2.00.1006011638540.8175@i5.linux-foundation.org> <20100602021029.GD10332@jenkins.ifup.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 1 Jun 2010, Brandon Philips wrote:
> 
> FWIW, I tried this same idea initially and it breaks because the
> kobject EEXIST is coming from mod_sysfs_init() which happens further
> up in load_module() before the list_add_rcu().

Ahh, right. So we'd need to mvoe that down too. As Rusty says, the kobject 
EEXIST warning should be fairly harmless - albeit annoying. Do things 
actually _work_ with that thing apart from the kobject warning?

> I also tried the obvious variation of moving the list_add_rcu() up
> to where the find_module is but got:

Yeah, I don't think moving it up will work, because then the module symbol 
resolver will see itself before having set up the symbols. So I think we 
need to expose it on the modules list only after having done the 
"simplify_symbols()" etc.

I dunno.

Does this work?

(Caveat emptor - I tried to make sure the error cases nest correctly, and 
it all compiles, but it's untested. As usual. Rusty mentioned a "see 
testing patch", but I didn't see it. Maybe he did the same thing)

		Linus
---
 kernel/module.c |   35 +++++++++++++++++++----------------
 1 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index a1f46a5..247c0aa 100644
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
@@ -2293,11 +2288,6 @@ static noinline struct module *load_module(void __user *umod,
 	/* Now we've moved module, initialize linked lists, etc. */
 	module_unload_init(mod);
 
-	/* add kobject, so we can reference it. */
-	err = mod_sysfs_init(mod);
-	if (err)
-		goto free_unload;
-
 	/* Set up license info based on the info section */
 	set_license(mod, get_modinfo(sechdrs, infoindex, "license"));
 
@@ -2486,16 +2476,28 @@ static noinline struct module *load_module(void __user *umod,
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
 
+	/* add kobject, so we can reference it. */
+	err = mod_sysfs_init(mod);
+	if (err)
+		goto unlink;
+
 	err = parse_args(mod->name, mod->args, mod->kp, mod->num_kp, NULL);
 	if (err < 0)
-		goto unlink;
+		goto sysfs_uninit;
 
 	err = mod_sysfs_setup(mod, mod->kp, mod->num_kp);
 	if (err < 0)
-		goto unlink;
+		goto sysfs_uninit;
 	add_sect_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
 	add_notes_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
 
@@ -2507,18 +2509,19 @@ static noinline struct module *load_module(void __user *umod,
 	/* Done! */
 	return mod;
 
+ sysfs_uninit:
+	free_modinfo(mod);
+	kobject_del(&mod->mkobj.kobj);
+	kobject_put(&mod->mkobj.kobj);
  unlink:
 	mutex_lock(&module_mutex);
 	/* Unlink carefully: kallsyms could be walking list. */
 	list_del_rcu(&mod->list);
+ already_exists:
 	mutex_unlock(&module_mutex);
 	synchronize_sched();
 	module_arch_cleanup(mod);
  cleanup:
-	free_modinfo(mod);
-	kobject_del(&mod->mkobj.kobj);
-	kobject_put(&mod->mkobj.kobj);
- free_unload:
 	module_unload_free(mod);
 #if defined(CONFIG_MODULE_UNLOAD)
 	free_percpu(mod->refptr);
