Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab1GLPJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 11:09:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61010 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab1GLPJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 11:09:47 -0400
Date: Tue, 12 Jul 2011 19:09:42 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: Len Brown <lenb@kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] power_supply: scrub device pointer if registration
 fails
Message-ID: <20110712150942.GA1291@oksana.dev.rtsoft.ru>
References: <1310457809-2731-1-git-send-email-stefanha@linux.vnet.ibm.com>
 <1310457809-2731-2-git-send-email-stefanha@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1310457809-2731-2-git-send-email-stefanha@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 09:03:27AM +0100, Stefan Hajnoczi wrote:
> This patch makes power_supply_register() safer for callers that are not
> being careful.  When the function fails it leaves the caller's psy.dev
> pointer set to the stale power supply device.  A correct caller would
> handle the error return and never use psy.dev but the example of
> drivers/acpi/battery.c shows otherwise.
> 
> Clear the psy.dev pointer when power_supply_register() fails so the
> caller either sees a valid pointer on success or NULL on failure.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
> ---
>  drivers/power/power_supply_core.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
> index 329b46b..33d4068 100644
> --- a/drivers/power/power_supply_core.c
> +++ b/drivers/power/power_supply_core.c
> @@ -194,6 +194,7 @@ create_triggers_failed:
>  kobject_set_name_failed:
>  device_add_failed:
>  	put_device(dev);
> +	psy->dev = NULL; /* make it crystal-clear that we failed */
>  success:
>  	return rc;
>  }

I think this may easily cause races. I.e.

- ACPI calls power_supply_register, it allocates dev, sets
  psy->dev;
- Someone calls acpi_battery_notify() or acpi_battery_update(),
  which tests for psy->dev;
- power_supply_register fails, it frees dev, and then clears psy->dev;
  but it's too late, as acpi_battery_notify/acpi_battery_update thinks
  that we're fine.

I believe the whole ACPI battery logic is overcomplicated, and
needs a bit of rework. In the meantime, we could move 'psy->dev =
dev;' assignment into the end of the function, where _register
could not fail, i.e. something like this:

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 329b46b..9f85b70 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -169,7 +169,6 @@ int power_supply_register(struct device *parent, struct power_supply *psy)
 	dev->parent = parent;
 	dev->release = power_supply_dev_release;
 	dev_set_drvdata(dev, psy);
-	psy->dev = dev;
 
 	INIT_WORK(&psy->changed_work, power_supply_changed_work);
 
@@ -185,6 +184,8 @@ int power_supply_register(struct device *parent, struct power_supply *psy)
 	if (rc)
 		goto create_triggers_failed;
 
+	psy->dev = dev;
+
 	power_supply_changed(psy);
 
 	goto success;


But still, I don't see how this will save us from the same issue
when ACPI calls power_supply_unregister, which doesn't clear psy->dev:

static void acpi_battery_refresh(struct acpi_battery *battery)
{
        if (!battery->bat.dev)
                return;

        acpi_battery_get_info(battery);
        /* The battery may have changed its reporting units. */
        sysfs_remove_battery(battery);
        sysfs_add_battery(battery);
}

Really, ACPI battery needs some proper fixing and locking. :-/

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
