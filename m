Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150Ab1GLAWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 20:22:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:44752 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574Ab1GLAWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 20:22:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,517,1304319600"; 
   d="scan'208";a="25962122"
Message-ID: <4E1B93CF.60700@linux.intel.com>
Date: Mon, 11 Jul 2011 17:22:39 -0700
From: J Freyensee <james_p_freyensee@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110628 Thunderbird/5.0
MIME-Version: 1.0
To: Per Forlin <per.forlin@linaro.org>
CC: linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-doc@vger.kernel.org,
        Venkatraman S <svenkatr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Sourav Poddar <sourav.poddar@ti.com>,
        Chris Ball <cjb@laptop.org>, Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH v6] mmc: documentation of mmc non-blocking request usage
 and design.
References: <1310325719-2151-1-git-send-email-per.forlin@linaro.org>
In-Reply-To: <1310325719-2151-1-git-send-email-per.forlin@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2011 12:21 PM, Per Forlin wrote:
> Documentation about the background and the design of mmc non-blocking.
> Host driver guidelines to minimize request preparation overhead.
>
> Signed-off-by: Per Forlin<per.forlin@linaro.org>
> Acked-by: Randy Dunlap<rdunlap@xenotime.net>
> ---
> ChangeLog:
>   v2: - Minor updates after proofreading comments from Chris
>   v3: - Minor updates after more comments from Chris
>   v4: - Minor updates after comments from Randy
>   v5: - Fixed one more comment and Acked-by from Randy
>   v6: - Write out full function names and use () for all functions,
>         feedback from James.
>
>   Documentation/mmc/00-INDEX          |    2 +
>   Documentation/mmc/mmc-async-req.txt |   88 +++++++++++++++++++++++++++++++++++
>   2 files changed, 90 insertions(+), 0 deletions(-)
>   create mode 100644 Documentation/mmc/mmc-async-req.txt
>
> diff --git a/Documentation/mmc/00-INDEX b/Documentation/mmc/00-INDEX
> index 93dd7a7..a9ba672 100644
> --- a/Documentation/mmc/00-INDEX
> +++ b/Documentation/mmc/00-INDEX
> @@ -4,3 +4,5 @@ mmc-dev-attrs.txt
>           - info on SD and MMC device attributes
>   mmc-dev-parts.txt
>           - info on SD and MMC device partitions
> +mmc-async-req.txt
> +        - info on mmc asynchronous requests
> diff --git a/Documentation/mmc/mmc-async-req.txt b/Documentation/mmc/mmc-async-req.txt
> new file mode 100644
> index 0000000..aac5634
> --- /dev/null
> +++ b/Documentation/mmc/mmc-async-req.txt
> @@ -0,0 +1,88 @@
> +Rationale
> +=========
> +
> +How significant is the cache maintenance overhead?
> +It depends. Fast eMMC and multiple cache levels with speculative cache
> +pre-fetch makes the cache overhead relatively significant. If the DMA
> +preparations for the next request are done in parallel with the current
> +transfer, the DMA preparation overhead would not affect the MMC performance.
> +The intention of non-blocking (asynchronous) MMC requests is to minimize the
> +time between when an MMC request ends and another MMC request begins.
> +Using mmc_wait_for_req(), the MMC controller is idle while dma_map_sg and
> +dma_unmap_sg are processing. Using non-blocking MMC requests makes it
> +possible to prepare the caches for next job in parallel with an active
> +MMC request.
> +
> +MMC block driver
> +================
> +
> +The mmc_blk_issue_rw_rq() in the MMC block driver is made non-blocking.
> +The increase in throughput is proportional to the time it takes to
> +prepare (major part of preparations are dma_map_sg() and dma_unmap_sg())
> +a request and how fast the memory is. The faster the MMC/SD is
> +the more significant the prepare request time becomes. Roughly the expected
> +performance gain is 5% for large writes and 10% on large reads on a L2 cache
> +platform. In power save mode, when clocks run on a lower frequency, the DMA
> +preparation may cost even more. As long as these slower preparations are run
> +in parallel with the transfer performance won't be affected.
> +
> +Details on measurements from IOZone and mmc_test
> +================================================
> +
> +https://wiki.linaro.org/WorkingGroups/Kernel/Specs/StoragePerfMMC-async-req
> +
> +MMC core API extension
> +======================
> +
> +There is one new public function mmc_start_req().
> +It starts a new MMC command request for a host. The function isn't
> +truly non-blocking. If there is on ongoing async request it waits
> +for completion of that request and starts the new one and returns. It
> +doesn't wait for the new request to complete. If there is no ongoing
> +request it starts the new request and returns immediately.
> +
> +MMC host extensions
> +===================
> +
> +There are two optional members in the
> +mmc_host_ops -- pre_req() and post_req() -- that the host
> +driver may implement in order to move work to before and after the actual
> +mmc_host_ops.request() function is called. In the DMA case pre_req() may do
> +dma_map_sg() and prepare the DMA descriptor, and post_req() runs
> +the dma_unmap_sg().
> +

One question: Is the 'Optimize for the first request' below an example 
of how to use the 'MMC host extensions' above?  So just using 
'mmc_start_req()' in an MMC client driver would not be beneficial if the 
MMC host was not also using the MMC host extensions, right?

Thanks,
Jay

> +Optimize for the first request
> +==============================
> +
> +The first request in a series of requests can't be prepared in parallel with
> +the previous transfer, since there is no previous request.
> +The argument is_first_req in pre_req() indicates that there is no previous
> +request. The host driver may optimize for this scenario to minimize
> +the performance loss. A way to optimize for this is to split the current
> +request in two chunks, prepare the first chunk and start the request,
> +and finally prepare the second chunk and start the transfer.
> +
> +Pseudocode to handle is_first_req scenario with minimal prepare overhead:
> +
> +if (is_first_req&&  req->size>  threshold)
> +   /* start MMC transfer for the complete transfer size */
> +   mmc_start_command(MMC_CMD_TRANSFER_FULL_SIZE);
> +
> +   /*
> +    * Begin to prepare DMA while cmd is being processed by MMC.
> +    * The first chunk of the request should take the same time
> +    * to prepare as the "MMC process command time".
> +    * If prepare time exceeds MMC cmd time
> +    * the transfer is delayed, guesstimate max 4k as first chunk size.
> +    */
> +    prepare_1st_chunk_for_dma(req);
> +    /* flush pending desc to the DMAC (dmaengine.h) */
> +    dma_issue_pending(req->dma_desc);
> +
> +    prepare_2nd_chunk_for_dma(req);
> +    /*
> +     * The second issue_pending should be called before MMC runs out
> +     * of the first chunk. If the MMC runs out of the first data chunk
> +     * before this call, the transfer is delayed.
> +     */
> +    dma_issue_pending(req->dma_desc);

