Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085Ab2EVXFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 19:05:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932977Ab2EVXE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 19:04:56 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 19/23] MODSIGN: Sign modules during the build process
To: rusty@rustcorp.com.au, kyle@mcmartin.ca
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, David Howells <dhowells@redhat.com>
Date: Wed, 23 May 2012 00:04:47 +0100
Message-ID: <20120522230447.24007.11074.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120522230218.24007.3556.stgit@warthog.procyon.org.uk>
References: <20120522230218.24007.3556.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_MODULE_SIG is set, then this patch will cause the module to get a
signature installed.  The following steps will occur:

 (1) The module will be linked to foo.ko.unsigned instead of foo.ko

 (2) The module will be stripped using both "strip -x -g" and "eu-strip" to
     ensure minimal size for inclusion in an initramfs.

 (3) The signature will be generated on the stripped module.

 (4) The signature will be appended to the module, along with the payload
     size, the signature size and a magic string.

Step (3) requires private and public keys to be available.  By default these
are expected to be found in PGP keyring files called modsign.sec (the secret
key) and modsign.pub (the public key) in the build root.

If the secret key is not found then signing will be skipped and the unsigned
module from (1) will just be copied to foo.ko.

If signing occurs, lines like the following will be seen:

	LD [M]  fs/foo/foo.ko.unsigned
	STRIP [M] fs/foo/foo.ko.stripped
	SIGN [M] fs/foo/foo.ko

will appear in the build log.  If the signature step will be skipped and the
following will be seen:

	LD [M]  fs/foo/foo.ko.unsigned
	STRIP [M] fs/foo/foo.ko.stripped
	NO SIGN [M] fs/foo/foo.ko

NOTE!  After the signature step, the signed module must not be passed through
strip.  The unstripped, unsigned module is still available at the name on the
LD [M] line.  This restriction may affect packaging tools (such as rpmbuild)
and initramfs composition tools.

Note that I do not agree with this method of attaching signatures to modules.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 scripts/Makefile.modpost |   98 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 97 insertions(+), 1 deletions(-)


diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 08dce14..bb761ab 100644
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
@@ -125,7 +129,99 @@ $(modules): %.ko :%.o %.mod.o FORCE
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
+MODSECKEY = ./modsign.sec
+MODPUBKEY = ./modsign.pub
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
+
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
+# We strip the module as best we can - note that using both strip and eu-strip
+# results in a smaller module than using either alone.
+quiet_cmd_sign_ko_stripped_ko_unsigned = STRIP [M] $@
+      cmd_sign_ko_stripped_ko_unsigned = \
+		cp $< $@ && \
+		strip -x -g $@ && \
+		eu-strip $@
+
+ifeq ($(SIGN_MODULES),1)
+KEYRING_DEP := modsign.sec modsign.pub
+quiet_cmd_sign_ko_ko_stripped = SIGN [M] $@
+      cmd_sign_ko_ko_stripped = \
+		rm -f $<.sig && \
+		gpg --batch --no-greeting $(KEYFLAGS) -b $< && \
+		stat -c @%-8s@ $< >$@.trailer && \
+		stat -c @%-8s@ $<.sig >>$@.trailer && \
+		echo -n "This Is A Crypto Signed Module" >>$@.trailer && \
+		cat $< $<.sig $@.trailer >$@
+else
+KEYRING_DEP :=
+quiet_cmd_sign_ko_ko_unsigned = NO SIGN [M] $@
+      cmd_sign_ko_ko_unsigned = \
+		cp $< $@
+endif
+
+$(modules): %.ko :%.ko.stripped $(KEYRING_DEP) FORCE
+	$(call if_changed,sign_ko_ko_stripped)
+
+$(patsubst %.ko,%.ko.stripped,$(modules)): %.ko.stripped :%.ko.unsigned FORCE
+	$(call if_changed,sign_ko_stripped_ko_unsigned)
 
+targets += $(modules)
+endif
 
 # Add FORCE to the prequisites of a target to force it to be always rebuilt.
 # ---------------------------------------------------------------------------

