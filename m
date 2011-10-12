Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab1JLTte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 15:49:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59750 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab1JLTtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 15:49:33 -0400
Date: Wed, 12 Oct 2011 23:49:27 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: "Kim, Milo" <Milo.Kim@nsc.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Subject: Re: [PATCH 2/3] power: Add LP8727 charger driver
Message-ID: <20111012194927.GA9239@oksana.dev.rtsoft.ru>
References: <B567DBAB974C0544994013492B949F8E380F619DE2@EXMAIL03.scwf.nsc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <B567DBAB974C0544994013492B949F8E380F619DE2@EXMAIL03.scwf.nsc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kim,

Sorry for the delay.

On Wed, Sep 07, 2011 at 01:55:27AM -0700, Kim, Milo wrote:
> 
> diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
> new file mode 100755
> index 0000000..2a649e0

Note that each patch should have commit message (ideally), and a
Signed-off-by: line.

Though, I would fixup all the issues myself, if the patch had at
least Signed-off-by. :-)

But while you're at it, you might also want to fix some cosmetic
issues:

[...]
> +static int lp8727_is_dedicated_charger(struct lp8727_chg *pchg)
> +{
> +	u8 val;
> +	(void)lp8727_i2c_read_byte(pchg, STATUS1, &val);

No need for these casts, please.

> +	return (val & DCPORT);
> +}
[...]
> +static int lp8727_charger_get_property(struct power_supply *psy,
> +				       enum power_supply_property psp,
> +				       union power_supply_propval *val)
> +{
> +	struct lp8727_chg *pchg = dev_get_drvdata(psy->dev->parent);
> +
> +	if (psp == POWER_SUPPLY_PROP_ONLINE) {
> +		val->intval = lp8727_is_charger_attached(psy->name,
> +							 pchg->devid);
> +	}

No need for brackets here.

> +
> +	return 0;
> +}
> +
[...]
> +static void lp8727_unregister_psy(struct lp8727_chg *pchg)
> +{
> +	struct lp8727_psy *psy = pchg->psy;
> +
> +	if (psy) {

if (!psy)
	return;

> +		power_supply_unregister(&psy->ac);
> +		power_supply_unregister(&psy->usb);
> +		power_supply_unregister(&psy->batt);
> +		kfree(psy);
> +	}
> +}
> +
> +static int lp8727_probe(struct i2c_client *cl, const struct i2c_device_id *id)
> +{
> +	struct lp8727_chg *pchg;
> +	int ret;
> +
> +	pchg = kzalloc(sizeof(*pchg), GFP_KERNEL);
> +	if (!pchg)
> +		return -ENOMEM;
> +
> +	pchg->client = cl;
> +	pchg->dev = &cl->dev;
> +	pchg->pdata = cl->dev.platform_data;
> +	i2c_set_clientdata(cl, pchg);
> +
> +	mutex_init(&pchg->xfer_lock);
> +
> +	lp8727_init_device(pchg);
> +	lp8727_intr_config(pchg);
> +
> +	ret = lp8727_register_psy(pchg);
> +	if (ret) {
> +		dev_err(pchg->dev,
> +			"can not register power supplies. err=%d", ret);

No need for brackets.

> +	}
> +
> +	return 0;
> +}
> +
> +static int __devexit lp8727_remove(struct i2c_client *cl)
> +{
> +	struct lp8727_chg *pchg = i2c_get_clientdata(cl);
> +
> +	lp8727_unregister_psy(pchg);
> +	free_irq(pchg->client->irq, pchg);
> +	flush_workqueue(pchg->irqthread);
> +	destroy_workqueue(pchg->irqthread);
> +	kfree(pchg);
> +	return 0;
> +}
> +
> +static const struct i2c_device_id lp8727_ids[] = {
> +	{"lp8727", 0},
> +};
> +
> +static struct i2c_driver lp8727_driver = {
> +	.driver = {
> +		   .name = "lp8727",
> +		   },
> +	.probe = lp8727_probe,
> +	.remove = __devexit_p(lp8727_remove),
> +	.id_table = lp8727_ids,
> +};
> +
> +static int __init lp8727_init(void)
> +{
> +	return i2c_add_driver(&lp8727_driver);
> +}
> +
> +static void __exit lp8727_chg_exit(void)
> +{
> +	i2c_del_driver(&lp8727_driver);
> +}
> +
> +module_init(lp8727_init);
> +module_exit(lp8727_chg_exit);
> +
> +MODULE_DESCRIPTION("National Semiconductor LP8727 charger driver");
> +MODULE_AUTHOR("Woogyom Kim <milo.kim@nsc.com>");
> +MODULE_LICENSE("GPL");
> 

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
