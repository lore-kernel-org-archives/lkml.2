Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab1HLTAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 15:00:11 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9353 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab1HLTAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 15:00:07 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6436"; a="109796389"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kbuild@vger.kernel.org
Subject: [PATCH] ARM: zImage: Skip relinking if nothing changes
Date: Fri, 12 Aug 2011 12:00:02 -0700
Message-Id: <1313175602-21834-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.6.409.ge7a85
In-Reply-To: <4E457682.5020107@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lib1funcs.S is reshipped even though the file hasn't changed
because the make rule is marked with FORCE. According to Sam
Ravnborg:

	The FORCE prerequisite will tell make to always execute
	the command.
	But we only want to execute the command if:
	1) $(obj)/lib1funcs.S is missing
	2) or $(srctree)/arch/$(SRCARCH)/lib/lib1funcs.S is not
	older then $(obj)/lib1funcs.S

	So dropping FORCE should be a safe thing to do.

This fixes the shipped problem, but we still have to reassemble
lib1funcs.S because it isn't part of $targets. Add
lib1funcs.{S,o} to $targets to avoid relinking the compressed
vmlinux if nothing changes.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/arm/boot/compressed/Makefile |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index 0c74a6f..937fd26 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -91,7 +91,7 @@ suffix_$(CONFIG_KERNEL_LZMA) = lzma
 
 targets       := vmlinux vmlinux.lds \
 		 piggy.$(suffix_y) piggy.$(suffix_y).o \
-		 font.o font.c head.o misc.o $(OBJS)
+		 font.o font.c head.o misc.o lib1funcs.o lib1funcs.S $(OBJS)
 
 # Make sure files are removed during clean
 extra-y       += piggy.gzip piggy.lzo piggy.lzma lib1funcs.S
@@ -121,9 +121,7 @@ LDFLAGS_vmlinux += -X
 LDFLAGS_vmlinux += -T
 
 # For __aeabi_uidivmod
-lib1funcs = $(obj)/lib1funcs.o
-
-$(obj)/lib1funcs.S: $(srctree)/arch/$(SRCARCH)/lib/lib1funcs.S FORCE
+$(obj)/lib1funcs.S: $(srctree)/arch/$(SRCARCH)/lib/lib1funcs.S
 	$(call cmd,shipped)
 
 # We need to prevent any GOTOFF relocs being used with references
@@ -140,7 +138,7 @@ bad_syms=$$($(CROSS_COMPILE)nm $@ | sed -n 's/^.\{8\} [bc] \(.*\)/\1/p') && \
     echo "$$bad_syms" >&2; rm -f $@; false )
 
 $(obj)/vmlinux: $(obj)/vmlinux.lds $(obj)/$(HEAD) $(obj)/piggy.$(suffix_y).o \
-	 	$(addprefix $(obj)/, $(OBJS)) $(lib1funcs) FORCE
+		$(addprefix $(obj)/, $(OBJS)) $(obj)/lib1funcs.o FORCE
 	$(call if_changed,ld)
 	@$(check_for_bad_syms)
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

