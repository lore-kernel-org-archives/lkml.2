Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab1EGTPb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 15:15:31 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53012 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973Ab1EGTP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 15:15:28 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v3 00/12] mmc: use nonblock mmc requests to minimize latency
Date: Sat,  7 May 2011 21:14:54 +0200
Message-Id: <1304795706-27308-1-git-send-email-per.forlin@linaro.org>
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

The intention for introducing none blocking mmc requests is to minimize the
time between a mmc request ends and another mmc request starts. In the
current implementation the MMC controller is idle when dma_map_sg and
dma_unmap_sg is processing. Introducing none blocking mmc request makes it
possible to prepare the caches for next job parallel with an active
mmc request.

This is done by making the issue_rw_rq() none blocking.
The increase in throughput is proportional to the time it takes to
prepare (major part of preparations is dma_map_sg and dma_unmap_sg)
a request and how fast the memory is. The faster the MMC/SD is
the more significant the prepare request time becomes. Measurements on U5500
and Panda on eMMC and SD shows significant performance gain for for large
reads when running DMA mode. In the PIO case the performance is unchanged.

There are two optional hooks pre_req() and post_req() that the host driver
may implement in order to move work to before and after the actual mmc_request
function is called. In the DMA case pre_req() may do dma_map_sg() and prepare
the dma descriptor and post_req runs the dma_unmap_sg.

Details on measurements from IOZone and mmc_test:
https://wiki.linaro.org/WorkingGroups/Kernel/Specs/StoragePerfMMC-async-req

Under consideration:
 * Make pre_req and post_req private to core.c.
 * Generalize implementation and make it available for SDIO. 

Changes since v2:
 * Fix compile warnings in core.c and block.c
 * Simplify max transfer size in mmc_test
 * set TASK_RUNNING in queue.c before issue_req()

Per Forlin (12):
  mmc: add none blocking mmc request function
  mmc: mmc_test: add debugfs file to list all tests
  mmc: mmc_test: add test for none blocking transfers
  mmc: add member in mmc queue struct to hold request data
  mmc: add a block request prepare function
  mmc: move error code in mmc_block_issue_rw_rq to a separate function.
  mmc: add a second mmc queue request member
  mmc: add handling for two parallel block requests in issue_rw_rq
  mmc: test: add random fault injection in core.c
  omap_hsmmc: use original sg_len for dma_unmap_sg
  omap_hsmmc: add support for pre_req and post_req
  mmci: implement pre_req() and post_req()

 drivers/mmc/card/block.c      |  493 +++++++++++++++++++++++++++--------------
 drivers/mmc/card/mmc_test.c   |  340 +++++++++++++++++++++++++++-
 drivers/mmc/card/queue.c      |  180 ++++++++++------
 drivers/mmc/card/queue.h      |   31 ++-
 drivers/mmc/core/core.c       |  132 ++++++++++-
 drivers/mmc/core/debugfs.c    |    5 +
 drivers/mmc/host/mmci.c       |  146 +++++++++++-
 drivers/mmc/host/mmci.h       |    8 +
 drivers/mmc/host/omap_hsmmc.c |   90 +++++++-
 include/linux/mmc/core.h      |    9 +-
 include/linux/mmc/host.h      |   13 +-
 lib/Kconfig.debug             |   11 +
 12 files changed, 1174 insertions(+), 284 deletions(-)

-- 
1.7.4.1

