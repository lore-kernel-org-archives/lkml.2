Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306Ab0FAX1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 19:27:45 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51017 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab0FAX1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 19:27:43 -0400
Date: Tue, 1 Jun 2010 16:24:31 -0700
From: Brandon Philips <brandon@ifup.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of
 module libcrc32c"
Message-ID: <20100601232430.GC10332@jenkins.ifup.org>
References: <201005252300.07739.rjw@sisk.pl>
 <201006011051.25636.rusty@rustcorp.com.au>
 <alpine.LFD.2.00.1005312011490.3637@i5.linux-foundation.org>
 <201006011452.06843.rusty@rustcorp.com.au>
 <alpine.LFD.2.00.1006010722160.3637@i5.linux-foundation.org>
 <alpine.LFD.2.00.1006011052340.8175@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006011052340.8175@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:53 Tue 01 Jun 2010, Linus Torvalds wrote:
> On Tue, 1 Jun 2010, Linus Torvalds wrote:
> > So I do agree that your later two-patch series is the way to go.
> 
> Oh, btw, did we ever get that version tested by the only person who seems 
> to see the problem? Brandon?

Sorry for the delay. I broke the fuse on the remote power switch I was
using.

This is the subset of patches that everyone agreed, right?
 git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6 modules
Otherwise what patches should I be applying to 2.6.35-rc1?

When I tested a Kernel with Rusty's modules branch pulled onto
2.6.35-rc1 I got duplicate sysfs path errors:

[    8.985303] WARNING: at fs/sysfs/dir.c:451 sysfs_add_one+0xb2/0xd0()
[    8.998161] Hardware name: Dinar
[    9.004734] sysfs: cannot create duplicate filename '/module/libcrc32c'
[    9.018068] Modules linked in: libcrc32c(+) button ohci_hcd
ehci_hcd usbcore sd_mod crc_t10dif edd ext3 mbcache jbd fan thermal
processor thermal_sys hwmon ide_pci_generic atiixp ide_core
ata_generic ahci libahci pata_atiixp libata scsi_mod
[    9.062682] Pid: 1588, comm: modprobe Not tainted 2.6.35-rc1-0.7-default #3
[    9.076711] Call Trace:
[    9.081731]  [<ffffffff8116a162>] ? sysfs_add_one+0xb2/0xd0
[    9.092988]  [<ffffffff8104f6aa>] warn_slowpath_common+0x7a/0xd0
[    9.105115]  [<ffffffff8104f7a1>] warn_slowpath_fmt+0x41/0x50
[    9.116718]  [<ffffffff8116a162>] sysfs_add_one+0xb2/0xd0
[    9.127628]  [<ffffffff8116ace5>] create_dir+0x75/0xc0
[    9.138015]  [<ffffffff8116adc6>] sysfs_create_dir+0x96/0xc0
[    9.149447]  [<ffffffff811c5297>] kobject_add_internal+0xe7/0x250
[    9.161744]  [<ffffffff811c5518>] kobject_add_varg+0x38/0x60
[    9.173173]  [<ffffffff811c5593>] kobject_init_and_add+0x53/0x70
[    9.185295]  [<ffffffff811c5160>] ? kset_find_obj+0x40/0x90
[    9.196555]  [<ffffffff8107f193>] mod_sysfs_init+0x83/0xf0
[    9.207639]  [<ffffffff810807ec>] load_module+0xbec/0x1e10
[    9.218723]  [<ffffffff810d7467>] ? handle_mm_fault+0x227/0xaf0
[    9.230672]  [<ffffffff810da47c>] ? vma_link+0xac/0x110
[    9.241236]  [<ffffffff81385168>] ? do_page_fault+0x228/0x410
[    9.252839]  [<ffffffff810dcc19>] ? do_mmap_pgoff+0x359/0x380
[    9.264442]  [<ffffffff81081a6a>] sys_init_module+0x5a/0x220
[    9.275873]  [<ffffffff81002ec2>] system_call_fastpath+0x16/0x1b
[    9.287993] ---[ end trace 2a73785cc061234f ]---
[    9.297350] kobject_add_internal failed for libcrc32c with -EEXIST,
don't try to register things with the same name in the same directory.

To fix this we need to make sure that we only have one copy of a module
going through load_module at a time.  Patch suggestion follows which
boots without errors. I am sure there is a better way to do what it does
   ;)

Full dmesg:
  http://ifup.org/~philips/rusty-module-branch.dmesg

Cheers,

	Brandon

>From 35c6bb7c9a48b3ce53bc4b51871e6bed6e09c80a Mon Sep 17 00:00:00 2001
From: Brandon Philips <bphilips@suse.de>
Date: Wed, 2 Jun 2010 01:13:54 +0200
Subject: [PATCH] module: track module names currently loading

After "make locking more fine-grained" multiple instances of the same module
can reach mod_sysfs_init() and spew -EEXIST from kobject_add_internal().

Track the modules that are currently in load_module() but are not in the
modules list yet so we can kick out duplicate modules early.

NOTE: I didn't use mod->list to track the loading modules because I
couldn't figure out how to unwind from an error in a nice way.

Signed-off-by: Brandon Philips <bphilips@suse.de>
---
 kernel/module.c |   45 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 4 deletions(-)

Index: linux-2.6/kernel/module.c
===================================================================
--- linux-2.6.orig/kernel/module.c
+++ linux-2.6/kernel/module.c
@@ -77,6 +77,7 @@
 DEFINE_MUTEX(module_mutex);
 EXPORT_SYMBOL_GPL(module_mutex);
 static LIST_HEAD(modules);
+static LIST_HEAD(modules_loading);
 #ifdef CONFIG_KGDB_KDB
 struct list_head *kdb_modules = &modules; /* kdb needs the list of modules */
 #endif /* CONFIG_KGDB_KDB */
@@ -2055,6 +2056,23 @@ static inline void kmemleak_load_module(
 }
 #endif
 
+/* Track module names running through load_module but not in modules list */
+struct module_name {
+	struct list_head list;
+	char name[MODULE_NAME_LEN];
+};
+
+static struct module_name *find_module_loading(const char *name)
+{
+	struct module_name *mod_name;
+
+	list_for_each_entry(mod_name, &modules_loading, list) {
+		if (strcmp(mod_name->name, name) == 0)
+			return mod_name;
+	}
+	return NULL;
+}
+
 /* Allocate and load the module: note that size of section 0 is always
    zero, and we rely on this for optional sections. */
 static noinline struct module *load_module(void __user *umod,
@@ -2074,6 +2092,7 @@ static noinline struct module *load_modu
 	void *ptr = NULL; /* Stops spurious gcc warning */
 	unsigned long symoffs, stroffs, *strmap;
 	void __percpu *percpu;
+	struct module_name *mod_name;
 
 	mm_segment_t old_fs;
 
@@ -2198,24 +2217,36 @@ static noinline struct module *load_modu
 		goto free_mod;
 	}
 
-	if (find_module(mod->name)) {
-		err = -EEXIST;
+	mod_name = kzalloc(sizeof(*mod_name), GFP_KERNEL);
+	if (!mod_name) {
+		err = -ENOMEM;
 		goto free_mod;
 	}
+	strcpy(mod_name->name, mod->name);
+	INIT_LIST_HEAD(&mod_name->list);
+
+	mutex_lock(&module_mutex);
+	if (find_module(mod->name) || find_module_loading(mod->name)) {
+		mutex_unlock(&module_mutex);
+		err = -EEXIST;
+		goto free_mod_name;
+	}
+	list_add(&mod_name->list, &modules_loading);
+	mutex_unlock(&module_mutex);
 
 	mod->state = MODULE_STATE_COMING;
 
 	/* Allow arches to frob section contents and sizes.  */
 	err = module_frob_arch_sections(hdr, sechdrs, secstrings, mod);
 	if (err < 0)
-		goto free_mod;
+		goto del_loading;
 
 	if (pcpuindex) {
 		/* We have a special allocation for this section. */
 		err = percpu_modalloc(mod, sechdrs[pcpuindex].sh_size,
 				      sechdrs[pcpuindex].sh_addralign);
 		if (err)
-			goto free_mod;
+			goto del_loading;
 		sechdrs[pcpuindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
 	}
 	/* Keep this around for failure path. */
@@ -2486,6 +2517,8 @@ static noinline struct module *load_modu
 	 * The mutex protects against concurrent writers.
 	 */
 	mutex_lock(&module_mutex);
+	list_del(&mod_name->list);
+	kfree(mod_name);
 	list_add_rcu(&mod->list, &modules);
 	mutex_unlock(&module_mutex);
 
@@ -2530,6 +2563,10 @@ static noinline struct module *load_modu
 	/* mod will be freed with core. Don't access it beyond this line! */
  free_percpu:
 	free_percpu(percpu);
+ del_loading:
+	list_del(&mod_name->list);
+ free_mod_name:
+	kfree(mod_name);
  free_mod:
 	kfree(args);
 	kfree(strmap);
