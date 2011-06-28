Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874Ab1F1Rhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 13:37:55 -0400
Received: from imr4.ericy.com ([198.24.6.8]:60482 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759950Ab1F1Rgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 13:36:43 -0400
Subject: Re: [PATCH 6/11] HWMON: DA9052 hwmon driver v1
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: "ashish.jangam@kpitcummins.com" <ashish.jangam@kpitcummins.com>
CC: "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "dchen@diasemi.com" <dchen@diasemi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
In-Reply-To: <1309271069.376.236.camel@L-0532.kpit.com>
References: <1309271069.376.236.camel@L-0532.kpit.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Tue, 28 Jun 2011 10:35:54 -0700
Message-ID: <1309282554.2612.7.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-28 at 10:24 -0400, ashishj3 wrote:
> The DA9052 PMIC provides an Analogue to Digital Converter with 10 bits
> resolution and 10 channels.
> 
> This patch montiors the DA9052 PMIC's ADC channels mostly for battery parameters
> like battery temperature, junction temperature, battery current etc.
> 
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>

[ ... ]

> +static ssize_t da9052_read_vddout(struct device *dev,
> +                                  struct device_attribute *devattr, char *buf)
> +{
> +       struct da9052_hwmon *hwmon = dev_get_drvdata(dev);
> +       int ret, vdd = -1;
> +
> +       mutex_lock(&hwmon->hwmon_lock);
> +
> +       ret = da9052_enable_vddout_channel(hwmon->da9052);
> +       if (ret < 0)
> +               goto hwmon_err;
> +
> +       ret = da9052_reg_read(hwmon->da9052, DA9052_VDD_RES_REG);
> +       if (ret < 0)
> +               pr_err("failed to read VDD_RES_REG\n");
> +       else
> +               vdd = ret;
> +
> +       ret = da9052_disable_vddout_channel(hwmon->da9052);
> +       if (ret < 0)
> +               goto hwmon_err;
> +
> +       if (vdd >= 0) {
> +               mutex_unlock(&hwmon->hwmon_lock);
> +               return sprintf(buf, "%d\n", vdd);
> +       }
> +
> +hwmon_err:
> +       mutex_unlock(&hwmon->hwmon_lock);
> +       return ret;
> +}

This function still produces a bad result if the call to
da9052_reg_read() fails and the call to da9052_disable_vddout_channel()
doesn't. 

I would suggest to replace pr_err() with "goto hwmon_err". If you do
that, you don't need to initialize vdd, you don't need the else case for
its assignment, and you don't need "if (vdd >= 0)" either.

Guenter


