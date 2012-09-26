Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab2IZDr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 23:47:59 -0400
Received: from ozlabs.org ([203.10.76.45]:44792 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab2IZDr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 23:47:57 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Howells <dhowells@redhat.com>, herbert@gondor.hengli.com.au
Cc: dhowells@redhat.com, pjones@redhat.com, jwboyer@redhat.com,
        linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, keyrings@linux-nfs.org
Subject: Re: [GIT PULL] Asymmetric keys and module signing
In-Reply-To: <5555.1348531649@warthog.procyon.org.uk>
References: <5555.1348531649@warthog.procyon.org.uk>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 26 Sep 2012 13:16:54 +0930
Message-ID: <87ehlp30pd.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:
> The module signing patches provide:
>
>  - Some fixes to Rusty's patch.  Also an additional patch to extend the policy
>    handling for modules signed with an unknown key and to handle FIPS mode.

Ok, I merged some of this (after our previous accidentally-off-list
discussion).

You previously wrote:
> You can't compare them that easily.  One has a FIPS-mode panic and the other
> doesn't.  Do we want to panic if we reject an unsigned module in enforcing
> mode when we're in FIPS mode?

It's a line ball, but I think consistency wins.  Not a validly signed
module => panic.

The code becomes pretty straightforward then:

        if (!err) {
                info->sig_ok = true;
                return 0;
        }
        if (fips_enabled)
               panic("Module verification failed with error %d in FIPS mode\n",
                     err);
        if (err == -ENOKEY && !sig_enforce)
                err = 0;
        
        return err;

In preparation, I've changed that below (and also, fixed up the -ENOKEY
which I said I'd do, and didn't).

Thanks,
Rusty.
PS.  Agree with Kconfig options move, but I'll do that in separate patch.

From: Rusty Russell <rusty@rustcorp.com.au>
Subject: module: signature checking hook

We do a very simple search for a particular string appended to the module
(which is cache-hot and about to be SHA'd anyway).  There's both a config
option and a boot parameter which control whether we accept (and taint) or
fail with unsigned modules.

(Useful feedback and tweaks by David Howells <dhowells@redhat.com>)

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1582,6 +1582,12 @@ bytes respectively. Such letter suffixes
 			log everything. Information is printed at KERN_DEBUG
 			so loglevel=8 may also need to be specified.
 
+	module.sig_enforce
+			[KNL] When CONFIG_MODULE_SIG is set, this means that
+			modules without (valid) signatures will fail to load.
+			Note that if CONFIG_MODULE_SIG_ENFORCE is set, that
+			is always true, so this option does nothing.
+
 	mousedev.tap_time=
 			[MOUSE] Maximum time between finger touching and
 			leaving touchpad surface for touch to be considered
diff --git a/include/linux/module.h b/include/linux/module.h
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -21,6 +21,9 @@
 #include <linux/percpu.h>
 #include <asm/module.h>
 
+/* In stripped ARM and x86-64 modules, ~ is surprisingly rare. */
+#define MODULE_SIG_STRING "~Module signature appended~\n"
+
 /* Not Yet Implemented */
 #define MODULE_SUPPORTED_DEVICE(name)
 
@@ -260,6 +263,11 @@ struct module
 	const unsigned long *unused_gpl_crcs;
 #endif
 
+#ifdef CONFIG_MODULE_SIG
+	/* Signature was verified. */
+	bool sig_ok;
+#endif
+
 	/* symbols that will be GPL-only in the near future. */
 	const struct kernel_symbol *gpl_future_syms;
 	const unsigned long *gpl_future_crcs;
diff --git a/init/Kconfig b/init/Kconfig
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1585,6 +1585,20 @@ config MODULE_SRCVERSION_ALL
 	  the version).  With this option, such a "srcversion" field
 	  will be created for all modules.  If unsure, say N.
 
+config MODULE_SIG
+	bool "Module signature verification"
+	depends on MODULES
+	help
+	  Check modules for valid signatures upon load: the signature
+	  is simply appended to the module. For more information see
+	  Documentation/module-signing.txt.
+
+config MODULE_SIG_FORCE
+	bool "Require modules to be validly signed"
+	depends on MODULE_SIG
+	help
+	  Reject unsigned modules or signed modules for which we don't have a
+	  key.  Without this, such modules will simply taint the kernel.
 endif # MODULES
 
 config INIT_ALL_POSSIBLE
diff --git a/kernel/Makefile b/kernel/Makefile
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -55,6 +55,7 @@ obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock
 obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
 obj-$(CONFIG_UID16) += uid16.o
 obj-$(CONFIG_MODULES) += module.o
+obj-$(CONFIG_MODULE_SIG) += module_signing.o
 obj-$(CONFIG_KALLSYMS) += kallsyms.o
 obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
 obj-$(CONFIG_KEXEC) += kexec.o
diff --git a/kernel/module-internal.h b/kernel/module-internal.h
new file mode 100644
--- /dev/null
+++ b/kernel/module-internal.h
@@ -0,0 +1,13 @@
+/* Module internals
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
+extern int mod_verify_sig(const void *mod, unsigned long modlen,
+			  const void *sig, unsigned long siglen);
diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -58,6 +58,7 @@
 #include <linux/jump_label.h>
 #include <linux/pfn.h>
 #include <linux/bsearch.h>
+#include "module-internal.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/module.h>
@@ -102,6 +103,43 @@ static LIST_HEAD(modules);
 struct list_head *kdb_modules = &modules; /* kdb needs the list of modules */
 #endif /* CONFIG_KGDB_KDB */
 
+#ifdef CONFIG_MODULE_SIG
+#ifdef CONFIG_MODULE_SIG_FORCE
+static bool sig_enforce = true;
+#else
+static bool sig_enforce = false;
+
+static int param_set_bool_enable_only(const char *val,
+				      const struct kernel_param *kp)
+{
+	int err;
+	bool test;
+	struct kernel_param dummy_kp = *kp;
+
+	dummy_kp.arg = &test;
+
+	err = param_set_bool(val, &dummy_kp);
+	if (err)
+		return err;
+
+	/* Don't let them unset it once it's set! */
+	if (!test && sig_enforce)
+		return -EROFS;
+
+	if (test)
+		sig_enforce = true;
+	return 0;
+}
+
+static const struct kernel_param_ops param_ops_bool_enable_only = {
+	.set = param_set_bool_enable_only,
+	.get = param_get_bool,
+};
+#define param_check_bool_enable_only param_check_bool
+
+module_param(sig_enforce, bool_enable_only, 0644);
+#endif /* !CONFIG_MODULE_SIG_FORCE */
+#endif /* CONFIG_MODULE_SIG */
 
 /* Block module loading/unloading? */
 int modules_disabled = 0;
@@ -136,6 +174,7 @@ struct load_info {
 	unsigned long symoffs, stroffs;
 	struct _ddebug *debug;
 	unsigned int num_debug;
+	bool sig_ok;
 	struct {
 		unsigned int sym, str, mod, vers, info, pcpu;
 	} index;
@@ -2379,7 +2418,49 @@ static inline void kmemleak_load_module(
 }
 #endif
 
-/* Sets info->hdr and info->len. */
+#ifdef CONFIG_MODULE_SIG
+static int module_sig_check(struct load_info *info,
+			    const void *mod, unsigned long *len)
+{
+	int err = -ENOKEY;
+	const unsigned long markerlen = sizeof(MODULE_SIG_STRING) - 1;
+	const void *p = mod, *end = mod + *len;
+
+	/* Poor man's memmem. */
+	while ((p = memchr(p, MODULE_SIG_STRING[0], end - p))) {
+		if (p + markerlen > end)
+			break;
+
+		if (memcmp(p, MODULE_SIG_STRING, markerlen) == 0) {
+			const void *sig = p + markerlen;
+			/* Truncate module up to signature. */
+			*len = p - mod;
+			err = mod_verify_sig(mod, *len, sig, end - sig);
+			break;
+		}
+		p++;
+	}
+
+	if (!err) {
+		info->sig_ok = true;
+		return 0;
+	}
+
+	/* Not having a signature is only an error if we're strict. */
+	if (err == -ENOKEY && !sig_enforce)
+		err = 0;
+
+	return err;
+}
+#else /* !CONFIG_MODULE_SIG */
+static int module_sig_check(struct load_info *info,
+			    void *mod, unsigned long *len)
+{
+	return 0;
+}
+#endif /* !CONFIG_MODULE_SIG */
+
+/* Sets info->hdr, info->len and info->sig_ok. */
 static int copy_and_check(struct load_info *info,
 			  const void __user *umod, unsigned long len,
 			  const char __user *uargs)
@@ -2399,6 +2480,10 @@ static int copy_and_check(struct load_in
 		goto free_hdr;
 	}
 
+	err = module_sig_check(info, hdr, &len);
+	if (err)
+		goto free_hdr;
+
 	/* Sanity checks against insmoding binaries or wrong arch,
 	   weird elf version */
 	if (memcmp(hdr->e_ident, ELFMAG, SELFMAG) != 0
@@ -2884,6 +2969,12 @@ static struct module *load_module(void _
 		goto free_copy;
 	}
 
+#ifdef CONFIG_MODULE_SIG
+	mod->sig_ok = info.sig_ok;
+	if (!mod->sig_ok)
+		add_taint_module(mod, TAINT_FORCED_MODULE);
+#endif
+
 	/* Now module is in final location, initialize linked lists, etc. */
 	err = module_unload_init(mod);
 	if (err)
diff --git a/kernel/module_signing.c b/kernel/module_signing.c
new file mode 100644
--- /dev/null
+++ b/kernel/module_signing.c
@@ -0,0 +1,22 @@
+/* Module signature checker
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
+#include <linux/kernel.h>
+#include "module-internal.h"
+
+/*
+ * Verify the signature on a module.
+ */
+int mod_verify_sig(const void *mod, unsigned long modlen,
+		   const void *sig, unsigned long siglen)
+{
+	return -ENOKEY;
+}

