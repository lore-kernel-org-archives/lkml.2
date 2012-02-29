Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030435Ab2B2GoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 01:44:17 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34647 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030429Ab2B2GoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 01:44:15 -0500
Date: Wed, 29 Feb 2012 14:32:17 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: linux-next: manual merge of the akpm tree with the arm-soc tree
Message-ID: <20120229063217.GA13386@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20120229172127.7b430cecc7ab2350d4e4a1b8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120229172127.7b430cecc7ab2350d4e4a1b8@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 05:21:27PM +1100, Stephen Rothwell wrote:
> Hi Andrew,
> 
> Today's linux-next merge of the akpm tree got a conflict in
> drivers/rtc/rtc-sa1100.c between commit 3888c09074db ("rtc: sa1100:
> declare irq in resource") from the arm-soc tree and commit "drivers/rtc:
> remove IRQF_DISABLED" from the akpm tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Your fix looks good to me.

Thanks,
Yong

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/rtc/rtc-sa1100.c
> index c105774,e70b4e6..0000000
> --- a/drivers/rtc/rtc-sa1100.c
> +++ b/drivers/rtc/rtc-sa1100.c
> @@@ -102,23 -156,20 +102,23 @@@ static irqreturn_t sa1100_rtc_interrupt
>   
>   static int sa1100_rtc_open(struct device *dev)
>   {
>  +	struct sa1100_rtc *info = dev_get_drvdata(dev);
>  +	struct rtc_device *rtc = info->rtc;
>   	int ret;
>  -	struct platform_device *plat_dev = to_platform_device(dev);
>  -	struct rtc_device *rtc = platform_get_drvdata(plat_dev);
>   
>  -	ret = request_irq(IRQ_RTC1Hz, sa1100_rtc_interrupt, 0,
>  +	ret = clk_prepare_enable(info->clk);
>  +	if (ret)
>  +		goto fail_clk;
> - 	ret = request_irq(info->irq_1hz, sa1100_rtc_interrupt, IRQF_DISABLED,
> ++	ret = request_irq(info->irq_1hz, sa1100_rtc_interrupt, 0,
>   		"rtc 1Hz", dev);
>   	if (ret) {
>  -		dev_err(dev, "IRQ %d already in use.\n", IRQ_RTC1Hz);
>  +		dev_err(dev, "IRQ %d already in use.\n", info->irq_1hz);
>   		goto fail_ui;
>   	}
> - 	ret = request_irq(info->irq_alarm, sa1100_rtc_interrupt, IRQF_DISABLED,
>  -	ret = request_irq(IRQ_RTCAlrm, sa1100_rtc_interrupt, 0,
> ++	ret = request_irq(info->irq_alarm, sa1100_rtc_interrupt, 0,
>   		"rtc Alrm", dev);
>   	if (ret) {
>  -		dev_err(dev, "IRQ %d already in use.\n", IRQ_RTCAlrm);
>  +		dev_err(dev, "IRQ %d already in use.\n", info->irq_alarm);
>   		goto fail_ai;
>   	}
>   	rtc->max_user_freq = RTC_FREQ;



-- 
Only stand for myself
