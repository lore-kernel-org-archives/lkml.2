Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab1DOGqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 02:46:45 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:49778 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753846Ab1DOGqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 02:46:44 -0400
Message-ID: <4DA7E997.3080402@st.com>
Date: Fri, 15 Apr 2011 12:15:43 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>, amitgoel <amit.goel@st.com>,
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

Hello,

There is one more issue in the current DW_DMAC driver.
As most of interrupt processing is done in tasklet, spin_lock_bh() is used in almost
every routine.

Now, if some driver is calling these routines from interrupt context or with interrupt
disabled, we get KERN_WARN() messages due to following in kernel/softirq.c:

static inline void _local_bh_enable_ip(unsigned long ip)
{
	WARN_ON_ONCE(in_irq() || irqs_disabled());
	...
}

Should i minimize processing in tasklets, so that spin_lock_bh is not required anymore,
as in drivers/dma/amba-pl08x.c (tasklet for every channel) or is there some other way of
doing it.

Currently, drivers/tty/serial/amba-pl011.c is calling from interrupt context or with
interrupt disabled.

-- 
viresh
