Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab2DNAvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 20:51:25 -0400
Received: from imr3.ericy.com ([198.24.6.13]:50037 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab2DNAvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 20:51:23 -0400
Date: Fri, 13 Apr 2012 17:46:02 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
CC: "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Jean Delvare <khali@linux-fr.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH v6 1/3] hwmon: Maxim MAX197 support
Message-ID: <20120414004602.GA5609@ericsson.com>
References: <1334276935-11258-1-git-send-email-vivien.didelot@savoirfairelinux.com>
 <1334276935-11258-2-git-send-email-vivien.didelot@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1334276935-11258-2-git-send-email-vivien.didelot@savoirfairelinux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 08:28:53PM -0400, Vivien Didelot wrote:
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> ---
[ ... ]

> +
> +/**
> + * max197_show_input() - Show channel input
> + *
> + * Function called on read access on in{0,1,2,3,4,5,6,7}_input
> + */
> +static ssize_t max197_show_input(struct device *dev,
> +                                struct device_attribute *devattr,
> +                                char *buf)
> +{
> +       struct max197_chip *chip = dev_get_drvdata(dev);
> +       struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
> +       int channel = attr->index;
> +       u16 raw;
> +       s32 scaled;
> +       int ret;
> +
> +       if (mutex_lock_interruptible(&chip->lock))
> +               return -ERESTARTSYS;
> +
> +       ret = chip->pdata->convert(chip->ctrl_bytes[channel], &raw);
> +       if (ret) {
> +               dev_err(dev, "conversion failed\n");
> +               goto unlock;
> +       }

Hi Vivien,

thinking about this, you can simplify the API to

	ret = chip->pdata->convert(chip->ctrl_bytes[channel]);
	if (ret < 0) {
		dev_err(dev, "conversion failed\n");
		goto unlock;
	}
	scaled = ret;

This overloads the return value with both error code (< 0) and return value (unsigned, >= 0).
This would make the code a bit simpler and smaller.

Thanks,
Guenter
