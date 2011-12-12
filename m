Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab1LLAvg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 19:51:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628Ab1LLAve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 19:51:34 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] MODSIGN: Automatically generate module signing keys if missing
To: jmorris@namei.org, linux-security-module@vger.kernel.org
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        arjan@linux.intel.com, alan@lxorguk.ukuu.org.uk, rusty@ozlabs.org
Date: Mon, 12 Dec 2011 00:51:10 +0000
Message-ID: <20111212005110.26058.87797.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Automatically generate keys for module signing if they're absent so that
allyesconfig doesn't break.  The builder should consider generating their own
keyrings, however, so that the keys are appropriately named and any extra keys
required get imported.

Also change the names of the keyring files to modsign.pub and modsign.sec so
that they are then a more obvious what they're about and add a dependency for
the signing rules on the keyring files so that the signatures get regenerated
if the keyrings change.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/module-signing.txt |   16 +++++++------
 kernel/Makefile                  |   46 +++++++++++++++++++++++++++++++++++++-
 kernel/modsign-pubkey.c          |    4 ++-
 scripts/Makefile.modpost         |    8 ++++---
 4 files changed, 60 insertions(+), 14 deletions(-)


diff --git a/Documentation/module-signing.txt b/Documentation/module-signing.txt
index 300b91a..2469f9c 100644
--- a/Documentation/module-signing.txt
+++ b/Documentation/module-signing.txt
@@ -28,16 +28,16 @@ SUPPLYING PUBLIC KEYS
 
 A set of public keys must be supplied at kernel image build time.  This is done
 by taking a GPG public key file and placing it in the base of the kernel
-directory in a file called kernel.pub.
+directory in a file called modsign.pub.
 
 For example, a throwaway key could be generated automatically by something like
 the following:
 
 	cat >genkey <<EOF
-	%pubring kernel.pub
-	%secring kernel.sec
-	Key-Type: DSA
-	Key-Length: 512
+	%pubring modsign.pub
+	%secring modsign.sec
+	Key-Type: RSA
+	Key-Length: 4096
 	Name-Real: A. N. Other
 	Name-Comment: Kernel Module GPG key
 	%commit
@@ -53,7 +53,7 @@ in the background.
 
 Note that no GPG password is used in the above scriptlet.
 
-The kernel.pub file is compiled into the kernel directly by the assembler by
+The modsign.pub file is compiled into the kernel directly by the assembler by
 means of an ".incbin" directive in kernel/modsign-pubkey.c.
 
 Once the kernel is running, the keys are visible to root as kernel crypto keys
@@ -98,12 +98,12 @@ include the following options:
  (*) MODSECKEY=<secret-key-ring-path>
 
      This indicates the whereabouts of the GPG keyring that is the source of
-     the secret key to be used.  The default is "./kernel.sec".
+     the secret key to be used.  The default is "./modsign.sec".
 
  (*) MODPUBKEY=<public-key-ring-path>
 
      This indicates the whereabouts of the GPG keyring that is the source of
-     the public key to be used.  The default is "./kernel.pub".
+     the public key to be used.  The default is "./modsign.pub".
 
  (*) MODKEYNAME=<key-name>
 
diff --git a/kernel/Makefile b/kernel/Makefile
index 1d1c91c..c9be9f4 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -54,7 +54,6 @@ obj-$(CONFIG_MODULES) += module.o
 obj-$(CONFIG_MODULE_VERIFY) += module-verify.o
 obj-$(CONFIG_MODULE_VERIFY_ELF) += module-verify-elf.o
 obj-$(CONFIG_MODULE_SIG) += module-verify-sig.o modsign-pubkey.o
-kernel/modsign-pubkey.o: kernel.pub
 obj-$(CONFIG_KALLSYMS) += kallsyms.o
 obj-$(CONFIG_PM) += power/
 obj-$(CONFIG_FREEZER) += power/
@@ -143,3 +142,48 @@ quiet_cmd_timeconst  = TIMEC   $@
 targets += timeconst.h
 $(obj)/timeconst.h: $(src)/timeconst.pl FORCE
 	$(call if_changed,timeconst)
+
+###############################################################################
+#
+# If module signing is requested, say by allyesconfig, but a key has not been
+# supplied, then one will need to be generated to make sure the build does not
+# fail and that the kernel may be used afterwards.
+#
+###############################################################################
+ifeq ($(CONFIG_MODULE_SIG),y)
+kernel/modsign-pubkey.o: modsign.pub
+
+modsign.pub modsign.sec: genkey
+	@echo "###"
+	@echo "### Now generating a PGP key pair to be used for signing modules."
+	@echo "###"
+	@echo "### If this takes a long time, you might wish to run rngd in the"
+	@echo "### background to keep the supply of entropy topped up.  It"
+	@echo "### needs to be run as root, and should use a hardware random"
+	@echo "### number generator if one is available, eg:"
+	@echo "###"
+	@echo "###     rngd -r /dev/hwrandom"
+	@echo "###"
+	@echo "### If one isn't available, the pseudo-random number generator"
+	@echo "### can be used:"
+	@echo "###"
+	@echo "###     rngd -r /dev/urandom"
+	@echo "###"
+	gpg --homedir . --batch --gen-key genkey
+	@echo "###"
+	@echo "### Key pair generated."
+	@echo "###"
+	rm -f pubring.gpg secring.gpg trustdb.gpg
+
+genkey:
+	echo "%pubring modsign.pub" >genkey
+	echo "%secring modsign.sec" >>genkey
+	echo "%transient-key: yes" >>genkey
+	echo "Key-Type: RSA" >>genkey
+	echo "Key-Length: 4096" >>genkey
+	echo "Name-Real: Sample kernel key" >>genkey
+	echo "Name-Comment: Sample kernel module signing key" >>genkey
+	echo "%commit" >>genkey
+
+endif
+CLEAN_FILES += modsign.pub modsign.sec genkey random_seed
diff --git a/kernel/modsign-pubkey.c b/kernel/modsign-pubkey.c
index df55565..06a1913 100644
--- a/kernel/modsign-pubkey.c
+++ b/kernel/modsign-pubkey.c
@@ -17,13 +17,13 @@ extern __initdata const u8 modsign_public_keys[];
 extern __initdata const u8 modsign_public_keys_end[];
 asm(".section .init.data,\"aw\"\n"
     "modsign_public_keys:\n"
-    ".incbin \"kernel.pub\"\n"
+    ".incbin \"modsign.pub\"\n"
     "modsign_public_keys_end:"
     );
 
 /*
  * We need to make sure ccache doesn't cache the .o file as it doesn't notice
- * if kernel.pub changes.
+ * if modsign.pub changes.
  */
 static __initdata const char annoy_ccache[] = __TIME__ "foo";
 
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index b436b04..17465d8 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -143,8 +143,8 @@ $(modules:.ko=.ko.unsigned): %.ko.unsigned :%.o %.mod.o FORCE
 targets += $(modules:.ko=.ko.unsigned)
 
 # Step 7), sign the modules
-MODSECKEY = ./kernel.sec
-MODPUBKEY = ./kernel.pub
+MODSECKEY = ./modsign.sec
+MODPUBKEY = ./modsign.pub
 KEYFLAGS = --no-default-keyring --secret-keyring $(MODSECKEY) --keyring $(MODPUBKEY) --no-default-keyring --homedir . --no-options --no-auto-check-trustdb --no-permission-warning
 
 ifdef CONFIG_MODULE_SIG_SHA1
@@ -190,6 +190,7 @@ SIGN_MODULES := 0
 endif
 
 ifeq ($(SIGN_MODULES),1)
+KEYRING_DEP := modsign.sec modsign.pub
 quiet_cmd_sign_ko_ko_unsigned = SIGN [M] $@
       cmd_sign_ko_ko_unsigned = \
 		scripts/mod/mod-extract $< $@.digest && \
@@ -199,12 +200,13 @@ quiet_cmd_sign_ko_ko_unsigned = SIGN [M] $@
 		  $(CC) -x assembler-with-cpp $(c_flags) $(CFLAGS_MODULE) -c -o $@.note.o - && \
 		$(LD) -r $(LDFLAGS) -o $@ $< $@.note.o
 else
+KEYRING_DEP :=
 quiet_cmd_sign_ko_ko_unsigned = NO SIGN [M] $@
       cmd_sign_ko_ko_unsigned = \
 		cp $< $@
 endif
 
-$(modules): %.ko :%.ko.unsigned FORCE
+$(modules): %.ko :%.ko.unsigned $(KEYRING_DEP) FORCE
 	$(call if_changed,sign_ko_ko_unsigned)
 
 targets += $(modules)

