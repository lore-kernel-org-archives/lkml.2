Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab1F2Nmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 09:42:36 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:30512 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab1F2Nme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 09:42:34 -0400
X-AuditID: cbfee61b-b7bfdae000006d51-54-4e0b2bc81f3b
Date: Wed, 29 Jun 2011 22:42:26 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH v2 2/5] Samsung SoC ADC: Channel selection for S5PV210,
 S5PC110, and Exynos4
In-reply-to: <1308621527-2457-3-git-send-email-myungjoo.ham@samsung.com>
To: "'MyungJoo Ham'" <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        dg77.kim@samsung.com, myungjoo.ham@gmail.com
Message-id: <004a01cc3662$65751a90$305f4fb0$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcwvtsyY1xPXQ3aXSuiXaGa/QCHqbwGqehbw
References: <20110620101737.GA31864@opensource.wolfsonmicro.com>
 <1308621527-2457-1-git-send-email-myungjoo.ham@samsung.com>
 <1308621527-2457-3-git-send-email-myungjoo.ham@samsung.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MyungJoo Ham wrote:
> 
> In S5PV210/S5PC110/Exynos4, ADCMUX channel selection uses ADCMUX
> register, not ADCCON register. This patch corrects the behavior of
> Samsung-ADC for such cpus.
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> --
> v2: No changes from v1. Resubmitted as a series of patches
> ---
>  arch/arm/plat-samsung/adc.c                   |   24
> +++++++++++++++++-------
>  arch/arm/plat-samsung/include/plat/regs-adc.h |    1 +
>  2 files changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm/plat-samsung/adc.c b/arch/arm/plat-samsung/adc.c
> index 938f6e9..0233c69 100644
> --- a/arch/arm/plat-samsung/adc.c
> +++ b/arch/arm/plat-samsung/adc.c
> @@ -41,8 +41,10 @@
> 
>  enum s3c_cpu_type {
>  	TYPE_S3C24XX,
> -	TYPE_S3C64XX
> +	TYPE_S3C64XX,
> +	TYPE_S5P,
>  };

How about S5PC100? Following is better for next if we cannot distinguish it
by CPU.

-enum s3c_cpu_type {
-	TYPE_S3C24XX,
-	TYPE_S3C64XX
+enum samsung_adc_type {
+	TYPE_ADC24,	 /* S3C24XX */
+	TYPE_ADC64,	 /* S3C64XX, S5P64X0, S5PC100 */
+	TYPE_ADCV3	/* S5PV210, EXYNOS4210 */
 };
...

TYPE_ADCV1 and V2?...
Of course, the name can be changed...

> +#define S3C64XX_OR_LATER(type)	((type) == TYPE_S3C64XX || (type) ==
> TYPE_S5P)
> 
>  struct s3c_adc_client {
>  	struct platform_device	*pdev;
> @@ -93,6 +95,7 @@ static inline void s3c_adc_select(struct adc_device
*adc,
>  				  struct s3c_adc_client *client)
>  {
>  	unsigned con = readl(adc->regs + S3C2410_ADCCON);
> +	enum s3c_cpu_type cpu = platform_get_device_id(adc->pdev)-
> >driver_data;
> 
>  	client->select_cb(client, 1);
> 
> @@ -100,8 +103,12 @@ static inline void s3c_adc_select(struct adc_device
*adc,
>  	con &= ~S3C2410_ADCCON_STDBM;
>  	con &= ~S3C2410_ADCCON_STARTMASK;
> 
> -	if (!client->is_ts)
> -		con |= S3C2410_ADCCON_SELMUX(client->channel);
> +	if (!client->is_ts) {
> +		if (cpu == TYPE_S5P)
> +			writel(client->channel & 0xf, adc->regs +
> S5P_ADCMUX);
> +		else
> +			con |= S3C2410_ADCCON_SELMUX(client->channel);
> +	}
> 
>  	writel(con, adc->regs + S3C2410_ADCCON);
>  }
> @@ -287,8 +294,8 @@ static irqreturn_t s3c_adc_irq(int irq, void *pw)
> 
>  	client->nr_samples--;
> 
> -	if (cpu == TYPE_S3C64XX) {
> -		/* S3C64XX ADC resolution is 12-bit */
> +	if (S3C64XX_OR_LATER(cpu)) {
> +		/* S3C64XX/S5P ADC resolution is 12-bit */
>  		data0 &= 0xfff;
>  		data1 &= 0xfff;
>  	} else {
> @@ -314,7 +321,7 @@ static irqreturn_t s3c_adc_irq(int irq, void *pw)
>  	}
> 
>  exit:
> -	if (cpu == TYPE_S3C64XX) {

Or (if we use s3c_cpu_type)
+	if (cpu != TYPE_S3C24XX) {

> +	if (S3C64XX_OR_LATER(cpu)) {
>  		/* Clear ADC interrupt */
>  		writel(0, adc->regs + S3C64XX_ADCCLRINT);
>  	}
> @@ -388,7 +395,7 @@ static int s3c_adc_probe(struct platform_device *pdev)
>  	clk_enable(adc->clk);
> 
>  	tmp = adc->prescale | S3C2410_ADCCON_PRSCEN;
> -	if (platform_get_device_id(pdev)->driver_data == TYPE_S3C64XX) {
> +	if (S3C64XX_OR_LATER(platform_get_device_id(pdev)->driver_data)) {
>  		/* Enable 12-bit ADC resolution */
>  		tmp |= S3C64XX_ADCCON_RESSEL;
>  	}
> @@ -478,6 +485,9 @@ static struct platform_device_id s3c_adc_driver_ids[]
= {
>  	}, {
>  		.name           = "s3c64xx-adc",
>  		.driver_data    = TYPE_S3C64XX,
> +	}, {
> +		.name		= "s5p-adc",
> +		.driver_data	= TYPE_S5P,
>  	},
>  	{ }
>  };
> diff --git a/arch/arm/plat-samsung/include/plat/regs-adc.h
b/arch/arm/plat-
> samsung/include/plat/regs-adc.h
> index 7554c4f..035e8c3 100644
> --- a/arch/arm/plat-samsung/include/plat/regs-adc.h
> +++ b/arch/arm/plat-samsung/include/plat/regs-adc.h
> @@ -21,6 +21,7 @@
>  #define S3C2410_ADCDAT1	   S3C2410_ADCREG(0x10)
>  #define S3C64XX_ADCUPDN		S3C2410_ADCREG(0x14)
>  #define S3C64XX_ADCCLRINT	S3C2410_ADCREG(0x18)
> +#define S5P_ADCMUX		S3C2410_ADCREG(0x1C)
>  #define S3C64XX_ADCCLRINTPNDNUP	S3C2410_ADCREG(0x20)
> 
> 
> --
> 1.7.4.1



Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

