Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab2LASKt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 13:10:49 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:62240 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679Ab2LASKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 13:10:48 -0500
Message-ID: <50BA47EF.4040409@gmail.com>
Date: Sat, 01 Dec 2012 19:09:51 +0100
From: Francesco Lavra <francescolavra.fl@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Rajanikanth H.V" <rajanikanth.hv@linaro.org>
CC: anton.vorontsov@linaro.org, rob.herring@calxeda.com, lee.jones@linaro.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        STEricsson_nomadik_linux@list.st.com, rajanikanth.hv@stericsson.com
Subject: Re: [PATCH] ab8500: remove explicit handling of battery type
References: <1354130865-6148-1-git-send-email-rajanikanth.hv@linaro.org>
In-Reply-To: <1354130865-6148-1-git-send-email-rajanikanth.hv@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 11/28/2012 08:27 PM, Rajanikanth H.V wrote:
> From: "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>
> 
> property, battery-type shall be one of supported technology type
> instead blank
> - refer: Documentation/devicetree/bindings/power_supply/ab8500/fg.txt
> 	for the list supported types
> - this patch appends to ab8500 bm devs DT binding patch set
> 	ref: commit-id e0f1abeba5c2d8a2183566717d99294fd1a29c2e
> 		git://git.infradead.org/battery-2.6.git
> - promote ab8500_fg probe to happen before ab8500_btemp probe as
> 	btemp driver depends on fuelgauge list,
> 	ref: ab8500_fg_get(...)
> 
> Signed-off-by: Rajanikanth H.V <rajanikanth.hv@stericsson.com>
> ---
>  drivers/power/Makefile        |    2 +-
>  drivers/power/ab8500_bmdata.c |   10 +++-------
>  2 files changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/power/Makefile b/drivers/power/Makefile
> index 696e3a9..070c73d 100644
> --- a/drivers/power/Makefile
> +++ b/drivers/power/Makefile
> @@ -38,7 +38,7 @@ obj-$(CONFIG_CHARGER_PCF50633)	+= pcf50633-charger.o
>  obj-$(CONFIG_BATTERY_JZ4740)	+= jz4740-battery.o
>  obj-$(CONFIG_BATTERY_INTEL_MID)	+= intel_mid_battery.o
>  obj-$(CONFIG_BATTERY_RX51)	+= rx51_battery.o
> -obj-$(CONFIG_AB8500_BM)		+= ab8500_bmdata.o ab8500_charger.o ab8500_btemp.o ab8500_fg.o abx500_chargalg.o
> +obj-$(CONFIG_AB8500_BM)		+= ab8500_bmdata.o ab8500_charger.o ab8500_fg.o ab8500_btemp.o abx500_chargalg.o
>  obj-$(CONFIG_CHARGER_ISP1704)	+= isp1704_charger.o
>  obj-$(CONFIG_CHARGER_MAX8903)	+= max8903_charger.o
>  obj-$(CONFIG_CHARGER_TWL4030)	+= twl4030_charger.o
> diff --git a/drivers/power/ab8500_bmdata.c b/drivers/power/ab8500_bmdata.c
> index 03cc528..f16b60c 100644
> --- a/drivers/power/ab8500_bmdata.c
> +++ b/drivers/power/ab8500_bmdata.c
> @@ -461,7 +461,6 @@ bmdevs_of_probe(struct device *dev,
>  	struct  device_node *np_bat_supply;
>  	struct	abx500_bm_data *bat;
>  	const char *btech;
> -	char bat_tech[8];
>  	int i, thermistor;
>  
>  	*battery = &ab8500_bm_data;
> @@ -488,12 +487,9 @@ bmdevs_of_probe(struct device *dev,
>  		"stericsson,battery-type", NULL);
>  	if (!btech) {
>  		dev_warn(dev, "missing property battery-name/type\n");
> -		strcpy(bat_tech, "UNKNOWN");
> -	} else {
> -		strcpy(bat_tech, btech);
> +		return -EINVAL;

Before returning, of_node_put() should be called on the device node.

--
Francesco
