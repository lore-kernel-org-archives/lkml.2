Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163Ab2F0RGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 13:06:11 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:62234 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab2F0RGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 13:06:09 -0400
MIME-Version: 1.0
In-Reply-To: <20120627134849.GN1623@pengutronix.de>
References: <1340772715-22117-1-git-send-email-rob.lee@linaro.org>
 <1340772715-22117-2-git-send-email-rob.lee@linaro.org> <20120627134849.GN1623@pengutronix.de>
From: Rob Lee <rob.lee@linaro.org>
Date: Wed, 27 Jun 2012 12:05:27 -0500
Message-ID: <CAMXH7KF7yzyw3e+R7vciZQ0+BjO+cSsARfq9fEfvbJ_1bMF24A@mail.gmail.com>
Subject: Re: [PATCH v6] ARM: imx: Add basic imx6q thermal driver
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: kernel@pengutronix.de, shawn.guo@linaro.org, linux@arm.linux.org.uk,
        richard.zhao@freescale.com, dirk.behme@de.bosch.com,
        amit.kachhap@linaro.org, amit.kucheria@linaro.org, lenb@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 8:48 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Tue, Jun 26, 2012 at 11:51:55PM -0500, Robert Lee wrote:
>> +static inline int anatop_get_temp(int *temp, struct thermal_zone_device *tzdev)
>> +{
>> +     unsigned int n_meas;
>> +     unsigned int reg;
>> +     struct imx_anatop_tsdata *sd;
>> +
>> +     sd = &((struct imx_anatop_thdata *)tzdev->devdata)->sensor_data;
>> +
>> +
>> +     do {
>> +             /*
>> +              * Every time we measure the temperature, we will power on the
>> +              * temperature sensor, enable measurements, take a reading,
>> +              * disable measurements, power off the temperature sensor.
>> +              */
>> +             sd->handle_suspend = false;
>> +
>> +             anatop_write_reg(sd->anatopmfd, HW_ANADIG_TEMPSENSE0, 0,
>> +                     BM_ANADIG_TEMPSENSE0_POWER_DOWN);
>> +             anatop_write_reg(sd->anatopmfd, HW_ANADIG_TEMPSENSE0,
>> +                     BM_ANADIG_TEMPSENSE0_MEASURE_TEMP,
>> +                     BM_ANADIG_TEMPSENSE0_MEASURE_TEMP);
>> +             /*
>> +              * According to the anatop temp sensor designers, it may require
>> +              * up to ~17us to complete a measurement (imx6q).
>> +              * But this timing isn't checked on every part nor is it
>> +              * specified in the datasheet,  so sleeping at least 1ms should
>> +              * provide plenty of time.  Sleeping longer than 1ms is ok so no
>> +              * need for usleep_range */
>> +             msleep(1);
>> +
>> +             reg = anatop_read_reg(sd->anatopmfd, HW_ANADIG_TEMPSENSE0);
>> +
>> +             anatop_write_reg(sd->anatopmfd, HW_ANADIG_TEMPSENSE0, 0,
>> +                     BM_ANADIG_TEMPSENSE0_MEASURE_TEMP);
>> +             anatop_write_reg(sd->anatopmfd, HW_ANADIG_TEMPSENSE0,
>> +                     BM_ANADIG_TEMPSENSE0_POWER_DOWN,
>> +                     BM_ANADIG_TEMPSENSE0_POWER_DOWN);
>> +
>> +     /* if we had a suspend and resume event, we will re-take the reading */
>> +     } while (sd->handle_suspend);
>
> [...]
>
>> +static int anatop_thermal_suspend(struct platform_device *pdev,
>> +                                     pm_message_t state)
>> +{
>> +     struct imx_anatop_thdata *dd = platform_get_drvdata(pdev);
>> +     struct imx_anatop_tsdata *sd = &dd->sensor_data;
>> +
>> +     /* power off the sensor during suspend */
>> +     anatop_write_reg(sd->anatopmfd, HW_ANADIG_TEMPSENSE0, 0,
>> +             BM_ANADIG_TEMPSENSE0_MEASURE_TEMP);
>> +
>> +     anatop_write_reg(sd->anatopmfd, HW_ANADIG_TEMPSENSE0,
>> +             BM_ANADIG_TEMPSENSE0_POWER_DOWN,
>> +             BM_ANADIG_TEMPSENSE0_POWER_DOWN);
>> +     return 0;
>> +}
>> +
>> +static int anatop_thermal_resume(struct platform_device *pdev)
>> +{
>> +     struct imx_anatop_thdata *dd = platform_get_drvdata(pdev);
>> +     struct imx_anatop_tsdata *sd = &dd->sensor_data;
>> +
>> +     sd->handle_suspend = true;
>> +     return 0;
>> +}
>
> I don't know how to handle this properly or if it's really needed, but
> the usage of this handle_suspend variable really looks suspicious. I've
> never seen a driver looping around a while-suspended-in-between. Someone
> else should have a look over this.

I'll add some more context that may help you and others in analyzing this.

As mentioned, this driver hooks into the linux thermal framework.
Upon registration with this is framework, the thermal framework
creates a kernel thread which periodically checks the temperature and
takes any necessary action.  So anatop_get_temp periodically gets
called.  Now if a suspend were to occur during the msleep() call of
this function for example, the temperature read afterword may not be
valid.  So the loop check can detect that a suspend had occurred and
that the temperature sensor value read was invalid so it will try
again.

Another option would be for the resume function to return the
temperature sensor to its previous state that it was in right before
suspend.  This would require the resume to re-enable the temperature
sensor and spin in a loop waiting for the temperature measurement to
complete (aka, checking a hardware bit for completion) which
theoretically may take up to ~17us.  In this case, a timeout could be
added to this loop if we don't trust the hardware, and the looping in
the anatop_get_temp could be removed.  This function already has some
handling if an invalid temp sensor reading is detected.

>
> Sascha
>
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
