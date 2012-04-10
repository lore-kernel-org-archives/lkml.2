Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602Ab2DJWpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 18:45:53 -0400
Received: from mail.windriver.com ([147.11.1.11]:43215 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814Ab2DJWpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 18:45:51 -0400
Date: Tue, 10 Apr 2012 18:45:43 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-next@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: linux-next: triage for April 10, 2012
Message-ID: <20120410224543.GA11433@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't do a report on Friday for Thursday's tree, however
there were four new breakages at the end of last week.  I did
a triage on them and sent notifications to those maintainers.
(and cc'd linux-next).  DaveM checked in fixes for blackfin eth
and gianfar eth as soon as I reported them, leaving only the
regmap_debugfs_init bug and and the GPLV2 vs GPLv2 typo carried
forward into this week's report (listed below).

We've finally got an sh tree inserted into linux-next, so a
a whole bunch of sh4 builds are now green again.  Probably
makes sense to go through and triage the remaining failures
as "new".  I have not done that yet here today since there
are about 20 or so.

------------

New breakage since last report:
	i386:allmodconfig:
		(modpost: GPL-incompat rc5t583-regulator uses GPL-only symbol)
	ARM/MIPS:magician_defconfig,omap1_defconfig,ip27_defconfig
		(regmap.c: too few arg to 'regmap_debugfs_init')
	ARM:eseries_pxa_defconfig,em_x270_defconfig,imx_v4_v5_defconfig
		(sound/soc/codecs/wm9712.c: error: 'runtime' undeclared)
	s390/sparc:allmodconfig,allyesconfig
		(wiznet Kconfig fallout, fixed by DaveM already)
	ARM:cam60_defconfig (kallsyms, ignore it).

Randconfig fails that may or may not be new (by their very nature):
	i386: fs/binfmt_misc.c (copy_from_user() is not provably correct)
		http://kisskb.ellerman.id.au/kisskb/buildresult/6087086/
	powerpc: kernel/built-in.o: undefined ref `perf_ftrace_event_register'
		http://kisskb.ellerman.id.au/kisskb/buildresult/6087164/
		Fix: https://lkml.org/lkml/2012/3/14/304

Builds that are fixed since last report:
	ia64:defconfig
	sh4:about 1/2 of all builds.
	
Note: The randconfig fails are only listed once and not tracked
in the below listing.

I'm also not tracking the kallsyms extra pass stuff on ARM on
a per board basis anymore.  It has nothing to do with the board.
Why? See:  http://marc.info/?l=linux-next&m=133267456809502

            ------------------------------------------------

Latest results at:
	http://kisskb.ellerman.id.au/kisskb/branch/9/

Failures as of April 10th, 2012:
===============================

s390/sparc:allmodconfig,allyesconfig
	when:	Apr 10
	why:	w5100.c: implicit declaration of function 'ioread8'
	status:	Kconfig not guarded from incompat arch.
	fix:	https://lkml.org/lkml/2012/4/10/194
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6086850/
----------------

AM33:asb2303_defconfig,asb2364_defconfig
	when:	Mar 15
	why:	cc1: error: unrecognized command line option '-mmem-funcs'
	status:	Possible fix from TonyB sent for review.
	fix:	http://marc.info/?l=linux-kernel&m=133185020313818&w=2
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5878400/
----------------

ARM:eseries_pxa_defconfig,em_x270_defconfig,imx_v4_v5_defconfig
	when:	Apr 10
	why:	sound/soc/codecs/wm9712.c: error: 'runtime' undeclared
	status:
	fix:
	ref:	http://marc.info/?l=linux-next&m=133409405513987&w=2
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6086893/

ARM/MIPS:magician_defconfig,omap1_defconfig,ip27_defconfig
	when:	Apr 5
	why:	regmap.c: too few args to 'regmap_debugfs_init'
	status:	reported
	fix:	
	ref:	http://marc.info/?l=linux-next&m=133368924324160&w=2

ARM:tct_hammer_defconfig,s3c2410_defconfig
	when:	Apr 1
	why:	missing "common.h"
	status:	fix pending, borkage probably masked by other global borkage.
	fix:
	ref:	http://marc.info/?l=linux-next&m=133349249421262&w=2

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

ARM:arm-allnoconfig
	when:	forever
	why:	not supported
	status:	nothing pending, but patches accepted
	fix:	n/a
	ref:	https://lkml.org/lkml/2009/4/30/105
	ref:	http://lists.infradead.org/pipermail/linux-arm-kernel/2012-January/081218.html
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
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5981475/
---------------

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
	when:	Apr 5
	why:	FATAL: modpost: GPL-incompatible module rc5t583-regulator.ko uses GPL-only symbol 'platform_driver_unregister'
	status:	reported
	fix:
	ref:	http://marc.info/?l=linux-next&m=133369125624696&w=2
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
	why:	driver_pci_host.c: implicit declaration of function 'pcibios_enable_device'
	status: one of many fixes mips needs...
	fix:	http://marc.info/?l=linux-wireless&m=133272031621916&w=2
	ref:	http://patchwork.ozlabs.org/patch/148614/
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5807000/
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

powerpc:allyesconfig
	when:	May 18 2009, 22:11
	why:	fat ass kernel with everything simply won't link
	status:	need to fix build config to ignore the final link
	fix:	
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5806793/
------------------

um:um-defconfig
	when:	Sep 16 2010, 01:28
	why:	os-Linux/start_up.c: error: 'PTRACE_SETOPTIONS' undeclared
	status:	clearly broken forever, so does anyone care?
	fix:	
	ref:	http://kisskb.ellerman.id.au/kisskb/target/2979/
