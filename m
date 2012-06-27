Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab2F0NtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 09:49:12 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37168 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab2F0NtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 09:49:10 -0400
Date: Wed, 27 Jun 2012 15:48:49 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Robert Lee <rob.lee@linaro.org>
Cc: kernel@pengutronix.de, shawn.guo@linaro.org, linux@arm.linux.org.uk,
        richard.zhao@freescale.com, dirk.behme@de.bosch.com,
        amit.kachhap@linaro.org, amit.kucheria@linaro.org, lenb@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH v6] ARM: imx: Add basic imx6q thermal driver
Message-ID: <20120627134849.GN1623@pengutronix.de>
References: <1340772715-22117-1-git-send-email-rob.lee@linaro.org>
 <1340772715-22117-2-git-send-email-rob.lee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340772715-22117-2-git-send-email-rob.lee@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:44:05 up 4 days,  4:55, 50 users,  load average: 0.30, 0.94, 1.40
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 11:51:55PM -0500, Robert Lee wrote:
> +static inline int anatop_get_temp(int *temp, struct thermal_zone_device *tzdev)
> +{
> +	unsigned int n_meas;
> +	unsigned int reg;
> +	struct imx_anatop_tsdata *sd;
> +
> +	sd = &((struct imx_anatop_thdata *)tzdev->devdata)->sensor_data;
> +
> +
> +	do {
> +		/*
> +		 * Every time we measure the temperature, we will power on the
> +		 * temperature sensor, enable measurements, take a reading,
> +		 * disable measurements, power off the temperature sensor.
> +		 */
> +		sd->handle_suspend = false;
> +
> +		anatop_write_reg(sd->anatopmfd, HW_ANADIG_TEMPSENSE0, 0,
> +			BM_ANADIG_TEMPSENSE0_POWER_DOWN);
> +		anatop_write_reg(sd->anatopmfd, HW_ANADIG_TEMPSENSE0,
> +			BM_ANADIG_TEMPSENSE0_MEASURE_TEMP,
> +			BM_ANADIG_TEMPSENSE0_MEASURE_TEMP);
> +		/*
> +		 * According to the anatop temp sensor designers, it may require
> +		 * up to ~17us to complete a measurement (imx6q).
> +		 * But this timing isn't checked on every part nor is it
> +		 * specified in the datasheet,	so sleeping at least 1ms should
> +		 * provide plenty of time.  Sleeping longer than 1ms is ok so no
> +		 * need for usleep_range */
> +		msleep(1);
> +
> +		reg = anatop_read_reg(sd->anatopmfd, HW_ANADIG_TEMPSENSE0);
> +
> +		anatop_write_reg(sd->anatopmfd, HW_ANADIG_TEMPSENSE0, 0,
> +			BM_ANADIG_TEMPSENSE0_MEASURE_TEMP);
> +		anatop_write_reg(sd->anatopmfd, HW_ANADIG_TEMPSENSE0,
> +			BM_ANADIG_TEMPSENSE0_POWER_DOWN,
> +			BM_ANADIG_TEMPSENSE0_POWER_DOWN);
> +
> +	/* if we had a suspend and resume event, we will re-take the reading */
> +	} while (sd->handle_suspend);

[...]

> +static int anatop_thermal_suspend(struct platform_device *pdev,
> +					pm_message_t state)
> +{
> +	struct imx_anatop_thdata *dd = platform_get_drvdata(pdev);
> +	struct imx_anatop_tsdata *sd = &dd->sensor_data;
> +
> +	/* power off the sensor during suspend */
> +	anatop_write_reg(sd->anatopmfd, HW_ANADIG_TEMPSENSE0, 0,
> +		BM_ANADIG_TEMPSENSE0_MEASURE_TEMP);
> +
> +	anatop_write_reg(sd->anatopmfd, HW_ANADIG_TEMPSENSE0,
> +		BM_ANADIG_TEMPSENSE0_POWER_DOWN,
> +		BM_ANADIG_TEMPSENSE0_POWER_DOWN);
> +	return 0;
> +}
> +
> +static int anatop_thermal_resume(struct platform_device *pdev)
> +{
> +	struct imx_anatop_thdata *dd = platform_get_drvdata(pdev);
> +	struct imx_anatop_tsdata *sd = &dd->sensor_data;
> +
> +	sd->handle_suspend = true;
> +	return 0;
> +}

I don't know how to handle this properly or if it's really needed, but
the usage of this handle_suspend variable really looks suspicious. I've
never seen a driver looping around a while-suspended-in-between. Someone
else should have a look over this.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
