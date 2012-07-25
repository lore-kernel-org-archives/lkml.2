Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab2GYKQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 06:16:34 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:51422
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751637Ab2GYKQc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 06:16:32 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dIc89bh1432I4015Izz1202hzz8275bh8275dhz2dh668h839h93fhd25hf0ah107ah)
X-WSS-ID: 0M7POJD-01-1ND-02
X-M-MSG: 
Date: Wed, 25 Jul 2012 18:16:02 +0800
From: Aaron Lu <aaron.lu@amd.com>
To: Borislav Petkov <bp@alien8.de>, wwang <wei_wang@realsil.com.cn>,
        <gregkh@linuxfoundation.org>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>, Philip Rakity <prakity@marvell.com>,
        Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH 1/3] drivers/misc: Add realtek card reader core driver
Message-ID: <20120725101601.GA8578@aarontestpc.amd.com>
References: <1343036558-8189-1-git-send-email-wei_wang@realsil.com.cn>
 <20120723163340.GA4105@x1.osrc.amd.com>
 <500DF89E.6090501@realsil.com.cn>
 <20120724064409.GA15735@liondog.tnic>
 <500E6126.4060604@realsil.com.cn>
 <20120724140709.GA13753@x1.osrc.amd.com>
 <500F59D7.2050508@realsil.com.cn>
 <20120725080415.GA21341@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20120725080415.GA21341@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 25 Jul 2012 10:16:02.0322 (UTC) FILETIME=[7E56BF20:01CD6A4E]
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

We do not use MMC_CAP_MAX_CURRENT_* anymore, for your host, I would
sugget you do something like this:

static void realtek_init(struct realtek_sdmmc *host)
{
	struct mmc_host *mmc = host->mmc;
	... ...
	/*
	 * since you have set MMC_CAP_MAX_CURRENT_800 in your
	 * original code, I assume your host can provide more than
	 * 800mA, and you've set the 1.8v support bit in your original
	 * code for the host, so I also set the max_current_180 to 800mA.
	 */
	mmc->max_current_330 = 800;
	mmc->max_current_180 = 800;
	... ...
}

Does this look right to you?

Thanks,
Aaron

On Wed, Jul 25, 2012 at 10:04:15AM +0200, Borislav Petkov wrote:
> On Wed, Jul 25, 2012 at 10:28:39AM +0800, wwang wrote:
> > 于 2012年07月24日 22:07, Borislav Petkov 写道:
> > >Kernel is Linus' from yesterday: v3.5-709-ga6be1fcbc57f and config
> > >is attached.
> > 
> > The compilation process is still OK with your config.
> 
> Yes, but not with the kernel I'm using. If you'd tried that exact kernel
> you would've seen that because...
> 
> > 
> > MMC_CAP_MAX_CURRENT_200 is usually defined in
> > include/linux/mmc/host.h, can you help to check it in your kernel
> > code?
> 
> ... MMC_CAP_MAX_CURRENT_* got removed by the patch at the end of this
> note and which went in through the MMC tree in this merge window:
> 
> commit a6be1fcbc57f95bb47ef3c8e4ee3d83731b8f21e
> Merge: 5b160bd42694 30b87c60e9cb
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sun Jul 22 16:36:08 2012 -0700
> 
>     Merge tag 'mmc-merge-for-3.6-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc
> ...
> 
> I'm adding some more people to Cc so that you can figure it all out
> among yourselves how to deal with the situation :)
> 
> Thanks.
> 
> ---
> 
> commit 55c4665ea0a42fd6427826bfce96eb4b0389262a
> Author: Aaron Lu <aaron.lu@amd.com>
> Date:   Wed Jul 4 13:31:48 2012 +0800
> 
>     mmc: sd: Fix sd current limit setting
>     
>     Host has different current capabilities at different voltages, we need
>     to record these settings seperately. The defined voltages are 1.8/3.0/3.3.
>     For other voltages, we do not touch current limit setting.
>     
>     Before we set the current limit for the sd card, find out the host's
>     operating voltage first and then find out the current capabilities of
>     the host at that voltage to set the current limit.
>     
>     Signed-off-by: Aaron Lu <aaron.lu@amd.com>
>     Reviewed-by: Philip Rakity <prakity@marvell.com>
>     Signed-off-by: Chris Ball <cjb@laptop.org>
> 
> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> index 65c64ee578a7..f578a71d82a6 100644
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -189,6 +189,9 @@ struct mmc_host {
>         u32                     ocr_avail_sd;   /* SD-specific OCR */
>         u32                     ocr_avail_mmc;  /* MMC-specific OCR */
>         struct notifier_block   pm_notify;
> +       u32                     max_current_330;
> +       u32                     max_current_300;
> +       u32                     max_current_180;
>  
>  #define MMC_VDD_165_195                0x00000080      /* VDD voltage 1.65 - 1.95 */
>  #define MMC_VDD_20_21          0x00000100      /* VDD voltage 2.0 ~ 2.1 */
> @@ -232,16 +235,9 @@ struct mmc_host {
>  #define MMC_CAP_UHS_SDR50      (1 << 17)       /* Host supports UHS SDR50 mode */
>  #define MMC_CAP_UHS_SDR104     (1 << 18)       /* Host supports UHS SDR104 mode */
>  #define MMC_CAP_UHS_DDR50      (1 << 19)       /* Host supports UHS DDR50 mode */
> -#define MMC_CAP_SET_XPC_330    (1 << 20)       /* Host supports >150mA current at 3.3V */
> -#define MMC_CAP_SET_XPC_300    (1 << 21)       /* Host supports >150mA current at 3.0V */
> -#define MMC_CAP_SET_XPC_180    (1 << 22)       /* Host supports >150mA current at 1.8V */
>  #define MMC_CAP_DRIVER_TYPE_A  (1 << 23)       /* Host supports Driver Type A */
>  #define MMC_CAP_DRIVER_TYPE_C  (1 << 24)       /* Host supports Driver Type C */
>  #define MMC_CAP_DRIVER_TYPE_D  (1 << 25)       /* Host supports Driver Type D */
> -#define MMC_CAP_MAX_CURRENT_200        (1 << 26)       /* Host max current limit is 200mA */
> -#define MMC_CAP_MAX_CURRENT_400        (1 << 27)       /* Host max current limit is 400mA */
> -#define MMC_CAP_MAX_CURRENT_600        (1 << 28)       /* Host max current limit is 600mA */
> -#define MMC_CAP_MAX_CURRENT_800        (1 << 29)       /* Host max current limit is 800mA */
>  #define MMC_CAP_CMD23          (1 << 30)       /* CMD23 supported. */
>  #define MMC_CAP_HW_RESET       (1 << 31)       /* Hardware reset */
> 
> -- 
> Regards/Gruss,
>     Boris.
> 

