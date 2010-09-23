Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab0IWPUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 11:20:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52533 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab0IWPUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 11:20:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uiDOHzamMErOESLi/F8rOloSV816iGcYDwoTav6sj3bXYeVwlUVtlEfkrBFAf+XFAo
         4YKj6FAyUaGbKae79ol14SunzxArcCUIexW3X9qgKfbhQ+9UA0dDfUSBxWK5jHMLsnI8
         I3tU9W7XYyKUaHDHkj6Pg9Oel8t4yly+/QQes=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pcmcia@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 3/5] firmware: enable usage of mkcis
Date: Thu, 23 Sep 2010 19:19:55 +0400
Message-Id: <1285255197-9262-3-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285255197-9262-1-git-send-email-dbaryshkov@gmail.com>
References: <1285255197-9262-1-git-send-email-dbaryshkov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable usage of mkcis for generation of cis files

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 firmware/Makefile |   44 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 43 insertions(+), 1 deletions(-)

diff --git a/firmware/Makefile b/firmware/Makefile
index 9c2d194..04ecf8c 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -156,6 +156,9 @@ quiet_cmd_ihex2fw  = IHEX2FW $@
 quiet_cmd_h16tofw  = H16TOFW $@
       cmd_h16tofw  = $(objtree)/$(obj)/ihex2fw -w $< $@
 
+quiet_cmd_mkcis	= MKCIS   $@
+      cmd_mkcis = $(objtree)/$(obj)/mkcis -o $@ $<
+
 quiet_cmd_fwbin = MK_FW   $@
       cmd_fwbin = FWNAME="$(patsubst firmware/%.gen.S,%,$@)";		     \
 		  FWSTR="$(subst /,_,$(subst .,_,$(subst -,_,$(patsubst	     \
@@ -224,6 +227,11 @@ ihex2fw_dep :=
 else
 ihex2fw_dep := $(obj)/ihex2fw
 endif
+ifeq ($(INSTALL):$(wildcard $(obj)/mkcis),install:$(obj)/mkcis)
+mkcis_dep :=
+else
+mkcis_dep := $(obj)/mkcis
+endif
 
 # .HEX is also Intel HEX, but where the offset and length in each record
 # is actually meaningful, because the firmware has to be loaded in a certain
@@ -236,6 +244,10 @@ $(obj)/%.fw: $(obj)/%.HEX $(ihex2fw_dep) | $(objtree)/$(obj)/$$(dir %)
 $(obj)/%.fw: $(obj)/%.H16 $(ihex2fw_dep) | $(objtree)/$(obj)/$$(dir %)
 	$(call cmd,h16tofw)
 
+# .ct is a text representation of CIS files, as originally developed by pcmcia-cs
+$(obj)/%.cis: $(obj)/%.ct $(mkcis_dep) | $(objtree)/$(obj)/$$(dir %)
+	$(call cmd,mkcis)
+
 $(firmware-dirs):
 	$(call cmd,mkdir)
 
@@ -251,4 +263,34 @@ targets := $(fw-shipped-) $(patsubst $(obj)/%,%, \
 # final vmlinux link will fail.
 obj-n := dummy
 
-hostprogs-y := ihex2fw
+hostprogs-y := ihex2fw mkcis
+
+mkcis-objs := mkcis.o mkcis-lexer.lex.o mkcis-parser.tab.o
+$(obj)/mkcis-parser.tab.o: $(obj)/mkcis-parser.tab.c $(obj)/mkcis-parser.tab.h
+$(obj)/mkcis-lexer.lex.o:  $(obj)/mkcis-lexer.lex.c $(obj)/mkcis-parser.tab.h
+HOSTCFLAGS_mkcis.o += -Iinclude/pcmcia
+HOSTCFLAGS_mkcis-lexer.lex.o += -Iinclude/pcmcia -Ifirmware/
+HOSTCFLAGS_mkcis-parser.tab.o += -Iinclude/pcmcia -Ifirmware/
+HOSTLOADLIBES_mkcis := -lm
+
+# GENERATE_PARSER := 1		# Uncomment to rebuild flex/bison output
+
+ifdef GENERATE_PARSER
+
+BISON = bison
+FLEX = flex
+
+quiet_cmd_bison = BISON   $@
+      cmd_bison = $(BISON) -o$@ -d $<; cp $@ $@_shipped
+quiet_cmd_flex = FLEX    $@
+      cmd_flex = $(FLEX) -o$@ $<; cp $@ $@_shipped
+
+$(obj)/mkcis-parser.tab.c: $(src)/mkcis-parser.y FORCE
+	$(call if_changed,bison)
+
+$(obj)/mkcis-parser.tab.h: $(obj)/mkcis-parser.tab.c
+
+$(obj)/mkcis-lexer.lex.c: $(src)/mkcis-lexer.l FORCE
+	$(call if_changed,flex)
+
+endif
-- 
1.5.6.5

