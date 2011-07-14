Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab1GNGIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 02:08:12 -0400
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:53769 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab1GNGII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 02:08:08 -0400
Date: Thu, 14 Jul 2011 07:07:51 +0100
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Len Brown <lenb@kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] power_supply: scrub device pointer if registration
 fails
Message-ID: <20110714060751.GA5386@stefanha-thinkpad.localdomain>
References: <1310457809-2731-1-git-send-email-stefanha@linux.vnet.ibm.com>
 <1310457809-2731-2-git-send-email-stefanha@linux.vnet.ibm.com>
 <20110712150942.GA1291@oksana.dev.rtsoft.ru>
 <20110712153017.GA4503@stefanha-thinkpad.localdomain>
 <20110712172331.GA9557@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110712172331.GA9557@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 09:23:31PM +0400, Anton Vorontsov wrote:
> On Tue, Jul 12, 2011 at 04:30:17PM +0100, Stefan Hajnoczi wrote:
> [...]
> > > I believe the whole ACPI battery logic is overcomplicated, and
> > > needs a bit of rework. In the meantime, we could move 'psy->dev =
> > > dev;' assignment into the end of the function, where _register
> > > could not fail, i.e. something like this:
> > 
> > Aha!  I didn't do this is because I don't know the code and was afraid
> > some other function somewhere would use psy->dev.  If you think it is
> > safer this way I'll resend the patch.
> 
> Neither is a proper fix, unfortunately. :-( Without some external lock
> you can't use psy->dev as a flag to check if the registration was
> successful. There is really no point trying to force core functions
> to keep psy->dev in a sane state after registration has failed.
> 
> So, instead of patching power_supply core, I'd suggest the
> following patch (on top of 2/3 and 3/3, so far only compile-
> tested). How does it look?

Comments below.  Thanks for adding this lock.

> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
> index 2ae2fca..475e17c 100644
> --- a/drivers/acpi/battery.c
> +++ b/drivers/acpi/battery.c
> @@ -101,6 +101,7 @@ enum {
> 
>  struct acpi_battery {
>  	struct mutex lock;
> +	struct mutex bat_lock;
>  	struct power_supply bat;
>  	struct acpi_device *device;
>  	struct notifier_block pm_nb;
> @@ -559,8 +560,10 @@ static int sysfs_add_battery(struct acpi_battery *battery)
>  	battery->bat.get_property = acpi_battery_get_property;
> 
>  	result = power_supply_register(&battery->device->dev, &battery->bat);
> -	if (result)
> +	if (result) {
> +		battery->bat.dev = NULL;
>  		return result;
> +	}
>  	return device_create_file(battery->bat.dev, &alarm_attr);
>  }
> 
> @@ -613,31 +616,40 @@ static int acpi_battery_update(struct acpi_battery *battery)
>  	result = acpi_battery_get_status(battery);
>  	if (result)
>  		return result;
> +
> +	mutex_lock(&battery->bat_lock);
> +
>  	if (!acpi_battery_present(battery)) {
>  		sysfs_remove_battery(battery);
>  		battery->update_time = 0;
> -		return 0;
> +		result = 0;
> +		goto out_unlock;
>  	}
>  	if (!battery->update_time ||
>  	    old_present != acpi_battery_present(battery)) {
>  		result = acpi_battery_get_info(battery);
>  		if (result)
> -			return result;
> +			goto out_unlock;
>  		acpi_battery_quirks(battery);
>  		acpi_battery_init_alarm(battery);
>  	}
>  	if (!battery->bat.dev) {
>  		result = sysfs_add_battery(battery);
>  		if (result)
> -			return result;
> +			goto out_unlock;
>  	}
>  	result = acpi_battery_get_state(battery);
>  	acpi_battery_quirks2(battery);
> +
> +out_unlock:
> +	mutex_unlock(&battery->bat_lock);
>  	return result;
>  }
> 
> -static void acpi_battery_refresh(struct acpi_battery *battery)
> +static void sysfs_readd_battery(struct acpi_battery *battery)

s/readd/read/?

>  {
> +	mutex_lock(&battery->bat_lock);
> +
>  	if (!battery->bat.dev)
>  		return;

Remember to unlock before return:

if (!battery->bat.dev)
    goto out;

> 
> @@ -645,6 +657,13 @@ static void acpi_battery_refresh(struct acpi_battery *battery)
>  	/* The battery may have changed its reporting units. */
>  	sysfs_remove_battery(battery);
>  	sysfs_add_battery(battery);
> +
out:
> +	mutex_unlock(&battery->bat_lock);
> +}

Stefan
