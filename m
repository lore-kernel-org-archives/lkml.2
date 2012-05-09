Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759925Ab2EIWDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 18:03:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44678 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758837Ab2EIWDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 18:03:32 -0400
Date: Wed, 9 May 2012 15:02:43 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-0f6f11eb00830fa691c16084048f53d83c5c3a5d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        sam@ravnborg.org, mmarek@suse.cz, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sam@ravnborg.org, tglx@linutronix.de, mmarek@suse.cz,
        hpa@linux.intel.com
In-Reply-To: <1336595106-21135-1-git-send-email-jarkko.sakkinen@intel.com>
References: <1336595106-21135-1-git-send-email-jarkko.sakkinen@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trampoline] x86, realmode:
  Make sure all generated files are listed in targets
Git-Commit-ID: 0f6f11eb00830fa691c16084048f53d83c5c3a5d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 09 May 2012 15:02:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f6f11eb00830fa691c16084048f53d83c5c3a5d
Gitweb:     http://git.kernel.org/tip/0f6f11eb00830fa691c16084048f53d83c5c3a5d
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 9 May 2012 14:53:01 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 9 May 2012 14:53:01 -0700

x86, realmode: Make sure all generated files are listed in targets

Kbuild expects all generated files to be listed in the targets
variable.  If it isn't, weird things happen.

Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1336595106-21135-1-git-send-email-jarkko.sakkinen@intel.com
---
 arch/x86/realmode/rm/Makefile |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
index 1c1d3d3..5b84a2d 100644
--- a/arch/x86/realmode/rm/Makefile
+++ b/arch/x86/realmode/rm/Makefile
@@ -7,13 +7,7 @@
 #
 #
 
-always := realmode.bin
-
-realmode-y			+= header.o
-realmode-y			+= trampoline_$(BITS).o
-realmode-y			+= stack.o
-realmode-$(CONFIG_X86_32)	+= reboot_32.o
-realmode-$(CONFIG_ACPI_SLEEP)	+= $(wakeup-objs)
+always := realmode.bin realmode.relocs
 
 wakeup-objs	:= wakeup_asm.o wakemain.o video-mode.o
 wakeup-objs	+= copy.o bioscall.o regs.o
@@ -25,6 +19,12 @@ wakeup-objs	+= video-vga.o
 wakeup-objs	+= video-vesa.o
 wakeup-objs	+= video-bios.o
 
+realmode-y			+= header.o
+realmode-y			+= trampoline_$(BITS).o
+realmode-y			+= stack.o
+realmode-$(CONFIG_X86_32)	+= reboot_32.o
+realmode-$(CONFIG_ACPI_SLEEP)	+= $(wakeup-objs)
+
 targets	+= $(realmode-y)
 
 REALMODE_OBJS = $(addprefix $(obj)/,$(realmode-y))
@@ -35,24 +35,30 @@ quiet_cmd_pasyms = PASYMS  $@
       cmd_pasyms = $(NM) $(filter-out FORCE,$^) | \
 		   sed $(sed-pasyms) | sort | uniq > $@
 
+targets += pasyms.h
 $(obj)/pasyms.h: $(REALMODE_OBJS) FORCE
 	$(call if_changed,pasyms)
 
+targets += realmode.lds
 $(obj)/realmode.lds: $(obj)/pasyms.h
 
 LDFLAGS_realmode.elf := --emit-relocs -T
 CPPFLAGS_realmode.lds += -P -C -I$(obj)
 
+targets += realmode.elf
 $(obj)/realmode.elf: $(obj)/realmode.lds $(REALMODE_OBJS) FORCE
 	$(call if_changed,ld)
 
 OBJCOPYFLAGS_realmode.bin := -O binary
 
+targets += realmode.bin
 $(obj)/realmode.bin: $(obj)/realmode.elf $(obj)/realmode.relocs
 	$(call if_changed,objcopy)
 
 quiet_cmd_relocs = RELOCS  $@
       cmd_relocs = arch/x86/tools/relocs --realmode $< > $@
+
+targets += realmode.relocs
 $(obj)/realmode.relocs: $(obj)/realmode.elf FORCE
 	$(call if_changed,relocs)
 
