Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab1AIWxH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 17:53:07 -0500
Received: from smtp-out.google.com ([216.239.44.51]:1537 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab1AIWxF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 17:53:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VAorFdhSTy+mBNYRUgGGzgUQ6RXRQ2qxNpQ28EAbGH/ZjVuqb31UV5cCaJo1qSFJEX
         vFjpwOfbKYS00mRS8w8Q==
MIME-Version: 1.0
In-Reply-To: <1283015148-10747-4-git-send-email-gbean@codeaurora.org>
References: <1283015148-10747-1-git-send-email-gbean@codeaurora.org>
	<1283015148-10747-4-git-send-email-gbean@codeaurora.org>
Date: Sun, 9 Jan 2011 14:53:01 -0800
Message-ID: <AANLkTikrLnGxNSJgv3KDNAQ5kvjNd8aPrOEBwftiiyrQ@mail.gmail.com>
Subject: Re: [PATCH 4/5 v4] msm: convert 7x30 to gpiomux.
From: Dima Zavin <dmitriyz@google.com>
To: Gregory Bean <gbean@codeaurora.org>
Cc: dwalker@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

Just rebased on top of 2.6.37 and this patch is totally the wrong way
to go about this.

I should have commented at the appropriate time, so sorry for the late reply.

Having this  msm_gpiomux_configs be always compiled in for all msm7x30
devices makes this entire system completely inflexible since you have
to modify common code to provide board specific initialization. The
definition of "msm_gpiomux_configs" belongs in the board file, not in
gpiomux-7x30.c. I think we need to delete this new file and move the
definition back into board-msm7x30.c, but just use the new gpiomux
APIs.

I can provide a patch if you like.

--Dima

On Sat, Aug 28, 2010 at 10:05 AM, Gregory Bean <gbean@codeaurora.org> wrote:
> Change deprecated gpio_tlmm_config calls to gpiomux calls.
>
> Signed-off-by: Gregory Bean <gbean@codeaurora.org>
> ---
>  arch/arm/mach-msm/board-msm7x30.c |   20 --------------------
>  arch/arm/mach-msm/gpiomux-7x30.c  |   21 ++++++++++++++++++++-
>  2 files changed, 20 insertions(+), 21 deletions(-)
>
> diff --git a/arch/arm/mach-msm/board-msm7x30.c b/arch/arm/mach-msm/board-msm7x30.c
> index e329819..74abb74 100644
> --- a/arch/arm/mach-msm/board-msm7x30.c
> +++ b/arch/arm/mach-msm/board-msm7x30.c
> @@ -39,22 +39,6 @@
>
>  extern struct sys_timer msm_timer;
>
> -#ifdef CONFIG_SERIAL_MSM_CONSOLE
> -static struct msm_gpio uart2_config_data[] = {
> -       { GPIO_CFG(49, 2, GPIO_OUTPUT,  GPIO_PULL_DOWN, GPIO_2MA), "UART2_RFR"},
> -       { GPIO_CFG(50, 2, GPIO_INPUT,   GPIO_PULL_DOWN, GPIO_2MA), "UART2_CTS"},
> -       { GPIO_CFG(51, 2, GPIO_INPUT,   GPIO_PULL_DOWN, GPIO_2MA), "UART2_Rx"},
> -       { GPIO_CFG(52, 2, GPIO_OUTPUT,  GPIO_PULL_DOWN, GPIO_2MA), "UART2_Tx"},
> -};
> -
> -static void msm7x30_init_uart2(void)
> -{
> -       msm_gpios_request_enable(uart2_config_data,
> -                       ARRAY_SIZE(uart2_config_data));
> -
> -}
> -#endif
> -
>  static struct platform_device *devices[] __initdata = {
>  #if defined(CONFIG_SERIAL_MSM) || defined(CONFIG_MSM_SERIAL_DEBUGGER)
>         &msm_device_uart2,
> @@ -70,10 +54,6 @@ static void __init msm7x30_init_irq(void)
>  static void __init msm7x30_init(void)
>  {
>        platform_add_devices(devices, ARRAY_SIZE(devices));
> -#ifdef CONFIG_SERIAL_MSM_CONSOLE
> -       msm7x30_init_uart2();
> -#endif
> -
>  }
>
>  static void __init msm7x30_map_io(void)
> diff --git a/arch/arm/mach-msm/gpiomux-7x30.c b/arch/arm/mach-msm/gpiomux-7x30.c
> index 7b380b3..6ce41c5 100644
> --- a/arch/arm/mach-msm/gpiomux-7x30.c
> +++ b/arch/arm/mach-msm/gpiomux-7x30.c
> @@ -16,4 +16,23 @@
>  */
>  #include "gpiomux.h"
>
> -struct msm_gpiomux_config msm_gpiomux_configs[GPIOMUX_NGPIOS] = {};
> +struct msm_gpiomux_config msm_gpiomux_configs[GPIOMUX_NGPIOS] = {
> +#ifdef CONFIG_SERIAL_MSM_CONSOLE
> +       [49] = { /* UART2 RFR */
> +               .suspended = GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |
> +                            GPIOMUX_FUNC_2 | GPIOMUX_VALID,
> +       },
> +       [50] = { /* UART2 CTS */
> +               .suspended = GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |
> +                            GPIOMUX_FUNC_2 | GPIOMUX_VALID,
> +       },
> +       [51] = { /* UART2 RX */
> +               .suspended = GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |
> +                            GPIOMUX_FUNC_2 | GPIOMUX_VALID,
> +       },
> +       [52] = { /* UART2 TX */
> +               .suspended = GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |
> +                            GPIOMUX_FUNC_2 | GPIOMUX_VALID,
> +       },
> +#endif
> +};
> --
> 1.7.0.4
>
> /usr2/gbean/.signature.codeaurora.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
