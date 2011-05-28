Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab1E1JwJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 05:52:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:47862 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776Ab1E1JwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 05:52:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,285,1304319600"; 
   d="scan'208";a="8884262"
Subject: [GIT] dmaengine update for 2.6.40
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 28 May 2011 02:52:04 -0700
Message-ID: <1306576324.5478.17.camel@dwillia2-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git next

...to receive:

1/ Vinod's efforts to document and unify the dma-slave infrastructure

2/ General slave-dma driver updates

These commits have only been in one recent -next release as we need to
get Vinod's tree included in -next directly in addition to mine (patch
volume is likely too low for me to pull from Vinod on a regular basis).

There is one trivial conflict adding a second MODULE_AUTHOR() to
dw_dmac.

--
Dan

Coly Li (3):
      dma: use BUG_ON correctly in iop-adma.c, v4
      dma: use BUG_ON correctly in mv_xor.c, v4
      dma: use BUG_ON correctly in ppc4xx/adam.c, v4

Dimitri Sivanich (1):
      x86: poll waiting for I/OAT DMA channel status

Kristen Carlson Accardi (1):
      intel_mid_dma: fix runtime pm issues

Linus Walleij (2):
      dmaengine/dw_dmac: implement pause and resume in dwc_control
      dmaengine: move link order

Liu Yuan (1):
      drivers, pch_dma: Fix uninitialized var before use

Nicolas Ferre (9):
      dmaengine: at_hdmac: modify way to use interrupts
      dmaengine: at_hdmac: add cyclic DMA operation support
      dmaengine: at_hdmac: debug information sg_len for prep_slave_sg
      dmaengine: at_hdmac: remove channel status testing in tasklet
      dmaengine: at_hdmac: specialize AHB interfaces to optimize transfers
      dmaengine: at_hdmac: set residue as total len in atc_tx_status
      dmaengine: at_hdmac: implement pause and resume in atc_control
      dmaengine: at_hdmac: use descriptor chaining help function
      dmaengine: at_hdmac: pause: no need to wait for FIFO empty

Philippe Langlais (1):
      dmaengine/ste_dma40: fix introduced warnings

Tomoya MORINAGA (6):
      pch_dma: fix dma direction issue for ML7213 IOH video-in
      pch_dma: modify for checkpatch
      pch_dma: Fix DMA setting issue
      pch_dma: Support I2S for ML7213 IOH
      pch_dma: Support new device ML7223 IOH
      pch_dma: modify pci device table definition

Vinod Koul (5):
      Merge branch 'old_next' into next
      Merge branch 'next' into for-linus
      dmaengine: Add API documentation for slave dma usage
      dmaengine: add TODO items for future work on dma drivers
      maintainers: add dma engine tree details

Viresh Kumar (6):
      dmaengine/dw_dmac fix: dwc_scan_descriptors must compare first desc address also with llp
      dmaengine/dw_dmac: don't call callback routine in case dmaengine_terminate_all() is called
      dmaengine/dw_dmac: set residue as total len in dwc_tx_status if status is !DMA_SUCCESS
      dmaengine/dw_dmac: Divide one sg to many desc, if sg len is greater than DWC_MAX_COUNT
      dmaengine/dw_dmac: Replace spin_lock* with irqsave variants and enable submission from callback
      dmaengine/dw_dmac: Update maintainer-ship

 Documentation/dmaengine.txt |   97 +++++++++++-
 MAINTAINERS                 |    9 +
 drivers/Makefile            |    4 +-
 drivers/dma/Kconfig         |   12 +-
 drivers/dma/TODO            |   14 ++
 drivers/dma/at_hdmac.c      |  376 +++++++++++++++++++++++++++++++++----------
 drivers/dma/at_hdmac_regs.h |   30 +++-
 drivers/dma/coh901318.c     |    2 +-
 drivers/dma/dw_dmac.c       |  272 +++++++++++++++++++++-----------
 drivers/dma/dw_dmac_regs.h  |    2 +
 drivers/dma/intel_mid_dma.c |   17 ++-
 drivers/dma/ioat/dma_v2.c   |    8 +-
 drivers/dma/iop-adma.c      |    6 +-
 drivers/dma/mv_xor.c        |    6 +-
 drivers/dma/pch_dma.c       |   96 ++++++++----
 drivers/dma/ppc4xx/adma.c   |    8 +-
 drivers/dma/ste_dma40.c     |    4 +-
 include/linux/dw_dmac.h     |    1 +
 18 files changed, 727 insertions(+), 237 deletions(-)
 create mode 100644 drivers/dma/TODO

commit 84adccfb8cd2a6b8237da6752668ba25cd90c20b
Author: Viresh Kumar <viresh.kumar@st.com>
Date:   Thu Mar 24 11:32:15 2011 +0530

    dmaengine/dw_dmac fix: dwc_scan_descriptors must compare first desc address also with llp
    
    dwc_scan_descriptors scans all descriptors from active_list in case transfer is
    not completed.  It compares first_desc->lli.llp, and then all childrens of its
    tx_list. But it doesn't compare its own address, i.e. first_desc->txd.phys, as
    this is what we have initially programmed into the controller register. So this
    causes dma to stop and finish a transfer, which was never started. And thus
    fail.
    
    Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

commit e2ec771a99a5cf231c9dea4da26238bf073e1e9c
Author: Coly Li <bosong.ly@taobao.com>
Date:   Sun Mar 27 01:26:52 2011 +0800

    dma: use BUG_ON correctly in iop-adma.c, v4
    
    This patch makes BUG_ON() usage correct in drivers/dma/iop-adma.c.
    
    Cc: Dan Williams <dan.j.williams@intel.com>
    Cc: Vinod Koul <vinod.koul@intel.com>
    Signed-off-by: Coly Li <bosong.ly@taobao.com>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

commit 7912d30007d0c958bcf11cd5ce19f77856cf041b
Author: Coly Li <bosong.ly@taobao.com>
Date:   Sun Mar 27 01:26:53 2011 +0800

    dma: use BUG_ON correctly in mv_xor.c, v4
    
    This patch makes BUG_ON() usage correct in drivers/dma/mv_xor.c
    
    Cc: Vinod Koul <vinod.koul@intel.com>
    Cc: Dan Williams <dan.j.williams@intel.com>
    Signed-off-by: Coly Li <bosong.ly@taobao.com>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

commit 427cdf19b97e509e21e5d347e18d8b0b34723dfc
Author: Coly Li <bosong.ly@taobao.com>
Date:   Sun Mar 27 01:26:54 2011 +0800

    dma: use BUG_ON correctly in ppc4xx/adam.c, v4
    
    This patch makes BUG_ON() usage correct in drivers/dma/ppc4xx/adam.c
    
    Cc: Vinod Koul <vinod.koul@intel.com>
    Cc: Dan Williams <dan.j.williams@intel.com>
    Cc: Grant Likely <grant.likely@secretlab.ca>
    Cc: Anatolij Gustschin <agust@denx.de>
    Cc: Sean MacLennan <smaclennan@pikatech.com>
    Cc: Joe Perches <joe@perches.com>
    Signed-off-by: Coly Li <bosong.ly@taobao.com>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

commit e2142df7ec7184ed4a77ada686bc1eb41075490f
Author: Kristen Carlson Accardi <kristen@linux.intel.com>
Date:   Thu Mar 31 11:02:43 2011 -0700

    intel_mid_dma: fix runtime pm issues
    
    Use the correct api in probe to enable runtime pm for this driver.
    Additionally, do not just call legacy suspend for runtime_suspend,
    as this duplicates some work the pci core does for you.
    
    Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

commit 8194145dcc9562387d93054a4fcf79438d3c3e40
Merge: 0ce790e e2142df
Author: Vinod Koul <vinod.koul@intel.com>
Date:   Wed Apr 6 11:51:12 2011 +0530

    Merge branch 'old_next' into next

commit 364de77831213be20f7f33c39ca1c194593b5c11
Author: Liu Yuan <tailai.ly@taobao.com>
Date:   Sat Apr 2 14:20:47 2011 +0800

    drivers, pch_dma: Fix uninitialized var before use
    
    In the function pdc_desc_get(), var 'i' is not
    initialized before use. This patch fixes it.
    
    Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

commit 9b3aa589eaa1366200062ce1f9cc7ddca8d1d578
Author: Nicolas Ferre <nicolas.ferre@atmel.com>
Date:   Sat Apr 30 16:57:45 2011 +0200

    dmaengine: at_hdmac: modify way to use interrupts
    
    Now we use Buffer Transfer Completed interrupts. If we
    want a chained buffer completed information, we setup the
    ATC_IEN bit in CTRLB register in the lli.
    This is done by set_desc_eol() function and used by
    memcpy/slave_sg functions.
    
    Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

commit 53830cc75974a199b6b654c062ff8c54c58caa0b
Author: Nicolas Ferre <nicolas.ferre@atmel.com>
Date:   Sat Apr 30 16:57:46 2011 +0200

    dmaengine: at_hdmac: add cyclic DMA operation support
    
    Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

commit cc52a10a048fc1fbe4ffba58c2f0afc79ae0f56f
Author: Nicolas Ferre <nicolas.ferre@atmel.com>
Date:   Sat Apr 30 16:57:47 2011 +0200

    dmaengine: at_hdmac: debug information sg_len for prep_slave_sg
    
    Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

commit 2f432823ec6e693d7b934e805ce1838f41d66ce7
Author: Nicolas Ferre <nicolas.ferre@atmel.com>
Date:   Sat Apr 30 16:57:48 2011 +0200

    dmaengine: at_hdmac: remove channel status testing in tasklet
    
    There is no need to test if channel is enabled in tasklet:
    - in error path, channel is disabled in interrupt routine
    - in normal path, this test is performed in sub functions to report
    a misuse of the engine.
    
    Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

commit ae14d4b5e0a4ebc4e674831cbb97b73ba66dba08
Author: Nicolas Ferre <nicolas.ferre@atmel.com>
Date:   Sat Apr 30 16:57:49 2011 +0200

    dmaengine: at_hdmac: specialize AHB interfaces to optimize transfers
    
    DMA controller has two AHB interfaces on the SOC internal
    matrix.
    It is more efficient to specialize each interface as the
    access to memory can introduce latencies that are not compatible
    with peripheral accesses requirements.
    
    Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

commit 711b9cea92554be6bd44f04f2485582d762fc441
Author: Philippe Langlais <philippe.langlais@linaro.org>
Date:   Sat May 7 17:09:43 2011 +0200

    dmaengine/ste_dma40: fix introduced warnings
    
    The compiler nowadays moans about possibly non-assigned variable.
    Fix this by default-assigning 0.
    
    Signed-off-by: Philippe Langlais <philippe.langlais@linaro.org>
    Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

commit 543aabc7d295bfe2489f184259395e3467520d48
Author: Nicolas Ferre <nicolas.ferre@atmel.com>
Date:   Fri May 6 19:56:51 2011 +0200

    dmaengine: at_hdmac: set residue as total len in atc_tx_status
    
    If transfer status is !=DMA_SUCCESS, return total transfer len as residue,
    instead of zero.
    
    Idea from dw_dmac patch by Viresh Kumar.
    
    Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

commit 23b5e3ad68a3c26a6a36039ea907997664aedcab
Author: Nicolas Ferre <nicolas.ferre@atmel.com>
Date:   Fri May 6 19:56:52 2011 +0200

    dmaengine: at_hdmac: implement pause and resume in atc_control
    
    Pause and resume controls are useful for audio devices. This also returns
    correct status from atc_tx_status() in case chan is paused.
    
    Idea from dw_dmac patch by Linus Walleij.
    
    Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
    Acked-by: Linus Walleij <linus.walleij@linaro.org>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

commit e257e1563f28890f54b5f82861373bb4b32dd770
Author: Nicolas Ferre <nicolas.ferre@atmel.com>
Date:   Fri May 6 19:56:53 2011 +0200

    dmaengine: at_hdmac: use descriptor chaining help function
    
    A little function helps to chain descriptors:
    it is already used in cyclic dma operations, now use it in memcpy and slave_sg
    preparation functions.
    
    Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

commit c8fcba600c46c5d7667ec230b1d9ce3ce5859f9c
Author: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Date:   Mon May 9 16:09:35 2011 +0900

    pch_dma: fix dma direction issue for ML7213 IOH video-in
    
    Currently, even-channel number is set as tx direction and odd is set as rx.
    However, though video-in uses ch6, the direction is not tx but rx.
    This patch sets video-in's DMA direction correctly.
    
    Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

commit 08645fdc7bab4564f7dfd07525da8a1761f8f106
Author: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Date:   Mon May 9 16:09:36 2011 +0900

    pch_dma: modify for checkpatch
    
    Fix checkpatch warnings.
    
    Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

commit 60092d0bde4c8741198da4a69b693d3709385bf1
Author: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Date:   Mon May 9 16:09:37 2011 +0900

    pch_dma: Fix DMA setting issue
    
    Currently, Direct-Start mode(*) is enabled.
    Our IOH's devices must not use this mode.
    This causes unexpected behavior.
    This patch deletes Direct-Start setting.
    (*) This mode is used in order for CPU to generate the DMA request.
    
    Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

commit 194f5f2706c7472f9c6bb2d17fa788993606581f
Author: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Date:   Mon May 9 16:09:38 2011 +0900

    pch_dma: Support I2S for ML7213 IOH
    
    Support I2S device for ML7213 IOH
    
    Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

commit c0dfc04ac96847913a791f5459f4ac83a81a4745
Author: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Date:   Mon May 9 16:09:39 2011 +0900

    pch_dma: Support new device ML7223 IOH
    
    Support new device OKI SEMICONDUCTOR ML7223 IOH(Input/Output Hub).
    The ML7223 IOH is for MP(Media Phone) use.
    The ML7223 is companion chip for Intel Atom E6xx series.
    The ML7223 is completely compatible for Intel EG20T PCH.
    
    Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

commit eb8590b504caacb029dea4540e0b0dcc98da4381
Author: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Date:   Mon May 9 16:09:40 2011 +0900

    pch_dma: modify pci device table definition
    
    Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

commit de7a2f9f7b6f5b48d8531ff4c9c9b95cab8a8ce8
Author: Nicolas Ferre <nicolas.ferre@atmel.com>
Date:   Mon May 9 18:11:37 2011 +0200

    dmaengine: at_hdmac: pause: no need to wait for FIFO empty
    
    With the addition of the "pause" feature, an active wait was introduced
    to check the "FIFO empty" event. This event was not always happening and
    a timout contition was needed.
    But, in some cases, this event depend on the peripheral connected to the
    channel that is paused: FIFO becomes empty if the peripheral consumes data.
    The timeout is pretty difficult to evaluate. Moreover, this check is not
    needed.
    In conclusion, it seems sensible to entirely remove the checking of
    "FIFO empty" status when pausing.
    
    Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
    [commit msg edited for grammer]
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

commit 5fedefb87bd0a64281d28edd295f29e3b989d78c
Author: Viresh Kumar <viresh.kumar@st.com>
Date:   Fri Apr 15 16:03:35 2011 +0530

    dmaengine/dw_dmac: don't call callback routine in case dmaengine_terminate_all() is called
    
    If dmaengine_terminate_all() is called for dma channel, then it doesn't make
    much sense to call registered callback routine. While in case of success or
    failure it must be called.
    
    Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

commit abf53902dcc6d44d2e06b09817fa67857aa686fe
Author: Viresh Kumar <viresh.kumar@st.com>
Date:   Fri Apr 15 16:03:35 2011 +0530

    dmaengine/dw_dmac: set residue as total len in dwc_tx_status if status is !DMA_SUCCESS
    
    If transfer status is !=DMA_SUCCESS, return total transfer len as residue,
    instead of zero.
    
    Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

commit 69dc14b51c1aad9d82afd8f96bf4e4835089bffc
Author: Viresh Kumar <viresh.kumar@st.com>
Date:   Mon Apr 18 14:54:56 2011 +0530

    dmaengine/dw_dmac: Divide one sg to many desc, if sg len is greater than DWC_MAX_COUNT
    
    If len passed in sg for slave_sg transfers is greater than DWC_MAX_COUNT, then
    driver programmes controller incorrectly.  This patch adds code to handle this
    situation by allocation more than one desc for same sg.
    
    Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

commit 69cea5a00d3135677939fce1fefe54ed522055a0
Author: Viresh Kumar <viresh.kumar@st.com>
Date:   Fri Apr 15 16:03:35 2011 +0530

    dmaengine/dw_dmac: Replace spin_lock* with irqsave variants and enable submission from callback
    
    dmaengine routines can be called from interrupt context and with interrupts
    disabled.  Whereas spin_unlock_bh can't be called from such contexts. So this
    patch converts all spin_*_bh routines to irqsave variants.
    
    Also, spin_lock() used in tasklet is converted to irqsave variants, as tasklet
    can be interrupted, and dma requests from such interruptions may also call
    spin_lock.
    
    Now, submission from callbacks are permitted as per dmaengine framework. So we
    shouldn't hold any locks while calling callbacks. As locks were taken by parent
    routines, so releasing them before calling callbacks doesn't look clean enough.
    So, locks are taken inside all routine now, whereever they are required. And
    dwc_descriptor_complete is always called without taking locks.
    
    Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

commit a7c57cf7d4327c41510f8cbf45b1b970e02c34f8
Author: Linus Walleij <linus.walleij@linaro.org>
Date:   Tue Apr 19 08:31:32 2011 +0800

    dmaengine/dw_dmac: implement pause and resume in dwc_control
    
    Some peripherals like amba-pl011 needs pause to be implemented in DMA controller
    drivers. This also returns correct status from dwc_tx_status() in case chan is
    paused.
    
    Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
    Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

commit a0eb221a446f2f6c988430f0b0a13f74b7c2b799
Author: Linus Walleij <linus.walleij@stericsson.com>
Date:   Wed May 18 14:18:57 2011 +0200

    dmaengine: move link order
    
    Move the dmaengine subsystem up early in the drivers Makefile so
    DMA is made available early to all drivers, just like e.g.
    regulators. Now even regulators can use DMA on the same initlevel.
    As a result we can bump the ste_dma40 and coh901318 dmaengine
    drivers down one initlevel to subsys_init().
    
    Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

commit aecb7b64dd9e2512c7a4c7e61dd781415d3dac5a
Author: Viresh Kumar <viresh.kumar@st.com>
Date:   Tue May 24 14:04:09 2011 +0530

    dmaengine/dw_dmac: Update maintainer-ship
    
    Nobody is currently maintaining dw_dmac. We are using dw_dmac for SPEAr13xx and
    are currently maintaining it. After discussing with Vinod, sending this patch to
    update maintainer-ship of dw_dmac.
    
    Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
    Acked-by: Havard Skinnemoen <hskinnemoen@gmail.com>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

commit f2889fee8c7fe0ac9752186d43f9486392bb204d
Merge: 6221f222 aecb7b6
Author: Vinod Koul <vinod.koul@intel.com>
Date:   Wed May 25 18:34:07 2011 +0530

    Merge branch 'next' into for-linus

commit 46b2903c05b248ed78304113ecfba368b4c55def
Author: Vinod Koul <vinod.koul@intel.com>
Date:   Wed May 25 14:49:20 2011 -0700

    dmaengine: Add API documentation for slave dma usage
    
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit bc9af76b1e87e4f925f97368dae6c22266922e8b
Author: Vinod Koul <vinod.koul@intel.com>
Date:   Wed May 25 16:56:34 2011 +0530

    dmaengine: add TODO items for future work on dma drivers
    
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 5dbd05d46fb7d849570c8fa09d48591aa7ce1766
Author: Vinod Koul <vinod.koul@intel.com>
Date:   Wed May 25 23:36:30 2011 +0530

    maintainers: add dma engine tree details
    
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 19d78a61be6dd707dcec298c486303d4ba2c840a
Author: Dimitri Sivanich <sivanich@sgi.com>
Date:   Fri May 6 10:33:44 2011 -0500

    x86: poll waiting for I/OAT DMA channel status
    
    For certain system configurations a 5 usec udelay before checking I/OAT DMA
    channel status is sometimes not sufficient, resulting in a false failure
    status and unnecessary freeing of channel resources.  Conversely, for many
    configurations 5 usec is longer than necessary.
    
    Loop for up to 20 usec waiting for successful status before failing.
    
    Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>


