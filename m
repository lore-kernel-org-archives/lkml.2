Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab2KSAJO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 19:09:14 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59790 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab2KSAJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 19:09:13 -0500
Date: Sun, 18 Nov 2012 16:05:52 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] bq27x00_battery: Do not report nominal available capaciy
 if battery is not calibrated
Message-ID: <20121119000552.GE29066@lizard.sbx05977.paloaca.wayport.net>
References: <1352558568-30607-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1352558568-30607-1-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2012 at 03:42:48PM +0100, Pali Rohár wrote:
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> ---
>  drivers/power/bq27x00_battery.c |    8 ++++++++
>  1 file changed, 8 insertions(+)

OK, I'm assuming we don't want this because otherwise we're getting bogus
values in the sysfs, and so we confuse userland. I added this explanation
to the commit message, but still would be great to hear some confirmation.

Anyways, this is applied now.

Thanks!

> diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
> index 5860d4d..41b3328 100644
> --- a/drivers/power/bq27x00_battery.c
> +++ b/drivers/power/bq27x00_battery.c
> @@ -230,6 +230,14 @@ static int bq27x00_battery_read_charge(struct bq27x00_device_info *di, u8 reg)
>   */
>  static inline int bq27x00_battery_read_nac(struct bq27x00_device_info *di)
>  {
> +	int flags;
> +	bool is_bq27500 = di->chip == BQ27500;
> +	bool is_higher = bq27xxx_is_chip_version_higher(di);
> +
> +	flags = bq27x00_read(di, BQ27x00_REG_FLAGS, !is_bq27500);
> +	if (flags >= 0 && !is_higher && (flags & BQ27000_FLAG_CI))
> +		return -ENODATA;
> +
>  	return bq27x00_battery_read_charge(di, BQ27x00_REG_NAC);
>  }
>  
> -- 
> 1.7.10.4
