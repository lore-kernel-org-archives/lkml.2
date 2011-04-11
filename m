Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab1DKKkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 06:40:20 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:55812 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751856Ab1DKKkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 06:40:19 -0400
Message-ID: <4DA2DA6A.6000202@st.com>
Date: Mon, 11 Apr 2011 16:09:38 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Koul, Vinod" <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        amitgoel <amit.goel@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: dmaengine: Can we schedule new transfer from dma callback	routine??
References: <4DA2B3D8.6060707@st.com> <20110411085603.GA13041@n2100.arm.linux.org.uk>
In-Reply-To: <20110411085603.GA13041@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2011 02:26 PM, Russell King - ARM Linux wrote:
> On Mon, Apr 11, 2011 at 01:25:04PM +0530, viresh kumar wrote:
>>
>> Hello,
>>
>> In dw_dmac.c driver, dwc_descriptor_complete() routine, following is
>> mentioned before calling callback:
>>
>> 	/*
>> 	 * The API requires that no submissions are done from a
>> 	 * callback, so we don't need to drop the lock here
>> 	 */
>> 	if (callback)
>> 		callback(param);
>>
>> Does this hold true for dmaengine??
> 
> Not for slave devices - see Dan's reply:
> 
> http://lists.arm.linux.org.uk/lurker/message/20101223.005313.a38d7bf0.en.html
> 
> As the slave API hasn't been well documented, there's a lot of
> inconsistency of behaviour between DMA engine slave implementations.
> I'd suggest at least fixing slave DMA engine drivers to ensure that:
> 
> (a) the callback is always called in tasklet context
> (b) the callback can submit new slave transactions (iow, the spinlock
>     which prep_slave_sg takes must not be held during the callback.)
> 
> The way that others solve this is to move the completed txd structures
> to a local 'completed' list, and then walk this list after the spinlocks
> have been dropped.
> 
> IOW, something like this:
> 
> my_tasklet()
> {
> 	INIT_LIST_HEAD(completed);
> 
> 	spin_lock_irqsave(my_chan->lock);
> 	for_each_txd(my_txd, my_chan) {
> 		if (has_completed(my_txd))
> 			list_add_tail(my_txd->node, &completed);
> 	}
> 	spin_unlock_irqrestore(my_chan->lock);
> 
> 	list_for_each_entry_safe(my_txd, next, &completed, node) {
> 		void *callback_param = my_txd->txd.callback_param;
> 		void (*fn)(void *) = my_txd->txd.callback;
> 
> 		my_txd_free(my_chan, my_txd);
> 
> 		fn(callback_param);
> 	}	
> }

Got it. Thanx.

-- 
viresh
