Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964806Ab2EJXnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:43:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933007Ab2EJXnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:43:05 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 21/29] MODSIGN: Provide Documentation and Kconfig options [ver
 #4]
To: rusty@rustcorp.com.au
Cc: kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        David Howells <dhowells@redhat.com>
Date: Fri, 11 May 2012 00:42:53 +0100
Message-ID: <20120510234253.4137.27117.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
References: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
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

 Documentation/module-signing.txt |  194 ++++++++++++++++++++++++++++++++++++++
 include/linux/modsign.h          |   27 +++++
 init/Kconfig                     |   53 ++++++++++
 3 files changed, 274 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/module-signing.txt
 create mode 100644 include/linux/modsign.h


diff --git a/Documentation/module-signing.txt b/Documentation/module-signing.txt
new file mode 100644
index 0000000..d75d473
--- /dev/null
+++ b/Documentation/module-signing.txt
@@ -0,0 +1,194 @@
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
+========================
+STRIPPING SIGNED MODULES
+========================
+
+Signed modules may be safely stripped with any of the following:
+
+	strip -x
+	strip -g
+	eu-strip
+
+as the signature only covers those parts of the module the kernel actually uses
+and any ELF metadata required to deal with them.  Any necessary ELF metadata
+that is affected by stripping is canonicalised by the sig generator and the sig
+checker to hide strip effects.
+
+This permits the debuginfo to be detached from the module and placed in another
+spot so that gdb can find it when referring to that module without the need for
+multiple signed versions of the module.  Such is done by rpmbuild when
+producing RPMs.
+
+It also permits the module to be stripped as far as possible for when modules
+are being reduced prior to being included in an initial ramdisk composition.
+
+Note that "strip" and "strip -s" may not be used on a module, signed or
+otherwise, as they remove the symbol table and render the relocation tables
+unusable.
+
+
+======================
+LOADING SIGNED MODULES
+======================
+
+Modules are loaded with insmod, exactly as for unsigned modules.  The signature
+is inserted into the module object file during the build process as an ELF note
+called "module.sig" in an ELF section called ".note.module.sig".  The signature
+checker will detect it and apply signature checking.
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
index 6cfd71d..7cda3e6 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1409,6 +1409,59 @@ config MODULE_SRCVERSION_ALL
 	  the version).  With this option, such a "srcversion" field
 	  will be created for all modules.  If unsure, say N.
 
+config MODULE_SIG
+	bool "Module signature verification"
+	depends on MODULES
+	select CRYPTO_KEY_TYPE
+	select CRYPTO_KEY_PKEY_ALGO_DSA
+	select CRYPTO_KEY_PKEY_ALGO_RSA
+	select PGP_PARSER
+	select PGP_PRELOAD
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
 endif # MODULES
 
 config INIT_ALL_POSSIBLE

