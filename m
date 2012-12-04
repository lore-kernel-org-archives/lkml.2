Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab2LDI44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 03:56:56 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53135 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab2LDI4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 03:56:54 -0500
Date: Tue, 4 Dec 2012 08:56:47 +0000
From: Lee Jones <lee.jones@linaro.org>
To: "Rajanikanth H.V" <rajanikanth.hv@linaro.org>
Cc: anton.vorontsov@linaro.org, francescolavra.fl@gmail.com,
        rob.herring@calxeda.com, arnd@arndb.de, linus.walleij@stericsson.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        STEricsson_nomadik_linux@list.st.com, rajanikanth.hv@stericsson.com
Subject: Re: [PATCH 1/2] ab8500: remove explicit handling of battery type
Message-ID: <20121204085647.GA2718@gmail.com>
References: <1354558375-15110-1-git-send-email-rajanikanth.hv@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1354558375-15110-1-git-send-email-rajanikanth.hv@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>
> 
> dt property, 'battery-type' shall be one of supported technology type
> instead blank.
> refer:Documentation/devicetree/bindings/power_supply/ab8500/fg.txt
>       for the list of supported types
> 
> thanks to Francesco Lavra for highlighting missing of_node_put(...)
> 
> for '3.7-rc5': of git://git.infradead.org/battery-2.6.git

Uppercase 'DT'. 
No need for the comma after 'property'.
No real need to reference to the documentation.
No need to add personal thanks to a commit message.
No need to mention the patch's intended route in the commit message.

How about something more like:

Subject: ab8500: Remove initial "UNKNOWN" battery-type string assignment

DT property 'stericsson,battery-type' should always be present in the
Device Tree when describing battery hardware. Thus, instead of
pointlessly assigning "UNKNOWN" as a valid battery-type, we should
actually fail initialisation entirely if the property is missing.

> Acked-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Rajanikanth H.V <rajanikanth.hv@stericsson.com>
> ---
>  drivers/power/ab8500_bmdata.c |   11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/power/ab8500_bmdata.c b/drivers/power/ab8500_bmdata.c
> index 03cc528..2230b2c 100644
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
> @@ -488,12 +487,10 @@ bmdevs_of_probe(struct device *dev,
>  		"stericsson,battery-type", NULL);
>  	if (!btech) {
>  		dev_warn(dev, "missing property battery-name/type\n");
> -		strcpy(bat_tech, "UNKNOWN");
> -	} else {
> -		strcpy(bat_tech, btech);
> +		of_node_put(np_bat_supply);
> +		return -EINVAL;
>  	}
> -
> -	if (strncmp(bat_tech, "LION", 4) == 0) {
> +	if (strncmp(btech, "LION", 4) == 0) {
>  		bat->no_maintenance  = true;
>  		bat->chg_unknown_bat = true;
>  		bat->bat_type[BATTERY_UNKNOWN].charge_full_design = 2600;
> @@ -508,7 +505,7 @@ bmdevs_of_probe(struct device *dev,
>  		if (thermistor == NTC_EXTERNAL) {
>  			btype->batres_tbl =
>  				temp_to_batres_tbl_ext_thermistor;
> -		} else if (strncmp(bat_tech, "LION", 4) == 0) {
> +		} else if (strncmp(btech, "LION", 4) == 0) {
>  			btype->batres_tbl =
>  				temp_to_batres_tbl_9100;
>  		} else {
> -- 
> 1.7.10.4
> 

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
