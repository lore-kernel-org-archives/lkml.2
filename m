Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab2DQUv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 16:51:56 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:24327 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab2DQUvy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 16:51:54 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-209.messagelabs.com!1334695901!3440825!30
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>,
        Rafal Prylowski <prylowski@metasoft.pl>
CC: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "rmallon@gmail.com" <rmallon@gmail.com>
Date: Tue, 17 Apr 2012 15:51:47 -0500
Subject: RE: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
Thread-Topic: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
Thread-Index: Ac0caex4X0qtK6OFStW/8+oWZlDE2AARxXCwAAoZL3A=
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206987A4034@AUSP01VMBX24.collaborationhost.net>
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
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F00206987A3E66@AUSP01VMBX24.collaborationhost.net>
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

On Tuesday, April 17, 2012 8:46 AM, H Hartley Sweeten wrote:
> On Tuesday, April 17, 2012 12:16 AM, Rafal Prylowski wrote:
>> On 2012-04-16 20:59, H Hartley Sweeten wrote:
>>> It appears your patch is causing an interrupt storm on my system.
>>> 
>>
>> Could you please apply the following patch on top of double buffering
>> patch? I would like to know the state of dma channel when you get
>> that interrupt storm.
>
> Rafal,
>
> Here's the output:
>
> mmc_spi spi0.1: SD/MMC host mmc0, no poweroff
> M2M: 20c3
> M2M: 20c3
> M2M: 21c3
> M2M: 21c3
> M2M: 21c3
> M2M: 21c3
> M2M: 21c3
> M2M: 21c3
>
> The "M2M: 21c3" keeps getting output until the system is turned off.

Rafal,

It appears that the M2M_CONTROL_NFBINT bit is never getting set when
dma is used with the spi-ep93xx.c and mmc_spi.c drivers.

I added a prink in msm_hw_submit():

	if (ep93xx_dma_advance_active(edmac)) {
		m2m_fill_desc(edmac);
		control |= M2M_CONTROL_NFBINT;
		printk("%s: NFB enabled\n", __func__);
	}

This message is never displayed.

And for some reason the txd.cookie is not getting set correctly to detect
the last entry in m2m_hw_interrupt.

	/*
	 * Check whether we are done with descriptors or not. This, together
	 * with DMA channel state, determines action to take in interrupt.
	 */
	last = list_first_entry(edmac->active.next,
		struct ep93xx_dma_desc, node)->txd.cookie;

This is causing the code for the INTERRUPT_NEXT_BUFFER to be executed
even though a "next" buffer does not exist.

I think your handling logic in m2m_hw_interrupt needs a bit more work.

I hacked it to test and this appears to work but it's not optimal...

Here's the whole function:


static int m2m_hw_interrupt(struct ep93xx_dma_chan *edmac)
{
	u32 status = readl(edmac->regs + M2M_STATUS);
	u32 ctl_fsm = status & M2M_STATUS_CTL_MASK;
	u32 buf_fsm = status & M2M_STATUS_BUF_MASK;
	bool done = status & M2M_STATUS_DONE;
	bool last;
	u32 control;

	/* Accept only DONE and NFB interrupts */
	if (!(readl(edmac->regs + M2M_INTERRUPT) & M2M_INTERRUPT_MASK))
		return INTERRUPT_UNKNOWN;

	if (done)
		/* Clear the DONE bit */
		writel(0, edmac->regs + M2M_INTERRUPT);

	/*
	 * Check whether we are done with descriptors or not. This, together
	 * with DMA channel state, determines action to take in interrupt.
	 */
	last = list_first_entry(edmac->active.next,
		struct ep93xx_dma_desc, node)->txd.cookie;

	/*
	 * Use M2M DMA Buffer FSM and Control FSM to check current state of
	 * DMA channel. Using DONE and NFB bits from channel status register
	 * or bits from channel interrupt register was proven not to be
	 * reliable.
	 */
	if (!last &&
	    (buf_fsm == M2M_STATUS_BUF_NO ||
	     buf_fsm == M2M_STATUS_BUF_ON)) {
		/*
		 * Two buffers are ready for update when Buffer FSM is in
		 * DMA_NO_BUF state. Only one buffer can be prepared without
		 * disabling the channel, or polling the DONE bit.
		 * To simplify things, always prepare only one buffer.
		 */
		if (ep93xx_dma_advance_active(edmac)) {
			m2m_fill_desc(edmac);
			if (done && !edmac->chan.private) {
				/* Software trigger for memcpy channel */
				control = readl(edmac->regs + M2M_CONTROL);
				control |= M2M_CONTROL_START;
				writel(control, edmac->regs + M2M_CONTROL);
			}
			return INTERRUPT_NEXT_BUFFER;
		} else {
			/*
			 * HACK: We don't have another buffer to prepare.
			 * Just disable the channel.
			 */
			control = readl(edmac->regs + M2M_CONTROL);
			control &= ~(M2M_CONTROL_DONEINT | M2M_CONTROL_NFBINT
				| M2M_CONTROL_ENABLE);
			writel(control, edmac->regs + M2M_CONTROL);
			return INTERRUPT_DONE;
		}
	}

	/*
	 * Disable the channel only when Buffer FSM is in DMA_NO_BUF state
	 * and Control FSM is in DMA_STALL state.
	 */
	if (last &&
	    buf_fsm == M2M_STATUS_BUF_NO &&
	    ctl_fsm == M2M_STATUS_CTL_STALL) {
		ep93xx_dma_advance_active(edmac);
		/* Disable interrupts and the channel */
		control = readl(edmac->regs + M2M_CONTROL);
		control &= ~(M2M_CONTROL_DONEINT | M2M_CONTROL_NFBINT
			    | M2M_CONTROL_ENABLE);
		writel(control, edmac->regs + M2M_CONTROL);
		return INTERRUPT_DONE;
	}

	/*
	 * Nothing to do this time.
	 */
	return INTERRUPT_NEXT_BUFFER;
}


With this I am able to boot my system and use the mmc card.

Regards,
Hartley

