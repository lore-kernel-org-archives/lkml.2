Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657Ab2EHWbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 18:31:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34653 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757175Ab2EHWbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 18:31:08 -0400
Date: Tue, 8 May 2012 15:30:49 -0700
From: tip-bot for Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Message-ID: <tip-f2604c141a00c00b92b7fd2f9d2455517fdd6c15@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        sam@ravnborg.org, mmarek@suse.cz, jarkko.sakkinen@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sam@ravnborg.org, tglx@linutronix.de, jarkko.sakkinen@intel.com,
        mmarek@suse.cz, hpa@linux.intel.com
In-Reply-To: <1336501366-28617-22-git-send-email-jarkko.sakkinen@intel.com>
References: <1336501366-28617-22-git-send-email-jarkko.sakkinen@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trampoline] x86, realmode: move relocs from scripts/
  to arch/x86/tools
Git-Commit-ID: f2604c141a00c00b92b7fd2f9d2455517fdd6c15
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 15:30:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f2604c141a00c00b92b7fd2f9d2455517fdd6c15
Gitweb:     http://git.kernel.org/tip/f2604c141a00c00b92b7fd2f9d2455517fdd6c15
Author:     Jarkko Sakkinen <jarkko.sakkinen@intel.com>
AuthorDate: Tue, 8 May 2012 21:22:44 +0300
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 8 May 2012 15:03:35 -0700

x86, realmode: move relocs from scripts/ to arch/x86/tools

Moved relocs tool from scripts/ to arch/x86/tools because
it is architecture specific script. Added new target archscripts
that can be used to build scripts needed building an architecture.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Link: http://lkml.kernel.org/r/1336501366-28617-22-git-send-email-jarkko.sakkinen@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>
---
 Makefile                                        |    9 ++++++---
 arch/x86/Makefile                               |    3 +++
 arch/x86/boot/compressed/Makefile               |    4 ++--
 arch/x86/realmode/rm/Makefile                   |    2 +-
 arch/x86/tools/.gitignore                       |    1 +
 arch/x86/tools/Makefile                         |    4 ++++
 scripts/x86-relocs.c => arch/x86/tools/relocs.c |    0
 scripts/Makefile                                |    1 -
 8 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/Makefile b/Makefile
index 9e384ae..ed1bd29 100644
--- a/Makefile
+++ b/Makefile
@@ -442,7 +442,7 @@ asm-generic:
 
 no-dot-config-targets := clean mrproper distclean \
 			 cscope gtags TAGS tags help %docs check% coccicheck \
-			 include/linux/version.h headers_% archheaders \
+			 include/linux/version.h headers_% archheaders archscripts \
 			 kernelversion %src-pkg
 
 config-targets := 0
@@ -979,7 +979,7 @@ prepare1: prepare2 include/linux/version.h include/generated/utsrelease.h \
                    include/config/auto.conf
 	$(cmd_crmodverdir)
 
-archprepare: archheaders prepare1 scripts_basic
+archprepare: archheaders archscripts prepare1 scripts_basic
 
 prepare0: archprepare FORCE
 	$(Q)$(MAKE) $(build)=.
@@ -1049,8 +1049,11 @@ hdr-dst = $(if $(KBUILD_HEADERS), dst=include/asm-$(hdr-arch), dst=include/asm)
 PHONY += archheaders
 archheaders:
 
+PHONY += archscripts
+archscripts:
+
 PHONY += __headers
-__headers: include/linux/version.h scripts_basic asm-generic archheaders FORCE
+__headers: include/linux/version.h scripts_basic asm-generic archheaders archscripts FORCE
 	$(Q)$(MAKE) $(build)=scripts build_unifdef
 
 PHONY += headers_install_all
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 41a7237..94e91e4 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -134,6 +134,9 @@ KBUILD_CFLAGS += $(call cc-option,-mno-avx,)
 KBUILD_CFLAGS += $(mflags-y)
 KBUILD_AFLAGS += $(mflags-y)
 
+archscripts:
+	$(Q)$(MAKE) $(build)=arch/x86/tools relocs
+
 ###
 # Syscall table generation
 
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 0435e8a..e398bb5 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -42,8 +42,8 @@ $(obj)/vmlinux.bin: vmlinux FORCE
 
 targets += vmlinux.bin.all vmlinux.relocs
 
-CMD_RELOCS = scripts/x86-relocs
-quiet_cmd_relocs = RELOCS $@
+CMD_RELOCS = arch/x86/tools/relocs
+quiet_cmd_relocs = RELOCS  $@
       cmd_relocs = $(CMD_RELOCS) $< > $@;$(CMD_RELOCS) --abs-relocs $<
 $(obj)/vmlinux.relocs: vmlinux FORCE
 	$(call if_changed,relocs)
diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
index fc8854b..de40bc4 100644
--- a/arch/x86/realmode/rm/Makefile
+++ b/arch/x86/realmode/rm/Makefile
@@ -52,7 +52,7 @@ $(obj)/realmode.bin: $(obj)/realmode.elf
 	$(call if_changed,objcopy)
 
 quiet_cmd_relocs = RELOCS  $@
-      cmd_relocs = scripts/x86-relocs --realmode $< > $@
+      cmd_relocs = arch/x86/tools/relocs --realmode $< > $@
 $(obj)/realmode.relocs: $(obj)/realmode.elf FORCE
 	$(call if_changed,relocs)
 
diff --git a/arch/x86/tools/.gitignore b/arch/x86/tools/.gitignore
new file mode 100644
index 0000000..be0ed06
--- /dev/null
+++ b/arch/x86/tools/.gitignore
@@ -0,0 +1 @@
+relocs
diff --git a/arch/x86/tools/Makefile b/arch/x86/tools/Makefile
index d511aa9..733057b 100644
--- a/arch/x86/tools/Makefile
+++ b/arch/x86/tools/Makefile
@@ -36,3 +36,7 @@ HOSTCFLAGS_insn_sanity.o := -Wall -I$(objtree)/arch/x86/lib/ -I$(srctree)/arch/x
 $(obj)/test_get_len.o: $(srctree)/arch/x86/lib/insn.c $(srctree)/arch/x86/lib/inat.c $(srctree)/arch/x86/include/asm/inat_types.h $(srctree)/arch/x86/include/asm/inat.h $(srctree)/arch/x86/include/asm/insn.h $(objtree)/arch/x86/lib/inat-tables.c
 
 $(obj)/insn_sanity.o: $(srctree)/arch/x86/lib/insn.c $(srctree)/arch/x86/lib/inat.c $(srctree)/arch/x86/include/asm/inat_types.h $(srctree)/arch/x86/include/asm/inat.h $(srctree)/arch/x86/include/asm/insn.h $(objtree)/arch/x86/lib/inat-tables.c
+
+HOST_EXTRACFLAGS += -I$(srctree)/tools/include
+hostprogs-y	+= relocs
+relocs: $(obj)/relocs
diff --git a/scripts/x86-relocs.c b/arch/x86/tools/relocs.c
similarity index 100%
rename from scripts/x86-relocs.c
rename to arch/x86/tools/relocs.c
diff --git a/scripts/Makefile b/scripts/Makefile
index a241359d..3626666 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -15,7 +15,6 @@ hostprogs-$(CONFIG_LOGO)         += pnmtologo
 hostprogs-$(CONFIG_VT)           += conmakehash
 hostprogs-$(CONFIG_IKCONFIG)     += bin2c
 hostprogs-$(BUILD_C_RECORDMCOUNT) += recordmcount
-hostprogs-$(CONFIG_X86)          += x86-relocs
 
 always		:= $(hostprogs-y) $(hostprogs-m)
 
