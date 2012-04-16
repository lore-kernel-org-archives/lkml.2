Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab2DPNzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 09:55:52 -0400
Received: from ironport-out.teksavvy.com ([206.248.143.162]:30953 "EHLO
	ironport-out.teksavvy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385Ab2DPNzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 09:55:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuEBACxOgk8Y9geI/2dsb2JhbAANLAqFc7AkhiwBAQEBAyMEURELGAICBRYLAgIJAwIBAgFFBgEMCAEBtCSKGIEviXSEH4EYBKklgTgW
X-IronPort-AV: E=Sophos;i="4.75,391,1330923600"; 
   d="scan'208";a="174586722"
Message-ID: <4F8C24E5.4020703@teksavvy.com>
Date: Mon, 16 Apr 2012 09:55:49 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        Greg Kroah-Hartman <greg@kroah.com>, stable@vger.kernel.org
Subject: Re: [REGRESSION] rtc/interface.c: kills suspend-to-ram
References: <4F8BA1C1.4030804@teksavvy.com>
In-Reply-To: <4F8BA1C1.4030804@teksavvy.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-04-16 12:36 AM, Mark Lord wrote:
> Something recent has killed suspend-to-ram on a number of machines here.
> The symptom is that they suspend, but immediately wake up and panic,
> with just a black screen so no visible messages to go by.
> 
> The patch below works around the issue -- making things work as they used to work.
> 
> +++ linux/drivers/rtc/interface.c	2012-04-16 00:09:14.105387382 -0400
> @@ -773,7 +773,7 @@
>  	if (!rtc->ops || !rtc->ops->alarm_irq_enable)
>  		return;
> 
> -	rtc->ops->alarm_irq_enable(rtc->dev.parent, false);
> +	//rtc->ops->alarm_irq_enable(rtc->dev.parent, false);  // Kills suspend on ZBOX HD-ID41U
>  }
>
> Last known working kernel was 3.2.11.
> The line above got added somewhere between it and 3.2.15,
> and is also present (no surprise) in newer kernels.
> 
> The highest kernel I've tested for this is 3.3.2,
> which also fails until I nuke the line shown above.
> 
> This is straight x86_64 (Atom) hardware, using rtc-cmos.
> I can re-test if anyone has a fix for this.
> 
> Meanwhile, whatever patch put this into -stable probably
> ought to be reverted upstream and in -stable as well.


Speaking of which -- that batch of RTC updates is riddled with bugs.
For example, this beauty from rtc-mpc5121.c in the same update:

        ...
        rtc->rtc = rtc_device_register("mpc5200-rtc", &op->dev,
                                        &mpc5200_rtc_ops, THIS_MODULE);
        ...

        rtc->rtc->uie_unsupported = 1;    // <<<< Ooops NULL pointer >>>>

        if (IS_ERR(rtc->rtc)) {           // <<<< this needs to be earlier >>>>
                err = PTR_ERR(rtc->rtc);
                goto out_free_irq;
        }
        ...

Can somebody show me how to identify the commit from the code?
I know which lines got changed, but don't know how to find
the corresponding commits in -git.

And once we do identify the commits, they really need a code review.

Thanks.
