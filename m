Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030522Ab2CVAsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 20:48:01 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:47611 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137Ab2CVArz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 20:47:55 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-131.messagelabs.com!1332377274!16542539!1
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Mika Westerberg <mika.westerberg@iki.fi>
CC: Rafal Prylowski <prylowski@metasoft.pl>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "rmallon@gmail.com" <rmallon@gmail.com>
Date: Wed, 21 Mar 2012 19:47:52 -0500
Subject: RE: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
Thread-Topic: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
Thread-Index: Ac0HmYMHnUWRKaHuTwKAz+EkszOhOgAKferQ
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020696D48AB1@AUSP01VMBX24.collaborationhost.net>
References: <4F683B36.8090101@metasoft.pl>
 <ADE657CA350FB648AAC2C43247A983F0020696D488E3@AUSP01VMBX24.collaborationhost.net>
 <20120321193231.GA3740@mwesterb-mobl.ger.corp.intel.com>
In-Reply-To: <20120321193231.GA3740@mwesterb-mobl.ger.corp.intel.com>
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

On Wednesday, March 21, 2012 12:33 PM, Mika Westerberg wrote:
> On Wed, Mar 21, 2012 at 12:12:11PM -0500, H Hartley Sweeten wrote:
>> On Tuesday, March 20, 2012 1:09 AM, Rafal Prylowski wrote:
>>>
>>> Implement double buffering for M2M DMA channels.
>>>
>>> Signed-off-by: Rafal Prylowski <prylowski@metasoft.pl>
>> 
>> Hmm... This isn't working on my ep9307 board...
>> 
>> When the system boots I get stormed with messages:
>> 
>> dma dma1chan0: unknown interrupt!
>> dma dma1chan0: unknown interrupt!
>> dma dma1chan0: unknown interrupt!
>> dma dma1chan1: unknown interrupt!
>> dma dma1chan1: unknown interrupt!
>> dma dma1chan1: unknown interrupt!
>> dma dma1chan0: unknown interrupt!
>> dma dma1chan0: unknown interrupt!
>> dma dma1chan1: unknown interrupt!
>> 
>> Note, I have use_dma set for the ep93xx_spi driver and am using mmc_spi.
>> 
>> Also note, without your patch I also get a couple messages:
>> 
>> dma dma1chan1: got interrupt while active list is empty
>> 
>> But, the mmc card is working fine. I haven't tracked down why I get these
>> yet. Mika, any ideas?
>
> I've noticed the same. But they also happen without this patch applied. I've
> tracked it down to MULTI_IRQ_HANDLER support patches for ARM vic but not sure
> what might be wrong there (or is the ep93xx_dma driver behaving badly). I
> Noticed that when we get that 'got interrupt while active list is empty' we
> don't have any interrupts set in the M2M_INTERRUPT register but we still got
> an interrupt.. weird.

I think you misunderstood my comment above.

With this patch applied I get the "unknown interrupt!" storm. These messages
keep getting spewed until I power off the board.

Without this patch I get the "got interrupt while active list is empty" messages
but only occasionally. Other than the messages the mmc_spi driver seems to
be working ok with dma.

I hacked in a dump of the DMA Global Interrupt register when I get the
"got interrupt while active list is empty" messages and get this:

dma dma1chan1: got interrupt while active list is empty (00000000)

So, according to the DMAGlInt register, there are no channels with an
active interrupt.

Are we missing a write to the INTERRUPT registers somewhere to clear the
current interrupt?

Regards,
Hartley

> Below is a workaround I've been using lately but it certainly is a hack and we
> should figure out what is the root cause for this.
>
> diff --git a/arch/arm/common/vic.c b/arch/arm/common/vic.c
> index dcb004a..cb6b49a 100644
> --- a/arch/arm/common/vic.c
> +++ b/arch/arm/common/vic.c
> @@ -441,11 +441,9 @@ static int handle_one_vic(struct vic_device *vic, struct pt_regs *regs)
>  	u32 stat, irq;
>  	int handled = 0;
>  
> -	stat = readl_relaxed(vic->base + VIC_IRQ_STATUS);
> -	while (stat) {
> +	while ((stat = readl_relaxed(vic->base + VIC_IRQ_STATUS))) {
>  		irq = ffs(stat) - 1;
>  		handle_IRQ(irq_domain_to_irq(&vic->domain, irq), regs);
> -		stat &= ~(1 << irq);
>  		handled = 1;
>  	}
 
