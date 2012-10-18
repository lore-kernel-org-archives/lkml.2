Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab2JRDSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 23:18:39 -0400
Received: from ozlabs.org ([203.10.76.45]:45875 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454Ab2JRDSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 23:18:35 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: RFC: sign the modules at install time
In-Reply-To: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 18 Oct 2012 11:47:31 +1030
Message-ID: <87txtso9xw.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
> This was based on the complaint from Davem that the "make
> allmodconfig" build got way slower because module signing takes a
> while.
>
> And quite frankly, the whole "extra strip and sign" thing at modpost
> time was just nasty ugly code.
>
> Why don't we do something *much* simpler? We already have a
> conditional stripping of modules (that whole INSTALL_MOD_STRIP) logic,
> and it really simplifies everything if we just do something very
> similar for the signing of modules. At "make modules_install" time,
> exactly like the stripping is done.

I generally hate "make install" targets which build stuff, but at it's
hard to argue with the diffstat.

You cut too much: you need genkeyid.  We don't want to do this at 'make
modules_install' time, so I made it depend on kernel/modsign_pubkey.o
which means it's easiest to move the script.  Though since signing is so
slow, I wonder if sign-file should just include the code to extract the
keyid and signer every time.

And in a moment of optimism I tried 'make modules_install MODLIB=.' to
sign modules in-place.  It deleted my kernel/ dir.  Don't recommend.

Cheers,
Rusty.

 Makefile                                 |   11 +++++
 kernel/Makefile                          |    9 +++-
 scripts/x509keyid => kernel/x509keyid.pl |    0
 scripts/Makefile.modinst                 |    9 +++-
 scripts/Makefile.modpost                 |   77 +-----------------------------
 scripts/sign-file                        |    2 +-
 6 files changed, 29 insertions(+), 79 deletions(-)

diff --git a/Makefile b/Makefile
index 5be2ee8..7b68a5a 100644
--- a/Makefile
+++ b/Makefile
@@ -717,6 +717,17 @@ endif # INSTALL_MOD_STRIP
 export mod_strip_cmd
 
 
+ifeq ($(CONFIG_MODULE_SIG),y)
+MODSECKEY = ./signing_key.priv
+MODPUBKEY = ./signing_key.x509
+export MODPUBKEY
+mod_sign_cmd = sh $(srctree)/scripts/sign-file $(MODSECKEY) $(MODPUBKEY)
+else
+mod_sign_cmd = true
+endif
+export mod_sign_cmd
+
+
 ifeq ($(KBUILD_EXTMOD),)
 core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
 
diff --git a/kernel/Makefile b/kernel/Makefile
index 0dfeca4..f7abe6c 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -139,7 +139,14 @@ ifeq ($(CONFIG_MODULE_SIG),y)
 extra_certificates:
 	touch $@
 
-kernel/modsign_pubkey.o: signing_key.x509 extra_certificates
+quiet_cmd_genkeyid = GENKEYID $@
+      cmd_genkeyid = $(PERL) $(src)/x509keyid.pl $< $<.signer $<.keyid
+
+%.signer %.keyid: %
+	$(call if_changed,genkeyid)
+
+kernel/modsign_pubkey.o: signing_key.x509 extra_certificates $(MODPUBKEY).signer $(MODPUBKEY).keyid
+
 
 ###############################################################################
 #
diff --git a/scripts/x509keyid b/kernel/x509keyid.pl
similarity index 100%
rename from scripts/x509keyid
rename to kernel/x509keyid.pl
diff --git a/scripts/Makefile.modinst b/scripts/Makefile.modinst
index 3d13d3a..5c564fc 100644
--- a/scripts/Makefile.modinst
+++ b/scripts/Makefile.modinst
@@ -17,7 +17,7 @@ __modinst: $(modules)
 	@:
 
 quiet_cmd_modules_install = INSTALL $@
-      cmd_modules_install = mkdir -p $(2); cp $@ $(2) ; $(mod_strip_cmd) $(2)/$(notdir $@)
+      cmd_modules_install = mkdir -p $(2); cp $@ $(2) ; $(mod_strip_cmd) $(2)/$(notdir $@) ; $(mod_sign_cmd) $(2)/$(notdir $@)
 
 # Modules built outside the kernel source tree go into extra by default
 INSTALL_MOD_DIR ?= extra
@@ -28,6 +28,13 @@ modinst_dir = $(if $(KBUILD_EXTMOD),$(ext-mod-dir),kernel/$(@D))
 $(modules):
 	$(call cmd,modules_install,$(MODLIB)/$(modinst_dir))
 
+quiet_cmd_genkeyid = GENKEYID $@
+      cmd_genkeyid = \
+		perl $(SCRIPTS_DIR)/x509keyid $< $<.signer $<.keyid
+
+%.signer %.keyid: %
+	$(call if_changed,genkeyid)
+
 
 # Declare the contents of the .PHONY variable as phony.  We keep that
 # information in a variable se we can use it in if_changed and friends.
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 0020891..a1cb022 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -14,8 +14,7 @@
 # 3)  create one <module>.mod.c file pr. module
 # 4)  create one Module.symvers file with CRC for all exported symbols
 # 5) compile all <module>.mod.c files
-# 6) final link of the module to a <module.ko> (or <module.unsigned>) file
-# 7) signs the modules to a <module.ko> file
+# 6) final link of the module to a <module.ko> file
 
 # Step 3 is used to place certain information in the module's ELF
 # section, including information such as:
@@ -33,8 +32,6 @@
 # Step 4 is solely used to allow module versioning in external modules,
 # where the CRC of each module is retrieved from the Module.symvers file.
 
-# Step 7 is dependent on CONFIG_MODULE_SIG being enabled.
-
 # KBUILD_MODPOST_WARN can be set to avoid error out in case of undefined
 # symbols in the final module linking stage
 # KBUILD_MODPOST_NOFINAL can be set to skip the final link of modules.
@@ -119,7 +116,6 @@ $(modules:.ko=.mod.o): %.mod.o: %.mod.c FORCE
 targets += $(modules:.ko=.mod.o)
 
 # Step 6), final link of the modules
-ifneq ($(CONFIG_MODULE_SIG),y)
 quiet_cmd_ld_ko_o = LD [M]  $@
       cmd_ld_ko_o = $(LD) -r $(LDFLAGS)                                 \
                              $(KBUILD_LDFLAGS_MODULE) $(LDFLAGS_MODULE) \
@@ -129,78 +125,7 @@ $(modules): %.ko :%.o %.mod.o FORCE
 	$(call if_changed,ld_ko_o)
 
 targets += $(modules)
-else
-quiet_cmd_ld_ko_unsigned_o = LD [M]  $@
-      cmd_ld_ko_unsigned_o =						\
-		$(LD) -r $(LDFLAGS)					\
-			 $(KBUILD_LDFLAGS_MODULE) $(LDFLAGS_MODULE)	\
-			 -o $@ $(filter-out FORCE,$^)			\
-		$(if $(AFTER_LINK),; $(AFTER_LINK))
-
-$(modules:.ko=.ko.unsigned): %.ko.unsigned :%.o %.mod.o FORCE
-	$(call if_changed,ld_ko_unsigned_o)
-
-targets += $(modules:.ko=.ko.unsigned)
-
-# Step 7), sign the modules
-MODSECKEY = ./signing_key.priv
-MODPUBKEY = ./signing_key.x509
-
-ifeq ($(wildcard $(MODSECKEY))+$(wildcard $(MODPUBKEY)),$(MODSECKEY)+$(MODPUBKEY))
-ifeq ($(KBUILD_SRC),)
-	# no O= is being used
-	SCRIPTS_DIR := scripts
-else
-	SCRIPTS_DIR := $(KBUILD_SRC)/scripts
-endif
-SIGN_MODULES := 1
-else
-SIGN_MODULES := 0
-endif
-
-# only sign if it's an in-tree module
-ifneq ($(KBUILD_EXTMOD),)
-SIGN_MODULES := 0
-endif
 
-# We strip the module as best we can - note that using both strip and eu-strip
-# results in a smaller module than using either alone.
-EU_STRIP = $(shell which eu-strip || echo true)
-
-quiet_cmd_sign_ko_stripped_ko_unsigned = STRIP [M] $@
-      cmd_sign_ko_stripped_ko_unsigned = \
-		cp $< $@ && \
-		strip -x -g $@ && \
-		$(EU_STRIP) $@
-
-ifeq ($(SIGN_MODULES),1)
-
-quiet_cmd_genkeyid = GENKEYID $@
-      cmd_genkeyid = \
-		perl $(SCRIPTS_DIR)/x509keyid $< $<.signer $<.keyid
-
-%.signer %.keyid: %
-	$(call if_changed,genkeyid)
-
-KEYRING_DEP := $(MODSECKEY) $(MODPUBKEY) $(MODPUBKEY).signer $(MODPUBKEY).keyid
-quiet_cmd_sign_ko_ko_stripped = SIGN [M] $@
-      cmd_sign_ko_ko_stripped = \
-		sh $(SCRIPTS_DIR)/sign-file $(MODSECKEY) $(MODPUBKEY) $< $@
-else
-KEYRING_DEP :=
-quiet_cmd_sign_ko_ko_unsigned = NO SIGN [M] $@
-      cmd_sign_ko_ko_unsigned = \
-		cp $< $@
-endif
-
-$(modules): %.ko :%.ko.stripped $(KEYRING_DEP) FORCE
-	$(call if_changed,sign_ko_ko_stripped)
-
-$(patsubst %.ko,%.ko.stripped,$(modules)): %.ko.stripped :%.ko.unsigned FORCE
-	$(call if_changed,sign_ko_stripped_ko_unsigned)
-
-targets += $(modules)
-endif
 
 # Add FORCE to the prequisites of a target to force it to be always rebuilt.
 # ---------------------------------------------------------------------------
diff --git a/scripts/sign-file b/scripts/sign-file
index e58e34e..3084ba4 100644
--- a/scripts/sign-file
+++ b/scripts/sign-file
@@ -16,7 +16,7 @@ fi
 key="$1"
 x509="$2"
 src="$3"
-dst="$4"
+dst="${4:-$3}"
 
 if [ ! -r "$key" ]
 then
