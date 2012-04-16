Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab2DPXKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 19:10:22 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:54627
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754028Ab2DPXKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 19:10:20 -0400
X-SpamScore: 2
X-BigFish: VS2(zz98dK78fbmzz1202hzz8275dhz2dh2a8h668h839h944hd24h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Mon, 16 Apr 2012 18:08:34 -0500
From: Kim Phillips <kim.phillips@freescale.com>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
CC: <rtc-linux@googlegroups.com>, Alessandro Zummo <a.zummo@towertech.it>,
        <linaro-dev@lists.linaro.org>, <patches@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, <linux-kernel@vger.kernel.org>,
        Eric Miao <eric.miao@linaro.org>, Shawn Guo <shawn.guo@linaro.org>,
        Anson Huang <b20788@freescale.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] rtc: add support for Freescale SNVS RTC
Message-ID: <20120416180834.a4578493ab1f747a1b3c2dd0@freescale.com>
In-Reply-To: <1334387237-23519-1-git-send-email-paul.liu@linaro.org>
References: <1334387237-23519-1-git-send-email-paul.liu@linaro.org>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Apr 2012 15:07:17 +0800
"Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org> wrote:

> +++ b/Documentation/devicetree/bindings/rtc/snvs-rtc.txt

this conflicts with the "Secure Non-Volatile Storage (SNVS) Node"
section published in:

Documentation/devicetree/bindings/crypto/fsl-sec4.txt

please use that instead.

> +config RTC_DRV_SNVS
> +	tristate "Freescale SNVS Real Time Clock"
> +	depends on ARCH_MXC

|| FSL_SOC

since this h/w also exists in other, non-ARM based, SoCs.

> +struct rtc_drv_data {
> +	struct rtc_device *rtc;
> +	void __iomem *ioaddr;
> +	int irq;
> +	bool irq_enable;
> +};
> +
> +static DEFINE_SPINLOCK(rtc_lock);

the lock belongs in struct rtc_drv_data.

> +static int64_t time_diff;

time_diff is only being written; it isn't being used.

> +	return IRQ_HANDLED;

return IRQ_NONE if !(lp_status & SNVS_LPSR_LPTA)

> +	alrm->pending =
> +	    ((readl(ioaddr + SNVS_LPSR) & SNVS_LPSR_LPTA) != 0) ? 1 : 0;

alrm->pending = !!readl(ioaddr + SNVS_LPSR) & SNVS_LPSR_LPTA;

> +	/* initialize glitch detect */
> +	writel(SNVS_LPPGDR_INIT, ioaddr + SNVS_LPPGDR);
> +	udelay(100);
> +
> +	/* clear lp interrupt status */
> +	writel(0xFFFFFFFF, ioaddr + SNVS_LPSR);
> +
> +	/* Enable RTC */
> +	lp_cr = readl(ioaddr + SNVS_LPCR);
> +	if ((lp_cr & SNVS_LPCR_SRTC_ENV) == 0)
> +		writel(lp_cr | SNVS_LPCR_SRTC_ENV, ioaddr + SNVS_LPCR);
> +	udelay(100);
> +
> +	writel(0xFFFFFFFF, ioaddr + SNVS_LPSR);
> +	udelay(100);

the manual doesn't state that delays are required after writing
these registers; it should be safe to remove them.

> +	/* By default, devices should wakeup if they can */
> +	/* So snvs is set as "should wakeup" as it can */

/*
 * multi-line
 * comment format
 */

Kim

