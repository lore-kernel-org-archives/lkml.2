Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab2EEMxh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 08:53:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65002 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238Ab2EEMxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 08:53:35 -0400
Date: Sat, 5 May 2012 05:52:11 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
        bruce.e.robertson@intel.com,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Subject: Re: [PATCH 4/4] power-supply: smb347-charger: convert to regmap API
Message-ID: <20120505125211.GA31577@lizard>
References: <1334566121-8243-1-git-send-email-mika.westerberg@linux.intel.com>
 <1334566121-8243-4-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1334566121-8243-4-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 11:48:41AM +0300, Mika Westerberg wrote:
> The smb347-charger driver does a lot of read-modify-write to the device
> registers. Instead of open-coding everything we can take advantage of regmap
> API which provides nice functions to do this kind of things.
> 
> In addition there is no need for custom debugfs file for dumping registers as
> this is already provided by the regmap API.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
[...]
>  static int smb347_set_temp_limits(struct smb347_charger *smb)
> @@ -491,22 +468,13 @@ static int smb347_set_temp_limits(struct smb347_charger *smb)
>  		val = clamp_val(val, 100, 130) - 100;
>  		val /= 10;
>  
> -		ret = smb347_read(smb, CFG_OTG);
> -		if (ret < 0)
> -			return ret;
> -
> -		ret &= ~CFG_OTG_TEMP_THRESHOLD_MASK;
> -		ret |= val << CFG_OTG_TEMP_THRESHOLD_SHIFT;
> -
> -		ret = smb347_write(smb, CFG_OTG, ret);
> +		ret = regmap_update_bits(smb->regmap, CFG_OTG,
> +					 CFG_OTG_TEMP_THRESHOLD_MASK,
> +					 val << CFG_OTG_TEMP_THRESHOLD_SHIFT);
>  		if (ret < 0)
>  			return ret;
>  	}
>  
> -	ret = smb347_read(smb, CFG_TEMP_LIMIT);
> -	if (ret < 0)
> -		return ret;
> -

FYI, removing these hunks causes the following warning:

  CC      drivers/power/smb347-charger.o
  drivers/power/smb347-charger.c: In function ‘smb347_set_temp_limits’:
  drivers/power/smb347-charger.c:462:6: warning: ‘ret’ may be used uninitialized in this function [-Wuninitialized]

I fixed this by the following change:

diff --git a/drivers/power/smb347-charger.c b/drivers/power/smb347-charger.c
index 1f27d21..cf31b31 100644
--- a/drivers/power/smb347-charger.c
+++ b/drivers/power/smb347-charger.c
@@ -459,7 +459,8 @@ static int smb347_set_voltage_limits(struct smb347_charger *smb)
 static int smb347_set_temp_limits(struct smb347_charger *smb)
 {
 	bool enable_therm_monitor = false;
-	int ret, val;
+	int ret = 0;
+	int val;
 
 	if (smb->pdata->chip_temp_threshold) {
 		val = smb->pdata->chip_temp_threshold;

Please check if that's all OK.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
