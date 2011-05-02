Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab1EBFHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 01:07:44 -0400
Received: from mail-px0-f170.google.com ([209.85.212.170]:55239 "EHLO
	mail-px0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab1EBFHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 01:07:43 -0400
Subject: [RFC PATCH 0/4] ARM: Basic Xilinx Support
To: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        John Linn <john.linn@xilinx.com>
Date: Sun, 01 May 2011 23:07:39 -0600
Message-ID: <20110502045207.24800.91172.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

Just for giggles, here is the Xilinx board support series reworked a
bit to depend entirely on CONFIG_OF and not use any static device
registrations other than what is needed to bootstrap the system, and
adds as little code as possible in terms of new infrastructure.  All
told, the 4th patch adds less than 950 lines of code to the kernel,
which is pretty darn good for a whole new subarch.

The zynq platform is a pretty ideal test case for this since the goal
has been from day one to depend on CONFIG_OF.  The previous series
only used static device registrations because device tree on arm isn't
yet in mainline.  Plus, xilinx is already quite comfortable with how
to use the device tree since their other two architectures (powerpc and
microblaze) have depended on device tree for years now.

I'd like to get your thoughts on the reuse of plat-versatile for the
struct clk implementation.  I'm certainly not excited about creating
yet another implementation, and versatile seems to be ideal to reuse.

The previous version of this board support has already been in
linux-next for quite a while now.  If you do decide to pick up
device tree support for 2.6.40, then it would pretty low risk thing to
queue up this board support also.

The 2nd and 3rd patches aren't actually part of the board support, but
I included them here because they're needed to get the patch to apply.
The whole series is based on top of both the irq_domain series I
posted last week and the latest arm device tree support series.

g.

---

Grant Likely (4):
      arm/dt: Add dt machine definition
      of/address: Add of_find_matching_node_by_address helper
      dt/irq: add of_irq_domain_add_simple() helper
      ARM: Xilinx: Adding Xilinx board support


 Documentation/devicetree/bindings/arm/xilinx.txt |    7 +
 arch/arm/Kconfig                                 |   14 +
 arch/arm/Makefile                                |    2 
 arch/arm/boot/dts/zynq-ep107.dts                 |   52 ++++
 arch/arm/include/asm/mach/arch.h                 |    9 +
 arch/arm/mach-zynq/Makefile                      |    6 
 arch/arm/mach-zynq/Makefile.boot                 |    3 
 arch/arm/mach-zynq/board_dt.c                    |   36 +++
 arch/arm/mach-zynq/common.c                      |  112 ++++++++
 arch/arm/mach-zynq/common.h                      |   29 ++
 arch/arm/mach-zynq/include/mach/clkdev.h         |   32 ++
 arch/arm/mach-zynq/include/mach/debug-macro.S    |   36 +++
 arch/arm/mach-zynq/include/mach/entry-macro.S    |   30 ++
 arch/arm/mach-zynq/include/mach/hardware.h       |   18 +
 arch/arm/mach-zynq/include/mach/io.h             |   33 ++
 arch/arm/mach-zynq/include/mach/irqs.h           |   21 ++
 arch/arm/mach-zynq/include/mach/memory.h         |   22 ++
 arch/arm/mach-zynq/include/mach/system.h         |   28 ++
 arch/arm/mach-zynq/include/mach/timex.h          |   23 ++
 arch/arm/mach-zynq/include/mach/uart.h           |   25 ++
 arch/arm/mach-zynq/include/mach/uncompress.h     |   51 ++++
 arch/arm/mach-zynq/include/mach/vmalloc.h        |   20 +
 arch/arm/mach-zynq/include/mach/zynq_soc.h       |   48 ++++
 arch/arm/mach-zynq/timer.c                       |  298 ++++++++++++++++++++++
 arch/arm/mm/Kconfig                              |    2 
 drivers/of/address.c                             |   18 +
 drivers/of/irq.c                                 |   44 +++
 include/linux/of_address.h                       |    4 
 include/linux/of_irq.h                           |    2 
 29 files changed, 1024 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/xilinx.txt
 create mode 100644 arch/arm/boot/dts/zynq-ep107.dts
 create mode 100644 arch/arm/mach-zynq/Makefile
 create mode 100644 arch/arm/mach-zynq/Makefile.boot
 create mode 100644 arch/arm/mach-zynq/board_dt.c
 create mode 100644 arch/arm/mach-zynq/common.c
 create mode 100644 arch/arm/mach-zynq/common.h
 create mode 100644 arch/arm/mach-zynq/include/mach/clkdev.h
 create mode 100644 arch/arm/mach-zynq/include/mach/debug-macro.S
 create mode 100644 arch/arm/mach-zynq/include/mach/entry-macro.S
 create mode 100644 arch/arm/mach-zynq/include/mach/hardware.h
 create mode 100644 arch/arm/mach-zynq/include/mach/io.h
 create mode 100644 arch/arm/mach-zynq/include/mach/irqs.h
 create mode 100644 arch/arm/mach-zynq/include/mach/memory.h
 create mode 100644 arch/arm/mach-zynq/include/mach/system.h
 create mode 100644 arch/arm/mach-zynq/include/mach/timex.h
 create mode 100644 arch/arm/mach-zynq/include/mach/uart.h
 create mode 100644 arch/arm/mach-zynq/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-zynq/include/mach/vmalloc.h
 create mode 100644 arch/arm/mach-zynq/include/mach/zynq_soc.h
 create mode 100644 arch/arm/mach-zynq/timer.c

-- 
Signature
