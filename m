Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab1LBQ3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 11:29:08 -0500
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:41259 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756990Ab1LBQ3G convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 11:29:06 -0500
MIME-Version: 1.0
In-Reply-To: <1322838172-11149-3-git-send-email-ming.lei@canonical.com>
References: <1322838172-11149-1-git-send-email-ming.lei@canonical.com> <1322838172-11149-3-git-send-email-ming.lei@canonical.com>
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Fri, 2 Dec 2011 10:28:42 -0600
Message-ID: <CAKnK67T9S6Z=f9qmn9ov7YNyTKjdDbOZHJDRO-7_fqkJGZzXbA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 2/7] omap4: build fdif omap device from hwmod
To: Ming Lei <ming.lei@canonical.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Sylwester Nawrocki <snjw23@gmail.com>, Greg KH <greg@kroah.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ming,

Thanks for the patches.

On Fri, Dec 2, 2011 at 9:02 AM, Ming Lei <ming.lei@canonical.com> wrote:
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  arch/arm/mach-omap2/devices.c |   33 +++++++++++++++++++++++++++++++++
>  1 files changed, 33 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
> index 1166bdc..a392af5 100644
> --- a/arch/arm/mach-omap2/devices.c
> +++ b/arch/arm/mach-omap2/devices.c
> @@ -728,6 +728,38 @@ void __init omap242x_init_mmc(struct omap_mmc_platform_data **mmc_data)
>
>  #endif
>
> +static struct platform_device* __init omap4_init_fdif(void)
> +{
> +       int id = -1;

You could remove this , as it is being used only once, and never changed.

> +       struct platform_device *pd;
> +       struct omap_hwmod *oh;
> +       const char *dev_name = "fdif";
> +
> +       oh = omap_hwmod_lookup("fdif");
> +       if (!oh) {
> +               pr_err("Could not look up fdif hwmod\n");
> +               return NULL;
> +       }
> +
> +       pd = omap_device_build(dev_name, id, oh, NULL, 0, NULL, 0, 0);

Just do:

pd = omap_device_build(dev_name, -1, oh, NULL, 0, NULL, 0, 0);

> +       WARN(IS_ERR(pd), "Can't build omap_device for %s.\n",
> +                               dev_name);
> +       return pd;
> +}
> +
> +static void __init omap_init_fdif(void)
> +{
> +       if (cpu_is_omap44xx()) {
> +               struct platform_device *pd;
> +
> +               pd = omap4_init_fdif();
> +               if (!pd)
> +                       return;
> +
> +               pm_runtime_enable(&pd->dev);
> +       }
> +}

IMHO, you could reduce 1 level of indentation here, like this:

static void __init omap_init_fdif(void)
{
	struct platform_device *pd;

	if (!cpu_is_omap44xx())
		return;

	pd = omap4_init_fdif();
	if (!pd)
		return;

	pm_runtime_enable(&pd->dev);
}

Regards,
Sergio

> +
>  /*-------------------------------------------------------------------------*/
>
>  #if defined(CONFIG_HDQ_MASTER_OMAP) || defined(CONFIG_HDQ_MASTER_OMAP_MODULE)
> @@ -808,6 +840,7 @@ static int __init omap2_init_devices(void)
>        omap_init_sham();
>        omap_init_aes();
>        omap_init_vout();
> +       omap_init_fdif();
>
>        return 0;
>  }
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
