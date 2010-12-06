Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab0LFWQC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:16:02 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:36053 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab0LFWQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:16:00 -0500
From: David Sin <davidsin@ti.com>
To: Greg KH <greg@kroah.com>, Russell King <rmk@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: David Sin <davidsin@ti.com>
Subject: [PATCH 0/9] TI DMM-TILER driver 
Date: Mon,  6 Dec 2010 16:27:17 -0600
Message-Id: <1291674446-10766-1-git-send-email-davidsin@ti.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tiling and Isometric Lightweight Engine for Rotation (TILER) driver
=====

Dynamic Memory Manager (DMM) is a hardware block made by Texas Instruments.
Within the DMM exists at least one TILER hardware component.  Its purpose is to
organize video/image memory in a 2-dimensional fashion to limit memory
bandwidth and facilitate 0 effort rotation and mirroring.  The TILER driver
facilitates allocating, freeing, as well as mapping 2D blocks (areas) in the
TILER container(s).  It also facilitates rotating and mirroring the allocated
blocks or its rectangular subsections.

TERMINOLOGY

"slot"

The basic TILER driver operates on blocks of slots.  A slot is the granularity
of the TILER hardware device.  For all current uses it is 4K, but could also be
16 or 64K.  The DMM-TILER TRM refers to this as "page" but we want to separate
this concept from the MMU pages.

"page"

The granularity of the MMU, used by the kernel.  This is 4K.

"block"

The TILER hardware component supports 1D and 2D blocks.  A 2D block is a
rectangular arrangement of slots with arbitrary width and height in a 2D
container.  A 1D block is a linear arrangement of slots with arbitrary length
 in a 1D container.  This TILER driver only supports 2D blocks.

"container"

The TILER driver supports an arbitrary TILER container size.  However, for
all current implementations it is 256 by 128 slots.  The container currently can
only be used as a 2D container.

"reserved area"

Each block resides within a reserved area in the container.  This area may
be larger than the actual set of slots that a block occupies.  The reason for
this is to protect access from one block into another.  Since TILER container is
mmap-ped into user space as individual pages, all slots that are spanned by
that page become visible to the user.  The tiler driver allows restricting the
granularity of the reserved area (default alignment) as well as the mapped
area (granularity).

Technical Reference Manual
=====
http://focus.ti.com/pdfs/wtbu/OMAP4430_ES2.x_PUBLIC_TRM_vN.zip

Changes since RFC v2: https://lkml.org/lkml/2010/11/30/352
=====
Randy Dunlap:
1) Clarify the meaning of 2^n when referring to TILER alignment and 
allocation granularity

Greg KH:
1) Move tiler.h to include/linux since it's not arch specific
2) Rename _tiler.h to tiler-geom.h (ick)
3) Use WARN_ON instead of BUG_ON
4) Export symbols as 'EXPORT_SYMBOL_GPL'
5) Remove comment from Kconfig file

Santosh Shilimkar:
1) Create separate DMM OMAP device file patch (#9)

Changes since RFC v1: http://www.spinics.net/lists/linux-omap/msg33867.html
=====
Santosh Shilimkar:
1) Correct documentation location
2) Remove ioremap of RAM
3) Implement probe function and hwmod
4) Correct commenting style
5) Reduce use of barrier instances

Linus Walleij:
1) Define TCM acryonym

Russell King:
1) Implement probe function
2) Fix spelling mistake
3) Remove GFP_ATOMIC flag when calling dma_alloc_coherent for PAT array mem
4) Replace alloc_page and flush range calls with dma_alloc_coherent

Nishanth Menon:
1) Address infinite while loop when reading dmm register

Benoit Cousson:
1) Fix source file headers
2) Correct logical errors in device file

Kevin Hilman:
1) Move DMM/TILER source code into driver/misc/tiler until a recommendation
is made as to where it should go

List of pending items in proposed order:

* Determine driver source code location
 (Currently, resides in drivers/misc/tiler)
* Add area packing support (multiple blocks can reside in the same band/area)
 to optimize area use
* Add group-ID support (to specify which blocks can reside together in the
 same area)
* Add multiple search directions to TCM-SiTA
* Add 1D block support (including adding 1D search algo to TCM-SiTA)
* Optimize mutex handling (don.t hold mutex during memory
 allocation/mapping/cache flushing)
* Add block reference counting, support for sharing blocks
* Move all kernel-API-s to tiler-iface.c
* Support orphaned block support (in preparation for process cleanup support)
* Change block identification from physical address to key-ID pair
 (in preparation for user space support, and process security)
* Add support for process security (blocks from separate processes never
 reside in the same band)
* Support file interface (ioctl and mmap)
* Support for buffers (ordered list of blocks that are mapped to userspace
 together, such as YUV420sp)
* Support 1D user buffer mapping into TILER container
* Support for block pre-reservation (to further optimize area use)

David Sin (2):
  TILER-DMM: DMM-PAT driver for TI TILER
  TILER-DMM: Device support for OMAP

Lajos Molnar (6):
  TILER-DMM: Container manager interface and utility definitons
  TILER-DMM: TILER Memory Manager interface and implementation
  TILER-DMM: TILER interface file and documentation
  TILER-DMM: Geometry and view manipulation functions
  TILER-DMM: Main TILER driver implementation
  TILER-DMM: Linking TILER driver into the Linux kernel build

Ravi Ramachandra (1):
  TILER-DMM: Sample TCM implementation: Simple TILER Allocator (SiTA)

 Documentation/arm/OMAP/TILER           |  126 ++++++++++
 arch/arm/mach-omap2/Makefile           |    2 +
 arch/arm/mach-omap2/dmm-omap44xx.c     |   80 ++++++
 arch/arm/mach-omap2/include/mach/dmm.h |   92 +++++++
 drivers/misc/Kconfig                   |    1 +
 drivers/misc/Makefile                  |    1 +
 drivers/misc/tiler/Kconfig             |   72 ++++++
 drivers/misc/tiler/Makefile            |    7 +
 drivers/misc/tiler/dmm-main.c          |  187 ++++++++++++++
 drivers/misc/tiler/tcm.h               |  171 +++++++++++++
 drivers/misc/tiler/tcm/Makefile        |    1 +
 drivers/misc/tiler/tcm/_tcm-sita.h     |   61 +++++
 drivers/misc/tiler/tcm/tcm-sita.c      |  422 ++++++++++++++++++++++++++++++++
 drivers/misc/tiler/tcm/tcm-sita.h      |   28 ++
 drivers/misc/tiler/tcm/tcm-utils.h     |   51 ++++
 drivers/misc/tiler/tiler-geom.c        |  362 +++++++++++++++++++++++++++
 drivers/misc/tiler/tiler-geom.h        |   48 ++++
 drivers/misc/tiler/tiler-iface.c       |   66 +++++
 drivers/misc/tiler/tiler-main.c        |  405 ++++++++++++++++++++++++++++++
 drivers/misc/tiler/tmm-pat.c           |  266 ++++++++++++++++++++
 drivers/misc/tiler/tmm.h               |  103 ++++++++
 include/linux/tiler.h                  |  173 +++++++++++++
 22 files changed, 2725 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/arm/OMAP/TILER
 create mode 100644 arch/arm/mach-omap2/dmm-omap44xx.c
 create mode 100644 arch/arm/mach-omap2/include/mach/dmm.h
 create mode 100644 drivers/misc/tiler/Kconfig
 create mode 100644 drivers/misc/tiler/Makefile
 create mode 100644 drivers/misc/tiler/dmm-main.c
 create mode 100644 drivers/misc/tiler/tcm.h
 create mode 100644 drivers/misc/tiler/tcm/Makefile
 create mode 100644 drivers/misc/tiler/tcm/_tcm-sita.h
 create mode 100644 drivers/misc/tiler/tcm/tcm-sita.c
 create mode 100644 drivers/misc/tiler/tcm/tcm-sita.h
 create mode 100644 drivers/misc/tiler/tcm/tcm-utils.h
 create mode 100644 drivers/misc/tiler/tiler-geom.c
 create mode 100644 drivers/misc/tiler/tiler-geom.h
 create mode 100644 drivers/misc/tiler/tiler-iface.c
 create mode 100644 drivers/misc/tiler/tiler-main.c
 create mode 100644 drivers/misc/tiler/tmm-pat.c
 create mode 100644 drivers/misc/tiler/tmm.h
 create mode 100644 include/linux/tiler.h

