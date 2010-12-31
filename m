Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab0LaTLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 14:11:45 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43520 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab0LaTLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 14:11:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=HpUhimR4SE/fzM+nB/KWXLZkN/iwq8CXT0PeOzdGJxsjsBhyVSjRbXIqDFR5VfnV4Q
         hAHrmCR5Xo/SaEESKDFIImz8SPeSqyjlYuAYmBJgWAGDfXyxD+9Ej6L7CTEpddo+ry2R
         tzRhiA41bWBFwC43s7UySeeqlI46gb9FF0pJs=
Date: Fri, 31 Dec 2010 20:11:26 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, netdev@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        John Stultz <johnstul@us.ibm.com>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH V8 00/13] ptp: IEEE 1588 hardware clock support
Message-ID: <cover.1293820862.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Introduction

  The aim of this patch set is to add support for PTP Hardware Clocks
  (PHCs) into the Linux kernel.

* PTP Patch ChangeLog
** v8
   - incorporates Arnd Bergmann's and Thomas Gleixner's comments from v7
   - use John Stultz's timekeeping_inject_offset in do_adjtimex()
   - adds new syscall clock_adjtime to each arch individually
   - cleaned up the CLOCK_DISPATCH mess
   - redsigned posix_clock_operations:
     . remove compat_ioctl
     . flatten clock ops and chardev ops into one structure
     . drivers use container_of to get private data
   - removed unused and useless code from posix-clock.c|h
   - moved posix-clock syscall prototypes into private header
   - moved extern declaration from c source file into header
   - ptp drivers use container_of to get private data

* Previous Discussions

  This patch set previously appeared on the netdev list. Since V5 of
  the character device patch set, the discussion has moved to the
  lkml.

  - IEEE 1588 hardware clock support [V5]
    http://lkml.org/lkml/2010/8/16/90

  - POSIX clock tuning syscall with static clock ids
    http://lkml.org/lkml/2010/8/23/49

  - POSIX clock tuning syscall with dynamic clock ids
    http://lkml.org/lkml/2010/9/3/119

  - IEEE 1588 hardware clock support [V6]
    http://lkml.org/lkml/2010/9/23/310

  - Dynamic clock devices [RFC]
    http://lkml.org/lkml/2010/11/4/290

  - IEEE 1588 hardware clock support [V7]
    http://lkml.org/lkml/2010/12/16/195


John Stultz (1):
  time: Introduce timekeeping_inject_offset

Richard Cochran (12):
  ntp: add ADJ_SETOFFSET mode bit
  posix clocks: introduce a syscall for clock tuning.
  posix_clocks: add clock_adjtime for arm
  posix_clocks: add clock_adjtime for blackfin
  posix_clocks: add clock_adjtime for powerpc
  posix_clocks: add clock_adjtime for x86
  posix clocks: cleanup the CLOCK_DISPTACH macro
  posix clocks: introduce dynamic clocks
  ptp: Added a brand new class driver for ptp clocks.
  ptp: Added a clock that uses the eTSEC found on the MPC85xx.
  ptp: Added a clock driver for the IXP46x.
  ptp: Added a clock driver for the National Semiconductor PHYTER.

 Documentation/ABI/testing/sysfs-ptp             |   97 +++
 Documentation/powerpc/dts-bindings/fsl/tsec.txt |   57 ++
 Documentation/ptp/ptp.txt                       |   93 +++
 Documentation/ptp/testptp.c                     |  352 +++++++++
 Documentation/ptp/testptp.mk                    |   33 +
 arch/arm/include/asm/unistd.h                   |    1 +
 arch/arm/kernel/calls.S                         |    1 +
 arch/arm/mach-ixp4xx/include/mach/ixp46x_ts.h   |   78 ++
 arch/blackfin/include/asm/unistd.h              |    3 +-
 arch/blackfin/mach-common/entry.S               |    1 +
 arch/powerpc/boot/dts/mpc8313erdb.dts           |   14 +
 arch/powerpc/boot/dts/mpc8572ds.dts             |   14 +
 arch/powerpc/boot/dts/p2020ds.dts               |   14 +
 arch/powerpc/boot/dts/p2020rdb.dts              |   14 +
 arch/powerpc/include/asm/systbl.h               |    1 +
 arch/powerpc/include/asm/unistd.h               |    3 +-
 arch/x86/ia32/ia32entry.S                       |    1 +
 arch/x86/include/asm/unistd_32.h                |    3 +-
 arch/x86/include/asm/unistd_64.h                |    2 +
 arch/x86/kernel/syscall_table_32.S              |    1 +
 drivers/Kconfig                                 |    2 +
 drivers/Makefile                                |    1 +
 drivers/char/mmtimer.c                          |    1 +
 drivers/net/Makefile                            |    1 +
 drivers/net/arm/ixp4xx_eth.c                    |  191 +++++
 drivers/net/gianfar_ptp.c                       |  448 +++++++++++
 drivers/net/gianfar_ptp_reg.h                   |  113 +++
 drivers/net/phy/Kconfig                         |   29 +
 drivers/net/phy/Makefile                        |    1 +
 drivers/net/phy/dp83640.c                       |  896 +++++++++++++++++++++++
 drivers/net/phy/dp83640_reg.h                   |  261 +++++++
 drivers/ptp/Kconfig                             |   53 ++
 drivers/ptp/Makefile                            |    7 +
 drivers/ptp/ptp_chardev.c                       |  146 ++++
 drivers/ptp/ptp_clock.c                         |  318 ++++++++
 drivers/ptp/ptp_ixp46x.c                        |  344 +++++++++
 drivers/ptp/ptp_private.h                       |   86 +++
 drivers/ptp/ptp_sysfs.c                         |  226 ++++++
 include/linux/Kbuild                            |    1 +
 include/linux/posix-clock.h                     |  137 ++++
 include/linux/posix-timers.h                    |   23 +-
 include/linux/ptp_clock.h                       |   79 ++
 include/linux/ptp_clock_kernel.h                |  141 ++++
 include/linux/syscalls.h                        |    2 +
 include/linux/time.h                            |    3 +
 include/linux/timex.h                           |    3 +-
 kernel/compat.c                                 |  136 +++--
 kernel/posix-cpu-timers.c                       |    6 +
 kernel/posix-timers.c                           |  279 ++++++--
 kernel/time/Makefile                            |    3 +-
 kernel/time/ntp.c                               |   11 +
 kernel/time/posix-clock-syscalls.h              |   39 +
 kernel/time/posix-clock.c                       |  454 ++++++++++++
 kernel/time/timekeeping.c                       |   36 +
 54 files changed, 5163 insertions(+), 97 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-ptp
 create mode 100644 Documentation/ptp/ptp.txt
 create mode 100644 Documentation/ptp/testptp.c
 create mode 100644 Documentation/ptp/testptp.mk
 create mode 100644 arch/arm/mach-ixp4xx/include/mach/ixp46x_ts.h
 create mode 100644 drivers/net/gianfar_ptp.c
 create mode 100644 drivers/net/gianfar_ptp_reg.h
 create mode 100644 drivers/net/phy/dp83640.c
 create mode 100644 drivers/net/phy/dp83640_reg.h
 create mode 100644 drivers/ptp/Kconfig
 create mode 100644 drivers/ptp/Makefile
 create mode 100644 drivers/ptp/ptp_chardev.c
 create mode 100644 drivers/ptp/ptp_clock.c
 create mode 100644 drivers/ptp/ptp_ixp46x.c
 create mode 100644 drivers/ptp/ptp_private.h
 create mode 100644 drivers/ptp/ptp_sysfs.c
 create mode 100644 include/linux/posix-clock.h
 create mode 100644 include/linux/ptp_clock.h
 create mode 100644 include/linux/ptp_clock_kernel.h
 create mode 100644 kernel/time/posix-clock-syscalls.h
 create mode 100644 kernel/time/posix-clock.c

