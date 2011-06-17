Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab1FQLCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 07:02:37 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37215 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab1FQLCg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 07:02:36 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=v7nOaDmdUr2FscNtou-5vRhhmyw@mail.gmail.com>
References: <1306360653-6196-1-git-send-email-per.forlin@linaro.org>
	<BANLkTi=v7nOaDmdUr2FscNtou-5vRhhmyw@mail.gmail.com>
Date: Fri, 17 Jun 2011 13:02:34 +0200
Message-ID: <BANLkTinFr-vq+nPKZ67Bc40yZNTy9znZgQ@mail.gmail.com>
Subject: Re: [PATCH v4 00/12] mmc: use nonblock mmc requests to minimize latency
From: Per Forlin <per.forlin@linaro.org>
To: "S, Venkatraman" <svenkatr@ti.com>
Cc: linux-mmc <linux-mmc@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linaro-dev <linaro-dev@lists.linaro.org>,
        David Vrabel <david.vrabel@csr.com>, Chris Ball <cjb@laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 June 2011 15:39, S, Venkatraman <svenkatr@ti.com> wrote:
> On Thu, May 26, 2011 at 3:27 AM, Per Forlin <per.forlin@linaro.org> wrote:
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
>> and Panda on eMMC and SD shows significant performance gain for large
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
>> Changes since v3:
>>  * Based on 2.6.39-rc7
>>  * Add error check for testlist in mmc_test.c
>>  * Resolve in mmc-queue-thread that caused the mmc-thread to miss a wakeup.
>>  * Move parallel request handling to core.c. This simplifies the interface
>>   from 4 public functions to 1. This also gives access for SDIO to use the
>>   same functionallity, even though the function is not tuned for the SDIO
>>   execution flow yet.
>>
>> Per Forlin (12):
>>  mmc: add none blocking mmc request function
>>  omap_hsmmc: use original sg_len for dma_unmap_sg
>>  omap_hsmmc: add support for pre_req and post_req
>>  mmci: implement pre_req() and post_req()
>>  mmc: mmc_test: add debugfs file to list all tests
>>  mmc: mmc_test: add test for none blocking transfers
>>  mmc: add member in mmc queue struct to hold request data
>>  mmc: add a block request prepare function
>>  mmc: move error code in mmc_block_issue_rw_rq to a separate function.
>>  mmc: add a second mmc queue request member
>>  mmc: test: add random fault injection in core.c
>>  mmc: add handling for two parallel block requests in issue_rw_rq
>>
>>  drivers/mmc/card/block.c      |  452 +++++++++++++++++++++++++----------------
>>  drivers/mmc/card/mmc_test.c   |  361 ++++++++++++++++++++++++++++++++-
>>  drivers/mmc/card/queue.c      |  184 +++++++++++------
>>  drivers/mmc/card/queue.h      |   32 +++-
>>  drivers/mmc/core/core.c       |  165 ++++++++++++++-
>>  drivers/mmc/core/debugfs.c    |    5 +
>>  drivers/mmc/host/mmci.c       |  146 ++++++++++++--
>>  drivers/mmc/host/mmci.h       |    8 +
>>  drivers/mmc/host/omap_hsmmc.c |   90 ++++++++-
>>  include/linux/mmc/core.h      |    6 +-
>>  include/linux/mmc/host.h      |   19 ++
>>  lib/Kconfig.debug             |   11 +
>>  12 files changed, 1187 insertions(+), 292 deletions(-)
>>
>
> Nitpick.. The mmc_test.c changes should be at the end of the series,
> after the async feature is available.
>
mmc_test sits on top of core.c It doesn't test any code in the mmc
block device. I use DT (data test) together with random fault
generation to verify the mmc block device code.

>>  mmc: add none blocking mmc request function
>>  omap_hsmmc: use original sg_len for dma_unmap_sg
>>  omap_hsmmc: add support for pre_req and post_req
>>  mmci: implement pre_req() and post_req()
>>  mmc: mmc_test: add debugfs file to list all tests
>>  mmc: mmc_test: add test for none blocking transfers
These patches are enough to run mmc_tests for async request for
omap_hsmmc and mmci.

Regards,
Per
