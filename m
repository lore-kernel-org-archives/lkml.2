Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab1F1JzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 05:55:07 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40717 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271Ab1F1Jyv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 05:54:51 -0400
MIME-Version: 1.0
In-Reply-To: <1309248717-14606-1-git-send-email-per.forlin@linaro.org>
References: <1309248717-14606-1-git-send-email-per.forlin@linaro.org>
Date: Tue, 28 Jun 2011 18:54:50 +0900
X-Google-Sender-Auth: tnohfobs1qBCVjp19U68HDaGf8g
Message-ID: <BANLkTinzOj-Uw3o__2=kHYqHwMW1BtAktQ@mail.gmail.com>
Subject: Re: [PATCH v8 00/12] use nonblock mmc requests to minimize latency
From: Kyungmin Park <kmpark@infradead.org>
To: Per Forlin <per.forlin@linaro.org>
Cc: linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org,
        Nickolay Nickolaev <nicknickolaev@gmail.com>,
        Venkatraman S <svenkatr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches are tested on samsung exynos4 platform.

Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

On Tue, Jun 28, 2011 at 5:11 PM, Per Forlin <per.forlin@linaro.org> wrote:
> How significant is the cache maintenance over head?
> It depends, the eMMC are much faster now
> compared to a few years ago and cache maintenance cost more due to
> multiple cache levels and speculative cache pre-fetch. In relation the
> cost for handling the caches have increased and is now a bottle neck
> dealing with fast eMMC together with DMA.
>
> The intention for introducing non-blocking mmc requests is to minimize the
> time between a mmc request ends and another mmc request starts. In the
> current implementation the MMC controller is idle when dma_map_sg and
> dma_unmap_sg is processing. Introducing non-blocking mmc request makes it
> possible to prepare the caches for next job in parallel to an active
> mmc request.
>
> This is done by making the issue_rw_rq() non-blocking.
> The increase in throughput is proportional to the time it takes to
> prepare (major part of preparations is dma_map_sg and dma_unmap_sg)
> a request and how fast the memory is. The faster the MMC/SD is
> the more significant the prepare request time becomes. Measurements on U5500
> and Panda on eMMC and SD shows significant performance gain for large
> reads when running DMA mode. In the PIO case the performance is unchanged.
>
> There are two optional hooks pre_req() and post_req() that the host driver
> may implement in order to move work to before and after the actual mmc_request
> function is called. In the DMA case pre_req() may do dma_map_sg() and prepare
> the dma descriptor and post_req runs the dma_unmap_sg.
>
> Details on measurements from IOZone and mmc_test:
> https://wiki.linaro.org/WorkingGroups/Kernel/Specs/StoragePerfMMC-async-req
>
> Changes since v7:
>  * rebase on mmc-next, on top of Russell's updated error handling.
>  * Clarify description of mmc_start_req()
>  * Resolve compile without CONFIG_DMA_ENIGNE issue for mmci
>  * Add mmc test to measure how performance is affected by sg length
>  * Add missing wait_for_busy in mmc_test non-blocking test. This call got lost
>   in v4 of this patchset when refactoring mmc_start_req.
>  * Add sub-prefix (core block queue) to relevant patches.
>
> Per Forlin (12):
>  mmc: core: add non-blocking mmc request function
>  omap_hsmmc: add support for pre_req and post_req
>  mmci: implement pre_req() and post_req()
>  mmc: mmc_test: add debugfs file to list all tests
>  mmc: mmc_test: add test for non-blocking transfers
>  mmc: mmc_test: test to measure how sg_len affect performance
>  mmc: block: add member in mmc queue struct to hold request data
>  mmc: block: add a block request prepare function
>  mmc: block: move error code in issue_rw_rq to a separate function.
>  mmc: queue: add a second mmc queue request member
>  mmc: core: add random fault injection
>  mmc: block: add handling for two parallel block requests in
>    issue_rw_rq
>
>  drivers/mmc/card/block.c      |  505 ++++++++++++++++++++++++-----------------
>  drivers/mmc/card/mmc_test.c   |  491 ++++++++++++++++++++++++++++++++++++++--
>  drivers/mmc/card/queue.c      |  184 ++++++++++------
>  drivers/mmc/card/queue.h      |   33 ++-
>  drivers/mmc/core/core.c       |  167 +++++++++++++-
>  drivers/mmc/core/debugfs.c    |    5 +
>  drivers/mmc/host/mmci.c       |  147 +++++++++++-
>  drivers/mmc/host/mmci.h       |    8 +
>  drivers/mmc/host/omap_hsmmc.c |   87 +++++++-
>  include/linux/mmc/core.h      |    6 +-
>  include/linux/mmc/host.h      |   24 ++
>  lib/Kconfig.debug             |   11 +
>  12 files changed, 1345 insertions(+), 323 deletions(-)
>
> --
> 1.7.4.1
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
