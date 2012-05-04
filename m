Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247Ab2EDN3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 09:29:12 -0400
Received: from ralfj.de ([85.214.220.216]:54235 "EHLO ralfj.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010Ab2EDN3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 09:29:11 -0400
From: Ralf Jung <post@ralfj.de>
To: Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH 1/1] battery: only refresh the sysfs files when pertinant information changes
Date: Fri, 4 May 2012 15:29:06 +0200
User-Agent: KMail/1.13.7 (Linux/3.4.0-rc5+; KDE/4.7.4; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jonathan Nieder <jrnieder@gmail.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Adrian Fita <adrian.fita@gmail.com>, Len Brown <lenb@kernel.org>,
        Paolo Scarabelli <paolo@msw.it>, linux-kernel@vger.kernel.org
References: <20120503124708.GA18622@srcf.ucam.org> <1336052907-15084-1-git-send-email-apw@canonical.com>
In-Reply-To: <1336052907-15084-1-git-send-email-apw@canonical.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205041529.07142.post@ralfj.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I applied this to 3.4-rc5, and it fixes the issue. Thanks a lot :)

> We only need to regenerate the sysfs files when the capacity units
> change, avoid the update otherwise.
> 
> Signed-off-by: Andy Whitcroft <apw@canonical.com>
Tested-by: Ralf Jung <post@ralfj.de>
> ---
>  drivers/acpi/battery.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> 	Based on Matthew's feedback here is a version which optimises
> 	based on the power_unit field as returned from the battery info.
> 	Could someone who suffers from this issue please test this out
> 	and report back.  Thanks.
> 
> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
> index 86933ca..7dd3f9f 100644
> --- a/drivers/acpi/battery.c
> +++ b/drivers/acpi/battery.c
> @@ -643,11 +643,19 @@ static int acpi_battery_update(struct acpi_battery
> *battery)
> 
>  static void acpi_battery_refresh(struct acpi_battery *battery)
>  {
> +	int power_unit;
> +
>  	if (!battery->bat.dev)
>  		return;
> 
> +	power_unit = battery->power_unit;
> +
>  	acpi_battery_get_info(battery);
> -	/* The battery may have changed its reporting units. */
> +
> +	if (power_unit == battery->power_unit)
> +		return;
> +
> +	/* The battery has changed its reporting units. */
>  	sysfs_remove_battery(battery);
>  	sysfs_add_battery(battery);
>  }

Kind regards,
Ralf Jung
