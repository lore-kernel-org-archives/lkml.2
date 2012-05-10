Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964837Ab2EJXnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:43:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933007Ab2EJXng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:43:36 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 24/29] MODSIGN: Provide module signing public keys to the
 kernel [ver #4]
To: rusty@rustcorp.com.au
Cc: kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        David Howells <dhowells@redhat.com>
Date: Fri, 11 May 2012 00:43:27 +0100
Message-ID: <20120510234327.4137.36031.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
References: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include a PGP keyring containing the public keys required to perform module
verification in the kernel image during build and create a special keyring
during boot which is then populated with keys of crypto type holding the public
keys found in the PGP keyring.

These can be seen by root:

[root@andromeda ~]# cat /proc/keys
07ad4ee0 I-----     1 perm 3f010000     0     0 crypto    modsign.0: RSA 87b9b3bd []
15c7f8c3 I-----     1 perm 1f030000     0     0 keyring   .module_sign: 1/4
...

It is probably worth permitting root to invalidate these keys, resulting in
their removal and preventing further modules from being loaded with that key.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/Makefile             |    3 +-
 kernel/modsign-pubkey.c     |   74 +++++++++++++++++++++++++++++++++++++++++++
 kernel/module-verify-defs.h |    4 ++
 kernel/module-verify.c      |    2 -
 4 files changed, 80 insertions(+), 3 deletions(-)
 create mode 100644 kernel/modsign-pubkey.c


diff --git a/kernel/Makefile b/kernel/Makefile
index 7608053..986ed7f 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -51,7 +51,8 @@ obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
 obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
 obj-$(CONFIG_UID16) += uid16.o
 obj-$(CONFIG_MODULES) += module.o
-obj-$(CONFIG_MODULE_SIG) += module-verify.o
+obj-$(CONFIG_MODULE_SIG) += module-verify.o modsign-pubkey.o
+kernel/modsign-pubkey.o: modsign.pub
 obj-$(CONFIG_KALLSYMS) += kallsyms.o
 obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
 obj-$(CONFIG_KEXEC) += kexec.o
diff --git a/kernel/modsign-pubkey.c b/kernel/modsign-pubkey.c
new file mode 100644
index 0000000..2ada460
--- /dev/null
+++ b/kernel/modsign-pubkey.c
@@ -0,0 +1,74 @@
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
+#include <linux/sched.h>
+#include <linux/cred.h>
+#include <keys/crypto-type.h>
+#include "module-verify-defs.h"
+
+struct key *modsign_keyring;
+
+extern __initdata const u8 modsign_public_keys[];
+extern __initdata const u8 modsign_public_keys_end[];
+asm(".section .init.data,\"aw\"\n"
+    "modsign_public_keys:\n"
+    ".incbin \"modsign.pub\"\n"
+    "modsign_public_keys_end:"
+    );
+
+/*
+ * We need to make sure ccache doesn't cache the .o file as it doesn't notice
+ * if modsign.pub changes.
+ */
+static __initdata const char annoy_ccache[] = __TIME__ "foo";
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
diff --git a/kernel/module-verify-defs.h b/kernel/module-verify-defs.h
index 292d2ba..45bea45 100644
--- a/kernel/module-verify-defs.h
+++ b/kernel/module-verify-defs.h
@@ -11,6 +11,10 @@
 
 #ifdef CONFIG_MODULE_SIG
 
+#include <linux/module.h>
+
+extern struct key *modsign_keyring;
+
 /*
  * Internal state
  */
diff --git a/kernel/module-verify.c b/kernel/module-verify.c
index 0a3eb4b..b1c1d4c 100644
--- a/kernel/module-verify.c
+++ b/kernel/module-verify.c
@@ -27,8 +27,6 @@
 #include <linux/slab.h>
 #include <linux/elf.h>
 #include <linux/elfnote.h>
-#include <linux/sched.h>
-#include <linux/cred.h>
 #include <linux/modsign.h>
 #include <linux/moduleparam.h>
 #include <keys/crypto-type.h>

