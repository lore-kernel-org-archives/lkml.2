Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab1LBSrH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 13:47:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932169Ab1LBSrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 13:47:03 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 21/21] MODSIGN: Apply signature checking to modules on module
 load [ver #3]
To: keyrings@linux-nfs.org
Cc: linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, arjan.van.de.ven@intel.com,
        alan.cox@intel.com, David Howells <dhowells@redhat.com>
Date: Fri, 02 Dec 2011 18:46:51 +0000
Message-ID: <20111202184651.21874.57769.stgit@warthog.procyon.org.uk>
In-Reply-To: <20111202184229.21874.25782.stgit@warthog.procyon.org.uk>
References: <20111202184229.21874.25782.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apply signature checking to modules on module load, checking the signature
against the ring of public keys compiled into the kernel (if enabled by
CONFIG_MODULE_SIG).  Turning on signature checking will also force the module's
ELF metadata to be verified first.

These patches have been in use by RHEL and Fedora kernels for years, and so
have been thoroughly tested.  The signed modules survive both the debuginfo
separation performed by rpmbuild and the strip performed when modules are being
reduced as much as possible before being included in an initial ramdisk
composition.  Signed modules have been tested to work with LE and BE, 32- and
64-bit arch kernels, including i386, x86_64, ppc64, ia64, s390 and s390x.

There are several reasons why these patches are useful, amongst which are:

 (1) to protect against accidentally-corrupted modules causing damage;

 (2) to protect against maliciously modified modules causing damage;

 (3) to allow a sysadmin (or more likely an IT department) to enforce a policy
     that only known and approved modules shall be loaded onto machines which
     they're expected to support;

 (4) to allow other support providers to do likewise, or at least to _detect_
     the fact that unsupported modules are loaded;

 (5) to allow the detection of modules replaced by a second-order distro or a
     preloaded Linux purveyor.

These patches have two main appeals: (a) preventing malicious modules from
being loaded, and (b) reducing support workload by pointing out modules on a
crashing box that aren't what they're expected to be.

Now, this is not a complete solution by any means: the core kernel is not
protected, and nor are /dev/mem or /dev/kmem, but it denies (or at least
controls) one relatively simple attack vector.

This facility is optional: the builder of a kernel is by no means under any
requirement to actually enable it, let alone force the set of loadable modules
to be restricted to just those that the builder provides (there are degrees of
restriction available).


Use of the module signing facility is documentated in:

	Documentation/module-signing.txt

which I've included here for reference:

			==============================
			KERNEL MODULE SIGNING FACILITY
			==============================

The module signing facilitiy applies cryptographic signature checking to
modules on module load, checking the signature against a ring of public keys
compiled into the kernel.  GPG is used to do the cryptographic work and
determines the format of the signature and key data.  The facility uses GPG's
MPI library to handle the huge numbers involved.

This facility is enabled through CONFIG_MODULE_SIG.  Turning on signature
checking will also force the module's ELF metadata to be verified before the
signature is checked.


=====================
SUPPLYING PUBLIC KEYS
=====================

A set of public keys must be supplied at main kernel compile time.  This is
done by taking a GPG public key file, running it through the kernel's bin2c
program and writing the result over crypto/signature/key.h.  To automate this
process, something like this could be done:

	cat >genkey <<EOF
	%pubring kernel.pub
	%secring kernel.sec
	Key-Type: DSA
	Key-Length: 512
	Name-Real: A. N. Other
	Name-Comment: Kernel Module GPG key
	%commit
	EOF
	make scripts/bin2c
	gpg --homedir . --batch --gen-key genkey

The above generates fresh keys using /dev/random.  If there's insufficient data
in /dev/random, more can be provided more by running:

	rngd -r /dev/urandom

in the background.

Note:

 (1) That "keyname" is the name of the key in the keyring.  This differentiates
     it from any other keys that may be added to the keyring.

 (2) That no GPG password is used in the above scriptlet.

 (3) It may be desirable to shred and delete the private key file after signing
     the modules.


==============
MODULE SIGNING
==============

Modules will then be signed automatically.  The kernel make command line can
include the following options:

 (*) MODSECKEY=<secret-key-ring-path>

     This indicates the whereabouts of the GPG keyring that is the source of
     the secret key to be used.  The default is "./kernel.sec".

 (*) MODPUBKEY=<public-key-ring-path>

     This indicates the whereabouts of the GPG keyring that is the source of
     the public key to be used.  The default is "./kernel.pub".

 (*) MODKEYNAME=<key-name>

     The name of the key pair to be used from the aforementioned keyrings.
     This defaults to being unset, thus leaving the choice of default key to
     gpg.

 (*) KEYFLAGS="gpg-options"

     Override the complete gpg command line, including the preceding three
     options.  The default options supplied to gpg are:

	--no-default-keyring
	--secret-keyring $(MODSECKEY)
	--keyring $(MODPUBKEY)
	--no-default-keyring
	--homedir .
	--no-options
	--no-auto-check-trustdb
	--no-permission-warning

      with:

	--default-key $(MODKEYNAME)

      being added if requested.

The resulting module.ko file will be the signed module.


========================
STRIPPING SIGNED MODULES
========================

Signed modules may be safely stripped as the signature only covers those parts
of the module the kernel actually uses and any ELF metadata required to deal
with them.  Any necessary ELF metadata that is affected by stripping is
canonicalised by the sig generator and the sig checker to hide strip effects.

This permits the debuginfo to be detached from the module and placed in another
spot so that gdb can find it when referring to that module without the need for
multiple signed versions of the module.  Such is done by rpmbuild when
producing RPMs.

It also permits the module to be stripped as far as possible for when modules
are being reduced prior to being included in an initial ramdisk composition.


======================
LOADING SIGNED MODULES
======================

Modules are loaded with insmod, exactly as for unsigned modules.  The signature
is inserted into the module object file as an ELF section called ".module_sig".
The signature checker will spot it and apply signature checking.


=========================================
NON-VALID SIGNATURES AND UNSIGNED MODULES
=========================================

If CONFIG_MODULE_SIG_FORCE is enabled or "enforcemodulesig=1" is supplied on
the kernel command line, the kernel will _only_ load validly signed modules
for which it has a public key.  Otherwise, it will also load modules that are
unsigned.  Any module for which the kernel has a key, but which proves to have
a signature mismatch will not be permitted to load (returning EKEYREJECTED).

This table indicates the behaviours of the various situations:

	MODULE STATE			PERMISSIVE MODE	ENFORCING MODE
	===============================	===============	===============
	Unsigned			Ok		EKEYREJECTED
	Signed, no public key		ENOKEY		ENOKEY
	Validly signed, public key	Ok		Ok
	Invalidly signed, public key	EKEYREJECTED	EKEYREJECTED
	Validly signed, expired key	EKEYEXPIRED	EKEYEXPIRED
	Corrupt signature		ELIBBAD		ELIBBAD
	Corrupt ELF			ELIBBAD		ELIBBAD


Signed-Off-By: David Howells <dhowells@redhat.com>
---

 .gitignore                       |   15 +
 Documentation/module-signing.txt |  186 ++++++++
 Makefile                         |    1 
 include/linux/elfnote.h          |    4 
 include/linux/modsign.h          |   27 +
 include/linux/module.h           |    3 
 init/Kconfig                     |   56 ++
 kernel/Makefile                  |    2 
 kernel/modsign-pubkey.c          |   44 ++
 kernel/module-verify-sig.c       |  526 ++++++++++++++++++++++
 kernel/module-verify.c           |    5 
 kernel/module-verify.h           |   19 +
 kernel/module.c                  |   21 +
 scripts/Makefile.modpost         |   85 +++-
 scripts/mod/.gitignore           |    1 
 scripts/mod/Makefile             |    2 
 scripts/mod/mod-extract.c        |  913 ++++++++++++++++++++++++++++++++++++++
 scripts/mod/modsign-note.sh      |   16 +
 18 files changed, 1914 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/module-signing.txt
 create mode 100644 include/linux/modsign.h
 create mode 100644 kernel/modsign-pubkey.c
 create mode 100644 kernel/module-verify-sig.c
 create mode 100644 scripts/mod/mod-extract.c
 create mode 100644 scripts/mod/modsign-note.sh


diff --git a/.gitignore b/.gitignore
index 57af07c..841a17ee 100644
--- a/.gitignore
+++ b/.gitignore
@@ -14,6 +14,9 @@
 *.o.*
 *.a
 *.s
+*.ko.unsigned
+*.ko.digest
+*.ko.digest.sig
 *.ko
 *.so
 *.so.dbg
@@ -84,3 +87,15 @@ GTAGS
 *.orig
 *~
 \#*#
+
+#
+# GPG leavings from module signing
+#
+trustdb.gpg
+random_seed
+kernel.pub
+kernel.sec
+extract.pub
+secring.gpg
+pubring.gpg
+crypto/signature/key.h
diff --git a/Documentation/module-signing.txt b/Documentation/module-signing.txt
new file mode 100644
index 0000000..300b91a
--- /dev/null
+++ b/Documentation/module-signing.txt
@@ -0,0 +1,186 @@
+			==============================
+			KERNEL MODULE SIGNING FACILITY
+			==============================
+
+The module signing facility applies cryptographic signature checking to modules
+on module load, checking the signature against a ring of public keys compiled
+into the kernel.  GPG is used to do the cryptographic work and determines the
+format of the signature and key data.  The facility uses GPG's MPI library to
+handle the huge numbers involved.
+
+This facility is enabled through CONFIG_MODULE_SIG.  Turning on signature
+checking will also force the module's ELF metadata to be verified before the
+signature is checked.
+
+The signature checker in the kernel is capable of handling multiple keys of
+either DSA or RSA type, and can support any of MD5, RIPE-MD-160, SHA-1,
+SHA-224, SHA-256, SHA-384 and SHA-512 hashes - PROVIDED(!) the requisite
+algorithms are compiled into the kernel.
+
+(!) NOTE: Modules may only be verified initially with algorithms compiled into
+the kernel.  Further algorithm modules may be loaded and used - but these must
+first pass a verification step using already loaded/compiled-in algorithms.
+
+
+=====================
+SUPPLYING PUBLIC KEYS
+=====================
+
+A set of public keys must be supplied at kernel image build time.  This is done
+by taking a GPG public key file and placing it in the base of the kernel
+directory in a file called kernel.pub.
+
+For example, a throwaway key could be generated automatically by something like
+the following:
+
+	cat >genkey <<EOF
+	%pubring kernel.pub
+	%secring kernel.sec
+	Key-Type: DSA
+	Key-Length: 512
+	Name-Real: A. N. Other
+	Name-Comment: Kernel Module GPG key
+	%commit
+	EOF
+	gpg --homedir . --batch --gen-key genkey
+
+The above generates fresh keys using /dev/random.  If there's insufficient data
+in /dev/random, more can be provided more by running:
+
+	rngd -r /dev/urandom
+
+in the background.
+
+Note that no GPG password is used in the above scriptlet.
+
+The kernel.pub file is compiled into the kernel directly by the assembler by
+means of an ".incbin" directive in kernel/modsign-pubkey.c.
+
+Once the kernel is running, the keys are visible to root as kernel crypto keys
+in /proc/keys in a keyring called .module_sign:
+
+335ab517 I-----     1 perm 1f030000     0     0 keyring   .module_sign: 2/4
+38d7d169 I-----     1 perm 3f010000     0     0 crypto    modsign.0: rsa 57532ca5 []
+195fa736 I-----     1 perm 3f010000     0     0 crypto    modsign.1: dsa 5acc2142 []
+
+This keyring can be listed with the keyctl program.  See:
+
+	Documentation/security/keys-crypto.txt
+
+for more information of crypto keys.
+
+
+============================
+SELECTING THE HASH ALGORITHM
+============================
+
+The hash algorithm to be used is selected by a multiple choice configuration
+item that enables one of the following variables:
+
+	CONFIG_SIG_SHA1
+	CONFIG_SIG_SHA224
+	CONFIG_SIG_SHA256
+	CONFIG_SIG_SHA384
+	CONFIG_SIG_SHA512
+
+These cause an appropriate "--digest-algo=" parameter to be passed to gpg when
+signing a module and force the appropriate hash algorithm to be compiled
+directly into the kernel rather than being built as a module.
+
+
+==============
+MODULE SIGNING
+==============
+
+Modules will then be signed automatically.  The kernel make command line can
+include the following options:
+
+ (*) MODSECKEY=<secret-key-ring-path>
+
+     This indicates the whereabouts of the GPG keyring that is the source of
+     the secret key to be used.  The default is "./kernel.sec".
+
+ (*) MODPUBKEY=<public-key-ring-path>
+
+     This indicates the whereabouts of the GPG keyring that is the source of
+     the public key to be used.  The default is "./kernel.pub".
+
+ (*) MODKEYNAME=<key-name>
+
+     The name of the key pair to be used from the aforementioned keyrings.
+     This defaults to being unset, thus leaving the choice of default key to
+     gpg.
+
+ (*) KEYFLAGS="gpg-options"
+
+     Override the complete gpg command line, including the preceding three
+     options.  The default options supplied to gpg are:
+
+	--no-default-keyring
+	--secret-keyring $(MODSECKEY)
+	--keyring $(MODPUBKEY)
+	--no-default-keyring
+	--homedir .
+	--no-options
+	--no-auto-check-trustdb
+	--no-permission-warning
+	--digest-algo=<hash-algorithm>
+
+      with:
+
+	--default-key $(MODKEYNAME)
+
+      being added if requested.
+
+The resulting module.ko file will be the signed module.
+
+
+========================
+STRIPPING SIGNED MODULES
+========================
+
+Signed modules may be safely stripped as the signature only covers those parts
+of the module the kernel actually uses and any ELF metadata required to deal
+with them.  Any necessary ELF metadata that is affected by stripping is
+canonicalised by the sig generator and the sig checker to hide strip effects.
+
+This permits the debuginfo to be detached from the module and placed in another
+spot so that gdb can find it when referring to that module without the need for
+multiple signed versions of the module.  Such is done by rpmbuild when
+producing RPMs.
+
+It also permits the module to be stripped as far as possible for when modules
+are being reduced prior to being included in an initial ramdisk composition.
+
+
+======================
+LOADING SIGNED MODULES
+======================
+
+Modules are loaded with insmod, exactly as for unsigned modules.  The signature
+is inserted into the module object file as an ELF section called ".module_sig".
+The signature checker will detect it and apply signature checking.
+
+
+=========================================
+NON-VALID SIGNATURES AND UNSIGNED MODULES
+=========================================
+
+If CONFIG_MODULE_SIG_FORCE is enabled or "enforcemodulesig=1" is supplied on
+the kernel command line, the kernel will _only_ load validly signed modules
+for which it has a public key.  Otherwise, it will also load modules that are
+unsigned.  Any module for which the kernel has a key, but which proves to have
+a signature mismatch will not be permitted to load (returning EKEYREJECTED).
+
+This table indicates the behaviours of the various situations:
+
+	MODULE STATE				PERMISSIVE MODE	ENFORCING MODE
+	=======================================	===============	===============
+	Unsigned				Ok		EKEYREJECTED
+	Signed, no public key			ENOKEY		ENOKEY
+	Validly signed, public key		Ok		Ok
+	Invalidly signed, public key		EKEYREJECTED	EKEYREJECTED
+	Validly signed, expired key		EKEYEXPIRED	EKEYEXPIRED
+	Signed, hash algorithm unavailable	ENOPKG		ENOPKG
+	Corrupt signature			EBADMSG		EBADMSG
+	Corrupt ELF				ELIBBAD		ELIBBAD
diff --git a/Makefile b/Makefile
index 361e4f0..9f246d3 100644
--- a/Makefile
+++ b/Makefile
@@ -1404,6 +1404,7 @@ clean: $(clean-dirs)
 	$(call cmd,rmfiles)
 	@find $(if $(KBUILD_EXTMOD), $(KBUILD_EXTMOD), .) $(RCS_FIND_IGNORE) \
 		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
+		-o -name '*.ko.*' \
 		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
 		-o -name '*.symtypes' -o -name 'modules.order' \
 		-o -name modules.builtin -o -name '.tmp_*.o.*' \
diff --git a/include/linux/elfnote.h b/include/linux/elfnote.h
index 278e3ef..949d494 100644
--- a/include/linux/elfnote.h
+++ b/include/linux/elfnote.h
@@ -58,6 +58,7 @@
 	ELFNOTE_END
 
 #else	/* !__ASSEMBLER__ */
+#include <linux/stringify.h>
 #include <linux/elf.h>
 /*
  * Use an anonymous structure which matches the shape of
@@ -93,6 +94,9 @@
 
 #define ELFNOTE32(name, type, desc) ELFNOTE(32, name, type, desc)
 #define ELFNOTE64(name, type, desc) ELFNOTE(64, name, type, desc)
+
+#define ELFNOTE_NAME(name)	__stringify(name)
+#define ELFNOTE_SECTION(name)	".note."ELFNOTE_NAME(name)
 #endif	/* __ASSEMBLER__ */
 
 #endif /* _LINUX_ELFNOTE_H */
diff --git a/include/linux/modsign.h b/include/linux/modsign.h
new file mode 100644
index 0000000..c5ac87a
--- /dev/null
+++ b/include/linux/modsign.h
@@ -0,0 +1,27 @@
+/* Module signing definitions
+ *
+ * Copyright (C) 2009 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _LINUX_MODSIGN_H
+#define _LINUX_MODSIGN_H
+
+#ifdef CONFIG_MODULE_SIG
+
+#include <linux/elfnote.h>
+
+/*
+ * The parameters of the ELF note used to carry the signature
+ */
+#define MODSIGN_NOTE_NAME	module.sig
+#define MODSIGN_NOTE_TYPE	100
+
+#endif
+
+#endif /* _LINUX_MODSIGN_H */
diff --git a/include/linux/module.h b/include/linux/module.h
index 3cb7839..527db2b 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -280,6 +280,9 @@ struct module
 
 	unsigned int taints;	/* same bits as kernel:tainted */
 
+	/* Is this module GPG signed */
+	int gpgsig_ok;
+
 #ifdef CONFIG_GENERIC_BUG
 	/* Support for BUG */
 	unsigned num_bugs;
diff --git a/init/Kconfig b/init/Kconfig
index 42e685d..7de546a 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1389,10 +1389,64 @@ config MODULE_VERIFY_ELF
 	help
 	  Check ELF structure of modules upon load
 
+config MODULE_SIG
+	bool "Module signature verification (EXPERIMENTAL)"
+	depends on MODULES && EXPERIMENTAL
+	select CRYPTO_KEY_TYPE
+	select CRYPTO_KEY_PKEY_ALGO_DSA
+	select CRYPTO_KEY_PKEY_ALGO_RSA
+	select PGP_PARSER
+	select PGP_PRELOAD
+	select MODULE_VERIFY_ELF
+	help
+	  Check modules for valid signatures upon load.  For more information
+	  see:
+
+	  Documentation/module-signing.txt
+
+choice
+	prompt "Which hash algorithm should modules be signed with?"
+	depends on MODULE_SIG
+	help
+	  This determines which sort of hashing algorithm will be used during
+	  signature generation.  This algorithm _must_ be built into the kernel
+	  directly so that signature verification can take place.  It is not
+	  possible to load a signed module containing the algorithm to check
+	  the signature on that module.
+
+config MODULE_SIG_SHA1
+	bool "Sign modules with SHA-1"
+	select CRYPTO_SHA1
+
+config MODULE_SIG_SHA224
+	bool "Sign modules with SHA-224"
+	select CRYPTO_SHA224
+
+config MODULE_SIG_SHA256
+	bool "Sign modules with SHA-256"
+	select CRYPTO_SHA256
+
+config MODULE_SIG_SHA384
+	bool "Sign modules with SHA-384"
+	select CRYPTO_SHA384
+
+config MODULE_SIG_SHA512
+	bool "Sign modules with SHA-512"
+	select CRYPTO_SHA512
+
+endchoice
+
+config MODULE_SIG_FORCE
+	bool "Required modules to be validly signed (EXPERIMENTAL)"
+	depends on MODULE_SIG
+	help
+	  Reject unsigned modules or signed modules for which we don't have a
+	  key.
+
 config MODULE_VERIFY
 	bool
 	depends on MODULES
-	default y if MODULE_VERIFY_ELF
+	default y if MODULE_VERIFY_ELF || MODULE_SIG
 
 endif # MODULES
 
diff --git a/kernel/Makefile b/kernel/Makefile
index 3c34fab..1d1c91c 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -53,6 +53,8 @@ obj-$(CONFIG_UID16) += uid16.o
 obj-$(CONFIG_MODULES) += module.o
 obj-$(CONFIG_MODULE_VERIFY) += module-verify.o
 obj-$(CONFIG_MODULE_VERIFY_ELF) += module-verify-elf.o
+obj-$(CONFIG_MODULE_SIG) += module-verify-sig.o modsign-pubkey.o
+kernel/modsign-pubkey.o: kernel.pub
 obj-$(CONFIG_KALLSYMS) += kallsyms.o
 obj-$(CONFIG_PM) += power/
 obj-$(CONFIG_FREEZER) += power/
diff --git a/kernel/modsign-pubkey.c b/kernel/modsign-pubkey.c
new file mode 100644
index 0000000..df55565
--- /dev/null
+++ b/kernel/modsign-pubkey.c
@@ -0,0 +1,44 @@
+/* Public keys for module signature verification
+ *
+ * Copyright (C) 2011 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <keys/crypto-type.h>
+#include "module-verify.h"
+
+extern __initdata const u8 modsign_public_keys[];
+extern __initdata const u8 modsign_public_keys_end[];
+asm(".section .init.data,\"aw\"\n"
+    "modsign_public_keys:\n"
+    ".incbin \"kernel.pub\"\n"
+    "modsign_public_keys_end:"
+    );
+
+/*
+ * We need to make sure ccache doesn't cache the .o file as it doesn't notice
+ * if kernel.pub changes.
+ */
+static __initdata const char annoy_ccache[] = __TIME__ "foo";
+
+/*
+ * Load the compiled-in keys
+ */
+static __init int modsign_pubkey_init(void)
+{
+	pr_notice("Load module verification keys\n");
+
+	if (preload_pgp_keys(modsign_public_keys,
+			     modsign_public_keys_end - modsign_public_keys,
+			     modsign_keyring, "modsign.") < 0)
+		panic("Can't load module signing keys\n");
+
+	return 0;
+}
+late_initcall(modsign_pubkey_init);
diff --git a/kernel/module-verify-sig.c b/kernel/module-verify-sig.c
new file mode 100644
index 0000000..ced5681
--- /dev/null
+++ b/kernel/module-verify-sig.c
@@ -0,0 +1,526 @@
+/* Module signature checker
+ *
+ * Copyright (C) 2004,2011 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ * - Derived from GregKH's RSA module signer
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/elf.h>
+#include <linux/sched.h>
+#include <linux/cred.h>
+#include <linux/modsign.h>
+#include <keys/keyring-type.h>
+#include "module-verify.h"
+
+#undef MODSIGN_DEBUG
+
+struct key *modsign_keyring;
+
+int modsign_debug;
+core_param(modsign_debug, modsign_debug, bool, 0644);
+
+#define _debug(FMT, ...)			      \
+	do {					      \
+		if (unlikely(modsign_debug))	      \
+			pr_debug(FMT, ##__VA_ARGS__); \
+	} while(0)
+
+#ifdef MODSIGN_DEBUG
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
+	(C)->signed_size += __n;		\
+} while (0)
+#endif
+
+#define crypto_digest_update_data(C, PTR, N)			\
+do {								\
+	uint8_t *__p = (uint8_t *)(PTR);			\
+	size_t __n = (N);					\
+	count_and_csum((C), __p, __n);				\
+	verify_sig_add_data((C)->mod_sig, __p, __n);		\
+} while (0)
+
+#define crypto_digest_update_val(C, VAL)			\
+do {								\
+	uint8_t *__p = (uint8_t *)&(VAL);			\
+	size_t __n = sizeof(VAL);				\
+	count_and_csum((C), __p, __n);				\
+	verify_sig_add_data((C)->mod_sig, __p, __n);		\
+} while (0)
+
+static int module_verify_canonicalise(struct module_verify_data *mvdata);
+
+static int extract_elf_rela(struct module_verify_data *mvdata,
+			    int secix,
+			    const Elf_Rela *relatab, size_t nrels,
+			    const char *sh_name);
+
+static int extract_elf_rel(struct module_verify_data *mvdata,
+			   int secix,
+			   const Elf_Rel *reltab, size_t nrels,
+			   const char *sh_name);
+
+#ifdef CONFIG_MODULE_SIG_FORCE
+static int signedonly = 1;
+#else
+static int signedonly;
+#endif
+
+static int __init sign_setup(char *str)
+{
+	signedonly = 1;
+	return 0;
+}
+__setup("enforcemodulesig", sign_setup);
+
+static const char modsign_note_name[] = ELFNOTE_NAME(MODSIGN_NOTE_NAME);
+static const char modsign_note_section[] = ELFNOTE_SECTION(MODSIGN_NOTE_NAME);
+
+/*
+ * verify a module's signature
+ */
+int module_verify_signature(struct module_verify_data *mvdata,
+			    int *_gpgsig_ok)
+{
+	struct crypto_key_verify_context *mod_sig;
+	const struct elf_note *note;
+	const Elf_Shdr *sechdrs = mvdata->sections;
+	const char *secstrings = mvdata->secstrings;
+	const char *sig;
+	unsigned note_size, sig_size, note_namesz;
+	int loop, ret;
+
+	_debug("looking for sig section '%s'\n", modsign_note_section);
+
+	for (loop = 1; loop < mvdata->nsects; loop++) {
+		switch (sechdrs[loop].sh_type) {
+		case SHT_NOTE:
+			if (strcmp(mvdata->secstrings + sechdrs[loop].sh_name,
+				   modsign_note_section) == 0)
+				mvdata->sig_index = loop;
+			break;
+		}
+	}
+
+	if (mvdata->sig_index <= 0)
+		goto no_signature;
+
+	note = mvdata->buffer + sechdrs[mvdata->sig_index].sh_offset;
+	note_size = sechdrs[mvdata->sig_index].sh_size;
+
+	/* there should be one note of the appropriate type */
+	if (note_size < sizeof(*note) + 2 * 4)
+		goto format_error_no_free;
+	note_namesz = note->n_namesz;
+	sig_size = note->n_descsz;
+	if (note_namesz != sizeof(modsign_note_name))
+		goto format_error_no_free;
+	if (note->n_type != MODSIGN_NOTE_TYPE)
+		goto format_error_no_free;
+	if (memcmp(note + 1, modsign_note_name, note_namesz) != 0)
+		goto format_error_no_free;
+	sig = (void *)(note + 1) + roundup(note_namesz, 4);
+
+	_debug("sig in section %d (size %d)\n",
+	       mvdata->sig_index, sig_size);
+	_debug("%02x%02x%02x%02x%02x%02x%02x%02x\n",
+	       sig[0], sig[1], sig[2], sig[3],
+	       sig[4], sig[5], sig[6], sig[7]);
+
+	/* produce a canonicalisation map for the sections */
+	ret = module_verify_canonicalise(mvdata);
+	if (ret < 0)
+		return ret;
+
+	/* Find the crypto key for the module signature
+	 * - !!! if this tries to load the required hash algorithm module,
+	 *       we will deadlock!!!
+	 */
+	mod_sig = verify_sig_begin(modsign_keyring, sig, sig_size);
+	if (IS_ERR(mod_sig)) {
+		pr_err("Couldn't initiate module signature verification: %ld\n",
+		       PTR_ERR(mod_sig));
+		return PTR_ERR(mod_sig);
+	}
+
+	mvdata->mod_sig = mod_sig;
+
+#ifdef MODSIGN_DEBUG
+	mvdata->xcsum = 0;
+#endif
+
+	/* load data from each relevant section into the digest */
+	for (loop = 0; loop < mvdata->ncanon; loop++) {
+		int sect = mvdata->canonlist[loop];
+		unsigned long sh_type = sechdrs[sect].sh_type;
+		unsigned long sh_info = sechdrs[sect].sh_info;
+		unsigned long sh_size = sechdrs[sect].sh_size;
+		unsigned long sh_flags = sechdrs[sect].sh_flags;
+		const char *sh_name = secstrings + sechdrs[sect].sh_name;
+		const void *data = mvdata->buffer + sechdrs[sect].sh_offset;
+
+#ifdef MODSIGN_DEBUG
+		mvdata->csum = 0;
+#endif
+
+		/* it would be nice to include relocation sections, but the act
+		 * of adding a signature to the module seems changes their
+		 * contents, because the symtab gets changed when sections are
+		 * added or removed */
+		if (sh_type == SHT_REL || sh_type == SHT_RELA) {
+			uint32_t xsh_info = mvdata->canonmap[sh_info];
+
+			crypto_digest_update_data(mvdata, sh_name, strlen(sh_name));
+			crypto_digest_update_val(mvdata, sechdrs[sect].sh_type);
+			crypto_digest_update_val(mvdata, sechdrs[sect].sh_flags);
+			crypto_digest_update_val(mvdata, sechdrs[sect].sh_size);
+			crypto_digest_update_val(mvdata, sechdrs[sect].sh_addralign);
+			crypto_digest_update_val(mvdata, xsh_info);
+
+			if (sh_type == SHT_RELA)
+				ret = extract_elf_rela(
+					mvdata, sect,
+					data,
+					sh_size / sizeof(Elf_Rela),
+					sh_name);
+			else
+				ret = extract_elf_rel(
+					mvdata, sect,
+					data,
+					sh_size / sizeof(Elf_Rel),
+					sh_name);
+
+			if (ret < 0)
+				goto format_error;
+			continue;
+		}
+
+		/* include the headers of BSS sections */
+		if (sh_type == SHT_NOBITS && sh_flags & SHF_ALLOC) {
+			crypto_digest_update_data(mvdata, sh_name, strlen(sh_name));
+			crypto_digest_update_val(mvdata, sechdrs[sect].sh_type);
+			crypto_digest_update_val(mvdata, sechdrs[sect].sh_flags);
+			crypto_digest_update_val(mvdata, sechdrs[sect].sh_size);
+			crypto_digest_update_val(mvdata, sechdrs[sect].sh_addralign);
+			goto digested;
+		}
+
+		/* include allocatable loadable sections */
+		if (sh_type != SHT_NOBITS && sh_flags & SHF_ALLOC)
+			goto include_section;
+
+		continue;
+
+	include_section:
+		crypto_digest_update_data(mvdata, sh_name, strlen(sh_name));
+		crypto_digest_update_val(mvdata, sechdrs[sect].sh_type);
+		crypto_digest_update_val(mvdata, sechdrs[sect].sh_flags);
+		crypto_digest_update_val(mvdata, sechdrs[sect].sh_size);
+		crypto_digest_update_val(mvdata, sechdrs[sect].sh_addralign);
+
+		crypto_digest_update_data(mvdata, data, sh_size);
+
+	digested:
+		_debug("%08zx %02x digested the %s section, size %ld\n",
+		       mvdata->signed_size, mvdata->csum, sh_name, sh_size);
+	}
+
+	_debug("Contributed %zu bytes to the digest (csum 0x%02x)\n",
+	       mvdata->signed_size, mvdata->xcsum);
+
+	/* do the actual signature verification */
+	ret = verify_sig_end(mvdata->mod_sig, sig, sig_size);
+	mvdata->mod_sig = NULL;
+
+	_debug("verify-sig : %d\n", ret);
+
+	switch (ret) {
+	case 0:			/* good signature */
+		*_gpgsig_ok = 1;
+		break;
+	case -EKEYREJECTED:	/* signature mismatch or number format error */
+		pr_err("Module signature verification failed\n");
+		break;
+	case -ENOKEY:		/* signed, but we don't have the public key */
+		pr_err("Module signed with unknown public key\n");
+		break;
+	default:		/* other error (probably ENOMEM) */
+		break;
+	}
+
+	return ret;
+
+format_error:
+	verify_sig_cancel(mvdata->mod_sig);
+	mvdata->mod_sig = NULL;
+format_error_no_free:
+	pr_err("Module format error encountered\n");
+	return -ELIBBAD;
+
+	/* deal with the case of an unsigned module */
+no_signature:
+	_debug("no signature found\n");
+	if (!signedonly)
+		return 0;
+	pr_err("An attempt to load unsigned module was rejected\n");
+	return -EKEYREJECTED;
+}
+
+/*
+ * canonicalise the section table index numbers
+ */
+static int module_verify_canonicalise(struct module_verify_data *mvdata)
+{
+	int canon, loop, changed, tmp;
+
+	/* produce a list of index numbers of sections that contribute
+	 * to the kernel's module image
+	 */
+	mvdata->canonlist =
+		kmalloc(sizeof(int) * mvdata->nsects * 2, GFP_KERNEL);
+	if (!mvdata->canonlist)
+		return -ENOMEM;
+
+	mvdata->canonmap = mvdata->canonlist + mvdata->nsects;
+	canon = 0;
+
+	for (loop = 1; loop < mvdata->nsects; loop++) {
+		const Elf_Shdr *section = mvdata->sections + loop;
+
+		if (loop == mvdata->sig_index)
+			continue;
+
+		/* we only need to canonicalise allocatable sections */
+		if (section->sh_flags & SHF_ALLOC)
+			mvdata->canonlist[canon++] = loop;
+		else if ((section->sh_type == SHT_REL ||
+			  section->sh_type == SHT_RELA) &&
+			 mvdata->sections[section->sh_info].sh_flags & SHF_ALLOC)
+			mvdata->canonlist[canon++] = loop;
+	}
+
+	/* canonicalise the index numbers of the contributing section */
+	do {
+		changed = 0;
+
+		for (loop = 0; loop < canon - 1; loop++) {
+			const char *x, *y;
+
+			x = mvdata->secstrings +
+				mvdata->sections[mvdata->canonlist[loop + 0]].sh_name;
+			y = mvdata->secstrings +
+				mvdata->sections[mvdata->canonlist[loop + 1]].sh_name;
+
+			if (strcmp(x, y) > 0) {
+				tmp = mvdata->canonlist[loop + 0];
+				mvdata->canonlist[loop + 0] =
+					mvdata->canonlist[loop + 1];
+				mvdata->canonlist[loop + 1] = tmp;
+				changed = 1;
+			}
+		}
+
+	} while (changed);
+
+	for (loop = 0; loop < canon; loop++)
+		mvdata->canonmap[mvdata->canonlist[loop]] = loop + 1;
+	mvdata->ncanon = canon;
+	return 0;
+}
+
+/*
+ * extract an ELF RELA table
+ * - need to canonicalise the entries in case section addition/removal has
+ *   rearranged the symbol table and the section table
+ */
+static int extract_elf_rela(struct module_verify_data *mvdata,
+			    int secix,
+			    const Elf_Rela *relatab, size_t nrels,
+			    const char *sh_name)
+{
+	struct {
+#if defined(MODULES_ARE_ELF32)
+		uint32_t	r_offset;
+		uint32_t	r_addend;
+		uint32_t	st_value;
+		uint32_t	st_size;
+		uint16_t	st_shndx;
+		uint8_t		r_type;
+		uint8_t		st_info;
+		uint8_t		st_other;
+#elif defined(MODULES_ARE_ELF64)
+		uint64_t	r_offset;
+		uint64_t	r_addend;
+		uint64_t	st_value;
+		uint64_t	st_size;
+		uint32_t	r_type;
+		uint16_t	st_shndx;
+		uint8_t		st_info;
+		uint8_t		st_other;
+#else
+#error unsupported module type
+#endif
+	} __attribute__((packed)) relocation;
+
+	const Elf_Rela *reloc;
+	const Elf_Sym *symbol;
+	size_t loop;
+
+	/* contribute the relevant bits from a join of { RELA, SYMBOL, SECTION } */
+	for (loop = 0; loop < nrels; loop++) {
+		int st_shndx;
+
+		reloc = &relatab[loop];
+
+		/* decode the relocation */
+		relocation.r_offset = reloc->r_offset;
+		relocation.r_addend = reloc->r_addend;
+		relocation.r_type = ELF_R_TYPE(reloc->r_info);
+
+		/* decode the symbol referenced by the relocation */
+		symbol = &mvdata->symbols[ELF_R_SYM(reloc->r_info)];
+		relocation.st_info = symbol->st_info;
+		relocation.st_other = symbol->st_other;
+		relocation.st_value = symbol->st_value;
+		relocation.st_size = symbol->st_size;
+		relocation.st_shndx = symbol->st_shndx;
+		st_shndx = symbol->st_shndx;
+
+		/* canonicalise the section used by the symbol */
+		if (st_shndx > SHN_UNDEF && st_shndx < mvdata->nsects)
+			relocation.st_shndx = mvdata->canonmap[st_shndx];
+
+		crypto_digest_update_val(mvdata, relocation);
+
+		/* undefined symbols must be named if referenced */
+		if (st_shndx == SHN_UNDEF) {
+			const char *name = mvdata->strings + symbol->st_name;
+			crypto_digest_update_data(mvdata,
+						  name, strlen(name) + 1);
+		}
+	}
+
+	_debug("%08zx %02x digested the %s section, nrels %zu\n",
+	       mvdata->signed_size, mvdata->csum, sh_name, nrels);
+
+	return 0;
+}
+
+/*
+ * extract an ELF REL table
+ * - need to canonicalise the entries in case section addition/removal has
+ *   rearranged the symbol table and the section table
+ */
+static int extract_elf_rel(struct module_verify_data *mvdata,
+			   int secix,
+			   const Elf_Rel *reltab, size_t nrels,
+			   const char *sh_name)
+{
+	struct {
+#if defined(MODULES_ARE_ELF32)
+		uint32_t	r_offset;
+		uint32_t	st_value;
+		uint32_t	st_size;
+		uint16_t	st_shndx;
+		uint8_t		r_type;
+		uint8_t		st_info;
+		uint8_t		st_other;
+#elif defined(MODULES_ARE_ELF64)
+		uint64_t	r_offset;
+		uint64_t	st_value;
+		uint64_t	st_size;
+		uint32_t	r_type;
+		uint16_t	st_shndx;
+		uint8_t		st_info;
+		uint8_t		st_other;
+#else
+#error unsupported module type
+#endif
+	} __attribute__((packed)) relocation;
+
+	const Elf_Rel *reloc;
+	const Elf_Sym *symbol;
+	size_t loop;
+
+	/* contribute the relevant bits from a join of { RELA, SYMBOL, SECTION } */
+	for (loop = 0; loop < nrels; loop++) {
+		int st_shndx;
+
+		reloc = &reltab[loop];
+
+		/* decode the relocation */
+		relocation.r_offset = reloc->r_offset;
+		relocation.r_type = ELF_R_TYPE(reloc->r_info);
+
+		/* decode the symbol referenced by the relocation */
+		symbol = &mvdata->symbols[ELF_R_SYM(reloc->r_info)];
+		relocation.st_info = symbol->st_info;
+		relocation.st_other = symbol->st_other;
+		relocation.st_value = symbol->st_value;
+		relocation.st_size = symbol->st_size;
+		relocation.st_shndx = symbol->st_shndx;
+		st_shndx = symbol->st_shndx;
+
+		/* canonicalise the section used by the symbol */
+		if (st_shndx > SHN_UNDEF && st_shndx < mvdata->nsects)
+			relocation.st_shndx = mvdata->canonmap[st_shndx];
+
+		crypto_digest_update_val(mvdata, relocation);
+
+		/* undefined symbols must be named if referenced */
+		if (st_shndx == SHN_UNDEF) {
+			const char *name = mvdata->strings + symbol->st_name;
+			crypto_digest_update_data(mvdata,
+						  name, strlen(name) + 1);
+		}
+	}
+
+	_debug("%08zx %02x digested the %s section, nrels %zu\n",
+	       mvdata->signed_size, mvdata->csum, sh_name, nrels);
+
+	return 0;
+}
+
+/*
+ * Load the compiled-in keys
+ */
+static __init int module_verify_init(void)
+{
+	pr_notice("Initialise module verification\n");
+
+	modsign_keyring = key_alloc(&key_type_keyring, ".module_sign",
+				    0, 0, current_cred(),
+				    (KEY_POS_ALL & ~KEY_POS_SETATTR) |
+				    KEY_USR_VIEW | KEY_USR_READ,
+				    KEY_ALLOC_NOT_IN_QUOTA);
+	if (IS_ERR(modsign_keyring))
+		panic("Can't allocate module signing keyring\n");
+
+	if (key_instantiate_and_link(modsign_keyring, NULL, 0, NULL, NULL) < 0)
+		panic("Can't instantiate module signing keyring\n");
+
+	return 0;
+}
+
+/*
+ * Must be initialised before we try and load the keys into the keyring.
+ */
+device_initcall(module_verify_init);
diff --git a/kernel/module-verify.c b/kernel/module-verify.c
index 875279f..64c5813 100644
--- a/kernel/module-verify.c
+++ b/kernel/module-verify.c
@@ -16,8 +16,9 @@
 /*
  * verify a module's integrity
  * - check the ELF is viable
+ * - check the module's signature
  */
-int module_verify(const Elf_Ehdr *hdr, size_t size)
+int module_verify(const Elf_Ehdr *hdr, size_t size, int *_gpgsig_ok)
 {
 	struct module_verify_data mvdata;
 	int ret;
@@ -34,6 +35,8 @@ int module_verify(const Elf_Ehdr *hdr, size_t size)
 		goto error;
 	}
 
+	ret = module_verify_signature(&mvdata, _gpgsig_ok);
+
 error:
 	kfree(mvdata.secsizes);
 	kfree(mvdata.canonlist);
diff --git a/kernel/module-verify.h b/kernel/module-verify.h
index 20884fc..0ccdb71 100644
--- a/kernel/module-verify.h
+++ b/kernel/module-verify.h
@@ -10,10 +10,13 @@
  */
 
 #include <linux/types.h>
+#include <linux/elf.h>
+#include <keys/crypto-type.h>
 #include <asm/module.h>
 
 #ifdef CONFIG_MODULE_VERIFY
 struct module_verify_data {
+	struct crypto_key_verify_context *mod_sig; /* Module signing context */
 	const void		*buffer;	/* module buffer */
 	const Elf_Ehdr		*hdr;		/* ELF header */
 	const Elf_Shdr		*sections;	/* ELF section table */
@@ -37,7 +40,7 @@ struct module_verify_data {
 /*
  * module-verify.c
  */
-extern int module_verify(const Elf_Ehdr *hdr, size_t size);
+extern int module_verify(const Elf_Ehdr *hdr, size_t size, int *_gpgsig_ok);
 
 /*
  * module-verify-elf.c
@@ -48,6 +51,18 @@ extern int module_verify_elf(struct module_verify_data *mvdata);
 #define module_verify_elf(m) (0)
 #endif
 
+/*
+ * module-verify-sig.c
+ */
+#ifdef CONFIG_MODULE_SIG
+extern struct key *modsign_keyring;
+
+extern int module_verify_signature(struct module_verify_data *mvdata,
+				   int *_gpgsig_ok);
+#else
+#define module_verify_signature(m, g) (0)
+#endif
+
 #else
-#define module_verify(h, s) (0)
+#define module_verify(h, s, g) (0)
 #endif
diff --git a/kernel/module.c b/kernel/module.c
index 8309389..9672d8a 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2333,7 +2333,8 @@ static inline void kmemleak_load_module(const struct module *mod,
 /* Sets info->hdr and info->len. */
 static int copy_and_check(struct load_info *info,
 			  const void __user *umod, unsigned long len,
-			  const char __user *uargs)
+			  const char __user *uargs,
+			  int *_gpgsig_ok)
 {
 	int err;
 	Elf_Ehdr *hdr;
@@ -2367,7 +2368,7 @@ static int copy_and_check(struct load_info *info,
 	}
 
 	/* Verify the module's contents */
-	err = module_verify(hdr, len);
+	err = module_verify(hdr, len, _gpgsig_ok);
 	if (err < 0)
 		goto free_hdr;
 
@@ -2713,7 +2714,8 @@ int __weak module_frob_arch_sections(Elf_Ehdr *hdr,
 	return 0;
 }
 
-static struct module *layout_and_allocate(struct load_info *info)
+static struct module *layout_and_allocate(struct load_info *info,
+					  int gpgsig_ok)
 {
 	/* Module within temporary copy. */
 	struct module *mod;
@@ -2723,6 +2725,7 @@ static struct module *layout_and_allocate(struct load_info *info)
 	mod = setup_load_info(info);
 	if (IS_ERR(mod))
 		return mod;
+	mod->gpgsig_ok = gpgsig_ok;
 
 	err = check_modinfo(mod, info);
 	if (err)
@@ -2816,17 +2819,18 @@ static struct module *load_module(void __user *umod,
 	struct load_info info = { NULL, };
 	struct module *mod;
 	long err;
+	int gpgsig_ok;
 
 	DEBUGP("load_module: umod=%p, len=%lu, uargs=%p\n",
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
@@ -3476,8 +3480,13 @@ void print_modules(void)
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
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 08dce14..b436b04 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -14,7 +14,8 @@
 # 3)  create one <module>.mod.c file pr. module
 # 4)  create one Module.symvers file with CRC for all exported symbols
 # 5) compile all <module>.mod.c files
-# 6) final link of the module to a <module.ko> file
+# 6) final link of the module to a <module.ko> (or <module.unsigned>) file
+# 7) signs the modules to a <module.ko> file
 
 # Step 3 is used to place certain information in the module's ELF
 # section, including information such as:
@@ -32,6 +33,8 @@
 # Step 4 is solely used to allow module versioning in external modules,
 # where the CRC of each module is retrieved from the Module.symvers file.
 
+# Step 7 is dependent on CONFIG_MODULE_SIG being enabled.
+
 # KBUILD_MODPOST_WARN can be set to avoid error out in case of undefined
 # symbols in the final module linking stage
 # KBUILD_MODPOST_NOFINAL can be set to skip the final link of modules.
@@ -116,6 +119,7 @@ $(modules:.ko=.mod.o): %.mod.o: %.mod.c FORCE
 targets += $(modules:.ko=.mod.o)
 
 # Step 6), final link of the modules
+ifneq ($(CONFIG_MODULE_SIG),y)
 quiet_cmd_ld_ko_o = LD [M]  $@
       cmd_ld_ko_o = $(LD) -r $(LDFLAGS)                                 \
                              $(KBUILD_LDFLAGS_MODULE) $(LDFLAGS_MODULE) \
@@ -125,7 +129,86 @@ $(modules): %.ko :%.o %.mod.o FORCE
 	$(call if_changed,ld_ko_o)
 
 targets += $(modules)
+else
+quiet_cmd_ld_ko_unsigned_o = LD [M]  $@
+      cmd_ld_ko_unsigned_o =						\
+		$(LD) -r $(LDFLAGS)					\
+			 $(KBUILD_LDFLAGS_MODULE) $(LDFLAGS_MODULE)	\
+			 -o $@ $(filter-out FORCE,$^)			\
+		$(if $(AFTER_LINK),; $(AFTER_LINK))
+
+$(modules:.ko=.ko.unsigned): %.ko.unsigned :%.o %.mod.o FORCE
+	$(call if_changed,ld_ko_unsigned_o)
+
+targets += $(modules:.ko=.ko.unsigned)
+
+# Step 7), sign the modules
+MODSECKEY = ./kernel.sec
+MODPUBKEY = ./kernel.pub
+KEYFLAGS = --no-default-keyring --secret-keyring $(MODSECKEY) --keyring $(MODPUBKEY) --no-default-keyring --homedir . --no-options --no-auto-check-trustdb --no-permission-warning
+
+ifdef CONFIG_MODULE_SIG_SHA1
+KEYFLAGS += --digest-algo=SHA1
+else
+ifdef CONFIG_MODULE_SIG_SHA224
+KEYFLAGS += --digest-algo=SHA224
+else
+ifdef CONFIG_MODULE_SIG_SHA256
+KEYFLAGS += --digest-algo=SHA256
+else
+ifdef CONFIG_MODULE_SIG_SHA384
+KEYFLAGS += --digest-algo=SHA384
+else
+ifdef CONFIG_MODULE_SIG_SHA512
+KEYFLAGS += --digest-algo=SHA512
+else
+endif
+endif
+endif
+endif
+endif
+
+ifdef MODKEYNAME
+KEYFLAGS += --default-key $(MODKEYNAME)
+endif
 
+ifeq ($(wildcard $(MODSECKEY))+$(wildcard $(MODPUBKEY)),$(MODSECKEY)+$(MODPUBKEY))
+ifeq ($(KBUILD_SRC),)
+	# no O= is being used
+	SCRIPTS_DIR := scripts
+else
+	SCRIPTS_DIR := $(KBUILD_SRC)/scripts
+endif
+SIGN_MODULES := 1
+else
+SIGN_MODULES := 0
+endif
+
+# only sign if it's an in-tree module
+ifneq ($(KBUILD_EXTMOD),)
+SIGN_MODULES := 0
+endif
+
+ifeq ($(SIGN_MODULES),1)
+quiet_cmd_sign_ko_ko_unsigned = SIGN [M] $@
+      cmd_sign_ko_ko_unsigned = \
+		scripts/mod/mod-extract $< $@.digest && \
+		rm -f $@.digest.sig && \
+		gpg --batch --no-greeting $(KEYFLAGS) -b $@.digest && \
+		sh $(SCRIPTS_DIR)/mod/modsign-note.sh $@.digest.sig | \
+		  $(CC) -x assembler-with-cpp $(c_flags) $(CFLAGS_MODULE) -c -o $@.note.o - && \
+		$(LD) -r $(LDFLAGS) -o $@ $< $@.note.o
+else
+quiet_cmd_sign_ko_ko_unsigned = NO SIGN [M] $@
+      cmd_sign_ko_ko_unsigned = \
+		cp $< $@
+endif
+
+$(modules): %.ko :%.ko.unsigned FORCE
+	$(call if_changed,sign_ko_ko_unsigned)
+
+targets += $(modules)
+endif
 
 # Add FORCE to the prequisites of a target to force it to be always rebuilt.
 # ---------------------------------------------------------------------------
diff --git a/scripts/mod/.gitignore b/scripts/mod/.gitignore
index e9b7abe..223dfd6 100644
--- a/scripts/mod/.gitignore
+++ b/scripts/mod/.gitignore
@@ -1,4 +1,5 @@
 elfconfig.h
 mk_elfconfig
 modpost
+mod-extract
 
diff --git a/scripts/mod/Makefile b/scripts/mod/Makefile
index ff954f8..4654e3b 100644
--- a/scripts/mod/Makefile
+++ b/scripts/mod/Makefile
@@ -1,4 +1,4 @@
-hostprogs-y	:= modpost mk_elfconfig
+hostprogs-y	:= modpost mk_elfconfig mod-extract
 always		:= $(hostprogs-y) empty.o
 
 modpost-objs	:= modpost.o file2alias.o sumversion.o
diff --git a/scripts/mod/mod-extract.c b/scripts/mod/mod-extract.c
new file mode 100644
index 0000000..0c0e3e3
--- /dev/null
+++ b/scripts/mod/mod-extract.c
@@ -0,0 +1,913 @@
+/* mod-extract.c: module extractor for signing
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <stdarg.h>
+#include <string.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <elf.h>
+#include <asm/byteorder.h>
+
+static void extract_elf64(void *buffer, size_t size, Elf64_Ehdr *hdr);
+static void extract_elf32(void *buffer, size_t size, Elf32_Ehdr *hdr);
+
+struct byteorder {
+	uint16_t (*get16)(const uint16_t *);
+	uint32_t (*get32)(const uint32_t *);
+	uint64_t (*get64)(const uint64_t *);
+	void (*set16)(uint16_t *, uint16_t);
+	void (*set32)(uint32_t *, uint32_t);
+	void (*set64)(uint64_t *, uint64_t);
+};
+
+static uint16_t get16_le(const uint16_t *p) { return __le16_to_cpu(*p); }
+static uint32_t get32_le(const uint32_t *p) { return __le32_to_cpu(*p); }
+static uint64_t get64_le(const uint64_t *p) { return __le64_to_cpu(*p); }
+static uint16_t get16_be(const uint16_t *p) { return __be16_to_cpu(*p); }
+static uint32_t get32_be(const uint32_t *p) { return __be32_to_cpu(*p); }
+static uint64_t get64_be(const uint64_t *p) { return __be64_to_cpu(*p); }
+
+static void set16_le(uint16_t *p, uint16_t n) { *p = __cpu_to_le16(n); }
+static void set32_le(uint32_t *p, uint32_t n) { *p = __cpu_to_le32(n); }
+static void set64_le(uint64_t *p, uint64_t n) { *p = __cpu_to_le64(n); }
+static void set16_be(uint16_t *p, uint16_t n) { *p = __cpu_to_be16(n); }
+static void set32_be(uint32_t *p, uint32_t n) { *p = __cpu_to_be32(n); }
+static void set64_be(uint64_t *p, uint64_t n) { *p = __cpu_to_be64(n); }
+
+static const struct byteorder byteorder_le = {
+	get16_le, get32_le, get64_le,
+	set16_le, set32_le, set64_le
+};
+static const struct byteorder byteorder_be = {
+	get16_be, get32_be, get64_be,
+	set16_be, set32_be, set64_be
+};
+static const struct byteorder *order;
+
+static inline uint16_t get16(const uint16_t *p) { return order->get16(p); }
+static inline uint32_t get32(const uint32_t *p) { return order->get32(p); }
+static inline uint64_t get64(const uint64_t *p) { return order->get64(p); }
+static inline void set16(uint16_t *p, uint16_t n) { order->set16(p, n); }
+static inline void set32(uint32_t *p, uint32_t n) { order->set32(p, n); }
+static inline void set64(uint64_t *p, uint64_t n) { order->set64(p, n); }
+
+static FILE *outfd;
+static uint8_t csum, xcsum;
+
+static void write_out(const void *data, size_t size)
+{
+	const uint8_t *p = data;
+	size_t loop;
+
+	for (loop = 0; loop < size; loop++) {
+		csum += p[loop];
+		xcsum += p[loop];
+	}
+
+	if (fwrite(data, 1, size, outfd) != size) {
+		perror("write");
+		exit(1);
+	}
+}
+
+#define write_out_val(VAL) write_out(&(VAL), sizeof(VAL))
+
+static int is_verbose;
+
+static __attribute__((format(printf, 1, 2)))
+void verbose(const char *fmt, ...)
+{
+	va_list va;
+
+	if (is_verbose) {
+		va_start(va, fmt);
+		vprintf(fmt, va);
+		va_end(va);
+	}
+}
+
+static __attribute__((noreturn))
+void usage(void)
+{
+	fprintf(stderr, "Usage: mod-extract [-v] <modulefile> <extractfile>\n");
+	exit(2);
+}
+
+/*
+ *
+ */
+int main(int argc, char **argv)
+{
+	struct stat st;
+	Elf32_Ehdr *hdr32;
+	Elf64_Ehdr *hdr64;
+	size_t len;
+	void *buffer;
+	int fd, be, b64;
+
+	while (argc > 1 && strcmp("-v", argv[1]) == 0) {
+		argv++;
+		argc--;
+		is_verbose++;
+	}
+
+	if (argc != 3)
+		usage();
+
+	/* map the module into memory */
+	fd = open(argv[1], O_RDONLY);
+	if (fd < 0) {
+		perror("open input");
+		exit(1);
+	}
+
+	if (fstat(fd, &st) < 0) {
+		perror("fstat");
+		exit(1);
+	}
+
+	len = st.st_size;
+
+	buffer = mmap(NULL, len, PROT_READ|PROT_WRITE, MAP_PRIVATE, fd, 0);
+	if (buffer == MAP_FAILED) {
+		perror("mmap");
+		exit(1);
+	}
+
+	if (close(fd) < 0) {
+		perror("close input");
+		exit(1);
+	}
+
+	/* check it's an ELF object */
+	hdr32 = buffer;
+	hdr64 = buffer;
+
+	if (hdr32->e_ident[EI_MAG0] != ELFMAG0 ||
+	    hdr32->e_ident[EI_MAG1] != ELFMAG1 ||
+	    hdr32->e_ident[EI_MAG2] != ELFMAG2 ||
+	    hdr32->e_ident[EI_MAG3] != ELFMAG3
+	    ) {
+		fprintf(stderr, "Module does not appear to be ELF\n");
+		exit(3);
+	}
+
+	/* determine endianness and word size */
+	b64 = (hdr32->e_ident[EI_CLASS] == ELFCLASS64);
+	be = (hdr32->e_ident[EI_DATA] == ELFDATA2MSB);
+	order = be ? &byteorder_be : &byteorder_le;
+
+	verbose("Module is %s-bit %s-endian\n",
+		b64 ? "64" : "32",
+		be ? "big" : "little");
+
+	/* open the output file */
+	outfd = fopen(argv[2], "w");
+	if (!outfd) {
+		perror("open output");
+		exit(1);
+	}
+
+	/* perform the extraction */
+	if (b64)
+		extract_elf64(buffer, len, hdr64);
+	else
+		extract_elf32(buffer, len, hdr32);
+
+	/* done */
+	if (fclose(outfd) == EOF) {
+		perror("close output");
+		exit(1);
+	}
+
+	return 0;
+}
+
+/*
+ * extract a RELA table
+ * - need to canonicalise the entries in case section addition/removal has
+ *   rearranged the symbol table and the section table
+ */
+static void extract_elf64_rela(const void *buffer, int secix, int targetix,
+			       const Elf64_Rela *relatab, size_t nrels,
+			       const Elf64_Sym *symbols, size_t nsyms,
+			       const Elf64_Shdr *sections, size_t nsects, int *canonmap,
+			       const char *strings, size_t nstrings,
+			       const char *sh_name)
+{
+	struct {
+		uint64_t	r_offset;
+		uint64_t	r_addend;
+		uint64_t	st_value;
+		uint64_t	st_size;
+		uint32_t	r_type;
+		uint16_t	st_shndx;
+		uint8_t		st_info;
+		uint8_t		st_other;
+
+	} __attribute__((packed)) relocation;
+
+	const Elf64_Sym *symbol;
+	size_t loop;
+
+	/* contribute the relevant bits from a join of { RELA, SYMBOL, SECTION } */
+	for (loop = 0; loop < nrels; loop++) {
+		Elf64_Section st_shndx;
+		Elf64_Xword r_info;
+
+		/* decode the relocation */
+		r_info = get64(&relatab[loop].r_info);
+		relocation.r_offset = relatab[loop].r_offset;
+		relocation.r_addend = relatab[loop].r_addend;
+		set32(&relocation.r_type, ELF64_R_TYPE(r_info));
+
+		if (ELF64_R_SYM(r_info) >= nsyms) {
+			fprintf(stderr, "Invalid symbol ID %zx in relocation %zu\n",
+				(size_t)ELF64_R_SYM(r_info), loop);
+			exit(1);
+		}
+
+		/* decode the symbol referenced by the relocation */
+		symbol = &symbols[ELF64_R_SYM(r_info)];
+		relocation.st_info = symbol->st_info;
+		relocation.st_other = symbol->st_other;
+		relocation.st_value = symbol->st_value;
+		relocation.st_size = symbol->st_size;
+		relocation.st_shndx = symbol->st_shndx;
+		st_shndx = get16(&symbol->st_shndx);
+
+		/* canonicalise the section used by the symbol */
+		if (st_shndx > SHN_UNDEF && st_shndx < nsects)
+			set16(&relocation.st_shndx, canonmap[st_shndx]);
+
+		write_out_val(relocation);
+
+		/* undefined symbols must be named if referenced */
+		if (st_shndx == SHN_UNDEF) {
+			const char *name = strings + get32(&symbol->st_name);
+			write_out(name, strlen(name) + 1);
+		}
+	}
+
+	verbose("%02x %4d %s [canon]\n", csum, secix, sh_name);
+}
+
+/*
+ * extract a REL table
+ * - need to canonicalise the entries in case section addition/removal has
+ *   rearranged the symbol table and the section table
+ */
+static void extract_elf64_rel(const void *buffer, int secix, int targetix,
+			      const Elf64_Rel *relatab, size_t nrels,
+			      const Elf64_Sym *symbols, size_t nsyms,
+			      const Elf64_Shdr *sections, size_t nsects, int *canonmap,
+			      const char *strings, size_t nstrings,
+			      const char *sh_name)
+{
+	struct {
+		uint64_t	r_offset;
+		uint64_t	st_value;
+		uint64_t	st_size;
+		uint32_t	r_type;
+		uint16_t	st_shndx;
+		uint8_t		st_info;
+		uint8_t		st_other;
+
+	} __attribute__((packed)) relocation;
+
+	const Elf64_Sym *symbol;
+	size_t loop;
+
+	/* contribute the relevant bits from a join of { RELA, SYMBOL, SECTION } */
+	for (loop = 0; loop < nrels; loop++) {
+		Elf64_Section st_shndx;
+		Elf64_Xword r_info;
+
+		/* decode the relocation */
+		r_info = get64(&relatab[loop].r_info);
+		relocation.r_offset = relatab[loop].r_offset;
+		set32(&relocation.r_type, ELF64_R_TYPE(r_info));
+
+		if (ELF64_R_SYM(r_info) >= nsyms) {
+			fprintf(stderr, "Invalid symbol ID %zx in relocation %zu\n",
+				(size_t)ELF64_R_SYM(r_info), loop);
+			exit(1);
+		}
+
+		/* decode the symbol referenced by the relocation */
+		symbol = &symbols[ELF64_R_SYM(r_info)];
+		relocation.st_info = symbol->st_info;
+		relocation.st_other = symbol->st_other;
+		relocation.st_value = symbol->st_value;
+		relocation.st_size = symbol->st_size;
+		relocation.st_shndx = symbol->st_shndx;
+		st_shndx = get16(&symbol->st_shndx);
+
+		/* canonicalise the section used by the symbol */
+		if (st_shndx > SHN_UNDEF && st_shndx < nsects)
+			set16(&relocation.st_shndx, canonmap[st_shndx]);
+
+		write_out_val(relocation);
+
+		/* undefined symbols must be named if referenced */
+		if (st_shndx == SHN_UNDEF) {
+			const char *name = strings + get32(&symbol->st_name);
+			write_out(name, strlen(name) + 1);
+		}
+	}
+
+	verbose("%02x %4d %s [canon]\n", csum, secix, sh_name);
+}
+
+/*
+ * extract the data from a 64-bit module
+ */
+static void extract_elf64(void *buffer, size_t len, Elf64_Ehdr *hdr)
+{
+	const Elf64_Sym *symbols;
+	Elf64_Shdr *sections;
+	const char *secstrings, *strings;
+	size_t nsyms, nstrings;
+	int loop, shnum, *canonlist, *canonmap, canon, changed, tmp;
+
+	sections = buffer + get64(&hdr->e_shoff);
+	secstrings = buffer + get64(&sections[get16(&hdr->e_shstrndx)].sh_offset);
+	shnum = get16(&hdr->e_shnum);
+
+	/* find the symbol table and the string table and produce a list of
+	 * index numbers of sections that contribute to the kernel's module
+	 * image
+	 */
+	canonlist = calloc(sizeof(int), shnum * 2);
+	if (!canonlist) {
+		perror("calloc");
+		exit(1);
+	}
+	canonmap = canonlist + shnum;
+	canon = 0;
+
+	symbols = NULL;
+	strings = NULL;
+	nstrings = 0;
+	nsyms = 0;
+
+	for (loop = 1; loop < shnum; loop++) {
+		const char *sh_name = secstrings + get32(&sections[loop].sh_name);
+		Elf64_Word  sh_type	= get32(&sections[loop].sh_type);
+		Elf64_Xword sh_size	= get64(&sections[loop].sh_size);
+		Elf64_Xword sh_flags	= get64(&sections[loop].sh_flags);
+		Elf64_Word  sh_info	= get32(&sections[loop].sh_info);
+		Elf64_Off   sh_offset	= get64(&sections[loop].sh_offset);
+		void *data = buffer + sh_offset;
+
+		/* quick sanity check */
+		if (sh_type != SHT_NOBITS && len < sh_offset + sh_size) {
+			fprintf(stderr, "Section goes beyond EOF\n");
+			exit(3);
+		}
+
+		/* we only need to canonicalise allocatable sections */
+		if (sh_flags & SHF_ALLOC)
+			canonlist[canon++] = loop;
+		else if ((sh_type == SHT_REL || sh_type == SHT_RELA) &&
+			 get64(&sections[sh_info].sh_flags) & SHF_ALLOC)
+			canonlist[canon++] = loop;
+
+		/* keep track of certain special sections */
+		switch (sh_type) {
+		case SHT_SYMTAB:
+			if (strcmp(sh_name, ".symtab") == 0) {
+				symbols = data;
+				nsyms = sh_size / sizeof(Elf64_Sym);
+			}
+			break;
+
+		case SHT_STRTAB:
+			if (strcmp(sh_name, ".strtab") == 0) {
+				strings = data;
+				nstrings = sh_size;
+			}
+			break;
+
+		default:
+			break;
+		}
+	}
+
+	if (!symbols) {
+		fprintf(stderr, "Couldn't locate symbol table\n");
+		exit(3);
+	}
+
+	if (!strings) {
+		fprintf(stderr, "Couldn't locate strings table\n");
+		exit(3);
+	}
+
+	/* canonicalise the index numbers of the contributing section */
+	do {
+		changed = 0;
+
+		for (loop = 0; loop < canon - 1; loop++) {
+			const char *x = secstrings + get32(&sections[canonlist[loop + 0]].sh_name);
+			const char *y = secstrings + get32(&sections[canonlist[loop + 1]].sh_name);
+			if (strcmp(x, y) > 0) {
+				tmp = canonlist[loop + 0];
+				canonlist[loop + 0] = canonlist[loop + 1];
+				canonlist[loop + 1] = tmp;
+				changed = 1;
+			}
+		}
+
+	} while (changed);
+
+	for (loop = 0; loop < canon; loop++)
+		canonmap[canonlist[loop]] = loop + 1;
+
+	if (is_verbose > 1) {
+		printf("\nSection canonicalisation map:\n");
+		for (loop = 1; loop < shnum; loop++) {
+			const char *x = secstrings + get32(&sections[loop].sh_name);
+			printf("%4d %s\n", canonmap[loop], x);
+		}
+
+		printf("\nAllocated section list in canonical order:\n");
+		for (loop = 0; loop < canon; loop++) {
+			const char *x = secstrings + get32(&sections[canonlist[loop]].sh_name);
+			printf("%4d %s\n", canonlist[loop], x);
+		}
+	}
+
+	/* iterate through the section table looking for sections we want to
+	 * contribute to the signature */
+	verbose("\n");
+	verbose("CAN FILE POS CS SECT NAME\n");
+	verbose("=== ======== == ==== ==============================\n");
+
+	for (loop = 0; loop < canon; loop++) {
+		int sect = canonlist[loop];
+		const char *sh_name = secstrings + get32(&sections[sect].sh_name);
+		Elf64_Word  sh_type	= get32(&sections[sect].sh_type);
+		Elf64_Xword sh_size	= get64(&sections[sect].sh_size);
+		Elf64_Xword sh_flags	= get64(&sections[sect].sh_flags);
+		Elf64_Word  sh_info	= get32(&sections[sect].sh_info);
+		Elf64_Off   sh_offset	= get64(&sections[sect].sh_offset);
+		void *data = buffer + sh_offset;
+
+		csum = 0;
+
+		/* include canonicalised relocation sections */
+		if (sh_type == SHT_REL || sh_type == SHT_RELA) {
+			Elf32_Word canon_sh_info;
+
+			if (sh_info <= 0 && sh_info >= hdr->e_shnum) {
+				fprintf(stderr,
+					"Invalid ELF - REL/RELA sh_info does"
+					" not refer to a valid section\n");
+				exit(3);
+			}
+
+			verbose("%3u %08lx ", loop, ftell(outfd));
+
+			set32(&canon_sh_info, canonmap[sh_info]);
+
+			/* write out selected portions of the section header */
+			write_out(sh_name, strlen(sh_name));
+			write_out_val(sections[sect].sh_type);
+			write_out_val(sections[sect].sh_flags);
+			write_out_val(sections[sect].sh_size);
+			write_out_val(sections[sect].sh_addralign);
+			write_out_val(canon_sh_info);
+
+			if (sh_type == SHT_RELA)
+				extract_elf64_rela(buffer, sect, sh_info,
+						   data, sh_size / sizeof(Elf64_Rela),
+						   symbols, nsyms,
+						   sections, shnum, canonmap,
+						   strings, nstrings,
+						   sh_name);
+			else
+				extract_elf64_rel(buffer, sect, sh_info,
+						  data, sh_size / sizeof(Elf64_Rel),
+						  symbols, nsyms,
+						  sections, shnum, canonmap,
+						  strings, nstrings,
+						  sh_name);
+			continue;
+		}
+
+		/* include the headers of BSS sections */
+		if (sh_type == SHT_NOBITS && sh_flags & SHF_ALLOC) {
+			verbose("%3u %08lx ", loop, ftell(outfd));
+
+			/* write out selected portions of the section header */
+			write_out(sh_name, strlen(sh_name));
+			write_out_val(sections[sect].sh_type);
+			write_out_val(sections[sect].sh_flags);
+			write_out_val(sections[sect].sh_size);
+			write_out_val(sections[sect].sh_addralign);
+
+			verbose("%02x %4d %s\n", csum, sect, sh_name);
+		}
+
+		/* include allocatable loadable sections */
+		if (sh_type != SHT_NOBITS && sh_flags & SHF_ALLOC)
+			goto include_section;
+
+		/* not this section */
+		continue;
+
+	include_section:
+		verbose("%3u %08lx ", loop, ftell(outfd));
+
+		/* write out selected portions of the section header */
+		write_out(sh_name, strlen(sh_name));
+		write_out_val(sections[sect].sh_type);
+		write_out_val(sections[sect].sh_flags);
+		write_out_val(sections[sect].sh_size);
+		write_out_val(sections[sect].sh_addralign);
+
+		/* write out the section data */
+		write_out(data, sh_size);
+
+		verbose("%02x %4d %s\n", csum, sect, sh_name);
+	}
+
+	verbose("%08lx         (%lu bytes csum 0x%02x)\n",
+		ftell(outfd), ftell(outfd), xcsum);
+}
+
+/*
+ * extract a RELA table
+ * - need to canonicalise the entries in case section addition/removal has
+ *   rearranged the symbol table and the section table
+ */
+static void extract_elf32_rela(const void *buffer, int secix, int targetix,
+			       const Elf32_Rela *relatab, size_t nrels,
+			       const Elf32_Sym *symbols, size_t nsyms,
+			       const Elf32_Shdr *sections, size_t nsects,
+			       int *canonmap,
+			       const char *strings, size_t nstrings,
+			       const char *sh_name)
+{
+	struct {
+		uint32_t	r_offset;
+		uint32_t	r_addend;
+		uint32_t	st_value;
+		uint32_t	st_size;
+		uint16_t	st_shndx;
+		uint8_t		r_type;
+		uint8_t		st_info;
+		uint8_t		st_other;
+
+	} __attribute__((packed)) relocation;
+
+	const Elf32_Sym *symbol;
+	size_t loop;
+
+	/* contribute the relevant bits from a join of { RELA, SYMBOL, SECTION } */
+	for (loop = 0; loop < nrels; loop++) {
+		Elf32_Section st_shndx;
+		Elf32_Word r_info;
+
+		/* decode the relocation */
+		r_info = get32(&relatab[loop].r_info);
+		relocation.r_offset = relatab[loop].r_offset;
+		relocation.r_addend = relatab[loop].r_addend;
+		relocation.r_type = ELF32_R_TYPE(r_info);
+
+		if (ELF32_R_SYM(r_info) >= nsyms) {
+			fprintf(stderr, "Invalid symbol ID %x in relocation %zu\n",
+				ELF32_R_SYM(r_info), loop);
+			exit(1);
+		}
+
+		/* decode the symbol referenced by the relocation */
+		symbol = &symbols[ELF32_R_SYM(r_info)];
+		relocation.st_info = symbol->st_info;
+		relocation.st_other = symbol->st_other;
+		relocation.st_value = symbol->st_value;
+		relocation.st_size = symbol->st_size;
+		relocation.st_shndx = symbol->st_shndx;
+		st_shndx = get16(&symbol->st_shndx);
+
+		/* canonicalise the section used by the symbol */
+		if (st_shndx > SHN_UNDEF && st_shndx < nsects)
+			set16(&relocation.st_shndx, canonmap[st_shndx]);
+
+		write_out_val(relocation);
+
+		/* undefined symbols must be named if referenced */
+		if (st_shndx == SHN_UNDEF) {
+			const char *name = strings + get32(&symbol->st_name);
+			write_out(name, strlen(name) + 1);
+		}
+	}
+
+	verbose("%02x %4d %s [canon]\n", csum, secix, sh_name);
+}
+
+/*
+ * extract a REL table
+ * - need to canonicalise the entries in case section addition/removal has
+ *   rearranged the symbol table and the section table
+ */
+static void extract_elf32_rel(const void *buffer, int secix, int targetix,
+			      const Elf32_Rel *relatab, size_t nrels,
+			      const Elf32_Sym *symbols, size_t nsyms,
+			      const Elf32_Shdr *sections, size_t nsects,
+			      int *canonmap,
+			      const char *strings, size_t nstrings,
+			      const char *sh_name)
+{
+	struct {
+		uint32_t	r_offset;
+		uint32_t	st_value;
+		uint32_t	st_size;
+		uint16_t	st_shndx;
+		uint8_t		r_type;
+		uint8_t		st_info;
+		uint8_t		st_other;
+
+	} __attribute__((packed)) relocation;
+
+	const Elf32_Sym *symbol;
+	size_t loop;
+
+	/* contribute the relevant bits from a join of { RELA, SYMBOL, SECTION } */
+	for (loop = 0; loop < nrels; loop++) {
+		Elf32_Section st_shndx;
+		Elf32_Word r_info;
+
+		/* decode the relocation */
+		r_info = get32(&relatab[loop].r_info);
+		relocation.r_offset = relatab[loop].r_offset;
+		relocation.r_type = ELF32_R_TYPE(r_info);
+
+		if (ELF32_R_SYM(r_info) >= nsyms) {
+			fprintf(stderr, "Invalid symbol ID %x in relocation %zu\n",
+				ELF32_R_SYM(r_info), loop);
+			exit(1);
+		}
+
+		/* decode the symbol referenced by the relocation */
+		symbol = &symbols[ELF32_R_SYM(r_info)];
+		relocation.st_info = symbol->st_info;
+		relocation.st_other = symbol->st_other;
+		relocation.st_value = symbol->st_value;
+		relocation.st_size = symbol->st_size;
+		relocation.st_shndx = symbol->st_shndx;
+		st_shndx = get16(&symbol->st_shndx);
+
+		/* canonicalise the section used by the symbol */
+		if (st_shndx > SHN_UNDEF && st_shndx < nsects)
+			set16(&relocation.st_shndx, canonmap[st_shndx]);
+
+		write_out_val(relocation);
+
+		/* undefined symbols must be named if referenced */
+		if (st_shndx == SHN_UNDEF) {
+			const char *name = strings + get32(&symbol->st_name);
+			write_out(name, strlen(name) + 1);
+		}
+	}
+
+	verbose("%02x %4d %s [canon]\n", csum, secix, sh_name);
+}
+
+/*
+ * extract the data from a 32-bit module
+ */
+static void extract_elf32(void *buffer, size_t len, Elf32_Ehdr *hdr)
+{
+	const Elf32_Sym *symbols;
+	Elf32_Shdr *sections;
+	const char *secstrings, *strings;
+	size_t nsyms, nstrings;
+	int loop, shnum, *canonlist, *canonmap, canon, changed, tmp;
+
+	sections = buffer + get32(&hdr->e_shoff);
+	secstrings = buffer + get32(&sections[get16(&hdr->e_shstrndx)].sh_offset);
+	shnum = get16(&hdr->e_shnum);
+
+	/* find the symbol table and the string table and produce a list of
+	 * index numbers of sections that contribute to the kernel's module
+	 * image
+	 */
+	canonlist = calloc(sizeof(int), shnum * 2);
+	if (!canonlist) {
+		perror("calloc");
+		exit(1);
+	}
+	canonmap = canonlist + shnum;
+	canon = 0;
+
+	symbols = NULL;
+	strings = NULL;
+	nstrings = 0;
+	nsyms = 0;
+
+	for (loop = 1; loop < shnum; loop++) {
+		const char *sh_name = secstrings + get32(&sections[loop].sh_name);
+		Elf32_Word  sh_type	= get32(&sections[loop].sh_type);
+		Elf32_Xword sh_size	= get32(&sections[loop].sh_size);
+		Elf32_Xword sh_flags	= get32(&sections[loop].sh_flags);
+		Elf64_Word  sh_info	= get32(&sections[loop].sh_info);
+		Elf32_Off   sh_offset	= get32(&sections[loop].sh_offset);
+		void *data = buffer + sh_offset;
+
+		/* quick sanity check */
+		if (sh_type != SHT_NOBITS && len < sh_offset + sh_size) {
+			fprintf(stderr, "Section goes beyond EOF\n");
+			exit(3);
+		}
+
+		/* we only need to canonicalise allocatable sections */
+		if (sh_flags & SHF_ALLOC)
+			canonlist[canon++] = loop;
+		else if ((sh_type == SHT_REL || sh_type == SHT_RELA) &&
+			 get32(&sections[sh_info].sh_flags) & SHF_ALLOC)
+			canonlist[canon++] = loop;
+
+		/* keep track of certain special sections */
+		switch (sh_type) {
+		case SHT_SYMTAB:
+			if (strcmp(sh_name, ".symtab") == 0) {
+				symbols = data;
+				nsyms = sh_size / sizeof(Elf32_Sym);
+			}
+			break;
+
+		case SHT_STRTAB:
+			if (strcmp(sh_name, ".strtab") == 0) {
+				strings = data;
+				nstrings = sh_size;
+			}
+			break;
+
+		default:
+			break;
+		}
+	}
+
+	if (!symbols) {
+		fprintf(stderr, "Couldn't locate symbol table\n");
+		exit(3);
+	}
+
+	if (!strings) {
+		fprintf(stderr, "Couldn't locate strings table\n");
+		exit(3);
+	}
+
+	/* canonicalise the index numbers of the contributing section */
+	do {
+		changed = 0;
+
+		for (loop = 0; loop < canon - 1; loop++) {
+			const char *x = secstrings + get32(&sections[canonlist[loop + 0]].sh_name);
+			const char *y = secstrings + get32(&sections[canonlist[loop + 1]].sh_name);
+			if (strcmp(x, y) > 0) {
+				tmp = canonlist[loop + 0];
+				canonlist[loop + 0] = canonlist[loop + 1];
+				canonlist[loop + 1] = tmp;
+				changed = 1;
+			}
+		}
+
+	} while (changed);
+
+	for (loop = 0; loop < canon; loop++)
+		canonmap[canonlist[loop]] = loop + 1;
+
+	if (is_verbose > 1) {
+		printf("\nSection canonicalisation map:\n");
+		for (loop = 1; loop < shnum; loop++) {
+			const char *x = secstrings + get32(&sections[loop].sh_name);
+			printf("%4d %s\n", canonmap[loop], x);
+		}
+
+		printf("\nAllocated section list in canonical order:\n");
+		for (loop = 0; loop < canon; loop++) {
+			const char *x = secstrings + get32(&sections[canonlist[loop]].sh_name);
+			printf("%4d %s\n", canonlist[loop], x);
+		}
+	}
+
+	/* iterate through the section table looking for sections we want to
+	 * contribute to the signature */
+	verbose("\n");
+	verbose("CAN FILE POS CS SECT NAME\n");
+	verbose("=== ======== == ==== ==============================\n");
+
+	for (loop = 0; loop < canon; loop++) {
+		int sect = canonlist[loop];
+		const char *sh_name = secstrings + get32(&sections[sect].sh_name);
+		Elf32_Word  sh_type	= get32(&sections[sect].sh_type);
+		Elf32_Xword sh_size	= get32(&sections[sect].sh_size);
+		Elf32_Xword sh_flags	= get32(&sections[sect].sh_flags);
+		Elf32_Word  sh_info	= get32(&sections[sect].sh_info);
+		Elf32_Off   sh_offset	= get32(&sections[sect].sh_offset);
+		void *data = buffer + sh_offset;
+
+		csum = 0;
+
+		/* quick sanity check */
+		if (sh_type != SHT_NOBITS && len < sh_offset + sh_size) {
+			fprintf(stderr, "section goes beyond EOF\n");
+			exit(3);
+		}
+
+		/* include canonicalised relocation sections */
+		if (sh_type == SHT_REL || sh_type == SHT_RELA) {
+			Elf32_Word canon_sh_info;
+
+			if (sh_info <= 0 && sh_info >= hdr->e_shnum) {
+				fprintf(stderr,
+					"Invalid ELF - REL/RELA sh_info does"
+					" not refer to a valid section\n");
+				exit(3);
+			}
+
+			verbose("%3u %08lx ", loop, ftell(outfd));
+
+			set32(&canon_sh_info, canonmap[sh_info]);
+
+			/* write out selected portions of the section header */
+			write_out(sh_name, strlen(sh_name));
+			write_out_val(sections[sect].sh_type);
+			write_out_val(sections[sect].sh_flags);
+			write_out_val(sections[sect].sh_size);
+			write_out_val(sections[sect].sh_addralign);
+			write_out_val(canon_sh_info);
+
+			if (sh_type == SHT_RELA)
+				extract_elf32_rela(buffer, sect, sh_info,
+						   data, sh_size / sizeof(Elf32_Rela),
+						   symbols, nsyms,
+						   sections, shnum, canonmap,
+						   strings, nstrings,
+						   sh_name);
+			else
+				extract_elf32_rel(buffer, sect, sh_info,
+						  data, sh_size / sizeof(Elf32_Rel),
+						  symbols, nsyms,
+						  sections, shnum, canonmap,
+						  strings, nstrings,
+						  sh_name);
+			continue;
+		}
+
+		/* include the headers of BSS sections */
+		if (sh_type == SHT_NOBITS && sh_flags & SHF_ALLOC) {
+			verbose("%3u %08lx ", loop, ftell(outfd));
+
+			/* write out selected portions of the section header */
+			write_out(sh_name, strlen(sh_name));
+			write_out_val(sections[sect].sh_type);
+			write_out_val(sections[sect].sh_flags);
+			write_out_val(sections[sect].sh_size);
+			write_out_val(sections[sect].sh_addralign);
+
+			verbose("%02x %4d %s\n", csum, sect, sh_name);
+		}
+
+		/* include allocatable loadable sections */
+		if (sh_type != SHT_NOBITS && sh_flags & SHF_ALLOC)
+			goto include_section;
+
+		/* not this section */
+		continue;
+
+	include_section:
+		verbose("%3u %08lx ", loop, ftell(outfd));
+
+		/* write out selected portions of the section header */
+		write_out(sh_name, strlen(sh_name));
+		write_out_val(sections[sect].sh_type);
+		write_out_val(sections[sect].sh_flags);
+		write_out_val(sections[sect].sh_size);
+		write_out_val(sections[sect].sh_addralign);
+
+		/* write out the section data */
+		write_out(data, sh_size);
+
+		verbose("%02x %4d %s\n", csum, sect, sh_name);
+	}
+
+	verbose("%08lx         (%lu bytes csum 0x%02x)\n",
+		ftell(outfd), ftell(outfd), xcsum);
+}
diff --git a/scripts/mod/modsign-note.sh b/scripts/mod/modsign-note.sh
new file mode 100644
index 0000000..bca67c0
--- /dev/null
+++ b/scripts/mod/modsign-note.sh
@@ -0,0 +1,16 @@
+#!/bin/sh
+#
+# Generate a module signature note source file
+#
+# mod-sign.sh <sig-file> ><note-src-file>
+#
+
+SIG=$1
+
+cat <<EOF
+#include <linux/modsign.h>
+
+ELFNOTE(MODSIGN_NOTE_NAME, MODSIGN_NOTE_TYPE, .incbin "$SIG")
+EOF
+
+exit 0

