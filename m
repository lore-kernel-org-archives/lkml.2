Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964830Ab2EJXnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:43:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933007Ab2EJXn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:43:27 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 23/29] MODSIGN: Module signature verification stub [ver #4]
To: rusty@rustcorp.com.au
Cc: kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        David Howells <dhowells@redhat.com>
Date: Fri, 11 May 2012 00:43:15 +0100
Message-ID: <20120510234315.4137.98902.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
References: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a stub for the module signature verifier and link it into module.c so
that it gets called.  A field is added to struct module to record whether or
not a valid module signature was detected.

The stub also implements the policy for handling unsigned modules and the
printing of error messages to indicate various problems with the module.

If CONFIG_MODULE_SIG_FORCE is enabled or "enforcemodulesig=1" is supplied on
the kernel command line, the kernel will _only_ load validly signed modules
for which it has a public key.  Otherwise, it will also load modules that are
unsigned.  Any module for which the kernel has a key, but which proves to have
a signature mismatch will not be permitted to load.

This table indicates the behaviours in the various situations:

	MODULE STATE				PERMISSIVE MODE	ENFORCING MODE
	=======================================	===============	===============
	Unsigned				Ok		EKEYREJECTED
	Signed, no public key			ENOKEY		ENOKEY
	Validly signed, public key		Ok		Ok
	Invalidly signed, public key		EKEYREJECTED	EKEYREJECTED
	Validly signed, expired key		EKEYEXPIRED	EKEYEXPIRED
	Signed, hash algorithm unavailable	ENOPKG		ENOPKG
	Corrupt signature			EBADMSG		EBADMSG
	Corrupt ELF				ELIBBAD		ELIBBAD

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/module.h      |    3 +
 kernel/Makefile             |    1 
 kernel/module-verify-defs.h |   77 ++++++++++++++++++++++++++++++
 kernel/module-verify.c      |  109 +++++++++++++++++++++++++++++++++++++++++++
 kernel/module-verify.h      |   19 +++++++
 kernel/module.c             |   26 ++++++++--
 6 files changed, 230 insertions(+), 5 deletions(-)
 create mode 100644 kernel/module-verify-defs.h
 create mode 100644 kernel/module-verify.c
 create mode 100644 kernel/module-verify.h


diff --git a/include/linux/module.h b/include/linux/module.h
index fbcafe2..7391833 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -227,6 +227,9 @@ struct module
 	/* Unique handle for this module */
 	char name[MODULE_NAME_LEN];
 
+	/* Is this module GPG signed */
+	bool gpgsig_ok;
+
 	/* Sysfs stuff. */
 	struct module_kobject mkobj;
 	struct module_attribute *modinfo_attrs;
diff --git a/kernel/Makefile b/kernel/Makefile
index cb41b95..7608053 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -51,6 +51,7 @@ obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
 obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
 obj-$(CONFIG_UID16) += uid16.o
 obj-$(CONFIG_MODULES) += module.o
+obj-$(CONFIG_MODULE_SIG) += module-verify.o
 obj-$(CONFIG_KALLSYMS) += kallsyms.o
 obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
 obj-$(CONFIG_KEXEC) += kexec.o
diff --git a/kernel/module-verify-defs.h b/kernel/module-verify-defs.h
new file mode 100644
index 0000000..292d2ba
--- /dev/null
+++ b/kernel/module-verify-defs.h
@@ -0,0 +1,77 @@
+/* Module verification internal definitions
+ *
+ * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifdef CONFIG_MODULE_SIG
+
+/*
+ * Internal state
+ */
+struct module_verify_data {
+	struct crypto_key_verify_context *mod_sig; /* Module signing context */
+	union {
+		const void	*buffer;	/* module buffer */
+		const Elf_Ehdr	*hdr;		/* ELF header */
+	};
+	const Elf_Shdr		*sections;	/* ELF section table */
+	const char		*secstrings;	/* ELF section string table */
+	const void		*sig;		/* Signature note content */
+	size_t			size;		/* module object size */
+	size_t			nsects;		/* number of sections */
+	size_t			sig_size;	/* Size of signature */
+	size_t			signed_size;	/* count of bytes contributed to digest */
+	unsigned		*canonlist;	/* list of canonicalised sections */
+	unsigned		*canonmap;	/* section canonicalisation map */
+	unsigned		ncanon;		/* number of canonicalised sections */
+	unsigned		sig_index;	/* module signature section index */
+	uint8_t			xcsum;		/* checksum of bytes contributed to digest */
+	uint8_t			csum;		/* checksum of bytes representing a section */
+};
+
+/*
+ * Whether or not we support various types of ELF relocation record
+ */
+#if defined(MODULE_HAS_ELF_REL_ONLY)
+#define is_elf_rel(sh_type)	((sh_type) == SHT_REL)
+#define is_elf_rela(sh_type)	(0)
+#elif defined(MODULE_HAS_ELF_RELA_ONLY)
+#define is_elf_rel(sh_type)	(0)
+#define is_elf_rela(sh_type)	((sh_type) == SHT_RELA)
+#else
+#define is_elf_rel(sh_type)	((sh_type) == SHT_REL)
+#define is_elf_rela(sh_type)	((sh_type) == SHT_RELA)
+#endif
+
+/*
+ * Debugging.  Define DEBUG to enable.
+ */
+#define _debug(FMT, ...)			      \
+	do {					      \
+		if (unlikely(modsign_debug))	      \
+			pr_debug(FMT, ##__VA_ARGS__); \
+	} while(0)
+
+#ifdef DEBUG
+#define count_and_csum(C, __p, __n)			\
+do {							\
+	int __loop;					\
+	for (__loop = 0; __loop < __n; __loop++) {	\
+		(C)->csum += __p[__loop];		\
+		(C)->xcsum += __p[__loop];		\
+	}						\
+	(C)->signed_size += __n;			\
+} while (0)
+#else
+#define count_and_csum(C, __p, __n)		\
+do {						\
+} while (0)
+#endif
+
+#endif /* CONFIG_MODULE_SIG */
diff --git a/kernel/module-verify.c b/kernel/module-verify.c
new file mode 100644
index 0000000..0a3eb4b
--- /dev/null
+++ b/kernel/module-verify.c
@@ -0,0 +1,109 @@
+/* Module signature verification
+ *
+ * The code in this file examines a signed kernel module and attempts to
+ * determine if the PGP signature inside the module matches a digest of the
+ * allocatable sections and the canonicalised relocation tables for those
+ * allocatable sections.
+ *
+ * The module signature is included in an ELF note within the ELF structure of
+ * the module blob.  This, combined with the minimal canonicalisation performed
+ * here, permits the module to pass through "strip -x", "strip -g" and
+ * "eu-strip" without becoming corrupt.  "strip" and "strip -s" will render a
+ * module unusable by removing the symbol table.
+ *
+ * Copyright (C) 2004, 2011, 2012 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ * - Derived from GregKH's RSA module signer
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#undef DEBUG
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/elf.h>
+#include <linux/elfnote.h>
+#include <linux/sched.h>
+#include <linux/cred.h>
+#include <linux/modsign.h>
+#include <linux/moduleparam.h>
+#include <keys/crypto-type.h>
+#include "module-verify.h"
+#include "module-verify-defs.h"
+
+#ifdef DEBUG
+static int modsign_debug;
+core_param(modsign_debug, modsign_debug, int, 0644);
+#else
+#define modsign_debug false
+#endif
+
+#ifdef CONFIG_MODULE_SIG_FORCE
+#define modsign_signedonly true
+#else
+static bool modsign_signedonly;
+#endif
+
+static const char modsign_note_name[] = ELFNOTE_NAME(MODSIGN_NOTE_NAME);
+static const char modsign_note_section[] = ELFNOTE_SECTION(MODSIGN_NOTE_NAME);
+
+/*
+ * Verify a module's integrity
+ */
+int module_verify(const Elf_Ehdr *hdr, size_t size, bool *_gpgsig_ok)
+{
+	struct module_verify_data mvdata;
+	int ret;
+
+	memset(&mvdata, 0, sizeof(mvdata));
+	mvdata.buffer = hdr;
+	mvdata.size = size;
+
+	if (mvdata.sig_index <= 0) {
+		/* Deal with an unsigned module */
+		if (modsign_signedonly) {
+			pr_err("An attempt to load unsigned module was rejected\n");
+			return -EKEYREJECTED;
+		} else {
+			return 0;
+		}
+		goto out;
+	}
+
+	ret = 0;
+
+out:
+	switch (ret) {
+	case 0:			/* Good signature */
+		*_gpgsig_ok = true;
+		break;
+	case -ELIBBAD:
+		pr_err("Module format error encountered\n");
+		break;
+	case -EBADMSG:
+		pr_err("Module signature error encountered\n");
+		break;
+	case -EKEYREJECTED:	/* Signature mismatch or number format error */
+		pr_err("Module signature verification failed\n");
+		break;
+	case -ENOKEY:		/* Signed, but we don't have the public key */
+		pr_err("Module signed with unknown public key\n");
+		break;
+	default:		/* Other error (probably ENOMEM) */
+		break;
+	}
+	return ret;
+}
+
+static int __init sign_setup(char *str)
+{
+#ifndef CONFIG_MODULE_SIG_FORCE
+	modsign_signedonly = true;
+#endif
+	return 0;
+}
+__setup("enforcemodulesig", sign_setup);
diff --git a/kernel/module-verify.h b/kernel/module-verify.h
new file mode 100644
index 0000000..6bb6b56
--- /dev/null
+++ b/kernel/module-verify.h
@@ -0,0 +1,19 @@
+/* Module verification definitions
+ *
+ * Copyright (C) 2004, 2012 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifdef CONFIG_MODULE_SIG
+extern int module_verify(const Elf_Ehdr *hdr, size_t size, bool *_gpgsig_ok);
+#else
+static inline int module_verify(const Elf_Ehdr *hdr, size_t size, bool *_gpgsig_ok)
+{
+	return 0;
+}
+#endif
diff --git a/kernel/module.c b/kernel/module.c
index 377cb06..c3797f7 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -58,6 +58,7 @@
 #include <linux/jump_label.h>
 #include <linux/pfn.h>
 #include <linux/bsearch.h>
+#include "module-verify.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/module.h>
@@ -2402,7 +2403,8 @@ static inline void kmemleak_load_module(const struct module *mod,
 /* Sets info->hdr and info->len. */
 static int copy_and_check(struct load_info *info,
 			  const void __user *umod, unsigned long len,
-			  const char __user *uargs)
+			  const char __user *uargs,
+			  bool *_gpgsig_ok)
 {
 	int err;
 	Elf_Ehdr *hdr;
@@ -2435,6 +2437,12 @@ static int copy_and_check(struct load_info *info,
 		goto free_hdr;
 	}
 
+	/* Verify the module's contents */
+	*_gpgsig_ok = false;
+	err = module_verify(hdr, len, _gpgsig_ok);
+	if (err < 0)
+		goto free_hdr;
+
 	info->hdr = hdr;
 	info->len = len;
 	return 0;
@@ -2777,7 +2785,8 @@ int __weak module_frob_arch_sections(Elf_Ehdr *hdr,
 	return 0;
 }
 
-static struct module *layout_and_allocate(struct load_info *info)
+static struct module *layout_and_allocate(struct load_info *info,
+					  bool gpgsig_ok)
 {
 	/* Module within temporary copy. */
 	struct module *mod;
@@ -2787,6 +2796,7 @@ static struct module *layout_and_allocate(struct load_info *info)
 	mod = setup_load_info(info);
 	if (IS_ERR(mod))
 		return mod;
+	mod->gpgsig_ok = gpgsig_ok;
 
 	err = check_modinfo(mod, info);
 	if (err)
@@ -2870,17 +2880,18 @@ static struct module *load_module(void __user *umod,
 	struct load_info info = { NULL, };
 	struct module *mod;
 	long err;
+	bool gpgsig_ok;
 
 	pr_debug("load_module: umod=%p, len=%lu, uargs=%p\n",
 	       umod, len, uargs);
 
 	/* Copy in the blobs from userspace, check they are vaguely sane. */
-	err = copy_and_check(&info, umod, len, uargs);
+	err = copy_and_check(&info, umod, len, uargs, &gpgsig_ok);
 	if (err)
 		return ERR_PTR(err);
 
 	/* Figure out module layout, and allocate all the memory. */
-	mod = layout_and_allocate(&info);
+	mod = layout_and_allocate(&info, gpgsig_ok);
 	if (IS_ERR(mod)) {
 		err = PTR_ERR(mod);
 		goto free_copy;
@@ -3517,8 +3528,13 @@ void print_modules(void)
 	printk(KERN_DEFAULT "Modules linked in:");
 	/* Most callers should already have preempt disabled, but make sure */
 	preempt_disable();
-	list_for_each_entry_rcu(mod, &modules, list)
+	list_for_each_entry_rcu(mod, &modules, list) {
 		printk(" %s%s", mod->name, module_flags(mod, buf));
+#ifdef CONFIG_MODULE_SIG
+		if (!mod->gpgsig_ok)
+			printk("(U)");
+#endif
+	}
 	preempt_enable();
 	if (last_unloaded_module[0])
 		printk(" [last unloaded: %s]", last_unloaded_module);

