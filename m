Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918Ab2JEWaP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 18:30:15 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37406 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757513Ab2JEWaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 18:30:12 -0400
Message-ID: <506F5F69.6040104@mvista.com>
Date: Sat, 06 Oct 2012 00:30:01 +0200
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: tony@atomide.com, linux@arm.linux.org.uk, b-cousson@ti.com, arnd@arndb.de,
        olof@lixom.net, rdunlap@xenotime.net, balbi@ti.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 3/3] ARM: OMAP: ocp2scp: create omap device for ocp2scp
References: <1349431628-2819-1-git-send-email-kishon@ti.com> <1349431628-2819-4-git-send-email-kishon@ti.com>
In-Reply-To: <1349431628-2819-4-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05-10-2012 12:07, Kishon Vijay Abraham I wrote:

> Platfrom device for ocp2scp is created using omap_device_build in
> devices file. This is used for both omap4(musb) and omap5(dwc3).
>
> Signed-off-by: Kishon Vijay Abraham I<kishon@ti.com>
> ---
>   arch/arm/mach-omap2/devices.c |   72 +++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 72 insertions(+)
>
> diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
> index c8c2117..e2ba505 100644
> --- a/arch/arm/mach-omap2/devices.c
> +++ b/arch/arm/mach-omap2/devices.c
[...]
> @@ -613,6 +614,76 @@ static void omap_init_vout(void)
[...]

> +static void omap_init_ocp2scp(void)
> +{
> +	struct omap_hwmod	*oh;
> +	struct platform_device	*pdev;
> +	int			bus_id = -1, dev_cnt = 0, i;
> +	struct omap_ocp2scp_dev	*ocp2scp_dev;
> +	const char		*oh_name, *name;
> +	struct omap_ocp2scp_platform_data *pdata;
> +
> +	oh_name = "ocp2scp_usb_phy";
> +	name	= "omap-ocp2scp";
> +
> +	oh = omap_hwmod_lookup(oh_name);
> +	if (!oh) {
> +		pr_err("%s: could not find omap_hwmod for %s\n", __func__,
> +								oh_name);
> +		return;
> +	}
> +
> +	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata) {
> +		pr_err("%s: No memory for ocp2scp pdata\n", __func__);
> +		return;
> +	}
> +
> +	ocp2scp_dev = oh->dev_attr;
> +	dev_cnt = count_ocp2scp_devices(ocp2scp_dev);
> +
> +	if (!dev_cnt) {
> +		pr_err("%s: No devices connected to ocp2scp\n", __func__);
> +		return;

    Don't you leak 'pdata' here?

> +	}
> +
> +	pdata->devices = kzalloc(sizeof(struct omap_ocp2scp_dev *)
> +					* dev_cnt, GFP_KERNEL);
> +	if (!pdata->devices) {
> +		pr_err("%s: No memory for ocp2scp pdata devices\n", __func__);
> +		return;
> +	}
> +
> +	for (i = 0; i<  dev_cnt; i++, ocp2scp_dev++)
> +		pdata->devices[i] = ocp2scp_dev;
> +
> +	pdata->dev_cnt	= dev_cnt;
> +
> +	pdev = omap_device_build(name, bus_id, oh, pdata, sizeof(*pdata), NULL,
> +								0, false);
> +	if (IS_ERR(pdev)) {
> +		pr_err("Could not build omap_device for %s %s\n",
> +						name, oh_name);
> +		return;

    Don't you leak 'pdata' and 'pdata->devices' here?


> +	}
> +}
>

WBR,  Sergei

