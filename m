Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab2JNMhz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 08:37:55 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40168 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858Ab2JNMhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 08:37:54 -0400
Message-ID: <507AB1E6.4000809@ti.com>
Date: Sun, 14 Oct 2012 18:06:54 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Hannu Heikkinen <hannuxx@iki.fi>
CC: <linux-kernel@vger.kernel.org>, <rtc-linux@googlegroups.com>,
        <a.zummo@towertech.it>,
        <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH v2] rtc: davinci: clean up probe/remove routines
References: <1350166210-23313-1-git-send-email-hannuxx@iki.fi> <1350207822-4857-1-git-send-email-hannuxx@iki.fi>
In-Reply-To: <1350207822-4857-1-git-send-email-hannuxx@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2012 3:13 PM, Hannu Heikkinen wrote:
> Use the devres managed resource functions in the probe routine.
> Also affects the remove routine where the previously used free and
> release functions are not needed.
> 
> The devm_* functions eliminate the need for manual resource releasing and
> simplify error handling.  Resources allocated by devm_* are freed
> automatically on driver detach.
> 
> Signed-off-by: Hannu Heikkinen <hannuxx@iki.fi>
> ---
>  drivers/rtc/rtc-davinci.c | 56 +++++++++++++----------------------------------
>  1 file changed, 15 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-davinci.c b/drivers/rtc/rtc-davinci.c
> index 14c2109..d24b573 100644
> --- a/drivers/rtc/rtc-davinci.c
> +++ b/drivers/rtc/rtc-davinci.c
> @@ -119,8 +119,6 @@ static DEFINE_SPINLOCK(davinci_rtc_lock);
>  struct davinci_rtc {
>  	struct rtc_device 		*rtc;
>  	void __iomem			*base;
> -	resource_size_t			pbase;
> -	size_t				base_size;
>  	int				irq;
>  };
>  
> @@ -482,22 +480,16 @@ static int __init davinci_rtc_probe(struct platform_device *pdev)
>  {
>  	struct device *dev = &pdev->dev;
>  	struct davinci_rtc *davinci_rtc;
> -	struct resource *res, *mem;
> +	struct resource *res;
>  	int ret = 0;
>  
> -	davinci_rtc = kzalloc(sizeof(struct davinci_rtc), GFP_KERNEL);
> +	davinci_rtc = devm_kzalloc(&pdev->dev, sizeof(struct davinci_rtc),
> +		GFP_KERNEL);
>  	if (!davinci_rtc) {
>  		dev_dbg(dev, "could not allocate memory for private data\n");
>  		return -ENOMEM;
>  	}
>  
> -	davinci_rtc->irq = platform_get_irq(pdev, 0);
> -	if (davinci_rtc->irq < 0) {
> -		dev_err(dev, "no RTC irq\n");
> -		ret = davinci_rtc->irq;
> -		goto fail1;
> -	}
> -
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!res) {
>  		dev_err(dev, "no mem resource\n");
> @@ -505,23 +497,16 @@ static int __init davinci_rtc_probe(struct platform_device *pdev)
>  		goto fail1;

As mentioned last time, this will have a build break here because fail1
is being removed down below.

Thanks,
Sekhar
