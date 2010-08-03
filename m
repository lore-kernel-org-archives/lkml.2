Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab0HCFU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 01:20:59 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64195 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab0HCFU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 01:20:58 -0400
Date: Tue, 3 Aug 2010 01:20:51 -0400
From: "George G. Davis" <gdavis@mvista.com>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: GCOV doesn't seem to work on ARM with kernel 2.6.35-rc6
Message-ID: <20100803052051.GA17719@mvista.com>
References: <4C4D6458.6040402@samsung.com>
 <4C4D6554.30707@samsung.com>
 <4C4DBE8E.70102@linux.vnet.ibm.com>
 <4C4E8C2C.3000903@samsung.com>
 <4C502CC5.7070205@linux.vnet.ibm.com>
 <4C50342F.2080001@samsung.local>
 <4C50536A.1090205@linux.vnet.ibm.com>
 <4C51AB7F.70805@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <4C51AB7F.70805@samsung.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Thu, Jul 29, 2010 at 06:25:35PM +0200, Karol Lewandowski wrote:
> On 07/28/2010 05:57 PM, Peter Oberparleiter wrote:
> >On 28.07.2010 15:44, Karol Lewandowski wrote:
> >>On 07/28/2010 03:12 PM, Peter Oberparleiter wrote:
> >>>On 27.07.2010 09:35, Karol Lewandowski wrote:
> >>>>On 07/26/2010 06:57 PM, Peter Oberparleiter wrote:
> >>>>>Karol Lewandowski wrote:
> >>>>>>On 07/26/2010 12:32 PM, Karol Lewandowski wrote:
> >>>>>>>I'm trying to use code coverage measurements with mainline Linux
> >>>>>>>kernel
> >>>>>>>2.6.35-rc6 on ARM platform (specifically on Samsung's S5PC110
> >>>>>>>board).
> >>>>...
> >>>>>I just tested gcov support for 2.6.35-rc6 on s390 and it works without
> >>>>>a problem. My assumption would be that you are using an EABI-GCC to
> >>>>>compile your kernel. Those compilers name their constructor symbols
> >>>>
> >>>>Exactly.
> >>>>
> >>>>>differently than the vanilla GCC so that the whole constructor calling
> >>>>>mechanism on which the gcov support relies, will fail. If that is
> >>>>>indeed the case, the following testing patch should solve your
> >>>>>problem:
> >>>>
> >>>>Yes, that was the case and your patch indeed solved my problem.
> >>>
> >>>Excellent. I could imagine that other ARM users might also benefit from
> >>>this patch. Before I submit it for integration though, I need to make
> >>>sure that it also works for kernel modules. Could you enable profiling
> >>>for a kernel module and verify that you are seeing files in
> >>>/sys/kernel/debug/gcov belonging to that module??
> >>
> >>That does work too.
> >>
> >>However, having seen this[x] patch I would ask if constructor name might
> >>be dynamically selected via user-(in)visible Kconfig option (like in
> >>that patch?) I've tested it and it does seem to work too.
> >>
> >>[x]
> >>http://groups.google.com/group/linux.kernel/browse_thread/thread/84439151c5386e0f/d7dbec62b9d7989f?show_docid=d7dbec62b9d7989f
> >>
> >>
> >>
> >>I've copy pasted interesting parts from that patch below - I'm sure you
> >>get the idea.
> >>
> >>Thanks.
> >>
> >>--- a/include/asm-generic/vmlinux.lds.h
> >>+++ b/include/asm-generic/vmlinux.lds.h
> >>@@ -442,7 +442,7 @@
> >>#ifdef CONFIG_CONSTRUCTORS
> >>#define KERNEL_CTORS() . = ALIGN(8); \
> >>VMLINUX_SYMBOL(__ctors_start) = .; \
> >>- *(.ctors) \
> >>+ *(CONFIG_GCOV_CTORS) \
> >
> >This should be named differently - gcov uses constructors but this
> >doesn't mean that constructors rely on gcov at all.

I actually changed that patch [x] long ago relative to the above but
haven't gotten around to following up with a new version and no one
has been anxious to reply about it since anyway.  ; )  The original
version of [x] had a GCOV_CTORS depends on GCOV_KERNEL bug where
GCOV_KERNEL could be disabled resulting in a CONSTRUCTORS build
error due to undefined GCOV_CTORS.  A new version of [x] is
attached below.

> >
> >>--- a/kernel/gcov/Kconfig
> >>+++ b/kernel/gcov/Kconfig
> >>+config GCOV_CTORS
> >>+ string
> >>+ depends on GCOV_KERNEL
> >>+ default ".init_array" if ARM && AEABI
> >>+ default ".ctors"
> >
> >Is it guaranteed that gcc will only create EABI compliant object files
> >if CONFIG_AEABI is defined? I don't have personal experience with arm so
> >my previous assumption was that if you're using an EABI gcc, you would
> >always get EABI object code, no matter what the compiler options were.
> 
> Honestly - I don't know.  Maybe George - author of cited patch could
> explain this?  (CC added).

Yes that is correct.

Thanks!

--
Regards,
George

> 
> Thanks.

--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-gcov-Add-ARM-eABI-support.patch"

>From 2a55028da8c8567de6a8223e753e1de440bb3e8f Mon Sep 17 00:00:00 2001
From: George G. Davis <gdavis@mvista.com>
Date: Tue, 27 Apr 2010 16:47:16 -0400
Subject: [PATCH] gcov: Add ARM eABI support

Initially based on linux-2.6.30-gcov-arm-eabi.patch [1] and
linux-2.6.30-gcov-arm-hack.patch [2] with fixups to resolve
forward port conflicts.  Improved on [1] by making the
constructors section name a kernel config variable so the
correct section name is automatically selected based on the
build target.

[1] http://ltp.cvs.sourceforge.net/viewvc/*checkout*/ltp/utils/analysis/gcov-kernel/linux-2.6.30-gcov-arm-eabi.patch?revision=1.1
[2] http://ltp.cvs.sourceforge.net/viewvc/*checkout*/ltp/utils/analysis/gcov-kernel/linux-2.6.30-gcov-arm-hack.patch?revision=1.1

Signed-off-by: David Singleton <dsingleton@mvista.com>
Signed-off-by: George G. Davis <gdavis@mvista.com>
---
 arch/arm/boot/bootp/Makefile      |    2 ++
 arch/arm/boot/compressed/Makefile |    2 ++
 arch/arm/include/asm/elf.h        |    1 +
 arch/arm/kernel/module.c          |    1 +
 include/asm-generic/vmlinux.lds.h |    2 +-
 init/Kconfig                      |    6 ++++++
 kernel/gcov/Kconfig               |    2 +-
 kernel/module.c                   |    2 +-
 8 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/bootp/Makefile b/arch/arm/boot/bootp/Makefile
index c394e30..5761f00 100644
--- a/arch/arm/boot/bootp/Makefile
+++ b/arch/arm/boot/bootp/Makefile
@@ -5,6 +5,8 @@
 # architecture-specific flags and dependencies.
 #
 
+GCOV_PROFILE	:= n
+
 LDFLAGS_bootp	:=-p --no-undefined -X \
 		 --defsym initrd_phys=$(INITRD_PHYS) \
 		 --defsym params_phys=$(PARAMS_PHYS) -T
diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index 864a002..4ecb1ba 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -8,6 +8,8 @@ HEAD	= head.o
 OBJS	= misc.o decompress.o
 FONTC	= $(srctree)/drivers/video/console/font_acorn_8x8.c
 
+GCOV_PROFILE		:= n
+
 #
 # Architecture dependencies
 #
diff --git a/arch/arm/include/asm/elf.h b/arch/arm/include/asm/elf.h
index 51662fe..6b19f46 100644
--- a/arch/arm/include/asm/elf.h
+++ b/arch/arm/include/asm/elf.h
@@ -52,6 +52,7 @@ typedef struct user_fp elf_fpregset_t;
 #define R_ARM_ABS32		2
 #define R_ARM_CALL		28
 #define R_ARM_JUMP24		29
+#define R_ARM_TARGET1		38
 #define R_ARM_V4BX		40
 #define R_ARM_PREL31		42
 #define R_ARM_MOVW_ABS_NC	43
diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
index c628bdf..2e04a98 100644
--- a/arch/arm/kernel/module.c
+++ b/arch/arm/kernel/module.c
@@ -129,6 +129,7 @@ apply_relocate(Elf32_Shdr *sechdrs, const char *strtab, unsigned int symindex,
 			break;
 
 		case R_ARM_ABS32:
+		case R_ARM_TARGET1:
 			*(u32 *)loc += sym->st_value;
 			break;
 
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 030a954..ef62639 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -452,7 +452,7 @@
 #ifdef CONFIG_CONSTRUCTORS
 #define KERNEL_CTORS()	. = ALIGN(8);			   \
 			VMLINUX_SYMBOL(__ctors_start) = .; \
-			*(.ctors)			   \
+			*(CONFIG_CTORS)			   \
 			VMLINUX_SYMBOL(__ctors_end) = .;
 #else
 #define KERNEL_CTORS()
diff --git a/init/Kconfig b/init/Kconfig
index 5cff9a9..eb3ad6e 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -21,6 +21,12 @@ config CONSTRUCTORS
 	depends on !UML
 	default y
 
+config CTORS
+	string
+	depends on CONSTRUCTORS
+	default ".init_array" if ARM && AEABI
+	default ".ctors"
+
 menu "General setup"
 
 config EXPERIMENTAL
diff --git a/kernel/gcov/Kconfig b/kernel/gcov/Kconfig
index 70a298d..c62fb42 100644
--- a/kernel/gcov/Kconfig
+++ b/kernel/gcov/Kconfig
@@ -34,7 +34,7 @@ config GCOV_KERNEL
 config GCOV_PROFILE_ALL
 	bool "Profile entire Kernel"
 	depends on GCOV_KERNEL
-	depends on S390 || X86 || (PPC && EXPERIMENTAL) || MICROBLAZE
+	depends on S390 || X86 || (PPC && EXPERIMENTAL) || MICROBLAZE || ARM
 	default n
 	---help---
 	This options activates profiling for the entire kernel.
diff --git a/kernel/module.c b/kernel/module.c
index 6c56282..26885e1 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2405,7 +2405,7 @@ static noinline struct module *load_module(void __user *umod,
 					    "__kcrctab_unused_gpl");
 #endif
 #ifdef CONFIG_CONSTRUCTORS
-	mod->ctors = section_objs(hdr, sechdrs, secstrings, ".ctors",
+	mod->ctors = section_objs(hdr, sechdrs, secstrings, CONFIG_CTORS,
 				  sizeof(*mod->ctors), &mod->num_ctors);
 #endif
 
-- 
1.6.3.3.334.g800a0


--6c2NcOVqGQ03X4Wi--
