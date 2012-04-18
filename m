Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab2DRRBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 13:01:14 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:56550 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab2DRRBN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 13:01:13 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-127.messagelabs.com!1334768444!3421604!69
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Rafal Prylowski <prylowski@metasoft.pl>
CC: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "rmallon@gmail.com" <rmallon@gmail.com>
Date: Wed, 18 Apr 2012 12:01:08 -0500
Subject: RE: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
Thread-Topic: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
Thread-Index: Ac0dgiSAq3oecNLxTYGx0RYRXwn0/wAAS0Sg
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206987A4265@AUSP01VMBX24.collaborationhost.net>
References: <4F683B36.8090101@metasoft.pl>
 <20120321193836.GC3740@mwesterb-mobl.ger.corp.intel.com>
 <ADE657CA350FB648AAC2C43247A983F0020696D48E3E@AUSP01VMBX24.collaborationhost.net>
 <20120323070446.GC5812@mwesterb-mobl.ger.corp.intel.com>
 <ADE657CA350FB648AAC2C43247A983F0020696D48EEB@AUSP01VMBX24.collaborationhost.net>
 <20120410172853.GA25697@mwesterb-mobl>
 <ADE657CA350FB648AAC2C43247A983F00206986C01D4@AUSP01VMBX24.collaborationhost.net>
 <4F853053.7040800@metasoft.pl>
 <ADE657CA350FB648AAC2C43247A983F00206987A3BFE@AUSP01VMBX24.collaborationhost.net>
 <4F8D189B.3010100@metasoft.pl>
 <ADE657CA350FB648AAC2C43247A983F00206987A3E66@AUSP01VMBX24.collaborationhost.net>
 <ADE657CA350FB648AAC2C43247A983F00206987A4034@AUSP01VMBX24.collaborationhost.net>
 <4F8EEEAD.6090306@metasoft.pl>
In-Reply-To: <4F8EEEAD.6090306@metasoft.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 18, 2012 9:41 AM, Rafal Prylowski wrote:
> On 2012-04-17 22:51, H Hartley Sweeten wrote:
>> On Tuesday, April 17, 2012 8:46 AM, H Hartley Sweeten wrote:
>>>
>>> Rafal,
>>>
>>> Here's the output:
>>>
>>> mmc_spi spi0.1: SD/MMC host mmc0, no poweroff
>>> M2M: 20c3
>>> M2M: 20c3
>>> M2M: 21c3
>>> M2M: 21c3
>>> M2M: 21c3
>>> M2M: 21c3
>>> M2M: 21c3
>>> M2M: 21c3
>>>
>>> The "M2M: 21c3" keeps getting output until the system is turned off.
>> 
>> Rafal,
>> 
>> It appears that the M2M_CONTROL_NFBINT bit is never getting set when
>> dma is used with the spi-ep93xx.c and mmc_spi.c drivers.
>> 
>> I added a prink in msm_hw_submit():
>> 
>> 	if (ep93xx_dma_advance_active(edmac)) {
>> 		m2m_fill_desc(edmac);
>> 		control |= M2M_CONTROL_NFBINT;
>> 		printk("%s: NFB enabled\n", __func__);
>> 	}
>> 
>> This message is never displayed.
>> 
>> And for some reason the txd.cookie is not getting set correctly to detect
>> the last entry in m2m_hw_interrupt.
>> 
>> 	/*
>> 	 * Check whether we are done with descriptors or not. This, together
>> 	 * with DMA channel state, determines action to take in interrupt.
>> 	 */
>> 	last = list_first_entry(edmac->active.next,
>> 		struct ep93xx_dma_desc, node)->txd.cookie;
>> 
>> This is causing the code for the INTERRUPT_NEXT_BUFFER to be executed
>> even though a "next" buffer does not exist.
>> 
>
> Well, I thought this is correct even if we have only one descriptor in active
> queue (when NFBINT bit is not set). edmac->active.next should point to the same
> element as edmac->active, and txd.cookie should be set. But maybe I'm wrong with
> this.
>
> Following is a double buffering patch, which should solve your issues with interrupt
> storm. It's similar to your hack, but hopefully more optimal, and (the most
> important thing for me) it never tries to disable the channel without ensuring
> that it is in proper state. If it happens that we are done with descriptors
> but Buffer and Control FSM informs that the channel is still operating, we just
> wait for another interrupt from EP93xx dma (it's quite interesting, that EP93xx dma
> always issues next interrupt, and sets DONE bit again).
> Patch applies to current mainline.
>
>
> Implement double buffering for M2M DMA channels.
>
>  Signed-off-by: Rafal Prylowski <prylowski@metasoft.pl>
>
> Index: linux-2.6/drivers/dma/ep93xx_dma.c
> ===================================================================
> --- linux-2.6.orig/drivers/dma/ep93xx_dma.c
> +++ linux-2.6/drivers/dma/ep93xx_dma.c
> @@ -71,6 +71,7 @@
>  #define M2M_CONTROL_TM_SHIFT		13
>  #define M2M_CONTROL_TM_TX		(1 << M2M_CONTROL_TM_SHIFT)
>  #define M2M_CONTROL_TM_RX		(2 << M2M_CONTROL_TM_SHIFT)
> +#define M2M_CONTROL_NFBINT		BIT(21)
>  #define M2M_CONTROL_RSS_SHIFT		22
>  #define M2M_CONTROL_RSS_SSPRX		(1 << M2M_CONTROL_RSS_SHIFT)
>  #define M2M_CONTROL_RSS_SSPTX		(2 << M2M_CONTROL_RSS_SHIFT)
> @@ -79,7 +80,23 @@
>  #define M2M_CONTROL_PWSC_SHIFT		25
>  
>  #define M2M_INTERRUPT			0x0004
> -#define M2M_INTERRUPT_DONEINT		BIT(1)
> +#define M2M_INTERRUPT_MASK		6
> +
> +#define M2M_STATUS			0x000c
> +#define M2M_STATUS_CTL_SHIFT		1
> +#define M2M_STATUS_CTL_IDLE		(0 << M2M_STATUS_CTL_SHIFT)
> +#define M2M_STATUS_CTL_STALL		(1 << M2M_STATUS_CTL_SHIFT)
> +#define M2M_STATUS_CTL_MEMRD		(2 << M2M_STATUS_CTL_SHIFT)
> +#define M2M_STATUS_CTL_MEMWR		(3 << M2M_STATUS_CTL_SHIFT)
> +#define M2M_STATUS_CTL_BWCWAIT		(4 << M2M_STATUS_CTL_SHIFT)
> +#define M2M_STATUS_CTL_MASK		(7 << M2M_STATUS_CTL_SHIFT)
> +#define M2M_STATUS_BUF_SHIFT		4
> +#define M2M_STATUS_BUF_NO		(0 << M2M_STATUS_BUF_SHIFT)
> +#define M2M_STATUS_BUF_ON		(1 << M2M_STATUS_BUF_SHIFT)
> +#define M2M_STATUS_BUF_NEXT		(2 << M2M_STATUS_BUF_SHIFT)
> +#define M2M_STATUS_BUF_MASK		(3 << M2M_STATUS_BUF_SHIFT)
> +#define M2M_STATUS_DONE			BIT(6)
> +

Nitpick.. Unnecessary whitespace.

>  
>  #define M2M_BCR0			0x0010
>  #define M2M_BCR1			0x0014
> @@ -426,15 +443,6 @@ static int m2p_hw_interrupt(struct ep93x
>  
>  /*
>   * M2M DMA implementation
> - *
> - * For the M2M transfers we don't use NFB at all. This is because it simply
> - * doesn't work well with memcpy transfers. When you submit both buffers it is
> - * extremely unlikely that you get an NFB interrupt, but it instead reports
> - * DONE interrupt and both buffers are already transferred which means that we
> - * weren't able to update the next buffer.
> - *
> - * So for now we "simulate" NFB by just submitting buffer after buffer
> - * without double buffering.
>   */
>  
>  static int m2m_hw_setup(struct ep93xx_dma_chan *edmac)
> @@ -543,6 +551,11 @@ static void m2m_hw_submit(struct ep93xx_
>  	m2m_fill_desc(edmac);
>  	control |= M2M_CONTROL_DONEINT;
>  
> +	if (ep93xx_dma_advance_active(edmac)) {
> +		m2m_fill_desc(edmac);
> +		control |= M2M_CONTROL_NFBINT;
> +	}
> +
>  	/*
>  	 * Now we can finally enable the channel. For M2M channel this must be
>  	 * done _after_ the BCRx registers are programmed.
> @@ -560,32 +573,87 @@ static void m2m_hw_submit(struct ep93xx_
>  	}
>  }
>  
> +/*
> + * According to EP93xx User's Guide, we should receive DONE interrupt when all
> + * M2M DMA controller transactions complete normally. This is not always the
> + * case - sometimes EP93xx M2M DMA asserts DONE interrupt when the DMA channel
> + * is still running (channel Buffer FSM in DMA_BUF_ON state, and channel
> + * Control FSM in DMA_MEM_RD state, observed at least in IDE-DMA operation).
> + * In effect, disabling the channel when only DONE bit is set could stop
> + * currently running DMA transfer. To avoid this, we use Buffer FSM and
> + * Control FSM to check current state of DMA channel.
> + */
>  static int m2m_hw_interrupt(struct ep93xx_dma_chan *edmac)
>  {
> +	u32 status = readl(edmac->regs + M2M_STATUS);
> +	u32 ctl_fsm = status & M2M_STATUS_CTL_MASK;
> +	u32 buf_fsm = status & M2M_STATUS_BUF_MASK;
> +	bool done = status & M2M_STATUS_DONE;
> +	bool last_done;
>  	u32 control;
> +	struct ep93xx_dma_desc *desc;
>  
> -	if (!(readl(edmac->regs + M2M_INTERRUPT) & M2M_INTERRUPT_DONEINT))
> +	/* Accept only DONE and NFB interrupts */
> +	if (!(readl(edmac->regs + M2M_INTERRUPT) & M2M_INTERRUPT_MASK))
>  		return INTERRUPT_UNKNOWN;
>  
> -	/* Clear the DONE bit */
> -	writel(0, edmac->regs + M2M_INTERRUPT);
> +	if (done)
> +		/* Clear the DONE bit */
> +		writel(0, edmac->regs + M2M_INTERRUPT);

Another nitpick. Either move the comment above the if (done) line or enclose
the two lines in { }.

>  
> -	/* Disable interrupts and the channel */
> -	control = readl(edmac->regs + M2M_CONTROL);
> -	control &= ~(M2M_CONTROL_DONEINT | M2M_CONTROL_ENABLE);
> -	writel(control, edmac->regs + M2M_CONTROL);
> +	/*
> +	 * Check whether we are done with descriptors or not. This, together
> +	 * with DMA channel state, determines action to take in interrupt.
> +	 */
> +	desc = ep93xx_dma_get_active(edmac);
> +	last_done = !desc || desc->txd.cookie;
>  
>  	/*
> -	 * Since we only get DONE interrupt we have to find out ourselves
> -	 * whether there still is something to process. So we try to advance
> -	 * the chain an see whether it succeeds.
> +	 * Use M2M DMA Buffer FSM and Control FSM to check current state of
> +	 * DMA channel. Using DONE and NFB bits from channel status register
> +	 * or bits from channel interrupt register is not reliable.
>  	 */
> -	if (ep93xx_dma_advance_active(edmac)) {
> -		edmac->edma->hw_submit(edmac);
> -		return INTERRUPT_NEXT_BUFFER;
> +	if (!last_done &&
> +	    (buf_fsm == M2M_STATUS_BUF_NO ||
> +	     buf_fsm == M2M_STATUS_BUF_ON)) {
> +		/*
> +		 * Two buffers are ready for update when Buffer FSM is in
> +		 * DMA_NO_BUF state. Only one buffer can be prepared without
> +		 * disabling the channel or polling the DONE bit.
> +		 * To simplify things, always prepare only one buffer.
> +		 */
> +		if (ep93xx_dma_advance_active(edmac)) {
> +			m2m_fill_desc(edmac);
> +			if (done && !edmac->chan.private) {
> +				/* Software trigger for memcpy channel */
> +				control = readl(edmac->regs + M2M_CONTROL);
> +				control |= M2M_CONTROL_START;
> +				writel(control, edmac->regs + M2M_CONTROL);
> +			}
> +			return INTERRUPT_NEXT_BUFFER;
> +		} else
> +			last_done = true;

One more nitpick. The else branch should also be enclosed with { }. See CodingStyle.

> +	}
> +
> +	/*
> +	 * Disable the channel only when Buffer FSM is in DMA_NO_BUF state
> +	 * and Control FSM is in DMA_STALL state.
> +	 */
> +	if (last_done &&
> +	    buf_fsm == M2M_STATUS_BUF_NO &&
> +	    ctl_fsm == M2M_STATUS_CTL_STALL) {
> +		/* Disable interrupts and the channel */
> +		control = readl(edmac->regs + M2M_CONTROL);
> +		control &= ~(M2M_CONTROL_DONEINT | M2M_CONTROL_NFBINT
> +			    | M2M_CONTROL_ENABLE);
> +		writel(control, edmac->regs + M2M_CONTROL);
> +		return INTERRUPT_DONE;
>  	}
>  
> -	return INTERRUPT_DONE;
> +	/*
> +	 * Nothing to do this time.
> +	 */
> +	return INTERRUPT_NEXT_BUFFER;
>  }
>  
>  /*

Other than the nitpicks, I'm now happy with this patch. It works fine on
my ep93xx board with the mmc_spi and sst25l drivers.

Tested-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>


