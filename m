Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab1ALSPE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 13:15:04 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57333 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab1ALSPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 13:15:02 -0500
From: Per Forlin <per.forlin@linaro.org>
To: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@lists.linaro.org
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH 0/5] mmc: add double buffering for mmc block requests
Date: Wed, 12 Jan 2011 19:13:58 +0100
Message-Id: <1294856043-13447-1-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to prepare one MMC request while another is active on
the host. This is done by making the issue_rw_rq() asynchronous.
The increase in throughput is proportional to the time it takes to
prepare a request and how fast the memory is. The faster the MMC/SD is
the more significant the prepare request time becomes. Measurements on U5500
and U8500 on eMMC shows significant performance gain for DMA on MMC for large
reads. In the PIO case there is some gain in performance for large reads too.
There seems to be no or small performance gain for write, don't have a good
explanation for this yet.

There are two optional hooks pre_req() and post_req() that the host driver
may implement in order to improve double buffering. In the DMA case pre_req()
may do dma_map_sg() and prepare the dma descriptor and post_req runs the
dma_unmap_sg.

The mmci host driver implementation for double buffering is not intended
nor ready for mainline yet. It is only an example of how to implement
pre_req() and post_req(). The reason for this is that the basic DMA support
for MMCI is not complete yet. The mmci patches are sent in a separate patch
series "[FYI 0/4] arm: mmci: example implementation of double buffering".

Issues/Questions for issue_rw_rq() in block.c:
* Is it safe to claim the host for the first MMC request and wait to release
  it until the MMC queue is empty again? Or must the host be claimed and
  released for every request?
* Is it possible to predict the result from __blk_end_request().
  If there are no errors for a completed MMC request and the
  blk_rq_bytes(req) == data.bytes_xfered, will it be guaranteed that
  __blk_end_request will return 0?

Here follows the IOZone results for u8500 v1.1 on eMMC.
The numbers for DMA are a bit to good here due to the fact that the
CPU speed is decreased compared to u8500 v2. This makes the cache handling
even more significant.

Command line used: ./iozone -az -i0 -i1 -i2 -s 50m -I -f /iozone.tmp -e -R -+u

Relative diff: VANILLA-MMC-PIO -> 2BUF-MMC-PIO
cpu load is abs diff
                                                        random  random
        KB      reclen  write   rewrite read    reread  read    write
        51200   4       +0%     +0%     +0%     +0%     +0%     +0%
        cpu:            +0.1    -0.1    -0.5    -0.3    -0.1    -0.0

        51200   8       +0%     +0%     +6%     +6%     +8%     +0%
        cpu:            +0.1    -0.1    -0.3    -0.4    -0.8    +0.0

        51200   16      +0%     -2%     +0%     +0%     -3%     +0%
        cpu:            +0.0    -0.2    +0.0    +0.0    -0.2    +0.0

        51200   32      +0%     +1%     +0%     +0%     +0%     +0%
        cpu:            +0.1    +0.0    -0.3    +0.0    +0.0    +0.0

        51200   64      +0%     +0%     +0%     +0%     +0%     +0%
        cpu:            +0.1    +0.0    +0.0    +0.0    +0.0    +0.0

        51200   128     +0%     +1%     +1%     +1%     +1%     +0%
        cpu:            +0.0    +0.2    +0.1    -0.3    +0.4    +0.0

        51200   256     +0%     +0%     +1%     +1%     +1%     +0%
        cpu:            +0.0    -0.0    +0.1    +0.1    +0.1    +0.0

        51200   512     +0%     +1%     +2%     +2%     +2%     +0%
        cpu:            +0.1    +0.0    +0.2    +0.2    +0.2    +0.1

        51200   1024    +0%     +2%     +2%     +2%     +3%     +0%
        cpu:            +0.2    +0.1    +0.2    +0.5    -0.8    +0.0

        51200   2048    +0%     +2%     +3%     +3%     +3%     +0%
        cpu:            +0.0    -0.2    +0.4    +0.8    -0.5    +0.2

        51200   4096    +0%     +1%     +3%     +3%     +3%     +1%
        cpu:            +0.2    +0.1    +0.9    +0.9    +0.5    +0.1

        51200   8192    +1%     +0%     +3%     +3%     +3%     +1%
        cpu:            +0.2    +0.2    +1.3    +1.3    +1.0    +0.0

        51200   16384   +0%     +1%     +3%     +3%     +3%     +1%
        cpu:            +0.2    +0.1    +1.0    +1.3    +1.0    +0.5

Relative diff: VANILLA-MMC-DMA -> 2BUF-MMC-MMCI-DMA
cpu load is abs diff
                                                        random  random
        KB      reclen  write   rewrite read    reread  read    write
        51200   4       +0%     -3%     +6%     +5%     +5%     +0%
        cpu:            +0.0    -0.2    -0.6    -0.1    +0.3    +0.0

        51200   8       +0%     +0%     +7%     +7%     +7%     +0%
        cpu:            +0.0    +0.1    +0.8    +0.6    +0.9    +0.0

        51200   16      +0%     +0%     +7%     +7%     +8%     +0%
        cpu:            +0.0    -0.0    +0.7    +0.7    +0.8    +0.0

        51200   32      +0%     +0%     +8%     +8%     +9%     +0%
        cpu:            +0.0    +0.1    +0.7    +0.7    +0.3    +0.0

        51200   64      +0%     +1%     +9%     +9%     +9%     +0%
        cpu:            +0.0    +0.0    +0.8    +0.7    +0.8    +0.0

        51200   128     +1%     +0%     +13%    +13%    +14%    +0%
        cpu:            +0.2    +0.0    +1.0    +1.0    +1.1    +0.0

        51200   256     +1%     +2%     +8%     +8%     +11%    +0%
        cpu:            +0.0    +0.3    +0.0    +0.7    +1.5    +0.0

        51200   512     +1%     +2%     +16%    +16%    +17%    +0%
        cpu:            +0.2    +0.2    +2.2    +2.1    +2.2    +0.1

        51200   1024    +1%     +2%     +20%    +20%    +20%    +1%
        cpu:            +0.2    +0.1    +2.6    +1.9    +2.6    +0.0

        51200   2048    +0%     +2%     +22%    +22%    +21%    +0%
        cpu:            +0.0    +0.3    +2.3    +2.9    +2.1    -0.0

        51200   4096    +1%     +2%     +23%    +23%    +23%    +1%
        cpu:            +0.2    +0.1    +2.0    +3.2    +3.1    +0.0

        51200   8192    +1%     +5%     +24%    +24%    +24%    +1%
        cpu:            +1.4    -0.0    +4.2    +3.0    +2.8    +0.1

        51200   16384   +1%     +3%     +24%    +24%    +24%    +2%
        cpu:            +0.0    +0.3    +3.4    +3.8    +3.7    +0.1

Here follows the IOZone results for u5500 on eMMC.
These numbers for DMA are more as expected.

Command line used: ./iozone -az -i0 -i1 -i2 -s 50m -I -f /iozone.tmp -e -R -+u

Relative diff: VANILLA-MMC-DMA -> 2BUF-MMC-MMCI-DMA
cpu load is abs diff
                                                        random  random
        KB      reclen  write   rewrite read    reread  read    write
        51200   128     +1%     +1%     +10%    +9%     +10%    +0%
        cpu:            +0.1    +0.0    +1.3    +0.1    +0.8    +0.1

        51200   256     +2%     +2%     +7%     +7%     +9%     +0%
        cpu:            +0.1    +0.4    +0.5    +0.6    +0.7    +0.0

        51200   512     +2%     +2%     +12%    +12%    +12%    +1%
        cpu:            +0.4    +0.6    +1.8    +2.4    +2.4    +0.2

        51200   1024    +2%     +3%     +14%    +14%    +14%    +0%
        cpu:            +0.3    +0.1    +2.1    +1.4    +1.4    +0.2

        51200   2048    +3%     +3%     +16%    +16%    +16%    +1%
        cpu:            +0.2    +0.2    +2.5    +1.8    +2.4    -0.2

        51200   4096    +3%     +3%     +17%    +17%    +18%    +3%
        cpu:            +0.1    -0.1    +2.7    +2.0    +2.7    -0.1

        51200   8192    +3%     +3%     +18%    +18%    +18%    +3%
        cpu:            -0.1    +0.2    +3.0    +2.3    +2.2    +0.2

        51200   16384   +3%     +3%     +18%    +18%    +18%    +4%
        cpu:            +0.2    +0.2    +2.8    +3.5    +2.4    -0.0

Per Forlin (5):
  mmc: add member in mmc queue struct to hold request data
  mmc: Add a block request prepare function
  mmc: Add a second mmc queue request member
  mmc: Store the mmc block request struct in mmc queue
  mmc: Add double buffering for mmc block requests

 drivers/mmc/card/block.c |  337 ++++++++++++++++++++++++++++++----------------
 drivers/mmc/card/queue.c |  171 +++++++++++++++---------
 drivers/mmc/card/queue.h |   31 +++-
 drivers/mmc/core/core.c  |   77 +++++++++--
 include/linux/mmc/core.h |    7 +-
 include/linux/mmc/host.h |    8 +
 6 files changed, 432 insertions(+), 199 deletions(-)

