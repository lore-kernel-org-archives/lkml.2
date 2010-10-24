Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867Ab0JXPH6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 11:07:58 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:55574 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932802Ab0JXPGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 11:06:16 -0400
X-Spam-Flag: NO
X-Spam-Score: -21.89
Message-ID: <4CC4410E.20003@tremplin-utc.net>
Date: Sun, 24 Oct 2010 16:22:06 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11) Gecko/20101020 Mandriva/3.1.5-1mdv2011.0 (2011.0) Thunderbird/3.1.5
MIME-Version: 1.0
To: Samu Onkalo <samu.p.onkalo@nokia.com>
CC: khali@linux-fr.org, guenter.roeck@ericsson.com, jic23@cam.ac.uk,
        lm-sensors@lm-sensors.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/12] hwmon: lis3: Power on corrections
References: <1287748654-2626-1-git-send-email-samu.p.onkalo@nokia.com> <1287748654-2626-6-git-send-email-samu.p.onkalo@nokia.com>
In-Reply-To: <1287748654-2626-6-git-send-email-samu.p.onkalo@nokia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 22-10-10 13:57, Samu Onkalo schreef:
> Sometimes lis3 chip seems to fail to setup factory tuning at boot up.
> This probably happens if there is some odd power ramp down ramp up sequence
> for example in device restart. Set boot bit in control2 register to
> trig boot sequence manually and wait until it is finished.
>
> Signed-off-by: Samu Onkalo<samu.p.onkalo@nokia.com>
> Acked-by: Jonathan Cameron<jic23@cam.ac.uk>
Acked-by: Eric Piel <eric.piel@tremplin-utc.net>
> ---
>   drivers/hwmon/lis3lv02d.c |   19 +++++++++++--------
>   drivers/hwmon/lis3lv02d.h |    1 +
>   2 files changed, 12 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
> index e2e0bb4..b44d4c5 100644
> --- a/drivers/hwmon/lis3lv02d.c
> +++ b/drivers/hwmon/lis3lv02d.c
> @@ -273,19 +273,22 @@ void lis3lv02d_poweron(struct lis3lv02d *lis3)
>
>   	lis3->init(lis3);
>
> -	/* LIS3 power on delay is quite long */
> -	msleep(lis3->pwron_delay / lis3lv02d_get_odr());
> -
>   	/*
>   	 * Common configuration
>   	 * BDU: (12 bits sensors only) LSB and MSB values are not updated until
>   	 *      both have been read. So the value read will always be correct.
> +	 * Set BOOT bit to refresh factory tuning values.
>   	 */
> -	if (lis3->whoami ==  WAI_12B) {
> -		lis3->read(lis3, CTRL_REG2,&reg);
> -		reg |= CTRL2_BDU;
> -		lis3->write(lis3, CTRL_REG2, reg);
> -	}
> +	lis3->read(lis3, CTRL_REG2,&reg);
> +	if (lis3->whoami ==  WAI_12B)
> +		reg |= CTRL2_BDU | CTRL2_BOOT;
> +	else
> +		reg |= CTRL2_BOOT_8B;
> +	lis3->write(lis3, CTRL_REG2, reg);
> +
> +	/* LIS3 power on delay is quite long */
> +	msleep(lis3->pwron_delay / lis3lv02d_get_odr());
> +
>   	if (lis3->reg_ctrl)
>   		lis3_context_restore(lis3);
>   }
> diff --git a/drivers/hwmon/lis3lv02d.h b/drivers/hwmon/lis3lv02d.h
> index 66e37b1..2ac27b9 100644
> --- a/drivers/hwmon/lis3lv02d.h
> +++ b/drivers/hwmon/lis3lv02d.h
> @@ -133,6 +133,7 @@ enum lis3lv02d_ctrl2 {
>   enum lis302d_ctrl2 {
>   	HP_FF_WU2	= 0x08,
>   	HP_FF_WU1	= 0x04,
> +	CTRL2_BOOT_8B   = 0x40,
>   };
>
>   enum lis3lv02d_ctrl3 {

