Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431Ab2EKC7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 22:59:41 -0400
Received: from mail1.windriver.com ([147.11.146.13]:40449 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab2EKC7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 22:59:39 -0400
Date: Thu, 10 May 2012 22:59:37 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-next@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: linux-next: triage for May 10, 2012
Message-ID: <20120511025937.GC24512@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This encompasses breakage appearing in the last two trees.

An NFS commit broke ARM, sh4 and or32.  (redef 'inode_dio_wait')

An ARM dma commit broke at least four ARM boards.

I tracked down the source of all the mips fails giving this msg:
    <command-line>:0:1: error: macro names must be identifiers
to a kbuild thing and a fix should be in shortly (May11?).

I briefly looked at the kvm kernheader export annoyance [sparc/parisc,etc]
and it seems also some kind of kbuild bug -- the headers from asm/generic
are not exported (you can see the same thing with the a.out header).

More details and/or other new dain bramage as listed below.

---------------------

New breakage since last report:
	ARM:badge4_defconfig,jornada720_defconfig,neponset_defconfig,cm_x2xx_defconfig 
		arch/arm/common/dmabounce.c: 'generic_dma_map_sg' undeclared

	or32:or1ksim_defconfig
	sh4:kfr2r09-romimage_defconfig
	ARM:xcep_defconfig,marzen_defconfig (bisected & reported, nfs tree)
		fs/inode.c:1777:6: error: redefinition of 'inode_dio_wait'

	ARM:at91x40_defconfig 
		arch/arm/mm/dma-mapping.c: 'pgprot_kernel' undeclared

	frv:defconfig
		kernel/fork.c: static decl 'alloc_task_struct_node' follows non-static

	i386:allmodconfig
		input/misc/twl6040-vibra.c: implicit decl 'of_property_read_u32
		(reported on linux-next ; needs a Kbuild arch dependency)

	i386:allnoconfig
		perf_event_amd.c:(.text+0xc0b0): undefined reference to `get_ibs_caps'

	powerpc:allmodconfig
		ERROR: ".of_mdio_find_bus" [phy/mdio-mux.ko] undefined!

	sh4:edosk7705_defconfig
		kernel/printk.c:1423: 'LOG_LINE_MAX' undeclared 

Randconfig fails that may or may not be new (by their very nature):
	i386: tps6586x.c: undefined reference to `of_regulator_match'

Builds that are fixed since last report:
	ARM:versatile_defconfig,realview_defconfig,realview-smp_defconfig,
 		u300_defconfig,vexpress_defconfig
		(implicit mmci_dt_populate_generic_pdata)

	ARM:sam9_l9260_defconfig (usb/gadget/at91_udc.c 'struct at91_ep' has
		 no member named 'desc')

	cris:etrax-100lx_defconfig 
		tty/serial/crisv10.c: blows up with two new errors.

	m68k:defconfig
		drivers/tty/amiserial.c: too few args to function 'tty_unlock'

----------------------

Note1: The randconfig fails are only listed once and not tracked
in the below listing.

Note2: Build fails that are perpetual and/or unlikely to ever
get fixed are not tracked here.

Note3: Issues that Stephen finds and reverts/avoids before kicking
off the all-arch/all-config builds are also not tracked here.

Note4: I'm also not tracking the kallsyms extra pass on ARM on
a per board basis anymore.  It has nothing to do with the board.
Why? See:  http://marc.info/?l=linux-next&m=133267456809502

----------------------

Latest results at:
	http://kisskb.ellerman.id.au/linux-next

Failures as of this report:
===========================

AM33:asb2303_defconfig,asb2364_defconfig
	when:	Mar 15
	why:	cc1: error: unrecognized command line option '-mmem-funcs'
	status:	Possible fix from TonyB sent for review.
	fix:	http://marc.info/?l=linux-kernel&m=133185020313818&w=2
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5878400/
----------------

ARM:xcep_defconfig,marzen_defconfig
	when:	May 11
	why:	fs/inode.c:1777:6: error: redefinition of 'inode_dio_wait'
	status:	bisected and reported (see linux-next mail)
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6291357/

ARM:at91x40_defconfig 
	when:	May10
	why:	arch/arm/mm/dma-mapping.c: 'pgprot_kernel' undeclared
	status:	bisected and reported (see linux-next mail)
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6291233/

ARM:badge4_defconfig,jornada720_defconfig,neponset_defconfig
	when:	May11
	why:	arch/arm/common/dmabounce.c: 'generic_dma_map_sg' undeclared
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6291438/

ARM:mv78xx0_defconfig
	when:	May 4
	why:	mach-mv78xx0/pcie.c:256:29: error: 'bus' undeclared
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6243629/

ARM:integrator_defconfig
	when:	May 3
	why:	pci_std_swizzle was deleted
	status:	fix sent to arm kernel ML.

ARM:nhk8815_defconfig
	when:	May 3
	why:	gpio-nomadik.c: 'struct gpio_chip' has no member named 'of_node'
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6229016/

ARM:bcmring_defconfig
	when:	Apr 20ish
	why:	usr/include/asm/kvm_para.h:1: included file 'asm-generic/kvm_para.h' is not exported
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6228994/

ARM:ezx_defconfig
	when:	Apr 19 (possibly earlier?)
	why:	ezx-pcap.c: implicit declaration of function 'irq_to_gpio'
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6131924/

ARM:netx_defconfig,pnx4008_defconfig 
	when:	Mar 14
	why:	net/core/pktgen.c: can't find a register in class 'GENERAL_REGS'
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5869486/
	ref:	https://lkml.org/lkml/2012/3/13/670

ARM:ixp4xx_defconfig
	when:	Oct 26
	why:	gpio.h: implicit declaration of function '__gpio_get_value'
	status:	fixed (Imre Kaloz) - but possibly needs rework?
	fix:	https://lkml.org/lkml/2012/2/8/288
	ref:	https://lkml.org/lkml/2012/2/8/287

ARM:raumfeld_defconfig
	when:	Nov 23
	why:	eeti_ts.c: implicit declaration of function 'irq_to_gpio'
	status:	perhaps broken since 2010?  See ref below.
	ref:	http://www.gossamer-threads.com/lists/linux/kernel/1291618?do=post_view_threaded#1291618

----------------

AVR32:allnoconfig
	when:	May 26 2010, 20:49
	why:	at32_map_usart: undefined reference to `atmel_default_console_device'
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6248032/
---------------

bfin: 50% of builds
	when:	Mar 31
	why:	"Error: pcrel too far BFD_RELOC_BFIN_10" from kernel/time/timekeeping.c
	status:	unknown, binutils issue?
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6087324/

bfin:SMP
	when	May 1
	why:	kernel/smp.c:724: undefined reference to `smp_call_function_many'
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6228892/
---------------

cris:etrax-100lx_defconfig
	when:	May 7
	why:	drivers/tty/serial/crisv10.c: macro "wait_event_interruptible_tty" requires 3 args,  only 2 given
	why:	drivers/tty/serial/crisv10.c: 'wait_event_interruptible_tty' undecl

cris:allyesconfig,allmodconfig
	when:	Apr 3
	why:	too many to list here
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6035250/
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6035249/
----------------

i386:allmodconfig
	when:	May11
	why:	input/misc/twl6040-vibra.c: implicit decl 'of_property_read_u32
	status:	reported on linux-next ; needs a Kbuild arch dependency

i386:allnoconfig
	when:	May11
	why:	perf_event_amd.c:(.text+0xc0b0): undefined reference to `get_ibs_caps'
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6291419/
----------------

h8300:defconfig
	when:	Mar 15
	why:	time.c: implicit declaration of function 'get_irq_regs'
	why:	also seems gcc suffers an ICE
	status:	ICE bug lodged with gcc folks (TonyB)
	ref:	http://gcc.gnu.org/bugzilla/show_bug.cgi?id=52598
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5884668/
----------------

m32r:m32700ut.smp_defconfig
	when:	Mar 15
	why:	No rule to make target `arch/m32r/boot/compressed/vmlinux.bin
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5884670/
----------------

mips:*
	when:	May 7
	why:	<command-line>:0:1: error: macro names must be identifiers
	ref:	http://www.linux-mips.org/archives/linux-mips/2012-05/msg00125.html

mips:allmodconfig
	when:	Apr 17
	why:	sound/oss/soundcard.c: 'MAX_DMA_CHANNELS' undeclared
	status: one of many fixes mips needs...
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6091660/
----------------

parisc:defconfig
	when:	Apr 20
	why:	file 'asm-generic/kvm_para.h' is not exported
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6137786/

parisc:allmodconfig
	when:	?
	why:	include/linux/log2.h: implicit declaration of function 'fls'
	status:	reported by PaulG, WIP by David Howells 
	ref:	http://www.spinics.net/lists/linux-parisc/msg04100.html
	ref:	https://lkml.org/lkml/2012/2/29/409
	ref:	https://lkml.org/lkml/2012/3/6/228

parisc64:a500_defconfig 
	when:	?
	why:	include/linux/log2.h: implicit declaration of function 'fls'
	status:	reported by PaulG, WIP by David Howells 
	ref:	https://lkml.org/lkml/2012/2/29/409
	ref:	https://lkml.org/lkml/2012/3/6/228
------------------

powerpc:allmodconfig
	when:	May 11
	why:	ERROR: ".of_mdio_find_bus" [phy/mdio-mux.ko] undefined!
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6291463/

------------------

sh4:edosk7705_defconfig
	when:	May 9
	why:	kernel/printk.c:1423: 'LOG_LINE_MAX' undeclared 
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6276831/
------------------

sparc[64]:allyesconfig,allmodconfig
	when:	Apr 18
	why:	usr/include/asm/kvm_para.h: included file 'asm-generic/kvm_para.h' is not exported
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6243021/

sparc:allnoconfig
	when:	Apr 20ish
	why:	arch/sparc/mm/init_64.c: unused variable 'paddr' 'node'
	why:	arch/sparc/mm/init_64.c: 'memblock_nid_range' defined but not used
------------------

tile:defconfig
	when:	May 5
	why:	usr/include/asm/kvm_para.h: included file 'asm-generic/kvm_para.h' is not exported
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6248599/
------------------

xtensa:defconfig
	when:	Apr 20
	why:	undefined reference to `_sdata'
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6228970/
