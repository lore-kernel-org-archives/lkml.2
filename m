Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808Ab2EGXEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 19:04:43 -0400
Received: from mail.windriver.com ([147.11.1.11]:35240 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757451Ab2EGXEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 19:04:41 -0400
Date: Mon, 7 May 2012 19:04:40 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-next@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: linux-next: triage for May 7, 2012
Message-ID: <20120507230439.GA19428@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lots of new fires burning today, let me try to summarize.

Looks like the "old" mmc fails got replaced by new ones on some
different boards.  I've reported the new fail on arm-kernel with
the cause of the fail.
  [ http://marc.info/?l=linux-arm-kernel&m=133642820330185&w=2 ]

Something evil vandalized all mips builds.  At a glance it looks
like a kbuild thing -- it fails with:
  LD      init/built-in.o
  KSYM    .tmp_kallsyms1.o
  <command-line>:0:1: error: macro names must be identifiers

The itanic blew up with some new kooky ld error I've not seen
before ("ia64-linux-ld: .tmp_kallsyms1.o: linking constant-gp
files with non-constant-gp files)

For arch=cris,m68k -- some new tty related fallout appeared.
Geert has a m68k patch posted 3pm EST today.

The parisc blew up on a basic gcc config option (WTF?)

I've triaged and fixed the ppc mpc85xx_defconfig fail; it is
in my linux-next feed temporarily. 

The kvm export annoyance [sparc/parisc,etc] continues to linger.

The kallsyms nonsense on ARM continues to muddy the waters on the
pass/fail triage as it shifts around from board to board.  :(

---------------------

New breakage since last report:
	arm:versatile_defconfig,realview_defconfig,realview-smp_defconfig,
	u300_defconfig,vexpress_defconfig
	   drivers/mmc/host/mmci.c: implicit decl mmci_dt_populate_generic_pdata
	   http://marc.info/?l=linux-arm-kernel&m=133642820330185&w=2
	mips:<everything>
	   <command-line>:0:1: error: macro names must be identifiers
	   http://kisskb.ellerman.id.au/kisskb/buildresult/6271954/
	m68k:defconfig
	   drivers/tty/amiserial.c: too few args to function 'tty_unlock'
	   http://kisskb.ellerman.id.au/kisskb/buildresult/6272350/
	parisc:allnoconfig
	   ld: unrecognized option '-print-libgcc-file-name`
	cris:etrax-100lx_defconfig 
	   tty/serial/crisv10.c: blows up with two new errors.

Randconfig fails that may or may not be new (by their very nature):
	i386: drivers/gpu/drm/radeon/radeon_state.o and
	      drivers/isdn/icn/icn.o
	  arch/x86/include/asm/uaccess_32.h:211:26: error: call to
	  'copy_from_user_overflow' declared with attribute error:
	  copy_from_user() buffer size is not provably correct
	  [ http://kisskb.ellerman.id.au/kisskb/buildresult/6271958/ ]

Builds that are fixed since last report:
	ARM:mackerel_defconfig,ag5evm_defconfig
	powerpc:ppc40x_defconfig  (ppc4xx_msi.c:right shift >= width of type)
	s390:allyesconfig,allmodconfig (via ARM emif kconfig dependency)

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

Failures as of May 7th, 2012:
===============================

AM33:asb2303_defconfig,asb2364_defconfig
	when:	Mar 15
	why:	cc1: error: unrecognized command line option '-mmem-funcs'
	status:	Possible fix from TonyB sent for review.
	fix:	http://marc.info/?l=linux-kernel&m=133185020313818&w=2
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5878400/
----------------

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
	when:	Apr 17
	why:	samples/seccomp/bpf-direct.c:47:2: error: #error Unsupported platform
	status:	reported
	ref:	http://marc.info/?l=linux-kernel&m=133471624530782&w=2
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

powerpc:mpc85xx_defconfig
	when:	May 3
	why:	powerpc/mm/hugetlbpage.c: passing argument 7 of 'parse_args' from incompatible pointer type
	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/6243069/

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
