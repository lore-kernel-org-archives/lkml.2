Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933077Ab2EVXEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 19:04:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932977Ab2EVXEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 19:04:50 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 18/23] MODSIGN: Provide Documentation and Kconfig options
To: rusty@rustcorp.com.au, kyle@mcmartin.ca
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, David Howells <dhowells@redhat.com>
Date: Wed, 23 May 2012 00:04:39 +0100
Message-ID: <20120522230439.24007.4195.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120522230218.24007.3556.stgit@warthog.procyon.org.uk>
References: <20120522230218.24007.3556.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide documentation and kernel configuration options for module signing.

The documentation can be found in:

	Documentation/module-signing.txt

The following configuration options are added:

 (1) CONFIG_MODULE_SIG

     Enable module signing.  This will both cause the build process to sign
     modules and the kernel to check modules when they're loaded.

 (2) CONFIG_MODULE_SIG_SHA1
     CONFIG_MODULE_SIG_SHA224
     CONFIG_MODULE_SIG_SHA256
     CONFIG_MODULE_SIG_SHA384
     CONFIG_MODULE_SIG_SHA512

     Select the cryptographic hash used to digest the data prior to signing.
     Additionally, the crypto module selected will be built into the kernel as
     it won't be possible to load it as a module without incurring a circular
     dependency when the kernel tries to check its signature.

 (3) CONFIG_MODULE_SIG_FORCE

     Require that any module loaded must be signed with a key compiled into
     the kernel.  All other modules are rejected with EKEYREJECTED.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/module-signing.txt |  183 ++++++++++++++++++++++++++++++++++++++
 include/linux/modsign.h          |   27 ++++++
 init/Kconfig                     |   62 +++++++++++++
 3 files changed, 272 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/module-signing.txt
 create mode 100644 include/linux/modsign.h


diff --git a/Documentation/module-signing.txt b/Documentation/module-signing.txt
new file mode 100644
index 0000000..b355aa2
--- /dev/null
+++ b/Documentation/module-signing.txt
@@ -0,0 +1,183 @@
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
+directory in a file called modsign.pub.
+
+For example, a throwaway key could be generated automatically by something like
+the following:
+
+	cat >genkey <<EOF
+	%pubring modsign.pub
+	%secring modsign.sec
+	Key-Type: RSA
+	Key-Length: 4096
+	Name-Real: A. N. Other
+	Name-Comment: Kernel Module GPG key
+	%commit
+	EOF
+	gpg --homedir . --batch --gen-key genkey
+
+The above generates fresh keys using /dev/random.  If there's insufficient data
+in /dev/random, more can be provided using the rngd program if there's a
+hardware random number generator available.
+
+Note that no GPG password is used in the above scriptlet.
+
+The modsign.pub file is compiled into the kernel directly by the assembler by
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
+     the secret key to be used.  The default is "./modsign.sec".
+
+ (*) MODPUBKEY=<public-key-ring-path>
+
+     This indicates the whereabouts of the GPG keyring that is the source of
+     the public key to be used.  The default is "./modsign.pub".
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
+============================
+SIGNED MODULES AND STRIPPING
+============================
+
+The module signature is just appended to the module binary with a magic number
+at the end of file, a couple of fixed-size lengths prior to that and the
+signature prior to that.
+
+WARNING! Signed modules are BRITTLE as the signature is outside of the defined
+ELF container.  Thus they MAY NOT be stripped once the signature is computed
+and attached, lest the signature be discarded or the payload be modified.  Note
+that the entire module is the signed payload, including all the debug
+information present at the time of signing so it must still be present when the
+signature is checked.
+
+As the module may need to be included in a ramdisk image of limited capacity,
+modules are maximally stripped prior to signing by the build process.
+
+Note that if FIPS mode is engaged, a module for which the signature does not
+match the payload will panic the box.
+
+
+======================
+LOADING SIGNED MODULES
+======================
+
+Modules are loaded with insmod, exactly as for unsigned modules.  The signature
+checker will check at the end of the file for the signature marker and apply
+signature checking if found.
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
+
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
diff --git a/init/Kconfig b/init/Kconfig
index 6cfd71d..f461fd2 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1409,6 +1409,68 @@ config MODULE_SRCVERSION_ALL
 	  the version).  With this option, such a "srcversion" field
 	  will be created for all modules.  If unsure, say N.
 
+config MODULE_SIG
+	bool "Module signature verification"
+	depends on MODULES
+	select CRYPTO_KEY_TYPE
+	select CRYPTO_KEY_PKEY_ALGO_RSA
+	select PGP_PARSER
+	select PGP_PRELOAD
+	help
+	  Check modules for valid signatures upon load.  For more information
+	  see:
+
+	  Documentation/module-signing.txt
+
+	  !!!WARNING!!!  If you enable this option, you MUST make sure that the
+	  module DOES NOT get stripped after being signed.  This includes the
+	  debuginfo strip done by some packagers (such as rpmbuild) and
+	  inclusion into an initramfs that wants the module size reduced.
+
+	  The signed module is brittle, and any change is likely to result in
+	  the module load being rejected due to the signature being discarded
+	  or the signed payload being altered.  If FIPS mode is engaged, the
+	  kernel will panic if the signature is detected, but does not match.
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
 endif # MODULES
 
 config INIT_ALL_POSSIBLE

