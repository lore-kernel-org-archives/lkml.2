Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab2KHRfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 12:35:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38238 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755628Ab2KHRfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 12:35:34 -0500
From: Takashi Iwai <tiwai@suse.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, joeyli <jlee@suse.com>,
        Jiri Kosina <jkosina@suse.cz>, David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH RFC v2 4/4] firmware: Install firmware signature files automatically
Date: Thu,  8 Nov 2012 18:35:09 +0100
Message-Id: <1352396109-3989-5-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352396109-3989-1-git-send-email-tiwai@suse.de>
References: <s5hhap49den.wl%tiwai@suse.de>
 <1352396109-3989-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... when CONFIG_FIRMWARE_SIG is set.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 Makefile                |  6 ++++++
 scripts/Makefile.fwinst | 18 ++++++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index a1ccf22..c6d7a3e 100644
--- a/Makefile
+++ b/Makefile
@@ -729,6 +729,12 @@ mod_sign_cmd = true
 endif
 export mod_sign_cmd
 
+ifeq ($(CONFIG_FIRMWARE_SIG),y)
+fw_sign_cmd = perl $(srctree)/scripts/sign-file -f $(MODSECKEY) $(MODPUBKEY)
+else
+fw_sign_cmd = true
+endif
+export fw_sign_cmd
 
 ifeq ($(KBUILD_EXTMOD),)
 core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
diff --git a/scripts/Makefile.fwinst b/scripts/Makefile.fwinst
index 4d908d1..df256f0 100644
--- a/scripts/Makefile.fwinst
+++ b/scripts/Makefile.fwinst
@@ -29,6 +29,20 @@ installed-mod-fw := $(addprefix $(INSTALL_FW_PATH)/,$(mod-fw))
 installed-fw := $(addprefix $(INSTALL_FW_PATH)/,$(fw-shipped-all))
 installed-fw-dirs := $(sort $(dir $(installed-fw))) $(INSTALL_FW_PATH)/./
 
+ifeq ($(CONFIG_FIRMWARE_SIG),y)
+installed-fw-sig := $(patsubst %,%.sig, $(installed-fw))
+installed-mod-fw-sig := $(patsubst %,%.sig, $(installed-mod-fw))
+else
+installed-fw-sig :=
+installed-mod-fw-sig :=
+endif
+
+quiet_cmd_fwsig = FWSIG $@
+      cmd_fwsig = $(fw_sign_cmd) $(patsubst %.sig,%,$@) $@
+
+%.sig: %
+	$(call cmd,fwsig)
+
 # Workaround for make < 3.81, where .SECONDEXPANSION doesn't work.
 PHONY += $(INSTALL_FW_PATH)/$$(%) install-all-dirs
 $(INSTALL_FW_PATH)/$$(%): install-all-dirs
@@ -49,9 +63,9 @@ PHONY +=  __fw_install __fw_modinst FORCE
 
 .PHONY: $(PHONY)
 
-__fw_install: $(installed-fw)
+__fw_install: $(installed-fw) $(installed-fw-sig)
 
-__fw_modinst: $(installed-mod-fw)
+__fw_modinst: $(installed-mod-fw) $(installed-mod-fw-sig)
 	@:
 
 __fw_modbuild: $(addprefix $(obj)/,$(mod-fw))
-- 
1.8.0

