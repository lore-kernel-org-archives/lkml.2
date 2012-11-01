Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761301Ab2KAOqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 10:46:31 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46243 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab2KAOq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 10:46:28 -0400
Message-ID: <50928BC9.30305@gmail.com>
Date: Thu, 01 Nov 2012 15:48:41 +0100
From: Francesco Lavra <francescolavra.fl@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: "hongbo.zhang" <hongbo.zhang@linaro.org>
CC: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, rui.zhang@intel.com, amit.kachhap@linaro.org,
        STEricsson_nomadik_linux@list.st.com, kernel@igloocommunity.org,
        linaro-kernel@lists.linaro.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>, patches@linaro.org
Subject: Re: [PATCH V3 4/5] Thermal: Add ST-Ericsson DB8500 thermal driver.
References: <1351079900-32236-1-git-send-email-hongbo.zhang@linaro.com> <1351615741-24134-1-git-send-email-hongbo.zhang@linaro.com> <1351615741-24134-5-git-send-email-hongbo.zhang@linaro.com>
In-Reply-To: <1351615741-24134-5-git-send-email-hongbo.zhang@linaro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/30/2012 05:49 PM, hongbo.zhang wrote:
> From: "hongbo.zhang" <hongbo.zhang@linaro.com>
> 
> This diver is based on the thermal management framework in thermal_sys.c. A
> thermal zone device is created with the trip points to which cooling devices
> can be bound, the current cooling device is cpufreq, e.g. CPU frequency is
> clipped down to cool the CPU, and other cooling devices can be added and bound
> to the trip points dynamically.  The platform specific PRCMU interrupts are
> used to active thermal update when trip points are reached.
> 
> Signed-off-by: hongbo.zhang <hongbo.zhang@linaro.com>

[...]
> +static struct db8500_thsens_platform_data*
> +		db8500_thermal_parse_dt(struct platform_device *pdev)
> +{
> +	struct db8500_thsens_platform_data *ptrips;
> +	struct device_node *np = pdev->dev.of_node;
> +	char prop_name[32];
> +	const char *tmp_str;
> +	u32 tmp_data;
> +	int i, j;
> +
> +	ptrips = devm_kzalloc(&pdev->dev, sizeof(*ptrips), GFP_KERNEL);
> +	if (!ptrips)
> +		return NULL;
> +
> +	if (of_property_read_u32(np, "num-trips", &tmp_data))
> +		goto err_parse_dt;
> +
> +	if (tmp_data > THERMAL_MAX_TRIPS)
> +		goto err_parse_dt;
> +
> +	ptrips->num_trips = tmp_data;
> +
> +	for (i = 0; i < ptrips->num_trips; i++) {
> +		sprintf(prop_name, "trip%d-temp", i);
> +		if (of_property_read_u32(np, prop_name, &tmp_data))
> +			goto err_parse_dt;
> +
> +		ptrips->trip_points[i].temp = tmp_data;
> +
> +		sprintf(prop_name, "trip%d-type", i);
> +		if (of_property_read_string(np, prop_name, &tmp_str))
> +			goto err_parse_dt;
> +
> +		if (!strcmp(tmp_str, "active"))
> +			ptrips->trip_points[i].type = THERMAL_TRIP_ACTIVE;
> +		else if (!strcmp(tmp_str, "passive"))
> +			ptrips->trip_points[i].type = THERMAL_TRIP_PASSIVE;
> +		else if (!strcmp(tmp_str, "hot"))
> +			ptrips->trip_points[i].type = THERMAL_TRIP_HOT;
> +		else if (!strcmp(tmp_str, "critical"))
> +			ptrips->trip_points[i].type = THERMAL_TRIP_CRITICAL;
> +		else
> +			goto err_parse_dt;
> +
> +		sprintf(prop_name, "trip%d-cdev-num", i);
> +		if (of_property_read_u32(np, prop_name, &tmp_data))
> +			goto err_parse_dt;
> +
> +		if (tmp_data > COOLING_DEV_MAX)
> +			goto err_parse_dt;
> +
> +		for (j = 0; j < tmp_data; j++) {
> +			sprintf(prop_name, "trip%d-cdev-name%d", i, j);
> +			if (of_property_read_string(np, prop_name, &tmp_str))
> +				goto err_parse_dt;
> +
> +			if (strlen(tmp_str) > THERMAL_NAME_LENGTH)
> +				goto err_parse_dt;
> +
> +			strcpy(ptrips->trip_points[i].cdev_name[j], tmp_str);

If strlen(tmp_str) equals THERMAL_NAME_LENGTH, strcpy() will go past the
size of the destination array.

After the above is fixed, you can add my:
Reviewed-by: Francesco Lavra <francescolavra.fl@gmail.com>

If you re-send a new version of the patch series, I suggest you do so in
a new thread.

Thanks,
Francesco
