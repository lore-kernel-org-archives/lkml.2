Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab1EIMfC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 08:35:02 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59386 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab1EIMfA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 08:35:00 -0400
MIME-Version: 1.0
In-Reply-To: <0F831E97-0168-4CD5-985C-4965BFF816A0@marvell.com>
References: <1304795706-27308-1-git-send-email-per.forlin@linaro.org>
	<0F831E97-0168-4CD5-985C-4965BFF816A0@marvell.com>
Date: Mon, 9 May 2011 14:34:58 +0200
Message-ID: <BANLkTikid1yHh6AdgOeqy7NqS8D=W0SWTw@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] mmc: use nonblock mmc requests to minimize latency
From: Per Forlin <per.forlin@linaro.org>
To: Philip Rakity <prakity@marvell.com>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Chris Ball <cjb@laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 May 2011 04:05, Philip Rakity <prakity@marvell.com> wrote:
>
> Hi Per,
>
> We noticed on some of our systems if we ADMA or SDMA and a bounce buffer it is significantly faster then SDMA.
>
I have not done work with ADMA or SDMA. Where should I look to read
more about it?
Are these the right places. DMA iop-dma.c and imx-sdma.c, MMC: sdhci.c.

> I believe ADMA will do large transfers.  Another data point.
>
> Philip
Thanks,
Per

>
> On May 7, 2011, at 12:14 PM, Per Forlin wrote:
>
>> How significant is the cache maintenance over head?
>> It depends, the eMMC are much faster now
>> compared to a few years ago and cache maintenance cost more due to
>> multiple cache levels and speculative cache pre-fetch. In relation the
>> cost for handling the caches have increased and is now a bottle neck
>> dealing with fast eMMC together with DMA.
>>
>> The intention for introducing none blocking mmc requests is to minimize the
>> time between a mmc request ends and another mmc request starts. In the
>> current implementation the MMC controller is idle when dma_map_sg and
>> dma_unmap_sg is processing. Introducing none blocking mmc request makes it
>> possible to prepare the caches for next job parallel with an active
>> mmc request.
>>
>> This is done by making the issue_rw_rq() none blocking.
>> The increase in throughput is proportional to the time it takes to
>> prepare (major part of preparations is dma_map_sg and dma_unmap_sg)
>> a request and how fast the memory is. The faster the MMC/SD is
>> the more significant the prepare request time becomes. Measurements on U5500
>> and Panda on eMMC and SD shows significant performance gain for for large
>> reads when running DMA mode. In the PIO case the performance is unchanged.
>>
>> There are two optional hooks pre_req() and post_req() that the host driver
>> may implement in order to move work to before and after the actual mmc_request
>> function is called. In the DMA case pre_req() may do dma_map_sg() and prepare
>> the dma descriptor and post_req runs the dma_unmap_sg.
>>
>> Details on measurements from IOZone and mmc_test:
>> https://wiki.linaro.org/WorkingGroups/Kernel/Specs/StoragePerfMMC-async-req
>>
>> Under consideration:
>> * Make pre_req and post_req private to core.c.
>> * Generalize implementation and make it available for SDIO.
>>
>> Changes since v2:
>> * Fix compile warnings in core.c and block.c
>> * Simplify max transfer size in mmc_test
>> * set TASK_RUNNING in queue.c before issue_req()
>>
>> Per Forlin (12):
>>  mmc: add none blocking mmc request function
>>  mmc: mmc_test: add debugfs file to list all tests
>>  mmc: mmc_test: add test for none blocking transfers
>>  mmc: add member in mmc queue struct to hold request data
>>  mmc: add a block request prepare function
>>  mmc: move error code in mmc_block_issue_rw_rq to a separate function.
>>  mmc: add a second mmc queue request member
>>  mmc: add handling for two parallel block requests in issue_rw_rq
>>  mmc: test: add random fault injection in core.c
>>  omap_hsmmc: use original sg_len for dma_unmap_sg
>>  omap_hsmmc: add support for pre_req and post_req
>>  mmci: implement pre_req() and post_req()
>>
>> drivers/mmc/card/block.c      |  493 +++++++++++++++++++++++++++--------------
>> drivers/mmc/card/mmc_test.c   |  340 +++++++++++++++++++++++++++-
>> drivers/mmc/card/queue.c      |  180 ++++++++++------
>> drivers/mmc/card/queue.h      |   31 ++-
>> drivers/mmc/core/core.c       |  132 ++++++++++-
>> drivers/mmc/core/debugfs.c    |    5 +
>> drivers/mmc/host/mmci.c       |  146 +++++++++++-
>> drivers/mmc/host/mmci.h       |    8 +
>> drivers/mmc/host/omap_hsmmc.c |   90 +++++++-
>> include/linux/mmc/core.h      |    9 +-
>> include/linux/mmc/host.h      |   13 +-
>> lib/Kconfig.debug             |   11 +
>> 12 files changed, 1174 insertions(+), 284 deletions(-)
>>
>> --
>> 1.7.4.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
