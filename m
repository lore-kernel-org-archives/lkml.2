Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab2I1Aaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 20:30:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54156 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab2I1Aap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 20:30:45 -0400
Date: Thu, 27 Sep 2012 17:27:49 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: mathieu.poirier@linaro.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 38/57] power: l9540: Charge only mode fixes
Message-ID: <20120928002749.GC20560@lizard>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
 <1348589574-25655-39-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1348589574-25655-39-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 10:12:35AM -0600, mathieu.poirier@linaro.org wrote:
> From: Rupesh Kumar <rupesh.kumar@stericsson.com>
> 
> Fix for: charging not getting enabled in
> charge only mode by external charger.

Subject says l9540.. what is this?

> Signed-off-by: Rupesh Kumar <rupesh.kumar@stericsson.com>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
> Reviewed-by: Michel JAOUEN <michel.jaouen@stericsson.com>
> Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
> Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
> ---
>  drivers/power/ab8500_charger.c            |   42 +++++++++++++++++++++++++++++
>  drivers/power/abx500_chargalg.c           |   14 +++++++++
>  include/linux/mfd/abx500/ux500_chargalg.h |    2 +
>  3 files changed, 58 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
> index 70e7c5e..ebeb068 100644
> --- a/drivers/power/ab8500_charger.c
> +++ b/drivers/power/ab8500_charger.c
> @@ -15,6 +15,7 @@
>  #include <linux/device.h>
>  #include <linux/interrupt.h>
>  #include <linux/delay.h>
> +#include <linux/notifier.h>
>  #include <linux/slab.h>
>  #include <linux/platform_device.h>
>  #include <linux/power_supply.h>
> @@ -94,6 +95,10 @@
>  #define AB8500_SW_CONTROL_FALLBACK	0x03
>  /* Wait for enumeration before charging in us */
>  #define WAIT_ACA_RID_ENUMERATION	(5 * 1000)
> +/*External charger control*/
> +#define AB8500_SYS_CHARGER_CONTROL_REG		0x52
> +#define EXTERNAL_CHARGER_DISABLE_REG_VAL	0x03
> +#define EXTERNAL_CHARGER_ENABLE_REG_VAL		0x07
>  
>  /* UsbLineStatus register - usb types */
>  enum ab8500_charger_link_status {
> @@ -1672,6 +1677,29 @@ static int ab8500_charger_usb_en(struct ux500_charger *charger,
>  	return ret;
>  }
>  
> +static int ab8500_external_charger_prepare(struct notifier_block *charger_nb,
> +				unsigned long event, void *data)
> +{
> +	int ret;
> +	struct device *dev = data;

Need an empty line here.

> +	/*Toggle External charger control pin*/

Spaces after /* and before */.

> +	ret = abx500_set_register_interruptible(dev, AB8500_SYS_CTRL1_BLOCK,
> +				  AB8500_SYS_CHARGER_CONTROL_REG,
> +				  EXTERNAL_CHARGER_DISABLE_REG_VAL);
> +	if (ret < 0) {
> +		dev_err(dev, "write reg failed %d\n", ret);
> +		goto out;

No need for goto.

> +	}
> +	ret = abx500_set_register_interruptible(dev, AB8500_SYS_CTRL1_BLOCK,
> +				  AB8500_SYS_CHARGER_CONTROL_REG,
> +				  EXTERNAL_CHARGER_ENABLE_REG_VAL);
> +	if (ret < 0)
> +		dev_err(dev, "Write reg failed %d\n", ret);
> +
> +out:
> +	return ret;
> +}
> +
>  /**
>   * ab8500_charger_usb_check_enable() - enable usb charging
>   * @charger:	pointer to the ux500_charger structure
> @@ -3201,6 +3229,10 @@ static int ab8500_charger_suspend(struct platform_device *pdev,
>  #define ab8500_charger_resume	    NULL
>  #endif
>  
> +static struct notifier_block charger_nb = {
> +	.notifier_call = ab8500_external_charger_prepare,
> +};
> +
>  static int __devexit ab8500_charger_remove(struct platform_device *pdev)
>  {
>  	struct ab8500_charger *di = platform_get_drvdata(pdev);
> @@ -3233,6 +3265,11 @@ static int __devexit ab8500_charger_remove(struct platform_device *pdev)
>  	/* Delete the work queue */
>  	destroy_workqueue(di->charger_wq);
>  
> +	/*Unregister external charger enable notifier*/

Spaces.

> +	if (!di->ac_chg.enabled)
> +		blocking_notifier_chain_unregister(
> +			&charger_notifier_list, &charger_nb);
> +
>  	flush_scheduled_work();
>  	if (di->usb_chg.enabled)
>  		power_supply_unregister(&di->usb_chg.psy);
> @@ -3307,6 +3344,11 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
>  	di->ac_chg.enabled = di->pdata->ac_enabled;
>  	di->ac_chg.external = false;
>  
> +	/*notifier for external charger enabling*/

Spaces.

> +	if (!di->ac_chg.enabled)
> +		blocking_notifier_chain_register(
> +			&charger_notifier_list, &charger_nb);
> +
>  	/* USB supply */
>  	/* power_supply base class */
>  	di->usb_chg.psy.name = "ab8500_usb";
> diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
> index 9568f63..3ca00dd 100644
> --- a/drivers/power/abx500_chargalg.c
> +++ b/drivers/power/abx500_chargalg.c
> @@ -24,6 +24,7 @@
>  #include <linux/mfd/abx500.h>
>  #include <linux/mfd/abx500/ux500_chargalg.h>
>  #include <linux/mfd/abx500/ab8500-bm.h>
> +#include <linux/notifier.h>
>  
>  /* Watchdog kick interval */
>  #define CHG_WD_INTERVAL			(6 * HZ)
> @@ -255,6 +256,9 @@ static enum power_supply_property abx500_chargalg_props[] = {
>  	POWER_SUPPLY_PROP_HEALTH,
>  };
>  
> +/*External charger prepare notifier*/
> +BLOCKING_NOTIFIER_HEAD(charger_notifier_list);

Can you place the notifier list in di->? Oh, you can't, di is
something different for registrat

struct abx500_chargalg *di;
struct ab8500_charger *di;

But having the global list is not friendly to multi-device situations.

If there's a subtle reason why you do it this way, it have to be described
in the patch description (which is very scarce, btw).

Also, the charger_notifier_list name is in global name space, it's too
generic. Has to be ab8500_chg_notifier_list or something.

>  /**
>   * abx500_chargalg_safety_timer_expired() - Expiration of the safety timer
>   * @data:	pointer to the abx500_chargalg structure
> @@ -508,6 +512,8 @@ static int abx500_chargalg_kick_watchdog(struct abx500_chargalg *di)
>  static int abx500_chargalg_ac_en(struct abx500_chargalg *di, int enable,
>  	int vset, int iset)
>  {
> +	static int ab8500_chargalg_ex_ac_enable_toggle;

Static? No, this is not multi-device friendly, seems like a hack.

> +
>  	if (!di->ac_chg || !di->ac_chg->ops.enable)
>  		return -ENXIO;
>  
> @@ -520,6 +526,14 @@ static int abx500_chargalg_ac_en(struct abx500_chargalg *di, int enable,
>  	di->chg_info.ac_iset = iset;
>  	di->chg_info.ac_vset = vset;
>  
> +	/*enable external charger*/

spaces.

> +	if (enable && di->ac_chg->external &&
> +		!ab8500_chargalg_ex_ac_enable_toggle) {

Wrong indentation.

> +		blocking_notifier_call_chain(&charger_notifier_list,
> +					0, di->dev);
> +		ab8500_chargalg_ex_ac_enable_toggle++;
> +	}
> +
>  	return di->ac_chg->ops.enable(di->ac_chg, enable, vset, iset);
>  }
>  
> diff --git a/include/linux/mfd/abx500/ux500_chargalg.h b/include/linux/mfd/abx500/ux500_chargalg.h
> index 110d12f..fa831f1 100644
> --- a/include/linux/mfd/abx500/ux500_chargalg.h
> +++ b/include/linux/mfd/abx500/ux500_chargalg.h
> @@ -41,4 +41,6 @@ struct ux500_charger {
>  	bool external;
>  };
>  
> +extern struct blocking_notifier_head charger_notifier_list;
> +
>  #endif
> -- 
> 1.7.5.4
