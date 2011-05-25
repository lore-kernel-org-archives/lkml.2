Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab1EYV6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 17:58:14 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38928 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313Ab1EYV6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 17:58:12 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        David Vrabel <david.vrabel@csr.com>
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v4 00/12] mmc: use nonblock mmc requests to minimize latency
Date: Wed, 25 May 2011 23:57:21 +0200
Message-Id: <1306360653-6196-1-git-send-email-per.forlin@linaro.org>
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
and Panda on eMMC and SD shows significant performance gain for large
reads when running DMA mode. In the PIO case the performance is unchanged.

There are two optional hooks pre_req() and post_req() that the host driver
may implement in order to move work to before and after the actual mmc_request
function is called. In the DMA case pre_req() may do dma_map_sg() and prepare
the dma descriptor and post_req runs the dma_unmap_sg.

Details on measurements from IOZone and mmc_test:
https://wiki.linaro.org/WorkingGroups/Kernel/Specs/StoragePerfMMC-async-req

Changes since v3:
 * Based on 2.6.39-rc7
 * Add error check for testlist in mmc_test.c
 * Resolve in mmc-queue-thread that caused the mmc-thread to miss a wakeup.
 * Move parallel request handling to core.c. This simplifies the interface
   from 4 public functions to 1. This also gives access for SDIO to use the
   same functionallity, even though the function is not tuned for the SDIO
   execution flow yet.

Per Forlin (12):
  mmc: add none blocking mmc request function
  omap_hsmmc: use original sg_len for dma_unmap_sg
  omap_hsmmc: add support for pre_req and post_req
  mmci: implement pre_req() and post_req()
  mmc: mmc_test: add debugfs file to list all tests
  mmc: mmc_test: add test for none blocking transfers
  mmc: add member in mmc queue struct to hold request data
  mmc: add a block request prepare function
  mmc: move error code in mmc_block_issue_rw_rq to a separate function.
  mmc: add a second mmc queue request member
  mmc: test: add random fault injection in core.c
  mmc: add handling for two parallel block requests in issue_rw_rq

 drivers/mmc/card/block.c      |  452 +++++++++++++++++++++++++----------------
 drivers/mmc/card/mmc_test.c   |  361 ++++++++++++++++++++++++++++++++-
 drivers/mmc/card/queue.c      |  184 +++++++++++------
 drivers/mmc/card/queue.h      |   32 +++-
 drivers/mmc/core/core.c       |  165 ++++++++++++++-
 drivers/mmc/core/debugfs.c    |    5 +
 drivers/mmc/host/mmci.c       |  146 ++++++++++++--
 drivers/mmc/host/mmci.h       |    8 +
 drivers/mmc/host/omap_hsmmc.c |   90 ++++++++-
 include/linux/mmc/core.h      |    6 +-
 include/linux/mmc/host.h      |   19 ++
 lib/Kconfig.debug             |   11 +
 12 files changed, 1187 insertions(+), 292 deletions(-)

-- 
1.7.4.1

