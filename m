Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab0DAMCC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 08:02:02 -0400
Received: from bamako.nerim.net ([62.4.17.28]:61748 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755769Ab0DAMBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 08:01:55 -0400
Date: Thu, 1 Apr 2010 14:01:52 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
       Jonathan Cameron <jic23@cam.ac.uk>
Cc: <lm-sensors@lm-sensors.org>, linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] [PATCH] hwmon: sht15: Fix sht15_calc_temp 
 interpolation function
Message-ID: <20100401140152.3141b989@hyperion.delvare>
In-Reply-To: <1269639013-26029-1-git-send-email-jerome.oufella@savoirfairelinux.com>
References: <1269639013-26029-1-git-send-email-jerome.oufella@savoirfairelinux.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jerome, Jonathan,

On Fri, 26 Mar 2010 17:30:13 -0400, Jerome Oufella wrote:
> I discovered two issues.
> First the previous sht15_calc_temp() loop did not iterate through the
> temppoints array since the (data->supply_uV > temppoints[i - 1].vdd)
> test is always true in this direction.
> 
> Also the two-points linear interpolation function was returning biased
> values which I adressed using a different form of interpolation.
> 
> Signed-off-by: Jerome Oufella <jerome.oufella@savoirfairelinux.com>
> ---
> 
>  drivers/hwmon/sht15.c |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/drivers/hwmon/sht15.c b/drivers/hwmon/sht15.c
> index 864a371..a6ad93b 100644
> --- a/drivers/hwmon/sht15.c
> +++ b/drivers/hwmon/sht15.c
> @@ -303,15 +303,15 @@ error_ret:
>  static inline int sht15_calc_temp(struct sht15_data *data)
>  {
>  	int d1 = 0;
> -	int i;
> +	int i, t;
>  
> -	for (i = 1; i < ARRAY_SIZE(temppoints); i++)
> +	for (i = ARRAY_SIZE(temppoints) - 1; i > 0; i--)
>  		/* Find pointer to interpolate */
> -		if (data->supply_uV > temppoints[i - 1].vdd) {
> -			d1 = (data->supply_uV/1000 - temppoints[i - 1].vdd)
> -				* (temppoints[i].d1 - temppoints[i - 1].d1)
> -				/ (temppoints[i].vdd - temppoints[i - 1].vdd)
> -				+ temppoints[i - 1].d1;
> +		if (data->supply_uV >= temppoints[i - 1].vdd) {
> +			t = (data->supply_uV - temppoints[i-1].vdd) / 
> +				((temppoints[i].vdd - temppoints[i-1].vdd) / 10000);
> +
> +			d1 = (temppoints[i].d1 * t + (10000 - t) * temppoints[i-1].d1) / 10000;
>  			break;
>  		}
>  

May I suggest the more simple fix below?

---
 drivers/hwmon/sht15.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.34-rc3.orig/drivers/hwmon/sht15.c	2010-04-01 13:41:15.000000000 +0200
+++ linux-2.6.34-rc3/drivers/hwmon/sht15.c	2010-04-01 13:41:55.000000000 +0200
@@ -305,10 +305,10 @@ static inline int sht15_calc_temp(struct
 	int d1 = 0;
 	int i;
 
-	for (i = 1; i < ARRAY_SIZE(temppoints); i++)
+	for (i = ARRAY_SIZE(temppoints) - 1; i > 0 ;i--)
 		/* Find pointer to interpolate */
 		if (data->supply_uV > temppoints[i - 1].vdd) {
-			d1 = (data->supply_uV/1000 - temppoints[i - 1].vdd)
+			d1 = (data->supply_uV - temppoints[i - 1].vdd)
 				* (temppoints[i].d1 - temppoints[i - 1].d1)
 				/ (temppoints[i].vdd - temppoints[i - 1].vdd)
 				+ temppoints[i - 1].d1;

It leads to the same numbers as with Jerome's patch, with the
advantages that 1* it is a much smaller change, more suitable for
applying to stable kernels and 2* it avoids the magic constant number
10000.

The "/1000" seems to be a relict of former times when temppoints[*].vdd
was probably expressed in millivolt instead of microvolt. And the
inverted loop iteration is obviously a bug.

Note that in both cases, something should be done about values which
are outside of the temppoints array. I don't know how likely these are,
but they are seriously mishandled. For supply_uV values below
temppoints[0].vdd, d1 defaults to 0, so no adjustment is done at all.
temppoints[0].d1 would seem to be a much better default, if we don't
want to do any interpolation in that case. For supply_uV values above
temppoints[4].vdd, we do interpolate, which seems reasonable.

Opinions?

-- 
Jean Delvare
