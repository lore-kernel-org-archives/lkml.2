Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010Ab2CVVg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:36:58 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:65443 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558Ab2CVVg5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:36:57 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-127.messagelabs.com!1332452212!1250890!11
X-Originating-IP: [216.166.12.31]
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
Date: Thu, 22 Mar 2012 16:36:51 -0500
Subject: RE: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
Thread-Topic: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
Thread-Index: Ac0IZwPUCpNyFGiNRlipqwgPPjIrnwADKSwQ
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020696D48D83@AUSP01VMBX24.collaborationhost.net>
References: <4F683B36.8090101@metasoft.pl>
 <ADE657CA350FB648AAC2C43247A983F0020696D488E3@AUSP01VMBX24.collaborationhost.net>
 <20120321193231.GA3740@mwesterb-mobl.ger.corp.intel.com>
 <ADE657CA350FB648AAC2C43247A983F0020696D48AB1@AUSP01VMBX24.collaborationhost.net>
 <20120322073750.GA637@mwesterb-mobl.ger.corp.intel.com>
 <ADE657CA350FB648AAC2C43247A983F0020696D48CAF@AUSP01VMBX24.collaborationhost.net>
 <20120322200339.GA5812@mwesterb-mobl.ger.corp.intel.com>
In-Reply-To: <20120322200339.GA5812@mwesterb-mobl.ger.corp.intel.com>
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

On Thursday, March 22, 2012 1:04 PM, Mika Westerberg wrote:
> On Thu, Mar 22, 2012 at 01:52:52PM -0500, H Hartley Sweeten wrote:
>
>> I hacked this back to the handle_one_vic function. It looks like every time
>> I get the message above the stat read in that function shows an active
>> interrupt for DMAM2M0 (the dma rx channel) and DMAM2M1 (the dma
>> tx channel). Because of the way handle_one_vic processes the irq's, the
>> DMAM2M0 interrupt gets handled first. When it's done it must be clearing
>> the DMAM2M1 interrupt automatically for some reason. So, when it's
>> handled there is no interrupt pending so we get the message.
>> 
>> The "cleanest" fix I can think of is the following patch.  This is against
>> linux-next.
>
> I can't figure out any better fix unless we move ep93xx back to use
> !MULTI_IRQ_HANDLER which obviously is not good thing to do.

I agree.

>> From: H Hartley Sweeten <hsweeten@visionengravers.com>
>> 
>> dma: ep93xx: check for spurious interrupts
>> 
>> The ep93xx dma controller generates spurious interrupts on dma1chan1 when
>> used with the mmc_spi driver. Catch these early by making sure there is an
>> interrupt to actually process.
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>
> Tested-by: Mika Westerberg <mika.westerberg@iki.fi>
>
> Thanks for investigating this. You missed one thing though, see below.
> Otherwise it doesn't compile :)
>
> diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
> index e1cc87a..614bff4 100644
> --- a/drivers/dma/ep93xx_dma.c
> +++ b/drivers/dma/ep93xx_dma.c
> @@ -751,7 +751,7 @@ static irqreturn_t ep93xx_dma_interrupt(int irq, void *dev_id)
> 		return IRQ_NONE;
>  	}
>  
> -	switch (edmac->edma->hw_interrupt(edmac)) {
> +	switch (edmac->edma->hw_interrupt(edmac, irq_status)) {
> 	case INTERRUPT_DONE:
> 		desc->complete = true;
> 		tasklet_schedule(&edmac->tasklet);

Gah... Misstyped it when I created the patch.

I'll fix it and post a proper patch with your Tested-by.

Thanks,
Hartley

