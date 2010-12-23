Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab0LWWYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 17:24:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49814 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab0LWWYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 17:24:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] acpi: Update battery information on notification 0x81
Date: Thu, 23 Dec 2010 23:23:42 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc7+; KDE/4.4.4; x86_64; ; )
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org
References: <1281990739-17912-1-git-send-email-mjg@redhat.com> <20101215171928.GA17746@srcf.ucam.org> <20101223211638.GA7862@srcf.ucam.org>
In-Reply-To: <20101223211638.GA7862@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012232323.42702.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 23, 2010, Matthew Garrett wrote:
> A notification event 0x81 from an ACPI battery device requires us to
> re-read the battery information structure. Do so, and if the battery's
> reporting units have changed (as is the case on some Thinkpads) destroy
> and recreate the battery in order to populate the fields correctly.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
> 
> Respun against Linus master

As I've already said on IRC, I'd simply add a new function like:

void acpi_battery_refresh(struct acpi_battery *battery)
{
	if (!battery->bat.dev)
		return;
	acpi_battery_get_info(battery);
	/* The battery may have changed its reporting units */
	sysfs_remove_battery(battery);
	sysfs_add_battery(battery);
}

and call it before acpi_battery_update()
(a) in acpi_battery_resume()
(b) in acpi_battery_notify() if event == ACPI_BATTERY_NOTIFY_INFO

That would be more straightforward IMHO.

Thanks,
Rafael


>  drivers/acpi/battery.c |   24 +++++++++++++++++-------
>  1 files changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
> index 9fb9d5a..8da9c88 100644
> --- a/drivers/acpi/battery.c
> +++ b/drivers/acpi/battery.c
> @@ -130,7 +130,7 @@ struct acpi_battery {
>  	unsigned long flags;
>  };
>  
> -static int acpi_battery_update(struct acpi_battery *battery);
> +static int acpi_battery_update(struct acpi_battery *battery, bool get_info);
>  
>  #define to_acpi_battery(x) container_of(x, struct acpi_battery, bat);
>  
> @@ -186,7 +186,7 @@ static int acpi_battery_get_property(struct power_supply *psy,
>  	int ret = 0;
>  	struct acpi_battery *battery = to_acpi_battery(psy);
>  
> -	if (acpi_battery_update(battery))
> +	if (acpi_battery_update(battery, false))
>  		return -ENODEV;
>  
>  	if (acpi_battery_present(battery)) {
> @@ -610,9 +610,11 @@ static void acpi_battery_quirks2(struct acpi_battery *battery)
>  	}
>  }
>  
> -static int acpi_battery_update(struct acpi_battery *battery)
> +static int acpi_battery_update(struct acpi_battery *battery, bool get_info)
>  {
>  	int result, old_present = acpi_battery_present(battery);
> +	int old_power_unit = battery->power_unit;
> +
>  	result = acpi_battery_get_status(battery);
>  	if (result)
>  		return result;
> @@ -631,6 +633,14 @@ static int acpi_battery_update(struct acpi_battery *battery)
>  	}
>  	if (!battery->bat.dev)
>  		sysfs_add_battery(battery);
> +	if (get_info) {
> +		acpi_battery_get_info(battery);
> +		if (old_power_unit != battery->power_unit) {
> +			/* The battery has changed its reporting units */
> +			sysfs_remove_battery(battery);
> +			sysfs_add_battery(battery);
> +		}
> +	}
>  	result = acpi_battery_get_state(battery);
>  	acpi_battery_quirks2(battery);
>  	return result;
> @@ -808,7 +818,7 @@ static print_func acpi_print_funcs[ACPI_BATTERY_NUMFILES] = {
>  static int acpi_battery_read(int fid, struct seq_file *seq)
>  {
>  	struct acpi_battery *battery = seq->private;
> -	int result = acpi_battery_update(battery);
> +	int result = acpi_battery_update(battery, false);
>  	return acpi_print_funcs[fid](seq, result);
>  }
>  
> @@ -919,7 +929,7 @@ static void acpi_battery_notify(struct acpi_device *device, u32 event)
>  	if (!battery)
>  		return;
>  	old = battery->bat.dev;
> -	acpi_battery_update(battery);
> +	acpi_battery_update(battery, (event == ACPI_BATTERY_NOTIFY_INFO));
>  	acpi_bus_generate_proc_event(device, event,
>  				     acpi_battery_present(battery));
>  	acpi_bus_generate_netlink_event(device->pnp.device_class,
> @@ -948,7 +958,7 @@ static int acpi_battery_add(struct acpi_device *device)
>  	if (ACPI_SUCCESS(acpi_get_handle(battery->device->handle,
>  			"_BIX", &handle)))
>  		set_bit(ACPI_BATTERY_XINFO_PRESENT, &battery->flags);
> -	acpi_battery_update(battery);
> +	acpi_battery_update(battery, false);
>  #ifdef CONFIG_ACPI_PROCFS_POWER
>  	result = acpi_battery_add_fs(device);
>  #endif
> @@ -989,7 +999,7 @@ static int acpi_battery_resume(struct acpi_device *device)
>  		return -EINVAL;
>  	battery = acpi_driver_data(device);
>  	battery->update_time = 0;
> -	acpi_battery_update(battery);
> +	acpi_battery_update(battery, true);
>  	return 0;
>  }
> 
> 

