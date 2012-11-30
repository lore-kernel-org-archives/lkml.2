Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863Ab2K3LMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:12:35 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60669 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077Ab2K3LMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:12:33 -0500
Date: Fri, 30 Nov 2012 11:12:27 +0000
From: Lee Jones <lee.jones@linaro.org>
To: "Rajanikanth H.V" <rajanikanth.hv@linaro.org>
Cc: anton.vorontsov@linaro.org, francescolavra.fl@gmail.com,
        rob.herring@calxeda.com, arnd@arndb.de, linus.walleij@stericsson.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        STEricsson_nomadik_linux@list.st.com, rajanikanth.hv@stericsson.com
Subject: Re: [PATCH] ab8500: remove explicit handling of battery type
Message-ID: <20121130111227.GE26023@gmail.com>
References: <1354130865-6148-1-git-send-email-rajanikanth.hv@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1354130865-6148-1-git-send-email-rajanikanth.hv@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2012, Rajanikanth H.V wrote:

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

I don't much like this commit message.

Take a look at some others to see how it's normally done.

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

This should be a separate patch.

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
>  	}
> -
> -	if (strncmp(bat_tech, "LION", 4) == 0) {
> +	if (strncmp(btech, "LION", 4) == 0) {
>  		bat->no_maintenance  = true;
>  		bat->chg_unknown_bat = true;
>  		bat->bat_type[BATTERY_UNKNOWN].charge_full_design = 2600;
> @@ -508,7 +504,7 @@ bmdevs_of_probe(struct device *dev,
>  		if (thermistor == NTC_EXTERNAL) {
>  			btype->batres_tbl =
>  				temp_to_batres_tbl_ext_thermistor;
> -		} else if (strncmp(bat_tech, "LION", 4) == 0) {
> +		} else if (strncmp(btech, "LION", 4) == 0) {
>  			btype->batres_tbl =
>  				temp_to_batres_tbl_9100;
>  		} else {

Code is good though.

Once you have a sensible commit message you can apply my Acked-by
for both patches.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
