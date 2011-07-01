Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab1GAQ4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 12:56:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62813 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab1GAQ4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 12:56:08 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, Venkatraman S <svenkatr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Sourav Poddar <sourav.poddar@ti.com>,
        Chris Ball <cjb@laptop.org>
Cc: Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v9 00/12] use nonblock mmc requests to minimize latency
Date: Fri,  1 Jul 2011 18:55:21 +0200
Message-Id: <1309539333-2606-1-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How significant is the cache maintenance over head?
It depends, the eMMC are much faster now
compared to a few years ago and cache maintenance cost more due to
multiple cache levels and speculative cache pre-fetch. In relation the
cost for handling the caches have increased and is now a bottle neck
dealing with fast eMMC together with DMA.

The intention for introducing non-blocking mmc requests is to minimize the
time between a mmc request ends and another mmc request starts. In the
current implementation the MMC controller is idle when dma_map_sg and
dma_unmap_sg is processing. Introducing non-blocking mmc request makes it
possible to prepare the caches for next job in parallel to an active
mmc request.

This is done by making the issue_rw_rq() non-blocking.
The increase in throughput is proportional to the time it takes to
prepare (major part of preparations is dma_map_sg and dma_unmap_sg)
a request and how fast the memory is. The faster the MMC/SD is
the more significant the prepare request time becomes. Measurements on U5500
and Panda on eMMC and SD shows significant performance gain for large
reads when running DMA mode. In the PIO case the performance is unchanged.

There are two optional hooks pre_req() and post_req() that the host driver
may implement in order to move work to before and after the actual mmc_request
function is called. In the DMA case pre_req() may do dma_map_sg() and prepare
the dma descriptor and post_req runs the dma_unmap_sg.

Details on measurements from IOZone and mmc_test:
https://wiki.linaro.org/WorkingGroups/Kernel/Specs/StoragePerfMMC-async-req

Tested on platforms
 * Development and extensive testing is done on ux500 and Pandaboard
 * Additional testing is done on
  * Patches are tested on samsung exynos4 platform
  * Boot tested on Omap4430 Blaze board
  * U300 MMC/PL180 mmc_test and ad hoc FS test
  * ARM realview mmc_test and ad hoc FS test

Changes since v8:
 * add comment to clarify bug print in issue_rw_rq.
 * mmc_test:
   * align size for sg_len test cases,
   * use MAX_SIZE define for test size for all non-blocking,
   * allow non-blocking test even if pre/post is not implemented,
   * return error if only one of pre or post is implemented.

Per Forlin (12):
  mmc: core: add non-blocking mmc request function
  omap_hsmmc: add support for pre_req and post_req
  mmci: implement pre_req() and post_req()
  mmc: mmc_test: add debugfs file to list all tests
  mmc: mmc_test: add test for non-blocking transfers
  mmc: mmc_test: test to measure how sg_len affect performance
  mmc: block: add member in mmc queue struct to hold request data
  mmc: block: add a block request prepare function
  mmc: block: move error code in issue_rw_rq to a separate function.
  mmc: queue: add a second mmc queue request member
  mmc: core: add random fault injection
  mmc: block: add handling for two parallel block requests in
    issue_rw_rq

 drivers/mmc/card/block.c      |  507 ++++++++++++++++++++++++----------------
 drivers/mmc/card/mmc_test.c   |  498 +++++++++++++++++++++++++++++++++++++++--
 drivers/mmc/card/queue.c      |  184 ++++++++++------
 drivers/mmc/card/queue.h      |   33 ++-
 drivers/mmc/core/core.c       |  167 +++++++++++++-
 drivers/mmc/core/debugfs.c    |    5 +
 drivers/mmc/host/mmci.c       |  147 +++++++++++-
 drivers/mmc/host/mmci.h       |    8 +
 drivers/mmc/host/omap_hsmmc.c |   87 +++++++-
 include/linux/mmc/core.h      |    6 +-
 include/linux/mmc/host.h      |   24 ++
 lib/Kconfig.debug             |   11 +
 12 files changed, 1356 insertions(+), 321 deletions(-)

-- 
1.7.4.1

