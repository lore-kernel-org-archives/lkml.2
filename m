Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab1G1PuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:50:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537Ab1G1PuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:50:00 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 00/40] UAPI header file split [ver #3]
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Date: Thu, 28 Jul 2011 16:49:21 +0100
Message-ID: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here's my first installment of patches to clean up the kernel header files and
sort out the inclusion recursion problems.

Note that these patches will need regenerating if the header files they alter
change before they're applied.  However, disintegration is scripted, so that
just takes a few minutes.


===================================
BACKGROUND ON THE RECURSION PROBLEM
===================================

I occasionally run into a problem where I can't write an inline function in a
header file because I need to access something from another header that
includes this one.  Due to this, I end up writing it as a #define instead.

The problems are mainly due to inline functions.  If we split some headers
(linux/sched.h being the biggest culprit) to separate the inline functions from
the data structs (e.g. task_struct) then we could reduce the problems.  Other
splits and rearrangements could help also.

Quite often it's a case of an inline function in header A wanting a struct[*]
from header B, but header B already has an inline function that wants a struct
from header A.

	[*] or constant or whatever.

Recently someone tried to add a kernel-offsets file (an analogue to
asm-offsets) to deal with the problems of dealing with both linux/rcupdate.h
and linux/sched.h - each header needed to be included before the other.


=================
PLANNED PROCEDURE
=================

The planned steps are:

 (1) Split the Userspace API (UAPI) out of the kernel headers into its own
     header directories.

 (2) Move stuff out of the Kernel API (KAPI) headers that can be contained in
     individual directories as it is referenced by a single file or directory
     of files.

 (3) Make coherent what can be found in commmon arch headers and disintegrate
     asm/system.h.

 (4) Split some headers into definitions containers and inline function
     containers to clean up recursion problems.  The main culprit is very
     likely to be linux/sched.h, I think.

 (5) I'd like to split some headers (e.g. linux/security.h) to reduce the
     conditional recompilation burden.  linux/security.h could have, for
     instance, struct security_operations split out into a header file private
     to the stuff in the security/ directory as the wrappers of its function
     pointers are now out of lined in security/security.c.

 (6) Replace the traditional anti-reinclusion guards on header files with
     three-state anti-recursion guards that abort compilation if recursive
     inclusion is encountered.

 (7) Provide a script to go through and rejig the #includes of each source file
     to have just the ones that are actually required (a lot of cut'n'pasting
     goes on, and there are quite a few unnecessary #includes out there).

 (8) Provide a make target that tests all the KAPI and UAPI headers by simply
     passing them one at a time to the compiler and attempting to compile them.


===================
IMPLEMENTING STEP 1
===================

The patches actually posted here are the manual preparation for the UAPI split
in step (1) above.  I haven't posted the patches that do the actual splitting
by email as the largest of them is in excess of 120,000 lines.  However, the
patches are available through GIT:

	http://git.infradead.org/users/dhowells/linux-headers.git

All the development is on the uapi-split branch.  The patches posted here are
from the base of that branch up to the uapi-prep tag; the automated split
follows thereafter to the uapi-post-split tag.

The scripts used are added to the sources in four patches:

	UAPI: Add script to convert #include "..." to #include <path/...> in sys headers
	UAPI: Add script to audit drivers/gpu/ for #including system headers with "..."
	UAPI: Add a script to create a commit to set up new UAPI dirs
	UAPI: Scripts to disintegrate header files

which are the first, third, eighth from last and last patches posted.  They can
be deleted later as they shouldn't be needed again - but a record of them will
be retained by GIT.


The main aims of the split are:

 (1) To simplify the kernel headers by separating the UAPI from the KAPI.

 (2) You should be able to simply copy the UAPI directories to userspace with
     no processing, and they should just work.  Unfortunately, it's not quite
     that simple as some of the UAPI headers behave differently depending on
     whether __KERNEL__ is defined or not.

 (3) To eliminate the need for __KERNEL__.  After the split, __KERNEL__ can
     certainly be unifdef'd from the residual kernel headers - but this isn't
     quite true of the UAPI headers.

The main restrictions on how I've done the split are:

 (1) The GIT history must be maintained in both sides of a split header file.

 (2) I don't want to have to alter every #include directive in the kernel
     sources.

 (3) "make allyesconfig" should work after.  This is tricky to test as it
     doesn't necessarily work before.

With this in mind, the way things work is that #include is used for the KAPI
header to refer to the UAPI header, with the path prefixed with 'uapi/'.  The
UAPI header is placed in a subdir of *include/uapi/ that mirrors where the KAPI
file is under *include/.  For instance:

	include/linux/types.h		-> include/uapi/linux/types.h
	arch/x86/include/asm/unistd.h	-> arch/x86/include/uapi/asm/unistd.h

include/linux/types.h therefore #includes <uapi/linux/types.h>.

The uapi/ directories are also added with -I to the CPP flags after the
include/ directories so that if the KAPI file does not exist, the UAPI file
will be used directly.  This is not as elegant as using #include_next might be,
but it does work.

I've created one patch for each include directory that gets exported.  I'd
prefer to use a single patch per file to make GIT's life easier and more sure,
but that would mean a stack of >1100 patches.  I think the most important thing
from git-blame's point of view is to keep the arch header splits separated by
arch as there's a lot of similarity.


I've tested it for make allyesconfig with x86_64, i386 and MIPS, and attempted
it for MN10300 (but that runs into other problems).  Other arches will need
fixing up as necessary.


======
ISSUES
======

There are some issues:

 (*) I'm not sure I have all the kernel scripts and Makefiles altered correctly
     - someone who knows the Kbuild magic should check things over.  However,
     headers do install correctly, so I think I've got things mostly right.

 (*) Documentation/vm/page-types.c directly refers to the magic.h file it wants
     to include using a path with '..' in it.  This is broken from the patch
     that alters the path until the header is split.

 (*) Is uapi/ the right name for the UAPI directories?  If not, it shouldn't be
     too hard to change as most of it is scripted.  It can't be put in usr/
     until the UAPI headers don't need any processing, and besides, the arch
     UAPI headers can't be put under there anyway without collision.

 (*) I'd also prefer to use #include_next and move the uapi/ directories out of
     the include/ directories:

	include/uapi/ -> uapi/
	arch/foo/include/uapi/ -> arch/foo/uapi/

     as it seems cleaner, especially as there's then no need to #include
     <uapi/...> anywhere - but various people object to the use of
     #include_next, though the kernel does already use it.

David
---
David Howells (40):
      UAPI: Scripts to disintegrate header files
      UAPI: Fix the x86 test_get_len tool
      UAPI: Fix the page-types query program in the docs
      UAPI: Make UAPI headers install to usr/include/
      UAPI: Move linux/version.h
      UAPI: Set up uapi/asm/Kbuild.asm
      UAPI: Plumb the UAPI Kbuilds into the user header handling system
      UAPI: Set up UAPI Kbuild files
      UAPI: Add a script to create a commit to set up new UAPI dirs
      UAPI: Fix arch/mips/include/asm/Kbuild to have separate header-y lines
      UAPI: Fix x86_64 system call count and generation
      UAPI: Fix linux/ncp.h
      UAPI: Guard linux/sound.h
      UAPI: Guard linux/isdn_divertif.h
      UAPI: Fix linux/coda.h
      UAPI: Fix u_quad_t ordering problem in linux/coda.h
      UAPI: Fix SNDRV_*_ENDIAN ordering problem
      UAPI: sound/sound_core.c should include linux/fs.h
      UAPI: Fix drmP.h to use #include <...> when referring to system header files
      UAPI: Fix linux/auto_fs.h inclusion order
      UAPI: Fix up linux/netfilter/xt_policy.h
      UAPI: Fix linux/input.h inclusion order
      UAPI: Fix linux/netfilter.h inclusion order
      UAPI: Fix E820_X_MAX ordering problem
      UAPI: Fix sigset_t ordering problem
      UAPI: elf_read_implies_exec() is a kernel-only feature - so hide from userspace
      UAPI: Fix definition of HZ in asm-generic/param.h
      UAPI: Remove the inclusion of linux/types.h from x86's asm/page.h
      UAPI: Split trivial #if defined(__KERNEL__) && X conditionals
      UAPI: Fix nested __KERNEL__ guards in video/edid.h
      UAPI: Don't have a #elif clause in a __KERNEL__ guard in linux/soundcard.h
      UAPI: Make linux/patchkey.h easier to parse
      UAPI: ac_etime in linux/acct.h must keep its __KERNEL__ guards
      UAPI: Fix AHZ multiple inclusion when __KERNEL__ is removed
      UAPI: Differentiate userspace build and kernelspace build include path sets
      UAPI: Add include/uapi/ directories to build
      UAPI: Convert #include "..." to #include <path/...> in kernel system headers
      UAPI: Add script to audit drivers/gpu/ for #including system headers with "..."
      UAPI: Convert #include "..." to #include <path/...> in kernel system headers
      UAPI: Add script to convert #include "..." to #include <path/...> in sys headers


 Documentation/vm/page-types.c                      |    2 
 Makefile                                           |   32 -
 arch/alpha/include/uapi/asm/Kbuild                 |    3 
 arch/arm/include/asm/hwcap.h                       |    4 
 arch/arm/include/asm/localtimer.h                  |    2 
 arch/arm/include/asm/page.h                        |    2 
 arch/arm/include/asm/pgtable.h                     |    2 
 arch/arm/include/asm/swab.h                        |    7 
 arch/arm/include/asm/unistd.h                      |    4 
 arch/arm/include/asm/vfpmacros.h                   |    2 
 arch/arm/include/uapi/asm/Kbuild                   |    3 
 arch/avr32/include/uapi/asm/Kbuild                 |    3 
 arch/blackfin/include/uapi/asm/Kbuild              |    3 
 arch/cris/include/arch-v10/arch/sv_addr_ag.h       |    2 
 arch/cris/include/arch-v10/arch/svinto.h           |    2 
 arch/cris/include/arch-v32/arch/dma.h              |    2 
 arch/cris/include/arch-v32/arch/hwregs/dma.h       |    2 
 arch/cris/include/uapi/arch-v10/arch/Kbuild        |    1 
 arch/cris/include/uapi/arch-v32/arch/Kbuild        |    1 
 arch/cris/include/uapi/asm/Kbuild                  |    5 
 arch/frv/include/uapi/asm/Kbuild                   |    3 
 arch/h8300/include/uapi/asm/Kbuild                 |    3 
 arch/ia64/include/asm/intrinsics.h                 |   21 
 arch/ia64/include/uapi/asm/Kbuild                  |    3 
 arch/m32r/include/uapi/asm/Kbuild                  |    3 
 arch/m68k/include/asm/cacheflush.h                 |    4 
 arch/m68k/include/asm/entry.h                      |    4 
 arch/m68k/include/asm/io.h                         |    4 
 arch/m68k/include/asm/m68360.h                     |    8 
 arch/m68k/include/asm/m68360_enet.h                |    2 
 arch/m68k/include/asm/page.h                       |    4 
 arch/m68k/include/asm/pgtable.h                    |    4 
 arch/m68k/include/asm/q40_master.h                 |    2 
 arch/m68k/include/asm/uaccess.h                    |    4 
 arch/m68k/include/uapi/asm/Kbuild                  |    3 
 arch/microblaze/include/asm/mmu_context.h          |    2 
 arch/microblaze/include/uapi/asm/Kbuild            |    3 
 arch/mips/include/asm/Kbuild                       |    4 
 arch/mips/include/asm/mach-bcm63xx/bcm63xx_io.h    |    2 
 arch/mips/include/asm/mach-pnx833x/gpio.h          |    2 
 arch/mips/include/asm/octeon/cvmx-asm.h            |    2 
 arch/mips/include/asm/octeon/cvmx-spinlock.h       |    2 
 arch/mips/include/asm/octeon/cvmx.h                |   36 -
 arch/mips/include/asm/octeon/octeon-model.h        |    2 
 arch/mips/include/asm/octeon/octeon.h              |    2 
 arch/mips/include/asm/sibyte/bcm1480_int.h         |    2 
 arch/mips/include/asm/sibyte/bcm1480_l2c.h         |    2 
 arch/mips/include/asm/sibyte/bcm1480_mc.h          |    2 
 arch/mips/include/asm/sibyte/bcm1480_regs.h        |    4 
 arch/mips/include/asm/sibyte/bcm1480_scd.h         |    4 
 arch/mips/include/asm/sibyte/sb1250_dma.h          |    2 
 arch/mips/include/asm/sibyte/sb1250_genbus.h       |    2 
 arch/mips/include/asm/sibyte/sb1250_int.h          |    2 
 arch/mips/include/asm/sibyte/sb1250_l2c.h          |    2 
 arch/mips/include/asm/sibyte/sb1250_ldt.h          |    2 
 arch/mips/include/asm/sibyte/sb1250_mac.h          |    2 
 arch/mips/include/asm/sibyte/sb1250_mc.h           |    2 
 arch/mips/include/asm/sibyte/sb1250_regs.h         |    2 
 arch/mips/include/asm/sibyte/sb1250_scd.h          |    2 
 arch/mips/include/asm/sibyte/sb1250_smbus.h        |    2 
 arch/mips/include/asm/sibyte/sb1250_syncser.h      |    2 
 arch/mips/include/asm/sibyte/sb1250_uart.h         |    2 
 arch/mips/include/asm/types.h                      |   10 
 arch/mips/include/uapi/asm/Kbuild                  |    3 
 arch/mn10300/include/uapi/asm/Kbuild               |    3 
 arch/openrisc/include/uapi/asm/Kbuild              |    3 
 arch/parisc/include/uapi/asm/Kbuild                |    3 
 arch/powerpc/include/asm/ps3.h                     |    2 
 arch/powerpc/include/asm/ucc_fast.h                |    2 
 arch/powerpc/include/asm/ucc_slow.h                |    2 
 arch/powerpc/include/uapi/asm/Kbuild               |    3 
 arch/s390/include/asm/mman.h                       |    4 
 arch/s390/include/uapi/asm/Kbuild                  |    3 
 arch/score/include/uapi/asm/Kbuild                 |    3 
 arch/sh/include/asm/checksum.h                     |    2 
 arch/sh/include/asm/mmu_context.h                  |    4 
 arch/sh/include/asm/posix_types.h                  |    8 
 arch/sh/include/asm/processor.h                    |    4 
 arch/sh/include/asm/ptrace.h                       |    4 
 arch/sh/include/asm/string.h                       |    4 
 arch/sh/include/asm/syscall.h                      |    4 
 arch/sh/include/asm/syscalls.h                     |    4 
 arch/sh/include/asm/system.h                       |    4 
 arch/sh/include/asm/tlb.h                          |    2 
 arch/sh/include/asm/uaccess.h                      |    4 
 arch/sh/include/asm/unistd.h                       |    8 
 arch/sh/include/mach-ecovec24/mach/romimage.h      |    2 
 arch/sh/include/mach-kfr2r09/mach/romimage.h       |    2 
 arch/sh/include/uapi/asm/Kbuild                    |    3 
 arch/sparc/include/uapi/asm/Kbuild                 |    5 
 arch/tile/include/asm/signal.h                     |    4 
 arch/tile/include/uapi/asm/Kbuild                  |    3 
 arch/unicore32/include/mach/PKUnity.h              |   36 -
 arch/unicore32/include/mach/hardware.h             |    2 
 arch/unicore32/include/mach/uncompress.h           |    4 
 arch/unicore32/include/uapi/asm/Kbuild             |    3 
 arch/x86/boot/Makefile                             |    4 
 arch/x86/boot/mkcpustr.c                           |    2 
 arch/x86/include/asm/atomic.h                      |    4 
 arch/x86/include/asm/calling.h                     |    2 
 arch/x86/include/asm/checksum.h                    |    4 
 arch/x86/include/asm/cmpxchg.h                     |    4 
 arch/x86/include/asm/cpufeature.h                  |    2 
 arch/x86/include/asm/e820.h                        |    2 
 arch/x86/include/asm/mmzone.h                      |    4 
 arch/x86/include/asm/mutex.h                       |    4 
 arch/x86/include/asm/numa.h                        |    4 
 arch/x86/include/asm/page.h                        |    2 
 arch/x86/include/asm/page_types.h                  |    3 
 arch/x86/include/asm/pci.h                         |    2 
 arch/x86/include/asm/pgtable.h                     |    4 
 arch/x86/include/asm/pgtable_types.h               |    4 
 arch/x86/include/asm/posix_types.h                 |    8 
 arch/x86/include/asm/seccomp.h                     |    4 
 arch/x86/include/asm/signal.h                      |    2 
 arch/x86/include/asm/string.h                      |    4 
 arch/x86/include/asm/suspend.h                     |    4 
 arch/x86/include/asm/uaccess.h                     |    4 
 arch/x86/include/asm/unistd.h                      |    8 
 arch/x86/include/asm/user.h                        |    4 
 arch/x86/include/asm/xen/interface.h               |    4 
 arch/x86/include/asm/xor.h                         |    4 
 arch/x86/include/uapi/asm/Kbuild                   |    3 
 arch/x86/kernel/asm-offsets_64.c                   |    1 
 arch/x86/kernel/cpu/mkcapflags.pl                  |    5 
 arch/x86/kernel/syscall_64.c                       |    2 
 arch/x86/tools/Makefile                            |    2 
 arch/xtensa/include/uapi/asm/Kbuild                |    3 
 drivers/gpu/drm/ati_pcigart.c                      |    2 
 drivers/gpu/drm/drm_agpsupport.c                   |    2 
 drivers/gpu/drm/drm_auth.c                         |    2 
 drivers/gpu/drm/drm_buffer.c                       |    2 
 drivers/gpu/drm/drm_bufs.c                         |    2 
 drivers/gpu/drm/drm_cache.c                        |    2 
 drivers/gpu/drm/drm_context.c                      |    2 
 drivers/gpu/drm/drm_crtc.c                         |    8 
 drivers/gpu/drm/drm_crtc_helper.c                  |    8 
 drivers/gpu/drm/drm_debugfs.c                      |    2 
 drivers/gpu/drm/drm_dma.c                          |    2 
 drivers/gpu/drm/drm_dp_i2c_helper.c                |    4 
 drivers/gpu/drm/drm_drv.c                          |    4 
 drivers/gpu/drm/drm_edid.c                         |    4 
 drivers/gpu/drm/drm_edid_modes.h                   |    4 
 drivers/gpu/drm/drm_encoder_slave.c                |    2 
 drivers/gpu/drm/drm_fb_helper.c                    |    8 
 drivers/gpu/drm/drm_fops.c                         |    2 
 drivers/gpu/drm/drm_gem.c                          |    2 
 drivers/gpu/drm/drm_global.c                       |    2 
 drivers/gpu/drm/drm_hashtab.c                      |    4 
 drivers/gpu/drm/drm_info.c                         |    2 
 drivers/gpu/drm/drm_ioc32.c                        |    4 
 drivers/gpu/drm/drm_ioctl.c                        |    6 
 drivers/gpu/drm/drm_irq.c                          |    2 
 drivers/gpu/drm/drm_lock.c                         |    2 
 drivers/gpu/drm/drm_memory.c                       |    2 
 drivers/gpu/drm/drm_mm.c                           |    4 
 drivers/gpu/drm/drm_modes.c                        |    6 
 drivers/gpu/drm/drm_pci.c                          |    2 
 drivers/gpu/drm/drm_platform.c                     |    2 
 drivers/gpu/drm/drm_proc.c                         |    2 
 drivers/gpu/drm/drm_scatter.c                      |    2 
 drivers/gpu/drm/drm_sman.c                         |    2 
 drivers/gpu/drm/drm_stub.c                         |    4 
 drivers/gpu/drm/drm_sysfs.c                        |    6 
 drivers/gpu/drm/drm_trace_points.c                 |    2 
 drivers/gpu/drm/drm_usb.c                          |    2 
 drivers/gpu/drm/drm_vm.c                           |    2 
 drivers/gpu/drm/i2c/ch7006_priv.h                  |    8 
 drivers/gpu/drm/i2c/sil164_drv.c                   |    8 
 drivers/gpu/drm/i810/i810_dma.c                    |    6 
 drivers/gpu/drm/i810/i810_drv.c                    |    8 
 drivers/gpu/drm/i915/dvo.h                         |    6 
 drivers/gpu/drm/i915/i915_debugfs.c                |    6 
 drivers/gpu/drm/i915/i915_dma.c                    |   10 
 drivers/gpu/drm/i915/i915_drv.c                    |    8 
 drivers/gpu/drm/i915/i915_gem.c                    |    6 
 drivers/gpu/drm/i915/i915_gem_debug.c              |    6 
 drivers/gpu/drm/i915/i915_gem_evict.c              |    6 
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |    6 
 drivers/gpu/drm/i915/i915_gem_gtt.c                |    6 
 drivers/gpu/drm/i915/i915_gem_tiling.c             |   10 
 drivers/gpu/drm/i915/i915_ioc32.c                  |    6 
 drivers/gpu/drm/i915/i915_irq.c                    |    6 
 drivers/gpu/drm/i915/i915_mem.c                    |    6 
 drivers/gpu/drm/i915/i915_suspend.c                |    6 
 drivers/gpu/drm/i915/intel_acpi.c                  |    2 
 drivers/gpu/drm/i915/intel_bios.c                  |    6 
 drivers/gpu/drm/i915/intel_bios.h                  |    2 
 drivers/gpu/drm/i915/intel_crt.c                   |   12 
 drivers/gpu/drm/i915/intel_display.c               |    8 
 drivers/gpu/drm/i915/intel_dp.c                    |   12 
 drivers/gpu/drm/i915/intel_drv.h                   |    6 
 drivers/gpu/drm/i915/intel_dvo.c                   |    8 
 drivers/gpu/drm/i915/intel_fb.c                    |   10 
 drivers/gpu/drm/i915/intel_hdmi.c                  |   10 
 drivers/gpu/drm/i915/intel_i2c.c                   |    6 
 drivers/gpu/drm/i915/intel_lvds.c                  |   10 
 drivers/gpu/drm/i915/intel_modes.c                 |    2 
 drivers/gpu/drm/i915/intel_opregion.c              |    4 
 drivers/gpu/drm/i915/intel_overlay.c               |    6 
 drivers/gpu/drm/i915/intel_ringbuffer.c            |    6 
 drivers/gpu/drm/i915/intel_sdvo.c                  |   10 
 drivers/gpu/drm/i915/intel_tv.c                    |   10 
 drivers/gpu/drm/mga/mga_dma.c                      |    8 
 drivers/gpu/drm/mga/mga_drv.c                      |    8 
 drivers/gpu/drm/mga/mga_ioc32.c                    |    6 
 drivers/gpu/drm/mga/mga_irq.c                      |    6 
 drivers/gpu/drm/mga/mga_state.c                    |    6 
 drivers/gpu/drm/mga/mga_warp.c                     |    6 
 drivers/gpu/drm/nouveau/nouveau_acpi.c             |   10 
 drivers/gpu/drm/nouveau/nouveau_backlight.c        |    4 
 drivers/gpu/drm/nouveau/nouveau_bios.c             |    2 
 drivers/gpu/drm/nouveau/nouveau_bo.c               |    4 
 drivers/gpu/drm/nouveau/nouveau_calc.c             |    2 
 drivers/gpu/drm/nouveau/nouveau_channel.c          |    6 
 drivers/gpu/drm/nouveau/nouveau_connector.c        |    6 
 drivers/gpu/drm/nouveau/nouveau_connector.h        |    2 
 drivers/gpu/drm/nouveau/nouveau_debugfs.c          |    2 
 drivers/gpu/drm/nouveau/nouveau_display.c          |    4 
 drivers/gpu/drm/nouveau/nouveau_dma.c              |    4 
 drivers/gpu/drm/nouveau/nouveau_dp.c               |    2 
 drivers/gpu/drm/nouveau/nouveau_drv.c              |    8 
 drivers/gpu/drm/nouveau/nouveau_drv.h              |   12 
 drivers/gpu/drm/nouveau/nouveau_encoder.h          |    2 
 drivers/gpu/drm/nouveau/nouveau_fbcon.c            |   12 
 drivers/gpu/drm/nouveau/nouveau_fbcon.h            |    2 
 drivers/gpu/drm/nouveau/nouveau_fence.c            |    4 
 drivers/gpu/drm/nouveau/nouveau_gem.c              |    6 
 drivers/gpu/drm/nouveau/nouveau_hw.c               |    2 
 drivers/gpu/drm/nouveau/nouveau_hw.h               |    2 
 drivers/gpu/drm/nouveau/nouveau_i2c.c              |    2 
 drivers/gpu/drm/nouveau/nouveau_i2c.h              |    2 
 drivers/gpu/drm/nouveau/nouveau_ioc32.c            |    4 
 drivers/gpu/drm/nouveau/nouveau_irq.c              |    6 
 drivers/gpu/drm/nouveau/nouveau_mem.c              |    6 
 drivers/gpu/drm/nouveau/nouveau_mm.c               |    2 
 drivers/gpu/drm/nouveau/nouveau_notifier.c         |    4 
 drivers/gpu/drm/nouveau/nouveau_object.c           |    6 
 drivers/gpu/drm/nouveau/nouveau_perf.c             |    2 
 drivers/gpu/drm/nouveau/nouveau_pm.c               |    2 
 drivers/gpu/drm/nouveau/nouveau_ramht.c            |    2 
 drivers/gpu/drm/nouveau/nouveau_sgdma.c            |    2 
 drivers/gpu/drm/nouveau/nouveau_state.c            |   10 
 drivers/gpu/drm/nouveau/nouveau_temp.c             |    2 
 drivers/gpu/drm/nouveau/nouveau_ttm.c              |    2 
 drivers/gpu/drm/nouveau/nouveau_vm.c               |    2 
 drivers/gpu/drm/nouveau/nouveau_vm.h               |    2 
 drivers/gpu/drm/nouveau/nouveau_volt.c             |    2 
 drivers/gpu/drm/nouveau/nv04_crtc.c                |    4 
 drivers/gpu/drm/nouveau/nv04_cursor.c              |    4 
 drivers/gpu/drm/nouveau/nv04_dac.c                 |    4 
 drivers/gpu/drm/nouveau/nv04_dfp.c                 |    6 
 drivers/gpu/drm/nouveau/nv04_display.c             |    6 
 drivers/gpu/drm/nouveau/nv04_fb.c                  |    6 
 drivers/gpu/drm/nouveau/nv04_fbcon.c               |    2 
 drivers/gpu/drm/nouveau/nv04_fifo.c                |    4 
 drivers/gpu/drm/nouveau/nv04_graph.c               |    6 
 drivers/gpu/drm/nouveau/nv04_instmem.c             |    4 
 drivers/gpu/drm/nouveau/nv04_mc.c                  |    6 
 drivers/gpu/drm/nouveau/nv04_pm.c                  |    2 
 drivers/gpu/drm/nouveau/nv04_timer.c               |    6 
 drivers/gpu/drm/nouveau/nv04_tv.c                  |    6 
 drivers/gpu/drm/nouveau/nv10_fb.c                  |    6 
 drivers/gpu/drm/nouveau/nv10_fifo.c                |    4 
 drivers/gpu/drm/nouveau/nv10_gpio.c                |    2 
 drivers/gpu/drm/nouveau/nv10_graph.c               |    6 
 drivers/gpu/drm/nouveau/nv17_tv.c                  |    4 
 drivers/gpu/drm/nouveau/nv17_tv_modes.c            |    4 
 drivers/gpu/drm/nouveau/nv20_graph.c               |    6 
 drivers/gpu/drm/nouveau/nv30_fb.c                  |    6 
 drivers/gpu/drm/nouveau/nv40_fb.c                  |    6 
 drivers/gpu/drm/nouveau/nv40_fifo.c                |    4 
 drivers/gpu/drm/nouveau/nv40_graph.c               |    4 
 drivers/gpu/drm/nouveau/nv40_grctx.c               |    2 
 drivers/gpu/drm/nouveau/nv40_mc.c                  |    6 
 drivers/gpu/drm/nouveau/nv40_mpeg.c                |    2 
 drivers/gpu/drm/nouveau/nv50_calc.c                |    2 
 drivers/gpu/drm/nouveau/nv50_crtc.c                |    6 
 drivers/gpu/drm/nouveau/nv50_cursor.c              |    4 
 drivers/gpu/drm/nouveau/nv50_dac.c                 |    4 
 drivers/gpu/drm/nouveau/nv50_display.c             |    2 
 drivers/gpu/drm/nouveau/nv50_display.h             |    4 
 drivers/gpu/drm/nouveau/nv50_evo.c                 |    2 
 drivers/gpu/drm/nouveau/nv50_fb.c                  |    6 
 drivers/gpu/drm/nouveau/nv50_fbcon.c               |    2 
 drivers/gpu/drm/nouveau/nv50_fifo.c                |    4 
 drivers/gpu/drm/nouveau/nv50_gpio.c                |    2 
 drivers/gpu/drm/nouveau/nv50_graph.c               |    4 
 drivers/gpu/drm/nouveau/nv50_grctx.c               |    2 
 drivers/gpu/drm/nouveau/nv50_instmem.c             |    4 
 drivers/gpu/drm/nouveau/nv50_mc.c                  |    4 
 drivers/gpu/drm/nouveau/nv50_mpeg.c                |    2 
 drivers/gpu/drm/nouveau/nv50_pm.c                  |    2 
 drivers/gpu/drm/nouveau/nv50_sor.c                 |    4 
 drivers/gpu/drm/nouveau/nv50_vm.c                  |    2 
 drivers/gpu/drm/nouveau/nv50_vram.c                |    2 
 drivers/gpu/drm/nouveau/nv84_crypt.c               |    2 
 drivers/gpu/drm/nouveau/nva3_copy.c                |    2 
 drivers/gpu/drm/nouveau/nva3_pm.c                  |    2 
 drivers/gpu/drm/nouveau/nvc0_copy.c                |    2 
 drivers/gpu/drm/nouveau/nvc0_fb.c                  |    6 
 drivers/gpu/drm/nouveau/nvc0_fbcon.c               |    2 
 drivers/gpu/drm/nouveau/nvc0_fifo.c                |    2 
 drivers/gpu/drm/nouveau/nvc0_graph.c               |    2 
 drivers/gpu/drm/nouveau/nvc0_grctx.c               |    2 
 drivers/gpu/drm/nouveau/nvc0_instmem.c             |    2 
 drivers/gpu/drm/nouveau/nvc0_vm.c                  |    2 
 drivers/gpu/drm/nouveau/nvc0_vram.c                |    2 
 drivers/gpu/drm/r128/r128_cce.c                    |    6 
 drivers/gpu/drm/r128/r128_drv.c                    |    8 
 drivers/gpu/drm/r128/r128_ioc32.c                  |    6 
 drivers/gpu/drm/r128/r128_irq.c                    |    6 
 drivers/gpu/drm/r128/r128_state.c                  |    6 
 drivers/gpu/drm/radeon/atom.h                      |    2 
 drivers/gpu/drm/radeon/atombios_dp.c               |    6 
 drivers/gpu/drm/radeon/evergreen.c                 |    4 
 drivers/gpu/drm/radeon/evergreen_blit_kms.c        |    6 
 drivers/gpu/drm/radeon/evergreen_cs.c              |    2 
 drivers/gpu/drm/radeon/ni.c                        |    4 
 drivers/gpu/drm/radeon/r100.c                      |    6 
 drivers/gpu/drm/radeon/r200.c                      |    6 
 drivers/gpu/drm/radeon/r300.c                      |    2 
 drivers/gpu/drm/radeon/r300_cmdbuf.c               |    8 
 drivers/gpu/drm/radeon/r420.c                      |    2 
 drivers/gpu/drm/radeon/r520.c                      |    2 
 drivers/gpu/drm/radeon/r600.c                      |    4 
 drivers/gpu/drm/radeon/r600_audio.c                |    2 
 drivers/gpu/drm/radeon/r600_blit.c                 |    6 
 drivers/gpu/drm/radeon/r600_blit_kms.c             |    6 
 drivers/gpu/drm/radeon/r600_cp.c                   |    6 
 drivers/gpu/drm/radeon/r600_cs.c                   |    2 
 drivers/gpu/drm/radeon/r600_hdmi.c                 |    4 
 drivers/gpu/drm/radeon/radeon_acpi.c               |    8 
 drivers/gpu/drm/radeon/radeon_agp.c                |    6 
 drivers/gpu/drm/radeon/radeon_atombios.c           |    4 
 drivers/gpu/drm/radeon/radeon_bios.c               |    2 
 drivers/gpu/drm/radeon/radeon_clocks.c             |    4 
 drivers/gpu/drm/radeon/radeon_combios.c            |    4 
 drivers/gpu/drm/radeon/radeon_connectors.c         |   10 
 drivers/gpu/drm/radeon/radeon_cp.c                 |    8 
 drivers/gpu/drm/radeon/radeon_cs.c                 |    4 
 drivers/gpu/drm/radeon/radeon_cursor.c             |    4 
 drivers/gpu/drm/radeon/radeon_display.c            |    8 
 drivers/gpu/drm/radeon/radeon_drv.c                |    8 
 drivers/gpu/drm/radeon/radeon_encoders.c           |    6 
 drivers/gpu/drm/radeon/radeon_fb.c                 |   12 
 drivers/gpu/drm/radeon/radeon_fence.c              |    4 
 drivers/gpu/drm/radeon/radeon_gart.c               |    4 
 drivers/gpu/drm/radeon/radeon_gem.c                |    6 
 drivers/gpu/drm/radeon/radeon_i2c.c                |    4 
 drivers/gpu/drm/radeon/radeon_ioc32.c              |    6 
 drivers/gpu/drm/radeon/radeon_irq.c                |    6 
 drivers/gpu/drm/radeon/radeon_irq_kms.c            |    6 
 drivers/gpu/drm/radeon/radeon_kms.c                |    6 
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c    |    6 
 drivers/gpu/drm/radeon/radeon_legacy_tv.c          |    4 
 drivers/gpu/drm/radeon/radeon_mem.c                |    6 
 drivers/gpu/drm/radeon/radeon_object.c             |    2 
 drivers/gpu/drm/radeon/radeon_pm.c                 |    2 
 drivers/gpu/drm/radeon/radeon_ring.c               |    4 
 drivers/gpu/drm/radeon/radeon_state.c              |   10 
 drivers/gpu/drm/radeon/radeon_trace_points.c       |    2 
 drivers/gpu/drm/radeon/rs600.c                     |    2 
 drivers/gpu/drm/radeon/rs690.c                     |    2 
 drivers/gpu/drm/radeon/rv515.c                     |    2 
 drivers/gpu/drm/radeon/rv770.c                     |    4 
 drivers/gpu/drm/savage/savage_bci.c                |    4 
 drivers/gpu/drm/savage/savage_drv.c                |    6 
 drivers/gpu/drm/savage/savage_state.c              |    4 
 drivers/gpu/drm/sis/sis_drv.c                      |    6 
 drivers/gpu/drm/sis/sis_drv.h                      |    2 
 drivers/gpu/drm/sis/sis_mm.c                       |    4 
 drivers/gpu/drm/tdfx/tdfx_drv.c                    |    4 
 drivers/gpu/drm/ttm/ttm_agp_backend.c              |    6 
 drivers/gpu/drm/ttm/ttm_bo.c                       |    6 
 drivers/gpu/drm/ttm/ttm_bo_manager.c               |    8 
 drivers/gpu/drm/ttm/ttm_bo_util.c                  |    4 
 drivers/gpu/drm/ttm/ttm_execbuf_util.c             |    6 
 drivers/gpu/drm/ttm/ttm_lock.c                     |    4 
 drivers/gpu/drm/ttm/ttm_memory.c                   |    6 
 drivers/gpu/drm/ttm/ttm_module.c                   |    4 
 drivers/gpu/drm/ttm/ttm_object.c                   |    4 
 drivers/gpu/drm/ttm/ttm_page_alloc.c               |    4 
 drivers/gpu/drm/ttm/ttm_tt.c                       |   12 
 drivers/gpu/drm/via/via_dma.c                      |    6 
 drivers/gpu/drm/via/via_dmablit.c                  |    4 
 drivers/gpu/drm/via/via_drv.c                      |    6 
 drivers/gpu/drm/via/via_drv.h                      |    2 
 drivers/gpu/drm/via/via_irq.c                      |    6 
 drivers/gpu/drm/via/via_map.c                      |    4 
 drivers/gpu/drm/via/via_mm.c                       |    6 
 drivers/gpu/drm/via/via_verifier.c                 |    6 
 drivers/gpu/drm/via/via_video.c                    |    4 
 drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c             |    4 
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |   10 
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                |   18 
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |    4 
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c                 |    4 
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c               |    4 
 drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c                |    4 
 drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c      |    6 
 drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c              |    2 
 drivers/gpu/drm/vmwgfx/vmwgfx_irq.c                |    2 
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.h                |    2 
 drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c            |    4 
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c           |    8 
 drivers/gpu/drm/vmwgfx/vmwgfx_ttm_glue.c           |    2 
 include/acpi/acpi.h                                |   18 
 include/acpi/acpiosxf.h                            |    4 
 include/acpi/acpixf.h                              |    4 
 include/acpi/platform/acenv.h                      |    2 
 include/acpi/platform/aclinux.h                    |    2 
 include/asm-generic/Kbuild.asm                     |   85 +-
 include/asm-generic/param.h                        |   13 
 include/drm/drm.h                                  |    2 
 include/drm/drmP.h                                 |   18 
 include/drm/drm_buffer.h                           |    2 
 include/drm/drm_encoder_slave.h                    |    4 
 include/drm/drm_memory.h                           |    2 
 include/drm/drm_sarea.h                            |    2 
 include/drm/drm_sman.h                             |    4 
 include/drm/i915_drm.h                             |    2 
 include/drm/mga_drm.h                              |    2 
 include/drm/radeon_drm.h                           |    2 
 include/drm/ttm/ttm_bo_api.h                       |    2 
 include/drm/ttm/ttm_bo_driver.h                    |   16 
 include/drm/ttm/ttm_execbuf_util.h                 |    2 
 include/drm/ttm/ttm_lock.h                         |    2 
 include/drm/ttm/ttm_object.h                       |    2 
 include/drm/ttm/ttm_page_alloc.h                   |    4 
 include/drm/via_drm.h                              |    2 
 include/linux/Kbuild                               |    1 
 include/linux/acct.h                               |    5 
 include/linux/auto_fs.h                            |    2 
 include/linux/bcma/bcma.h                          |    2 
 include/linux/ceph/ceph_fs.h                       |    4 
 include/linux/ceph/debugfs.h                       |    4 
 include/linux/ceph/decode.h                        |    2 
 include/linux/ceph/libceph.h                       |   14 
 include/linux/ceph/mdsmap.h                        |    2 
 include/linux/ceph/messenger.h                     |    4 
 include/linux/ceph/mon_client.h                    |    2 
 include/linux/ceph/msgpool.h                       |    2 
 include/linux/ceph/osd_client.h                    |    6 
 include/linux/ceph/osdmap.h                        |    4 
 include/linux/ceph/rados.h                         |    2 
 include/linux/ceph/types.h                         |    6 
 include/linux/coda.h                               |    3 
 include/linux/crush/mapper.h                       |    2 
 include/linux/drbd_tag_magic.h                     |   10 
 include/linux/elf.h                                |   18 
 include/linux/input.h                              |    2 
 include/linux/isdn_divertif.h                      |    4 
 include/linux/mroute6.h                            |    4 
 include/linux/ncp.h                                |    2 
 include/linux/netfilter.h                          |    2 
 include/linux/netfilter/nf_conntrack_h323_asn1.h   |    2 
 include/linux/netfilter/xt_policy.h                |    2 
 include/linux/patchkey.h                           |    4 
 include/linux/sound.h                              |    4 
 include/linux/soundcard.h                          |    4 
 include/scsi/osd_attributes.h                      |    2 
 include/scsi/osd_initiator.h                       |    4 
 include/scsi/osd_sec.h                             |    4 
 include/sound/ac97_codec.h                         |    6 
 include/sound/ad1816a.h                            |    6 
 include/sound/ak4531_codec.h                       |    4 
 include/sound/asound.h                             |    1 
 include/sound/cs46xx.h                             |   10 
 include/sound/cs46xx_dsp_spos.h                    |    4 
 include/sound/cs46xx_dsp_task_types.h              |    2 
 include/sound/emu10k1_synth.h                      |    4 
 include/sound/emu8000.h                            |    4 
 include/sound/emux_legacy.h                        |    2 
 include/sound/emux_synth.h                         |   14 
 include/sound/es1688.h                             |    4 
 include/sound/gus.h                                |   10 
 include/sound/mpu401.h                             |    2 
 include/sound/pcm.h                                |    2 
 include/sound/rawmidi.h                            |    2 
 include/sound/sb.h                                 |    4 
 include/sound/sb16_csp.h                           |    4 
 include/sound/seq_kernel.h                         |    2 
 include/sound/seq_midi_emul.h                      |    2 
 include/sound/seq_midi_event.h                     |    2 
 include/sound/seq_oss.h                            |    4 
 include/sound/seq_virmidi.h                        |    4 
 include/sound/snd_wavefront.h                      |    8 
 include/sound/soundfont.h                          |    4 
 include/sound/tea6330t.h                           |    2 
 include/sound/trident.h                            |    8 
 include/sound/wss.h                                |    8 
 include/sound/ymfpci.h                             |    8 
 include/trace/events/compaction.h                  |    2 
 include/trace/events/kmem.h                        |    2 
 include/trace/events/vmscan.h                      |    2 
 include/uapi/Kbuild                                |   14 
 include/uapi/asm-generic/Kbuild                    |    1 
 include/uapi/asm-generic/Kbuild.asm                |   44 +
 include/uapi/drm/Kbuild                            |    1 
 include/uapi/linux/Kbuild                          |   18 
 include/uapi/linux/byteorder/Kbuild                |    1 
 include/uapi/linux/caif/Kbuild                     |    1 
 include/uapi/linux/can/Kbuild                      |    1 
 include/uapi/linux/dvb/Kbuild                      |    1 
 include/uapi/linux/hdlc/Kbuild                     |    1 
 include/uapi/linux/isdn/Kbuild                     |    1 
 include/uapi/linux/mmc/Kbuild                      |    1 
 include/uapi/linux/netfilter/Kbuild                |    2 
 include/uapi/linux/netfilter/ipset/Kbuild          |    1 
 include/uapi/linux/netfilter_arp/Kbuild            |    1 
 include/uapi/linux/netfilter_bridge/Kbuild         |    1 
 include/uapi/linux/netfilter_ipv4/Kbuild           |    1 
 include/uapi/linux/netfilter_ipv6/Kbuild           |    1 
 include/uapi/linux/nfsd/Kbuild                     |    1 
 include/uapi/linux/raid/Kbuild                     |    1 
 include/uapi/linux/spi/Kbuild                      |    1 
 include/uapi/linux/sunrpc/Kbuild                   |    1 
 include/uapi/linux/tc_act/Kbuild                   |    1 
 include/uapi/linux/tc_ematch/Kbuild                |    1 
 include/uapi/linux/usb/Kbuild                      |    1 
 include/uapi/linux/wimax/Kbuild                    |    1 
 include/uapi/mtd/Kbuild                            |    1 
 include/uapi/rdma/Kbuild                           |    1 
 include/uapi/scsi/Kbuild                           |    2 
 include/uapi/scsi/fc/Kbuild                        |    1 
 include/uapi/sound/Kbuild                          |    1 
 include/uapi/video/Kbuild                          |    1 
 include/uapi/xen/Kbuild                            |    1 
 include/video/edid.h                               |    6 
 include/xen/interface/callback.h                   |    2 
 include/xen/interface/hvm/params.h                 |    2 
 include/xen/interface/io/blkif.h                   |    4 
 include/xen/interface/io/netif.h                   |    4 
 include/xen/interface/sched.h                      |    2 
 include/xen/interface/version.h                    |    2 
 scripts/uapi-disintegration/disintegrate-1-stg.sh  |   53 +
 .../uapi-disintegration/disintegrate-many-stg.sh   |   63 +
 scripts/uapi-disintegration/disintegrate-one.pl    | 1036 ++++++++++++++++++++
 .../disintegrate-to-git-by-dir.pl                  |   69 +
 scripts/uapi-disintegration/disintegrate-to-git.pl |   70 +
 .../disintegrate-to-stg-by-dir.pl                  |   85 ++
 scripts/uapi-disintegration/drm-headers.pl         |  103 ++
 scripts/uapi-disintegration/genlist.pl             |   79 ++
 scripts/uapi-disintegration/set-up-Kbuild.pl       |  107 ++
 scripts/uapi-disintegration/sound-headers.pl       |   75 +
 scripts/uapi-disintegration/system-headers.pl      |  165 +++
 sound/sound_core.c                                 |    1 
 548 files changed, 3252 insertions(+), 1077 deletions(-)
 create mode 100644 arch/alpha/include/uapi/asm/Kbuild
 create mode 100644 arch/arm/include/uapi/asm/Kbuild
 create mode 100644 arch/avr32/include/uapi/asm/Kbuild
 create mode 100644 arch/blackfin/include/uapi/asm/Kbuild
 create mode 100644 arch/cris/include/uapi/arch-v10/arch/Kbuild
 create mode 100644 arch/cris/include/uapi/arch-v32/arch/Kbuild
 create mode 100644 arch/cris/include/uapi/asm/Kbuild
 create mode 100644 arch/frv/include/uapi/asm/Kbuild
 create mode 100644 arch/h8300/include/uapi/asm/Kbuild
 create mode 100644 arch/ia64/include/uapi/asm/Kbuild
 create mode 100644 arch/m32r/include/uapi/asm/Kbuild
 create mode 100644 arch/m68k/include/uapi/asm/Kbuild
 create mode 100644 arch/microblaze/include/uapi/asm/Kbuild
 create mode 100644 arch/mips/include/uapi/asm/Kbuild
 create mode 100644 arch/mn10300/include/uapi/asm/Kbuild
 create mode 100644 arch/openrisc/include/uapi/asm/Kbuild
 create mode 100644 arch/parisc/include/uapi/asm/Kbuild
 create mode 100644 arch/powerpc/include/uapi/asm/Kbuild
 create mode 100644 arch/s390/include/uapi/asm/Kbuild
 create mode 100644 arch/score/include/uapi/asm/Kbuild
 create mode 100644 arch/sh/include/uapi/asm/Kbuild
 create mode 100644 arch/sparc/include/uapi/asm/Kbuild
 create mode 100644 arch/tile/include/uapi/asm/Kbuild
 create mode 100644 arch/unicore32/include/uapi/asm/Kbuild
 create mode 100644 arch/x86/include/uapi/asm/Kbuild
 create mode 100644 arch/xtensa/include/uapi/asm/Kbuild
 create mode 100644 include/uapi/Kbuild
 create mode 100644 include/uapi/asm-generic/Kbuild
 create mode 100644 include/uapi/asm-generic/Kbuild.asm
 create mode 100644 include/uapi/drm/Kbuild
 create mode 100644 include/uapi/linux/Kbuild
 create mode 100644 include/uapi/linux/byteorder/Kbuild
 create mode 100644 include/uapi/linux/caif/Kbuild
 create mode 100644 include/uapi/linux/can/Kbuild
 create mode 100644 include/uapi/linux/dvb/Kbuild
 create mode 100644 include/uapi/linux/hdlc/Kbuild
 create mode 100644 include/uapi/linux/isdn/Kbuild
 create mode 100644 include/uapi/linux/mmc/Kbuild
 create mode 100644 include/uapi/linux/netfilter/Kbuild
 create mode 100644 include/uapi/linux/netfilter/ipset/Kbuild
 create mode 100644 include/uapi/linux/netfilter_arp/Kbuild
 create mode 100644 include/uapi/linux/netfilter_bridge/Kbuild
 create mode 100644 include/uapi/linux/netfilter_ipv4/Kbuild
 create mode 100644 include/uapi/linux/netfilter_ipv6/Kbuild
 create mode 100644 include/uapi/linux/nfsd/Kbuild
 create mode 100644 include/uapi/linux/raid/Kbuild
 create mode 100644 include/uapi/linux/spi/Kbuild
 create mode 100644 include/uapi/linux/sunrpc/Kbuild
 create mode 100644 include/uapi/linux/tc_act/Kbuild
 create mode 100644 include/uapi/linux/tc_ematch/Kbuild
 create mode 100644 include/uapi/linux/usb/Kbuild
 create mode 100644 include/uapi/linux/wimax/Kbuild
 create mode 100644 include/uapi/mtd/Kbuild
 create mode 100644 include/uapi/rdma/Kbuild
 create mode 100644 include/uapi/scsi/Kbuild
 create mode 100644 include/uapi/scsi/fc/Kbuild
 create mode 100644 include/uapi/sound/Kbuild
 create mode 100644 include/uapi/video/Kbuild
 create mode 100644 include/uapi/xen/Kbuild
 create mode 100755 scripts/uapi-disintegration/disintegrate-1-stg.sh
 create mode 100755 scripts/uapi-disintegration/disintegrate-many-stg.sh
 create mode 100755 scripts/uapi-disintegration/disintegrate-one.pl
 create mode 100755 scripts/uapi-disintegration/disintegrate-to-git-by-dir.pl
 create mode 100755 scripts/uapi-disintegration/disintegrate-to-git.pl
 create mode 100755 scripts/uapi-disintegration/disintegrate-to-stg-by-dir.pl
 create mode 100755 scripts/uapi-disintegration/drm-headers.pl
 create mode 100755 scripts/uapi-disintegration/genlist.pl
 create mode 100755 scripts/uapi-disintegration/set-up-Kbuild.pl
 create mode 100755 scripts/uapi-disintegration/sound-headers.pl
 create mode 100755 scripts/uapi-disintegration/system-headers.pl

