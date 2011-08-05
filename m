Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab1HEFLx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 01:11:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:39667 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab1HEFLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 01:11:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,321,1309762800"; 
   d="scan'208";a="4355481"
Subject: Re: [PATCH] Battery: sysfs_remove_battery(): possible circular
 locking
From: "lan,Tianyu" <tianyu.lan@intel.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110805003322.GA8311@swordfish>
References: <20110805003322.GA8311@swordfish>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Aug 2011 13:10:08 +0800
Message-ID: <1312521008.2096.173.camel@lantianyu-ws>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think changing  'the marker' to 'battery->bat.name' will introduce
problem.
In the sysfs_add_battery(), when the 'battery->bat.name' is assigned,
the power_supply_register() and device_create_file() have not been
invoked. In this time, maybe sysfs_remove_battery() will be invoked and
cause device_remove_file() and power_supply_unregister() invoked without
device file created and power supply registered.

sysfs_remove_battery()  will be invoked in the battery_notify(),
acpi_battery_refresh() and sysfs_remove_battery() which causes the
situation. This is also the cause  of bug 35642.

> I've changed `the marker' from `battery->bat.dev' to `battery->bat.name', so 
> the basic idea should remain the same, now we just can release battery->lock 
> more quicker, before device_remove_file() call.
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> 
> ---
> 
>  drivers/acpi/battery.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
> index 87c0a8d..398cbfb 100644
> --- a/drivers/acpi/battery.c
> +++ b/drivers/acpi/battery.c
> @@ -574,15 +574,17 @@ static int sysfs_add_battery(struct acpi_battery *battery)
>  static void sysfs_remove_battery(struct acpi_battery *battery)
>  {
>  	mutex_lock(&battery->lock);
> -	if (!battery->bat.dev) {
> +	if (!battery->bat.name) {
>  		mutex_unlock(&battery->lock);
>  		return;
>  	}
>  
> +	battery->bat.name = NULL;
> +	mutex_unlock(&battery->lock);
> +
>  	device_remove_file(battery->bat.dev, &alarm_attr);
>  	power_supply_unregister(&battery->bat);
>  	battery->bat.dev = NULL;
> -	mutex_unlock(&battery->lock);
>  }
>  
>  /*
> 


