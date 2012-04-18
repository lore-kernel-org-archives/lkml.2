Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab2DRDFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 23:05:31 -0400
Received: from mail1.windriver.com ([147.11.146.13]:51775 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab2DRDFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 23:05:30 -0400
Date: Tue, 17 Apr 2012 23:05:24 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-next@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: linux-next: triage for April 17, 2012
Message-ID: <20120418030524.GD21302@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was some RCU fallout due to a missing symbol export; that is
already fixed, and so not listed in anything below.  It used to fail
with:  ERROR: "rcu_read_lock_nesting" [somemodule.ko] undefined!
[ http://marc.info/?l=linux-kernel&m=133468298118423&w=2 ]

The s390 got stabbed by some tty ref counting patches, but these
appear to be reported and fixed as well (by me and others).  So
they aren't listed below either.
[ http://marc.info/?l=linux-next&m=133466627810965&w=2 ]

We've got fails in a couple ARM platforms, since those platforms
were deleted.  Perhaps we can slot in new ARM boards like the vexpress
into those slots? [ixp2000_defconfig, ixp23xx_defconfig now dead]

The i386 allmodconfig lost the fails from rc5t583 and mellanox
via my patches, but picked up a new issue in seccomp/bpf-direct.c
[ http://marc.info/?l=linux-kernel&m=133471624530782&w=2 ]

For ARCH=cris, we are seeing a kooky error triggered by the G+
crowdsourcing macro foo.  I need to look into how that happens,
since I was the sap who got delegated to doing the implementation.
Looks specific to files fed to gas vs. gcc at 1st glance.  Whee.

The pagemap.h fixes are in, but that reveals that mips allmodconfig
still has various (longstanding?) issues hiding behind that.

I've deleted info about the ppc allyesconfig, ARM allnoconfig,
and UML fails, since they may be broken indefinitely.  See new
Note2 below.

----------------------

New breakage since last report:
	i386:allmodconfig
		(samples/seccomp/bpf-direct.c: #error Unsupported platform)
	cris:various_defconfigs
		(kconfig.h:23 syntax error in macro parameter list)

Randconfig fails that may or may not be new (by their very nature):
	powerpc: drivers/i2c/busses/i2c-designware-pci.o
		(In function `i2c_dw_clear_int': mult def of `i2c_dw_clear_int'
		 drivers/i2c/busses/i2c-designware-platform.o: first def here

Builds that are fixed since last report:
	ARM:u8500_defconfig
		(ste_dma40.c: implicit decl of function 'regulator_disable')
	AVR32:defconfig
		(pagemap.h: assignment of read-only variable '__pu_val')
	m68k:various
		(pagemap.h: read-only location '*end' used as 'asm' output)
	powerpc:mpc85xx_defconfig
		(spi-fsl-lib.c: dereferencing pointer to incomplete type)

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
	http://kisskb.ellerman.id.au/kisskb/branch/9/

Failures as of April 17th, 2012:
===============================

AM33:asb2303_defconfig,asb2364_defconfig
	when:	Mar 15
	why:	cc1: error: unrecognized command line option '-mmem-funcs'
	status:	Possible fix from TonyB sent for review.
	fix:	http://marc.info/?l=linux-kernel&m=133185020313818&w=2
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5878400/
----------------

ARM:netx_defconfig,pnx4008_defconfig 
	when:	Mar 14
	why:	net/core/pktgen.c: can't find a register in class 'GENERAL_REGS'
	status:	
	fix:	
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
	fix:	
	ref:	http://www.gossamer-threads.com/lists/linux/kernel/1291618?do=post_view_threaded#1291618

----------------

AVR32:allnoconfig
	when:	May 26 2010, 20:49
	why:	at32_map_usart: undefined reference to `atmel_default_console_device'
	status:
	fix:
	ref:
---------------

bfin: 50% of builds
	when:	Mar 31
	why:	"Error: pcrel too far BFD_RELOC_BFIN_10" from kernel/time/timekeeping.c
	status:	unknown, binutils issue?
	fix:
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6087324/
---------------

cris:various_defconfigs
	when:	Apr 16
	why:	AS      arch/cris/arch-v10/lib/checksumcopy.o
	why:	In file included from <command-line>:4:0:
	why:	include/linux/kconfig.h:23:0: error: syntax error in macro parameter list
	why:	[macro magic for config_enabled]
	status:	
	fix:	
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6123623/
	ref:	commit 69349c2dc01c489eccaa4c472542c08e370c6d7e

cris:allyesconfig,allmodconfig
	when:	Apr 3
	why:	too many to list here
	status:	
	fix:	
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6035250/
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6035249/
----------------

frv:defconfig
	when:	Mar 15
	why:	undefined reference to `pci_cardbus_resource_alignment'
	status:
	fix:
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6030067/
----------------

i386:allmodconfig
	when:	Apr 17
	why:	samples/seccomp/bpf-direct.c:47:2: error: #error Unsupported platform
	status:	reported
	fix:
	ref:	http://marc.info/?l=linux-kernel&m=133471624530782&w=2
----------------

h8300:defconfig
	when:	Mar 15
	why:	time.c: implicit declaration of function 'get_irq_regs'
	why:	also seems gcc suffers an ICE
	status:	ICE bug lodged with gcc folks (TonyB)
	fix:
	ref:	http://gcc.gnu.org/bugzilla/show_bug.cgi?id=52598
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5884668/
----------------

m32r:m32700ut.smp_defconfig
	when:	Mar 15
	why:	No rule to make target `arch/m32r/boot/compressed/vmlinux.bin
	status:
	fix:
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5884670/
----------------

m68k:allmodconfig
	when:	Mar 16
	why:	persistent_ram.c: implicit declaration of 'memblock_reserve'
	status:	
	fix:	
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5884324/
	ref:	http://www.spinics.net/lists/linux-next/msg19343.html
----------------

mips:allmodconfig
	when:
	why:	sound/oss/soundcard.c: 'MAX_DMA_CHANNELS' undeclared
	status: one of many fixes mips needs...
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6091660/
----------------

parisc:allmodconfig
	when:
	why:	include/linux/log2.h: implicit declaration of function 'fls'
	status:	reported by PaulG, WIP by David Howells 
	fix:
	ref:	https://lkml.org/lkml/2012/2/29/409
	ref:	https://lkml.org/lkml/2012/3/6/228

parisc64:a500_defconfig 
	when:
	why:	include/linux/log2.h: implicit declaration of function 'fls'
	status:	reported by PaulG, WIP by David Howells 
	fix:
	ref:	https://lkml.org/lkml/2012/2/29/409
	ref:	https://lkml.org/lkml/2012/3/6/228
------------------
