Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab0JGXdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 19:33:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:31474 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab0JGXdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 19:33:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,299,1283756400"; 
   d="scan'208";a="844917913"
Message-ID: <4CAE58B5.1030901@intel.com>
Date: Thu, 07 Oct 2010 16:33:09 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Ilya Yanok <yanok@emcraft.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Vladimir K'" <vlad@emcraft.com>, Wolfgang Denk <wd@denx.de>
Subject: Re: [RFC] CONFIG_NET_DMA  can hang the system if DMA engine driver
 uses tasklets
References: <4CAE5445.4020106@emcraft.com>
In-Reply-To: <4CAE5445.4020106@emcraft.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/7/2010 4:14 PM, Ilya Yanok wrote:
[..]
> We can see that the network stack calls dma_memcpy_to_iovec() function
> from the softirq context and it never returns in case of DMA driver runs
> out of descriptors and thus blocks the tasklet from being executed. We
> have a deadlock.
>
> Dan, I'd like to ask your opinion, do you think this is a problem of
> CONFIG_NET_DMA feature implementation or should the DMA engine drivers
> be aware of it? How should we fix it?
>
> I can imagine the following possible solutions:
> 1. Add a possibility to return a failure to the dma_memcpy_to_iovec()
> function (and reschedule it from the upper level) to give tasklets a
> chance to be executed.
> 2. Place a restriction on the DMA drivers that descriptors should be
> freed from the hard-irq context, not soft-irq and fix the existing drivers.
> 3. Try to free the descriptors not only from tasklet but also from the
> place they get requested.

This is what ioatdma and iop-adma do i.e. process descriptor reclaim 
from the allocation failure path.  For example in ioat2_check_space_lock():

    /* progress reclaim in the allocation failure case we may be
     * called under bh_disabled so we need to trigger the timer
     * event directly
     */
    if (jiffies > chan->timer.expires && timer_pending(&chan->timer)) {
            struct ioatdma_device *device = chan->device;

            mod_timer(&chan->timer, jiffies + COMPLETION_TIMEOUT);
            device->timer_fn((unsigned long) &chan->common);
    }

The assumption is that a free descriptor is always a short time delay.

> Maybe somebody has a better solution.

Not really, but extending dmatest with a test for this expectation would 
help make this more clear but it would need a config option that injects 
descriptor allocation failures.

--
Dan
