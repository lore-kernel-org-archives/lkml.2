Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab2E1Qhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 12:37:33 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:43087 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892Ab2E1Qhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 12:37:31 -0400
Date: Mon, 28 May 2012 18:36:59 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, Russell King <linux@arm.linux.org.uk>,
        x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH V2 0/6] Bridging PCI to amba
Message-ID: <cover.1338220457.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V2: accepted comments I got on V1; rewritten the driver to be generic;
    made it tristate instead of boolean. Rebased on new next.


This patch set introduces use of AMBA devices under a PCI bridge.
The device table in the driver include all the devices that we'll be
able to run using AMBA drivers.

To compile AMBA under x86, though I need <asm/sizes.h>,
which is moved to <linux/sizes.h> as suggested earlier.

I'm hereby volunteering to handle the moving of the various users
of <asm/sizes.h> to <linux/sizes.h>; this set only moves the ARM core
files and the ones that I need under x86.

The whole patch set is sent to the same set of recipients:
all relevant lists, Russell King (for arm), Greg-KH (for uart) and
Arnd Bergmann (for generic include).

With this set in place (plus a clok API not included here) I have
4 serial ports working.

Success strings:
   spusa.root# uname -r
   3.4.0-next-20120528-00016-g1e5853d

   spusa.root# dmesg | grep ttyA
   amba-0000:03:00.5: ttyAMA0 at MMIO 0xcf400000 (irq = 64) is a PL011 rev3
   amba-0000:03:00.6: ttyAMA1 at MMIO 0xcec00000 (irq = 65) is a PL011 rev3
   amba-0000:03:00.7: ttyAMA2 at MMIO 0xce400000 (irq = 66) is a PL011 rev3
   amba-0000:04:00.5: ttyAMA3 at MMIO 0xd3400000 (irq = 71) is a PL011 rev3

   spusa.root# grep -B2 pl011 /proc/iomem
           ce400000-ce7fffff : 0000:03:00.7
             ce400000-ce400fff : amba-0000:03:00.7
             ce400000-ce400fff : uart-pl011
   --
           cec00000-ceffffff : 0000:03:00.6
             cec00000-cec00fff : amba-0000:03:00.6
             cec00000-cec00fff : uart-pl011
   --
           cf400000-cf7fffff : 0000:03:00.5
             cf400000-cf400fff : amba-0000:03:00.5
             cf400000-cf400fff : uart-pl011
   --
           d3400000-d37fffff : 0000:04:00.5
             d3400000-d3400fff : amba-0000:04:00.5
             d3400000-d3400fff : uart-pl011


Alessandro Rubini (6):
  sizes.h: move from asm-generic to <linux/sizes.h>
  amba: use the new linux/sizes.h
  ARM: use the new linux/sizes.h
  serial: use the new linux/sizes.h
  x86: add CONFIG_ARM_AMBA, selected by STA2X11
  drivers/amba: add support for a PCI bridge

 arch/arm/include/asm/memory.h   |    2 +-
 arch/arm/mm/dma-mapping.c       |    2 +-
 arch/arm/mm/init.c              |    2 +-
 arch/arm/mm/ioremap.c           |    2 +-
 arch/arm/mm/mmu.c               |    2 +-
 arch/x86/Kconfig                |    4 ++
 drivers/Kconfig                 |    2 +
 drivers/amba/Kconfig            |   10 ++++
 drivers/amba/Makefile           |    1 +
 drivers/amba/bus.c              |    2 +-
 drivers/amba/pci-amba.c         |   95 +++++++++++++++++++++++++++++++++++++++
 drivers/tty/serial/amba-pl011.c |    2 +-
 include/asm-generic/sizes.h     |   49 +-------------------
 include/linux/sizes.h           |   47 +++++++++++++++++++
 14 files changed, 168 insertions(+), 54 deletions(-)
 create mode 100644 drivers/amba/Kconfig
 create mode 100644 drivers/amba/pci-amba.c
 create mode 100644 include/linux/sizes.h

-- 
1.7.7.2
