Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab2HWCip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 22:38:45 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:36638 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab2HWCin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 22:38:43 -0400
Date: Wed, 22 Aug 2012 19:36:15 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>
Subject: Re: [PATCH] power_supply: Remove broken mark for da9052-battery
Message-ID: <20120823023612.GD24471@lizard>
References: <1344413298.17894.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1344413298.17894.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 04:08:18PM +0800, Axel Lin wrote:
> The fix for MFD part is already merged so we can remove the broken mark
> for da9052-battery.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
[...]
> -	depends on BROKEN

Applied, thanks a lot!

Though, I had to apply the following right after:

commit bc909f27f55ceb8f950ced5cf3a26d6b26e86ca6
Author: Anton Vorontsov <anton.vorontsov@linaro.org>
Date:   Wed Aug 22 19:29:44 2012 -0700

    da9052-battery: Fix da9052_determine_vc_tbl_index's return value
    
    The patch fixes the following warnings:
    
      CHECK   drivers/power/da9052-battery.c
    drivers/power/da9052-battery.c:330:15: warning: symbol 'da9052_determine_vc_tbl_index' was not declared. Should it be static?
      CC      drivers/power/da9052-battery.o
    drivers/power/da9052-battery.c: In function 'da9052_determine_vc_tbl_index':
    drivers/power/da9052-battery.c:348:1: warning: control reaches end of non-void function [-Wreturn-type]
    
    Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

diff --git a/drivers/power/da9052-battery.c b/drivers/power/da9052-battery.c
index a5f6a0e..20b86ed 100644
--- a/drivers/power/da9052-battery.c
+++ b/drivers/power/da9052-battery.c
@@ -327,7 +327,7 @@ static int da9052_bat_interpolate(int vbat_lower, int  vbat_upper,
 	return tmp;
 }
 
-unsigned char da9052_determine_vc_tbl_index(unsigned char adc_temp)
+static unsigned char da9052_determine_vc_tbl_index(unsigned char adc_temp)
 {
 	int i;
 
@@ -345,6 +345,13 @@ unsigned char da9052_determine_vc_tbl_index(unsigned char adc_temp)
 		     && (adc_temp <= vc_tbl_ref[i]))
 				return i + 1;
 	}
+	/*
+	 * For some reason authors of the driver didn't presume that we can
+	 * end up here. It might be OK, but might be not, no one knows for
+	 * sure. Go check your battery, is it on fire?
+	 */
+	WARN_ON(1);
+	return 0;
 }
 
 static int da9052_bat_read_capacity(struct da9052_battery *bat, int *capacity)
