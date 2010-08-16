Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab0HPLQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 07:16:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41771 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab0HPLQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 07:16:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ceX5MJ5XyoXj7mhWPS4J+ZIUDsKvDGJbBUivwWANQ1VL0KpRKin7oDRsIh7ZHjuf+h
         1FwfkCtL7GiTz7I31JAdGu1cN2gNaUIYFqVyz1yMK8Zk51HHY28XMJ1s/0hyRD0yYkLI
         wdvAfYr2wWhzhWtm3EcreqUNQylx0n+oJO7Ow=
Date: Mon, 16 Aug 2010 13:17:05 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, Krzysztof Halasa <khc@pm.waw.pl>,
        Rodolfo Giometti <giometti@linux.it>
Subject: [PATCH v5 0/5] ptp: IEEE 1588 clock support
Message-ID: <cover.1281956490.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now and again there has been talk on the netdev list of adding PTP
support into Linux. One part of the picture is already in place, the
SO_TIMESTAMPING API for hardware time stamping. This patch set offers
the missing second part needed for complete IEEE 1588 support.

* Why all the CCs?

  1. IMHO, the patches should go through netdev.
  2. A reviewer on netdev said, this should appear on lkml.
  3. One driver is for PowerPC, and adds device tree stuff.
  4. One driver is for the ARM Xscale IXP465.

* Open Issues:

** DP83640
   In order to make this work, one line must be added into the MAC
   driver. If you have the DP83640 and want to try the driver, you
   need to add this one line to your MAC driver: In the
   .ndo_start_xmit function, add skb_tx_timestamp(skb).

** IXP465
   I do not know how to correctly choose the timestamp "channel" based
   on the port identifier:

+#define PORT2CHANNEL(p)		1
+/*
+ * PHYSICAL_ID(p->id) ?
+ * TODO - Figure out correct mapping.
+ */

   Krzysztof, can you help?

* PTP Patch ChangeLog
** v5
*** general
   - Added a hook into the PPS subsystem
   - Corrected max_adj in all drivers
   - Removed unnecessary sysfs stuff
   - Replaced spinlock with mutex in class driver
*** gianfar
   - Added PPS support
   - Changed underscore to minus in device tree bindings
   - Use of_iomap instead of ioremap
*** ixp465
   - Added an external trigger event
   - Corrected in_progress logic
*** phyter
   - Added an external trigger event
   - Added support for phy status frames

** v4
*** general
   - Added a clock driver for the National Semiconductor PHYTER.
   - Added a clock driver for the Intel IXP465.
   - Made more stylish according to checkstyle.pl.
*** gianfar
   - Replace device_type and model with compatible string ("fsl,etsec-ptp")
   - Register only one interrupt, since others are superfluous.
   - Combine ptp clock instance with private variable structure.
   - ISR now returns NONE or HANDLED properly.
   - Print error message if something is missing from the device nodes.

** v3
*** general
   - Added documentation on writing clock drivers.
   - Added the ioctls for the ancillary clock features.
   - Changed wrong subsys_initcall() to module_init() in clock drivers.
   - Removed the (too coarse) character device mutex.
   - Setting the clock now requires CAP_SYS_TIME.
*** gianfar
   - Added alarm feature.
   - Added device tree node binding description.
   - Added fine grain locking of the clock registers.
   - Added the external time stamp feature.
   - Added white space for better style.
   - Coverted base+offset to structure pointers for register access.
   - When removing the driver, we now disable all PTP functions.

** v2
   - Changed clock list from a static array into a dynamic list. Also,
     use a bitmap to manage the clock's minor numbers.
   - Replaced character device semaphore with a mutex.
   - Drop .ko from module names in Kbuild help.
   - Replace deprecated unifdef-y with header-y for user space header file.
   - Added links to both of the ptpd patches on sourceforge.
   - Gianfar driver now gets parameters from device tree.
   - Added API documentation to Documentation/ptp/ptp.txt


Richard Cochran (5):
  ptp: Added a brand new class driver for ptp clocks.
  ptp: Added a clock that uses the Linux system time.
  ptp: Added a clock that uses the eTSEC found on the MPC85xx.
  ptp: Added a clock driver for the IXP46x.
  ptp: Added a clock driver for the National Semiconductor PHYTER.

 Documentation/powerpc/dts-bindings/fsl/tsec.txt |   57 ++
 Documentation/ptp/ptp.txt                       |   95 +++
 Documentation/ptp/testptp.c                     |  306 ++++++++
 Documentation/ptp/testptp.mk                    |   33 +
 arch/arm/mach-ixp4xx/include/mach/ixp46x_ts.h   |   78 ++
 arch/powerpc/boot/dts/mpc8313erdb.dts           |   14 +
 arch/powerpc/boot/dts/mpc8572ds.dts             |   14 +
 arch/powerpc/boot/dts/p2020ds.dts               |   14 +
 arch/powerpc/boot/dts/p2020rdb.dts              |   14 +
 drivers/Kconfig                                 |    2 +
 drivers/Makefile                                |    1 +
 drivers/net/Makefile                            |    1 +
 drivers/net/arm/ixp4xx_eth.c                    |  191 +++++
 drivers/net/gianfar_ptp.c                       |  527 +++++++++++++
 drivers/net/gianfar_ptp_reg.h                   |  113 +++
 drivers/net/phy/Kconfig                         |   29 +
 drivers/net/phy/Makefile                        |    1 +
 drivers/net/phy/dp83640.c                       |  904 +++++++++++++++++++++++
 drivers/net/phy/dp83640_reg.h                   |  261 +++++++
 drivers/ptp/Kconfig                             |   65 ++
 drivers/ptp/Makefile                            |    7 +
 drivers/ptp/ptp_clock.c                         |  514 +++++++++++++
 drivers/ptp/ptp_ixp46x.c                        |  359 +++++++++
 drivers/ptp/ptp_linux.c                         |  136 ++++
 include/linux/Kbuild                            |    1 +
 include/linux/ptp_clock.h                       |   79 ++
 include/linux/ptp_clock_kernel.h                |  137 ++++
 kernel/time/ntp.c                               |    2 +
 28 files changed, 3955 insertions(+), 0 deletions(-)
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
 create mode 100644 drivers/ptp/ptp_clock.c
 create mode 100644 drivers/ptp/ptp_ixp46x.c
 create mode 100644 drivers/ptp/ptp_linux.c
 create mode 100644 include/linux/ptp_clock.h
 create mode 100644 include/linux/ptp_clock_kernel.h

