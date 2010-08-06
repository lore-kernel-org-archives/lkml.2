Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab0HFT5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:57:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:39835 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133Ab0HFT5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:57:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,330,1278313200"; 
   d="scan'208";a="645333898"
Subject: [GIT] dmaengine/async_tx update for 2.6.36
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        yong.y.wang@linux.intel.com, vinod.koul@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Aug 2010 13:02:07 -0700
Message-ID: <1281124927.29414.41.camel@dwillia2-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git next

...to receive:

1/ 2 new drivers intel_mid and pch_dma to support the embedded dma
engines on upcoming platforms.  Unlike ioat these drivers will be used
to do bus mastering on behalf of other devices (slave-dma).

2/ LinusW has introduced a common way for slave-dma clients to pass
configuration information to the dmaengine driver at runtime.  He has
updated the ste_dma40 and coh drivers accordingly, and Vinod has
expressed interest in using this interface for intel_mid.

3/ A workaround for a boot regression triggered by a bad BIOS DMAR table
and the recent (2.6.32) auto-loading behavior of the ioatdma module:
"ioat2: catch and recover from broken vtd configurations v6".  This is
tagged for -stable.

4/ A collection of fixes for ste_dma40, timb_dma, and at_hdmac.

This tree has a known conflict with the ARM tree that you already pulled
(caught thanks to Stephen).  I include the confirmed conflict diff and a
git-url for a backmerge of the ARM tree at the bottom of this message if
you'd rather pull that.

Thanks,
Dan

Dan Carpenter (1):
      dma/timb_dma: compile warning on 32 bit

Dan Williams (2):
      Merge branch 'timb' into dmaengine
      ioat2: catch and recover from broken vtd configurations v6

Jonas Aaberg (14):
      DMAENGINE: ste_dma40: use kmem cache
      DMAENGINE: ste_dma40: improve allocation error handling
      DMAENGINE: ste_dma40: various cosmetic clean-ups
      DMAENGINE: ste_dma40: deny ops on non-alloc channels
      DMAENGINE: ste_dma40: lock fix
      DMAENGINE: ste_dma40: avoid doing unnessecary suspend
      DMAENGINE: ste_dma40: interrupts only on dst
      DMAENGINE: ste_dma40: no premature stop
      DMAENGINE: ste_dma40: arch updates for LCLA and LCPA
      DMAENGINE: ste_dma40: no flow control on memcpy
      DMAENGINE: ste_dma40: add DB8500 memcpy channels
      DMAENGINE: ste_dma40: fix suspend bug
      DMAENGINE: ste_dma40: no disabled phy channels on ux500
      DMAENGINE: ste_dma40: support disabling physical channels

Julia Lawall (1):
      drivers/dma: Eliminate a NULL pointer dereference

Kulikov Vasiliy (1):
      dma: dmatest: fix potential sign bug

Linus Walleij (6):
      DMAENGINE: ste_dma40: only write phy channel config first time
      DMAENGINE: ste_dma40: allocate LCLA dynamically
      DMAENGINE: ste_dma40: support older silicon
      DMAENGINE: generic slave channel control v3
      DMAENGINE: add runtime slave config to DMA40 v3
      DMAENGINE: add runtime slave control to COH 901 318 v3

Per Friden (2):
      DMAENGINE: ste_dma40: fixed lli_max=1 issue
      DMAENGINE: ste_dma40: moved freeing of client owned desc

Vinod Koul (1):
      intel_mid: Add Mrst & Mfld DMA Drivers

Yong Wang (3):
      dmaengine: Driver for Topcliff PCH DMA controller
      DMAENGINE: pch_dma: kill another usage of __raw_{read|write}l
      DMAENGINE: at_hdmac: locking fixlet

 arch/arm/mach-ux500/devices-db8500.c           |   30 +-
 arch/arm/mach-ux500/include/mach/db8500-regs.h |    6 +-
 arch/arm/mach-ux500/ste-dma40-db8500.h         |    2 +-
 arch/arm/plat-nomadik/include/plat/ste_dma40.h |    4 +-
 drivers/dma/Kconfig                            |   20 +
 drivers/dma/Makefile                           |    2 +
 drivers/dma/at_hdmac.c                         |    4 +-
 drivers/dma/coh901318.c                        |  169 ++++
 drivers/dma/dmatest.c                          |    2 +-
 drivers/dma/intel_mid_dma.c                    | 1143 ++++++++++++++++++++++++
 drivers/dma/intel_mid_dma_regs.h               |  260 ++++++
 drivers/dma/ioat/dma.h                         |    1 +
 drivers/dma/ioat/dma_v2.c                      |   24 +-
 drivers/dma/ioat/dma_v3.c                      |    5 +-
 drivers/dma/pch_dma.c                          |  957 ++++++++++++++++++++
 drivers/dma/ste_dma40.c                        |  860 +++++++++++-------
 drivers/dma/ste_dma40_ll.c                     |   40 +-
 drivers/dma/ste_dma40_ll.h                     |   15 +-
 drivers/dma/timb_dma.c                         |    8 +-
 drivers/pci/intel-iommu.c                      |   28 +
 include/linux/dmaengine.h                      |   71 ++
 include/linux/intel_mid_dma.h                  |   86 ++
 include/linux/pch_dma.h                        |   37 +
 23 files changed, 3391 insertions(+), 383 deletions(-)
 create mode 100644 drivers/dma/intel_mid_dma.c
 create mode 100644 drivers/dma/intel_mid_dma_regs.h
 create mode 100644 drivers/dma/pch_dma.c
 create mode 100644 include/linux/intel_mid_dma.h
 create mode 100644 include/linux/pch_dma.h

commit b0ebeb9c09cb5b84bb2f33927c84c7648845fcec
Author: Yong Wang <yong.y.wang@linux.intel.com>
Date:   Thu Aug 5 10:40:08 2010 +0800

    DMAENGINE: at_hdmac: locking fixlet
    
    atc_chain_complete shall be called with atchan->lock held
    and bh disabled.
    
    Signed-off-by: Yong Wang <yong.y.wang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 61cd2203769a2bf35d41f8682f6ef865fe2d23ff
Author: Yong Wang <yong.y.wang@linux.intel.com>
Date:   Thu Aug 5 10:38:43 2010 +0800

    DMAENGINE: pch_dma: kill another usage of __raw_{read|write}l
    
    Use {read|write}l instead of __raw_{read|write}l since PCH DMA
    controller is PCI device.
    
    Signed-off-by: Yong Wang <yong.y.wang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit b9033e682e86f3c6a66763f9b6a3935c5c64e145
Author: Kulikov Vasiliy <segooon@gmail.com>
Date:   Sat Jul 17 19:19:48 2010 +0400

    dma: dmatest: fix potential sign bug
    
    'cnt' is unsigned, so this code may become wrong in future as
    dmatest_add_threads() can return error code:
    
    	cnt = dmatest_add_threads(dtc, DMA_MEMCPY);
    	thread_count += cnt > 0 ? cnt : 0;
    		        ^^^^^^^
    
    Now it can return only -EINVAL if and only if second argument of
    dmatest_add_threads() is not one of DMA_MEMCPY, DMA_XOR, DMA_PQ.
    So, now it is not wrong but may become wrong in future.
    
    The semantic patch that finds this problem (many false-positive results):
    (http://coccinelle.lip6.fr/)
    
    // <smpl>
    @ r1 @
    identifier f;
    @@
    int f(...) { ... }
    
    @@
    identifier r1.f;
    type T;
    unsigned T x;
    @@
    
    *x = f(...)
     ...
    *x > 0
    
    Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 556ab45f9a775bfa4762bacc0a4afb5b44b067bc
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Jul 23 15:47:56 2010 -0700

    ioat2: catch and recover from broken vtd configurations v6
    
    On some platforms (MacPro3,1) the BIOS assigns the ioatdma device to the
    incorrect iommu causing faults when the driver initializes.  Add a quirk
    to catch this misconfiguration and try falling back to untranslated
    operation (which works in the MacPro3,1 case).
    
    Assuming there are other platforms with misconfigured iommus teach the
    ioatdma driver to treat initialization failures as non-fatal (just fail
    the driver load and emit a warning instead of triggering a BUG_ON).
    
    This can be classified as a boot regression since 2.6.32 on affected
    platforms since the ioatdma module did not autoload prior to that
    kernel.
    
    Cc: <stable@kernel.org>
    Acked-by: David Woodhouse <David.Woodhouse@intel.com>
    Reported-by: Chris Li <lkml@chrisli.org>
    Tested-by: Chris Li <lkml@chrisli.org>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 128f904ac87cb6e63921e80f378fdf9ba532c0f6
Author: Linus Walleij <linus.walleij@stericsson.com>
Date:   Wed Aug 4 13:37:53 2010 +0200

    DMAENGINE: add runtime slave control to COH 901 318 v3
    
    This extends the DMA engine driver for the COH 901 318 used in the
    U300 platform with the generic runtime slave control command.
    
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 95e1400fa1317e566b316ff4af947bd5341332c8
Author: Linus Walleij <linus.walleij@stericsson.com>
Date:   Wed Aug 4 13:37:45 2010 +0200

    DMAENGINE: add runtime slave config to DMA40 v3
    
    This extends the DMA engine driver for the DMA40 used in the
    U8500 platform with the generic runtime slave configuration
    interface.
    
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit c156d0a5b0c667999e06d0bb52e3d1376faec8bf
Author: Linus Walleij <linus.walleij@stericsson.com>
Date:   Wed Aug 4 13:37:33 2010 +0200

    DMAENGINE: generic slave channel control v3
    
    This adds an interface to the DMAengine to make it possible to
    reconfigure a slave channel at runtime. We add a few foreseen
    config parameters to the passed struct, with a void * pointer
    for custom per-device or per-platform runtime slave data.
    
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 0c42bd0e425e9c8ddb7019fc446f7d915e36c5f6
Author: Yong Wang <yong.y.wang@linux.intel.com>
Date:   Fri Jul 30 16:23:03 2010 +0800

    dmaengine: Driver for Topcliff PCH DMA controller
    
    Topcliff PCH is the platform controller hub that is going to
    be used in Intel's upcoming general embedded platforms. This
    adds the driver for Topcliff PCH DMA controller. The DMA
    channels are strictly for device to host or host to device
    transfers and cannot be used for generic memcpy.
    
    Signed-off-by: Yong Wang <yong.y.wang@intel.com>
    [kill GFP_ATOMIC, kill __raw_{read|write}l, locking fixlet]
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit b3c567e474b5ba4447b6e16063a3b0cffc22d205
Author: Vinod Koul <vinod.koul@intel.com>
Date:   Wed Jul 21 13:28:10 2010 +0530

    intel_mid: Add Mrst & Mfld DMA Drivers
    
    This patch add DMA drivers for DMA controllers in Langwell chipset
    of Intel(R) Moorestown platform and DMA controllers in Penwell of
    Intel(R) Medfield platfrom
    
    This patch adds support for Moorestown DMAC1 and DMAC2 controllers.
    It also add support for Medfiled GP DMA and DMAC1 controllers.
    These controllers supports memory to peripheral and peripheral to
    memory transfers. It support only single block transfers.
    
    This driver is based on Kernel DMA engine
    Anyone who wishes to use this controller should use DMA engine APIs
    
    This controller exposes DMA_SLAVE capabilities and notifies the client drivers
    of DMA transaction completion
    
    Config option required to be enabled CONFIG_INTEL_MID_DMAC=y
    
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>
    Signed-off-by: Alan Cox <alan@linux.intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 084a2ab9c258fb1efbb009f1bb1c6976da1f73f4
Merge: f418559 4856800
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Jul 1 02:29:19 2010 -0700

    Merge branch 'timb' into dmaengine

commit 485680050166dc8c6ac976346430ab1f453c228b
Author: Julia Lawall <julia@diku.dk>
Date:   Thu May 27 14:33:17 2010 +0200

    drivers/dma: Eliminate a NULL pointer dereference
    
    If td_desc is NULL, just skip both kfrees.
    
    A simplified version of the semantic match that finds this problem is as
    follows: (http://coccinelle.lip6.fr/)
    
    // <smpl>
    @r exists@
    expression E,E1;
    identifier f;
    statement S1,S2,S3;
    @@
    
    if ((E == NULL && ...) || ...)
    {
      ... when != if (...) S1 else S2
          when != E = E1
    * E->f
      ... when any
      return ...;
    }
    else S3
    // </smpl>
    
    Signed-off-by: Julia Lawall <julia@diku.dk>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit efcc28981745bc6aca88acb2d4d37d87f090a80a
Author: Dan Carpenter <error27@gmail.com>
Date:   Tue May 25 11:55:06 2010 +0200

    dma/timb_dma: compile warning on 32 bit
    
    This silences a compile warning on 32 bit systems:
    drivers/dma/timb_dma.c:203: warning: cast to pointer from integer of different size
    
    Signed-off-by: Dan Carpenter <error27@gmail.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit f41855929c9fdc3b4f2863ada9df3e0cf4231b5b
Author: Linus Walleij <linus.walleij@stericsson.com>
Date:   Tue Jun 22 18:06:42 2010 -0700

    DMAENGINE: ste_dma40: support older silicon
    
    This makes sure the DMA40 driver will also work on the oldest
    silicon revisions that have the on-chip memory on another location
    in the DB8500 and also requires explicit suspend before starting
    or resuming a logical channel.
    
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    [added parenthesis to the definition of U8500_DMA_LCPA_BASE_ED]
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 6b7acd84426235c63a3c0f0b230a95064f97b0d4
Author: Jonas Aaberg <jonas.aberg@stericsson.com>
Date:   Sun Jun 20 21:26:59 2010 +0000

    DMAENGINE: ste_dma40: support disabling physical channels
    
    This makes it possible to disable physical channels.
    
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 595167253a20167efae704ff2a8f6e2ee66cf25f
Author: Jonas Aaberg <jonas.aberg@stericsson.com>
Date:   Sun Jun 20 21:26:45 2010 +0000

    DMAENGINE: ste_dma40: no disabled phy channels on ux500
    
    Make sure we have no disabled physical channels when we start on
    the ux500 machines.
    
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit d181b3a8cb2fc1732ad1826a5e6fdccab03e6a51
Author: Jonas Aaberg <jonas.aberg@stericsson.com>
Date:   Sun Jun 20 21:26:38 2010 +0000

    DMAENGINE: ste_dma40: fix suspend bug
    
    This fixes a bug when suspending channels: first make the checks,
    then suspend the channel, not the other way around.
    
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 8bc68fa51d7ed520cd4c69f74fb37add60b6ea47
Author: Jonas Aaberg <jonas.aberg@stericsson.com>
Date:   Sun Jun 20 21:26:30 2010 +0000

    DMAENGINE: ste_dma40: add DB8500 memcpy channels
    
    This adds all available memcpy channels to the DB8500 in the
    ux500 platform (and fixes a typo).
    
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit ef934aea861323820cb39051e94a52319f456fbe
Author: Jonas Aaberg <jonas.aberg@stericsson.com>
Date:   Sun Jun 20 21:26:22 2010 +0000

    DMAENGINE: ste_dma40: no flow control on memcpy
    
    On memcpy DMA operations we don't need flow control.
    
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 5aa12e8c9c57741606e52f43e62ab1b9dc8e9dcc
Author: Jonas Aaberg <jonas.aberg@stericsson.com>
Date:   Sun Jun 20 21:26:14 2010 +0000

    DMAENGINE: ste_dma40: arch updates for LCLA and LCPA
    
    This follows on the patch to allocate LCLA dynamically: the
    on-chip memory is needed for other things so now that that
    we're using it dynamically we can remove the LCLA resource
    altogether and free up some ESRAM memory.
    
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 508849ade23c1167bfbdf557259398adfe7044b9
Author: Linus Walleij <linus.walleij@stericsson.com>
Date:   Sun Jun 20 21:26:07 2010 +0000

    DMAENGINE: ste_dma40: allocate LCLA dynamically
    
    Switch to allocating LCLA in memory instead of having a fixed
    address.
    
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 1d392a7ba43300b0bde877de15121b261d7a6ce2
Author: Jonas Aaberg <jonas.aberg@stericsson.com>
Date:   Sun Jun 20 21:26:01 2010 +0000

    DMAENGINE: ste_dma40: no premature stop
    
    Correct bug that could cause paused channels to stop.
    
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 2123a61e174074b849fce2277412836b1b897942
Author: Jonas Aaberg <jonas.aberg@stericsson.com>
Date:   Sun Jun 20 21:25:54 2010 +0000

    DMAENGINE: ste_dma40: interrupts only on dst
    
    We don't want interrupts when the source is done, only when
    the destination is done and everything is complete at the
    recieveing end of a transfer.
    
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 0c32269d813c148194524fc8272f7ec1f7c90e6a
Author: Jonas Aaberg <jonas.aberg@stericsson.com>
Date:   Sun Jun 20 21:25:46 2010 +0000

    DMAENGINE: ste_dma40: avoid doing unnessecary suspend
    
    Avoid doing unnessecary suspend when modifying logical channels.
    
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 2292b880e411276d127a020a1c35ca149fcca992
Author: Jonas Aaberg <jonas.aberg@stericsson.com>
Date:   Sun Jun 20 21:25:39 2010 +0000

    DMAENGINE: ste_dma40: lock fix
    
    Fix up some locking issues found by enabling lock debugging.
    
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 0d0f6b8bbb13e1287f4f2a271e4f4306789511a2
Author: Jonas Aaberg <jonas.aberg@stericsson.com>
Date:   Sun Jun 20 21:25:31 2010 +0000

    DMAENGINE: ste_dma40: deny ops on non-alloc channels
    
    Added checks to deny operating on none-allocated channels.
    
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 2a6143407d9114a0c5d16a7eed1a0892a4ce9f19
Author: Jonas Aaberg <jonas.aberg@stericsson.com>
Date:   Sun Jun 20 21:25:24 2010 +0000

    DMAENGINE: ste_dma40: various cosmetic clean-ups
    
    This cleans up some extra newlines, removes some code duplication
    and moves the code to comply better with checkpatch.
    
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit ff0b12baa50390ba6a963cb6f6162a94ed4fc333
Author: Jonas Aaberg <jonas.aberg@stericsson.com>
Date:   Sun Jun 20 21:25:15 2010 +0000

    DMAENGINE: ste_dma40: improve allocation error handling
    
    Better error handling when channel allocation fails.
    
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit c675b1b424446b52de00cad84ca3d823d29a3d0e
Author: Jonas Aaberg <jonas.aberg@stericsson.com>
Date:   Sun Jun 20 21:25:08 2010 +0000

    DMAENGINE: ste_dma40: use kmem cache
    
    Use kmem cache instead of own cache, reducing code duplication
    and bug sources.
    
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit a8be8627a3a00859367d219848f2cd771d6aa925
Author: Per Friden <per.friden@stericsson.com>
Date:   Sun Jun 20 21:24:59 2010 +0000

    DMAENGINE: ste_dma40: moved freeing of client owned desc
    
    fixed typo and moved freeing of client owned desc to free_dma.
    
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit ef1872ec652b3bc472d6c0995d0b64d5058878ea
Author: Linus Walleij <linus.walleij@stericsson.com>
Date:   Sun Jun 20 21:24:52 2010 +0000

    DMAENGINE: ste_dma40: only write phy channel config first time
    
    We only need to write the configuration to a physical channel if
    it is free, else it is already written.
    
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 941b77a3b6946dd6223a029007f695aa841b6d34
Author: Per Friden <per.friden@stericsson.com>
Date:   Sun Jun 20 21:24:45 2010 +0000

    DMAENGINE: ste_dma40: fixed lli_max=1 issue
    
    Fixed lli_max=1 issue in case of full lcla, currently this case
    is not properly handled.
    
    Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

---
Conflict backmerge available here:

   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git arm-vs-dmaengine-2.6.36

 23 files changed, 3390 insertions(+), 382 deletions(-)

commit 8504792f74f165095a9abc42c09ab6e563f98af2
Merge: 7b70c42 b0ebeb9
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Aug 6 11:39:50 2010 -0700

    Merge branch 'dmaengine' into arm-vs-dmaengine-2.6.36
    
    Conflicts:
    	arch/arm/mach-ux500/devices-db8500.c

diff --cc arch/arm/mach-ux500/devices-db8500.c
index 654fca9,c62cdbe..9280d25
--- a/arch/arm/mach-ux500/devices-db8500.c
+++ b/arch/arm/mach-ux500/devices-db8500.c
@@@ -119,20 -119,15 +119,15 @@@ static struct resource dma40_resources[
  	},
  	[1] = {
  		.start = U8500_DMA_LCPA_BASE,
- 		.end = U8500_DMA_LCPA_BASE + SZ_4K - 1,
+ 		.end   = U8500_DMA_LCPA_BASE + 2 * SZ_1K - 1,
  		.flags = IORESOURCE_MEM,
- 		.name = "lcpa",
+ 		.name  = "lcpa",
  	},
  	[2] = {
- 		.start = U8500_DMA_LCLA_BASE,
- 		.end = U8500_DMA_LCLA_BASE + 16 * 1024 - 1,
- 		.flags = IORESOURCE_MEM,
- 		.name = "lcla",
- 	},
- 	[3] = {
 -		.start = IRQ_DMA,
 -		.end   = IRQ_DMA,
 +		.start = IRQ_DB8500_DMA,
 +		.end   = IRQ_DB8500_DMA,
- 		.flags = IORESOURCE_IRQ}
+ 		.flags = IORESOURCE_IRQ,
+ 	}
  };
  
  /* Default configuration for physcial memcpy */


