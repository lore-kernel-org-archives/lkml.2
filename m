Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219Ab0JXPG2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 11:06:28 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:47597 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876Ab0JXPG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 11:06:27 -0400
X-Spam-Flag: NO
X-Spam-Score: -21.89
Message-ID: <4CC443C4.1040700@tremplin-utc.net>
Date: Sun, 24 Oct 2010 16:33:40 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11) Gecko/20101020 Mandriva/3.1.5-1mdv2011.0 (2011.0) Thunderbird/3.1.5
MIME-Version: 1.0
To: Samu Onkalo <samu.p.onkalo@nokia.com>
CC: khali@linux-fr.org, guenter.roeck@ericsson.com, jic23@cam.ac.uk,
        lm-sensors@lm-sensors.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/12] hwmon: lis3: Adjust fuzziness for 8 bit device
References: <1287748654-2626-1-git-send-email-samu.p.onkalo@nokia.com> <1287748654-2626-9-git-send-email-samu.p.onkalo@nokia.com>
In-Reply-To: <1287748654-2626-9-git-send-email-samu.p.onkalo@nokia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 22-10-10 13:57, Samu Onkalo schreef:
> Default fuziness is set smaller for 8 device.
> In 12 bit device LSB is quite close to 1 mg
> (mg = 1 / 1000 of earth gravity).
> In 8bit device LSB is about 18 mg.
> Set fuziness to 1 for 8 bit device.
>
> Signed-off-by: Samu Onkalo<samu.p.onkalo@nokia.com>
Acked-by: Eric Piel <eric.piel@tremplin-utc.net>
> ---
>   drivers/hwmon/lis3lv02d.c |   18 ++++++++++++++----
>   1 files changed, 14 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
> index d66cbe1..7555091 100644
> --- a/drivers/hwmon/lis3lv02d.c
> +++ b/drivers/hwmon/lis3lv02d.c
> @@ -71,8 +71,10 @@
>   #define LIS3_SENSITIVITY_12B		((LIS3_ACCURACY * 1000) / 1024)
>   #define LIS3_SENSITIVITY_8B		(18 * LIS3_ACCURACY)
>
> -#define LIS3_DEFAULT_FUZZ		3
> -#define LIS3_DEFAULT_FLAT		3
> +#define LIS3_DEFAULT_FUZZ_12B		3
> +#define LIS3_DEFAULT_FLAT_12B		3
> +#define LIS3_DEFAULT_FUZZ_8B		1
> +#define LIS3_DEFAULT_FLAT_8B		1
>
>   struct lis3lv02d lis3_dev = {
>   	.misc_wait   = __WAIT_QUEUE_HEAD_INITIALIZER(lis3_dev.misc_wait),
> @@ -530,8 +532,16 @@ int lis3lv02d_joystick_enable(void)
>
>   	set_bit(EV_ABS, input_dev->evbit);
>   	max_val = (lis3_dev.mdps_max_val * lis3_dev.scale) / LIS3_ACCURACY;
> -	fuzz = (LIS3_DEFAULT_FUZZ * lis3_dev.scale) / LIS3_ACCURACY;
> -	flat = (LIS3_DEFAULT_FLAT * lis3_dev.scale) / LIS3_ACCURACY;
> +	if (lis3_dev.whoami == WAI_12B) {
> +		fuzz = LIS3_DEFAULT_FUZZ_12B;
> +		flat = LIS3_DEFAULT_FLAT_12B;
> +	} else {
> +		fuzz = LIS3_DEFAULT_FUZZ_8B;
> +		flat = LIS3_DEFAULT_FLAT_8B;
> +	}
> +	fuzz = (fuzz * lis3_dev.scale) / LIS3_ACCURACY;
> +	flat = (flat * lis3_dev.scale) / LIS3_ACCURACY;
> +
>   	input_set_abs_params(input_dev, ABS_X, -max_val, max_val, fuzz, flat);
>   	input_set_abs_params(input_dev, ABS_Y, -max_val, max_val, fuzz, flat);
>   	input_set_abs_params(input_dev, ABS_Z, -max_val, max_val, fuzz, flat);

