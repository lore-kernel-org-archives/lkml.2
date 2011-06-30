Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab1F3NNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 09:13:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54010 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab1F3NMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 09:12:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v8 00/12] use nonblock mmc requests to minimize latency
Date: Thu, 30 Jun 2011 15:12:46 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Per Forlin <per.forlin@linaro.org>, linaro-dev@lists.linaro.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org,
        Nickolay Nickolaev <nicknickolaev@gmail.com>,
        Venkatraman S <svenkatr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>
References: <1309248717-14606-1-git-send-email-per.forlin@linaro.org>
In-Reply-To: <1309248717-14606-1-git-send-email-per.forlin@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106301512.46788.arnd@arndb.de>
X-Provags-ID: V02:K0:25I16rQkQp5DJaO66+PNW4ETN2DJOfd6Dq/FQBU3vmZ
 LciMDKfXjmXxumrk4TMLbuhEnNXbZhZxDkGyg7G7muaNQVDLnj
 rXWVcgvSavSTEHSVCRxZ32JcIu5ueKevQZKukZ4z7XLDOinfSQ
 0u9gwtQWJPdOU7mokpHQiQyVHg0NDNV7RSD2WX+koxUHZtjE/G
 FLxsaQvj0Y16Z6YxuDe1g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 June 2011, Per Forlin wrote:
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

I think this looks good enough to merge into the linux-mmc tree, the code is
clean and the benefits are clear.

Acked-by: Arnd Bergmann <arnd@arndb.de>

One logical follow-up as both a cleanup and performance optimization would be
to get rid of the mmc_queue_thread completely. When mmc_blk_issue_rq() is
non-blocking always, you can call it directly from the mmc_request()
function, instead of waking up another thread to do it for you.

	Arnd
