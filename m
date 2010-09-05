Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab0IEQpl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 12:45:41 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:14282 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab0IEQpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 12:45:40 -0400
Date: Sun, 5 Sep 2010 18:45:22 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guillem Jover <guillem@hadrons.org>
Cc: Riku Voipio <riku.voipio@iki.fi>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH 1/2] hwmon: (f75375s) Shift control mode to
 the  correct bit position
Message-ID: <20100905184522.0825f390@hyperion.delvare>
In-Reply-To: <20100903025459.GA15996@gaara.hadrons.org>
References: <20100903025459.GA15996@gaara.hadrons.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guillem,

On Fri, 3 Sep 2010 04:54:59 +0200, Guillem Jover wrote:
> The spec notes that fan0 and fan1 control mode bits are located in bits
> 7-6 and 5-4 respectively, but the FAN_CTRL_MODE macro was making the
> bits shift by 5 instead of by 4.
> 
> Signed-off-by: Guillem Jover <guillem@hadrons.org>
> ---
>  drivers/hwmon/f75375s.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hwmon/f75375s.c b/drivers/hwmon/f75375s.c
> index 0f58ecc..e5828c0 100644
> --- a/drivers/hwmon/f75375s.c
> +++ b/drivers/hwmon/f75375s.c
> @@ -79,7 +79,7 @@ enum chips { f75373, f75375 };
>  #define F75375_REG_PWM2_DROP_DUTY	0x6C
>  
>  #define FAN_CTRL_LINEAR(nr)		(4 + nr)
> -#define FAN_CTRL_MODE(nr)		(5 + ((nr) * 2))
> +#define FAN_CTRL_MODE(nr)		(4 + ((nr) * 2))
>  
>  /*
>   * Data structures and manipulation thereof

Good catch, patch applied, thanks.

Note though that it seems that this driver needs some more love in this
area. Struct f75375_data has a member fan_timer to which the contents
of register 0x60 (F75375_REG_FAN_TIMER) is written in
f75375_update_device(), but this value isn't used anywhere. Secondly,
struct member pwm_mode is _not_ initialized anywhere, although
show_pwm_mode() exports it to user-space. And member pwm_enable is
worse, the fans are set to full speed arbitrarily when the driver is
loaded (in function f75375_init()), which is bad practice. So there is
definitely room for cleanups and improvements, if you are interested in
this driver.

-- 
Jean Delvare
