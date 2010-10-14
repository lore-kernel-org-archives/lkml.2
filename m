Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab0JNVBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:01:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42948 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919Ab0JNVBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:01:38 -0400
X-Authority-Analysis: v=1.1 cv=vbQZhf6WRU4XF+4tPWNJEMYU0N1CowIjcRZ/qR/IBDs= c=1 sm=0 a=TAV5VDu9UMMA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=SyI_GHdlAAAA:8 a=meVymXHHAAAA:8 a=GDdaM7npN3j1qw79OkgA:9 a=dZDXiM9gv3ETj-_RhnEWPNEh0eAA:4 a=jEp0ucaQiEUA:10 a=UQxMgyrMzRwA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101014210136.230687571@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 Oct 2010 17:00:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, <linux-arch@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        John Reiser <jreiser@bitwagon.com>
Subject: [PATCH 2/3] ftrace/x86: Add support for C version of recordmcount
References: <20101014210014.895157788@goodmis.org>
Content-Disposition: inline; filename=0002-ftrace-x86-Add-support-for-C-version-of-recordmcount.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch adds the support for the C version of recordmcount and
compile times show ~ 12% improvement.

After verifying this works, other archs can add:

 HAVE_C_MCOUNT_RECORD

in its Kconfig and it will use the C version of recordmcount
instead of the perl version.

Cc: <linux-arch@vger.kernel.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org
Cc: John Reiser <jreiser@bitwagon.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Makefile               |    6 ++++++
 arch/x86/Kconfig       |    1 +
 kernel/trace/Kconfig   |    5 +++++
 scripts/Makefile       |    1 +
 scripts/Makefile.build |    4 ++++
 5 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index 534c09c..0dd3a8d 100644
--- a/Makefile
+++ b/Makefile
@@ -568,6 +568,12 @@ endif
 
 ifdef CONFIG_FUNCTION_TRACER
 KBUILD_CFLAGS	+= -pg
+ifdef CONFIG_DYNAMIC_FTRACE
+	ifdef CONFIG_HAVE_C_MCOUNT_RECORD
+		BUILD_C_RECORDMCOUNT := y
+		export BUILD_C_RECORDMCOUNT
+	endif
+endif
 endif
 
 # We trigger additional mismatches with less inlining
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c14d8b4..788b50e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -33,6 +33,7 @@ config X86
 	select HAVE_KRETPROBES
 	select HAVE_OPTPROBES
 	select HAVE_FTRACE_MCOUNT_RECORD
+	select HAVE_C_MCOUNT_RECORD
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_GRAPH_TRACER
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 538501c..df00fbb 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -49,6 +49,11 @@ config HAVE_SYSCALL_TRACEPOINTS
 	help
 	  See Documentation/trace/ftrace-design.txt
 
+config HAVE_C_MCOUNT_RECORD
+	bool
+	help
+	  C version of recordmcount available?
+
 config TRACER_MAX_TRACE
 	bool
 
diff --git a/scripts/Makefile b/scripts/Makefile
index 842dbc2..2e08810 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -11,6 +11,7 @@ hostprogs-$(CONFIG_KALLSYMS)     += kallsyms
 hostprogs-$(CONFIG_LOGO)         += pnmtologo
 hostprogs-$(CONFIG_VT)           += conmakehash
 hostprogs-$(CONFIG_IKCONFIG)     += bin2c
+hostprogs-$(BUILD_C_RECORDMCOUNT) += recordmcount
 
 always		:= $(hostprogs-y) $(hostprogs-m)
 
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index a1a5cf9..4d03a7e 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -209,12 +209,16 @@ cmd_modversions =								\
 endif
 
 ifdef CONFIG_FTRACE_MCOUNT_RECORD
+ifdef BUILD_C_RECORDMCOUNT
+cmd_record_mcount = $(srctree)/scripts/recordmcount "$(@)";
+else
 cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
 	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
 	"$(if $(CONFIG_64BIT),64,32)" \
 	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" "$(MV)" \
 	"$(if $(part-of-module),1,0)" "$(@)";
 endif
+endif
 
 define rule_cc_o_c
 	$(call echo-cmd,checksrc) $(cmd_checksrc)			  \
-- 
1.7.1


