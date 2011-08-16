Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab1HPX0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 19:26:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751862Ab1HPX0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 19:26:13 -0400
Date: Tue, 16 Aug 2011 16:25:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Clifton Barnes <cabarnes@indesign-llc.com>
Cc: <ryan@bluewatersys.com>, <haojian.zhuang@marvell.com>,
        <johnpol@2ka.mipt.ru>, <simon.inizan@goobie.fr>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] w1: ds2780, fix potential deadlock on insertion and
 removal
Message-Id: <20110816162553.c87ceb5c.akpm@linux-foundation.org>
In-Reply-To: <4E4575F9.40006@indesign-llc.com>
References: <4E4575F9.40006@indesign-llc.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Aug 2011 14:50:33 -0400
Clifton Barnes <cabarnes@indesign-llc.com> wrote:

> Simon Inizan found a synchronization problem with the w1 interface locking the 
> mutex during insertion and removal, but the power supply interface trying to 
> get POWER_SUPPLY_PROP_STATUS upon insertion and removal, which causes a 1-wire 
> transaction that tries to lock the mutex again.  The following patch has been 
> tested to fix the problem.  It is not a very elegant solution with using a 
> variable to store the lock status, so if anyone has a better idea please 
> present it.

Changing the type of the first arg to ds2780_read8() and friends
created a lot of patch noise - it would have been nice to separate that
out into a second patch.  Not a major issue though.

> ---
>  drivers/power/ds2780_battery.c |   86 +++++++++++++++++++++++----------------
>  drivers/w1/slaves/w1_ds2780.c  |    1 -
>  2 files changed, 51 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/power/ds2780_battery.c b/drivers/power/ds2780_battery.c
> index 1fefe82..2be668d 100644
> --- a/drivers/power/ds2780_battery.c
> +++ b/drivers/power/ds2780_battery.c
> @@ -39,6 +39,7 @@ struct ds2780_device_info {
>  	struct device *dev;
>  	struct power_supply bat;
>  	struct device *w1_dev;
> +	int lock_held;
>  };
>  
>  enum current_types {
> @@ -49,8 +50,8 @@ enum current_types {
>  static const char model[] = "DS2780";
>  static const char manufacturer[] = "Maxim/Dallas";
>  
> -static inline struct ds2780_device_info *to_ds2780_device_info(
> -	struct power_supply *psy)
> +static inline struct ds2780_device_info *
> +to_ds2780_device_info(struct power_supply *psy)
>  {
>  	return container_of(psy, struct ds2780_device_info, bat);
>  }
> @@ -60,17 +61,28 @@ static inline struct power_supply *to_power_supply(struct device *dev)
>  	return dev_get_drvdata(dev);
>  }
>  
> -static inline int ds2780_read8(struct device *dev, u8 *val, int addr)
> +static inline int ds2780_battery_io(struct ds2780_device_info *dev_info,
> +	char *buf, int addr, size_t count, int io)
>  {
> -	return w1_ds2780_io(dev, val, addr, sizeof(u8), 0);
> +	if (dev_info->lock_held)
> +		return count;
> +	else
> +		return w1_ds2780_io(dev_info->w1_dev, buf, addr, count, io);
> +}

I think this is just not correct.

a) We only need to avoid the mutex_lock() if *this thread* already
   holds the lock.  But testing the flag in this manner causes the code
   to avoid taking the lock if some other thread set lock_held.  But
   what we should have done in this case was to wait, by calling
   mutex_lock().

b) If the lock was held, the function simply bales out, returning
   incorrect data for a read() and doing nothing for a write().


A way to fix all this (still ugly though) would be to replace lock_held
with a task_struct* which points at the task which currently holds the
mutex, and is NULL if no task holds the mutex.  Then we do

	if (dev_info->mutex_holder == current)
		w1_ds2780_io_nolock(...);
	else
		w1_ds2780_io(...);

Where w1_ds2780_io_nolock() is the guts of the current w1_ds2780_io(),
without the mutex_lock/unlock.

But it would be better to fix things properly :(

