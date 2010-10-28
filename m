Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760583Ab0J1RDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 13:03:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:31500 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760462Ab0J1RDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 13:03:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,253,1286175600"; 
   d="scan'208";a="568250100"
Message-ID: <4CC9ACC9.1060207@linux.intel.com>
Date: Thu, 28 Oct 2010 10:03:05 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11) Gecko/20101006 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>
Subject: Getting started with the Linux kernel vDSO
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to figure out how to go about adding a function to the Linux
vDSO. What I'm trying to accomplish is pretty basic: add a function to
the vDSO that can read from a chunk of user-readable kernel memory and
return a boolean.

long tidrunning(pid_t tid);

This is for a mostly userspace version follow-on to this as a POC for
Plumbers: http://lwn.net/Articles/386536/

To start, I'm just trying to return a static value and I'll get to
mapping in the memory block later. I mimicked the x86/vdso/vgetcpu.c to
create vtidrunning.c, updated the Makefile, and built the kernel,
resulting in a vdso.so that now has the desired symbols:

$ objdump -T arch/x86/vdso/vdso.so

arch/x86/vdso/vdso.so:     file format elf64-x86-64

DYNAMIC SYMBOL TABLE:
ffffffffff70035c l    d  .eh_frame_hdr	0000000000000000              .eh_frame_hdr
ffffffffff7008d0  w   DF .text	000000000000009c  LINUX_2.6   clock_gettime
0000000000000000 g    DO *ABS*	0000000000000000  LINUX_2.6   LINUX_2.6
ffffffffff700790 g    DF .text	000000000000008a  LINUX_2.6   __vdso_gettimeofday
ffffffffff7009b0 g    DF .text	0000000000000008  LINUX_2.6   __vdso_tidrunning
ffffffffff7009b0  w   DF .text	0000000000000008  LINUX_2.6   tidrunning
ffffffffff700970 g    DF .text	000000000000003d  LINUX_2.6   __vdso_getcpu
ffffffffff700790  w   DF .text	000000000000008a  LINUX_2.6   gettimeofday
ffffffffff700970  w   DF .text	000000000000003d  LINUX_2.6   getcpu
ffffffffff7008d0 g    DF .text	000000000000009c  LINUX_2.6   __vdso_clock_gettime

Note the two new symbols: tidrunning and __vdso_tidrunning.

I'm having trouble linking to them. glibc takes the vsyscall approach
and just calls a calculated address directly for getcpu (on x86_64
anyway). It does use the vdso version of gettimeofday for powerpc and
x86_64, but the amount of symbol lookup code is staggering. I was
hoping to find a way to link to this new symbol without having to
patch glibc (or untangle the symbol lookup code for use in a
stand-alone testcase).

Unfortunately, adding the vdso.so path to ld.so.conf.d/... doesn't
pickup vdso.so on the next run of ldconfig, and the link step of the
compile obviously fails to find the library. My test app is simple:

#include <stdio.h>
#include <sys/types.h>

extern long tidrunning(pid_t *tid);

int main(int argc, char *argv[])
{
	long running = tidrunning(0);
	printf("tid 0 is %s\n", running ? "running" : "not running");
	return 0;
}

Am I veering off into the weeds here? What is the proper way to link
to the vdso? My current kernel patch (just a hack still) follows:


diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 4a2afa1..09c10c9 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -11,7 +11,7 @@ vdso-install-$(VDSO32-y)	+= $(vdso32-images)
   # files to link into the vdso
-vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o vvar.o
+vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o vvar.o vtidrunning.o
  # files to link into kernel
 obj-$(VDSO64-y)			+= vma.o vdso.o
diff --git a/arch/x86/vdso/vdso.lds.S b/arch/x86/vdso/vdso.lds.S
index 4e5dd3b..21255eb 100644
--- a/arch/x86/vdso/vdso.lds.S
+++ b/arch/x86/vdso/vdso.lds.S
@@ -23,6 +23,8 @@ VERSION {
 		__vdso_gettimeofday;
 		getcpu;
 		__vdso_getcpu;
+		tidrunning;
+		__vdso_tidrunning;
 	local: *;
 	};
 }
diff --git a/arch/x86/vdso/vtidrunning.c b/arch/x86/vdso/vtidrunning.c
new file mode 100644
index 0000000..642c25c
--- /dev/null
+++ b/arch/x86/vdso/vtidrunning.c
@@ -0,0 +1,23 @@
+/*
+ * Copyright 2010 Darren Hart, Intel Corporation
+ * Subject to the GNU Public License, v.2
+ *
+ * User context test for tid running state.
+ */
+
+#include <linux/kernel.h>
+#include <linux/getcpu.h>
+#include <linux/jiffies.h>
+#include <linux/time.h>
+#include <asm/vsyscall.h>
+#include <asm/vgtod.h>
+#include "vextern.h"
+
+notrace long
+__vdso_tidrunning(pid_t *tid)
+{
+	return 0;
+}
+
+long tidrunning(pid_t *tid)
+	__attribute__((weak, alias("__vdso_tidrunning")));

-- 
Darren Hart
Embedded Linux Kernel
