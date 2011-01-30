Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab1A3UwV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 15:52:21 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:54668 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754230Ab1A3UwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 15:52:20 -0500
Message-ID: <4D45CF96.1090100@bluewatersys.com>
Date: Mon, 31 Jan 2011 09:52:38 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: linux-kernel@vger.kernel.org, Eric Miao <eric.miao@linaro.org>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Hemanth V <hemanthv@ti.com>,
        Jean Delvare <khali@linux-fr.org>,
        linux-arm-kernel@lists.infradead.org,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Bill Gatliff <bgat@billgatliff.com>,
        Arun Murthy <arun.murthy@stericsson.com>
Subject: Re: [PATCH 1/2] pwmlib: add pwm support
References: <1296217283-14531-1-git-send-email-s.hauer@pengutronix.de> <1296217283-14531-2-git-send-email-s.hauer@pengutronix.de>
In-Reply-To: <1296217283-14531-2-git-send-email-s.hauer@pengutronix.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2011 01:21 AM, Sascha Hauer wrote:
> The barebone pwm API is present in the kernel for longer.
> This patch adds pwmlib support to support dynamically registered
> pwms. Porions of this code are inspired by the gpiolib support.

Hi Sascha,

A couple of comments below. I have added Bill and Arun to the Cc list.
As somebody else pointed out there have been a couple of attempts to
create a generic pwm framework so far. It would be good to try and
consolidate the efforts.

~Ryan

> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  drivers/Kconfig      |    2 +
>  drivers/Makefile     |    1 +
>  drivers/pwm/Kconfig  |   11 +++
>  drivers/pwm/Makefile |    1 +
>  drivers/pwm/pwmlib.c |  246 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pwm.h  |   38 ++++++++
>  6 files changed, 299 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/pwm/Kconfig
>  create mode 100644 drivers/pwm/Makefile
>  create mode 100644 drivers/pwm/pwmlib.c
> 
> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index 9bfb71f..bb332a6 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -117,4 +117,6 @@ source "drivers/staging/Kconfig"
>  source "drivers/platform/Kconfig"
>  
>  source "drivers/clk/Kconfig"
> +
> +source "drivers/pwm/Kconfig"
>  endmenu
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 7eb35f4..8cd30a5 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -6,6 +6,7 @@
>  #
>  
>  obj-y				+= gpio/
> +obj-y				+= pwm/
>  obj-$(CONFIG_PCI)		+= pci/
>  obj-$(CONFIG_PARISC)		+= parisc/
>  obj-$(CONFIG_RAPIDIO)		+= rapidio/
> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> new file mode 100644
> index 0000000..04ddbfd
> --- /dev/null
> +++ b/drivers/pwm/Kconfig
> @@ -0,0 +1,11 @@
> +menuconfig PWMLIB
> +	bool "PWM Support"
> +	help
> +	  This enables PWM support through the generic PWM library.
> +	  You only need to enable this, if you also want to enable
> +	  one or more of the PWM drivers below.
> +
> +	  If unsure, say N.
> +
> +if PWMLIB
> +endif
> diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
> new file mode 100644
> index 0000000..389c049
> --- /dev/null
> +++ b/drivers/pwm/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_PWMLIB)		+= pwmlib.o
> diff --git a/drivers/pwm/pwmlib.c b/drivers/pwm/pwmlib.c
> new file mode 100644
> index 0000000..0d6c4cc
> --- /dev/null
> +++ b/drivers/pwm/pwmlib.c
> @@ -0,0 +1,246 @@
> +/*
> + * Generic pwmlib implementation
> + *
> + * Copyright (C) 2011 Sascha Hauer <s.hauer@pengutronix.de>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2, or (at your option)
> + *  any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; see the file COPYING.  If not, write to
> + *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +#include <linux/module.h>
> +#include <linux/pwm.h>
> +#include <linux/list.h>
> +#include <linux/mutex.h>
> +#include <linux/err.h>
> +#include <linux/slab.h>
> +#include <linux/device.h>
> +
> +struct pwm_device {
> +	struct			pwm_chip *chip;
> +	const char		*label;
> +	int			enabled;
> +	unsigned long		flags;
> +#define FLAG_REQUESTED	0
> +#define FLAG_ENABLED	1
> +	struct list_head	node;
> +};
> +
> +static LIST_HEAD(pwm_list);
> +
> +static DEFINE_MUTEX(pwm_lock);
> +
> +static struct pwm_device *find_pwm(int pwm_id)
> +{
> +	struct pwm_device *pwm;
> +
> +	list_for_each_entry(pwm, &pwm_list, node) {
> +		if (pwm->chip->pwm_id == pwm_id)
> +			return pwm;
> +	}
> +
> +	return NULL;
> +}
> +
> +/*
> + * The next pwm id to assign. We do not bother to fill gaps which
> + * occur during dynamic registering/deregistering of pwms, but
> + * instead assign a uniq id to each new pwm.
> + */
> +static int next_pwm_id;
> +
> +/**
> + * pwmchip_reserve() - reserve range of pwms to use with platform code only
> + * @npwms: number of pwms to reserve
> + * Context: platform init
> + *
> + * Maybe called only once. It reserves the first pwm_ids for platform use so
> + * that they can refer to pwm_ids during compile time.
> + */
> +int __init pwmchip_reserve(int npwms)
> +{

This concept is a bit ugly.

> +	if (next_pwm_id)
> +		return -EBUSY;
> +
> +	next_pwm_id = npwms;
> +
> +	return 0;
> +}
> +
> +/**
> + * pwmchip_add() - register a new pwm
> + * @chip: the pwm
> + *
> + * register a new pwm. pwm->pwm_id must be initialized. if pwm_id < 0 then
> + * a dynamically assigned id will be used, otherwise the id specified,
> + */
> +int pwmchip_add(struct pwm_chip *chip)
> +{
> +	struct pwm_device *pwm;
> +	int ret = 0;
> +
> +	mutex_lock(&pwm_lock);
> +
> +	if (chip->pwm_id >= 0 && find_pwm(chip->pwm_id)) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
> +	pwm = kzalloc(sizeof(*pwm), GFP_KERNEL);
> +	if (!pwm) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	pwm->chip = chip;
> +
> +	if (chip->pwm_id < 0)
> +		chip->pwm_id = next_pwm_id++;
> +
> +	list_add_tail(&pwm->node, &pwm_list);
> +out:
> +	mutex_unlock(&pwm_lock);

The locking here is a little heavier than it needs to be. Only the list
lookup, incrementing next_pwm_id and the list add need to be protected.
The pwm allocation and assignment of chip do not need to be protected by
the mutex.

The performance difference is negligible, but it does make it more clear
what the lock actually protects.

> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(pwmchip_add);
> +
> +/**
> + * pwmchip_remove() - remove a pwm
> + * @chip: the pwm
> + *
> + * remove a pwm. This function may return busy if the pwm is still requested.
> + */
> +int pwmchip_remove(struct pwm_chip *chip)
> +{
> +	struct pwm_device *pwm;
> +	int ret = 0;
> +
> +	mutex_lock(&pwm_lock);
> +
> +	pwm = find_pwm(chip->pwm_id);
> +	if (!pwm) {
> +		ret = -ENOENT;
> +		goto out;
> +	}
> +
> +	if (test_bit(FLAG_REQUESTED, &pwm->flags)) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
> +	list_del(&pwm->node);
> +out:
> +	mutex_unlock(&pwm_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(pwmchip_remove);
> +
> +/*
> + * pwm_request - request a PWM device
> + */
> +struct pwm_device *pwm_request(int pwm_id, const char *label)
> +{

What purpose does the label serve? It gets assigned but never used.
Possibly it could be useful later in sysfs/debugfs output?

I think requesting pwm's by id is not particularly useful in practice.
Drivers which need to request a pwm would need to know what the id of
the correct pwm was, which may vary between platforms. A better approach
would be to either use device associations (similar to the clock api) or
to just use a string label for lookup.

> +	struct pwm_device *pwm;
> +	int ret;
> +
> +	mutex_lock(&pwm_lock);
> +
> +	pwm = find_pwm(pwm_id);
> +	if (!pwm) {
> +		pwm = ERR_PTR(-ENOENT);
> +		goto out;
> +	}
> +
> +	if (test_bit(FLAG_REQUESTED, &pwm->flags)) {
> +		pwm = ERR_PTR(-EBUSY);
> +		goto out;
> +	}
> +
> +	if (!try_module_get(pwm->chip->owner)) {
> +		pwm = ERR_PTR(-ENODEV);
> +		goto out;
> +	}
> +
> +	if (pwm->chip->ops->request) {

The pwm driver you have provide does not have a request callback. Based
on just the id/label why might a particular pwm driver refuse a request
if the pwm core would grant it?

> +		ret = pwm->chip->ops->request(pwm->chip);
> +		if (ret) {
> +			pwm = ERR_PTR(ret);
> +			goto out_put;
> +		}
> +	}
> +
> +	pwm->label = label;
> +	set_bit(FLAG_REQUESTED, &pwm->flags);
> +
> +	goto out;
> +
> +out_put:
> +	module_put(pwm->chip->owner);
> +out:
> +	mutex_unlock(&pwm_lock);
> +
> +	return pwm;
> +}
> +EXPORT_SYMBOL_GPL(pwm_request);
> +
> +/*
> + * pwm_free - free a PWM device
> + */
> +void pwm_free(struct pwm_device *pwm)
> +{
> +	mutex_lock(&pwm_lock);
> +
> +	if (!test_and_clear_bit(FLAG_REQUESTED, &pwm->flags)) {
> +		pr_warning("PWM device already freed\n");
> +		goto out;
> +	}
> +
> +	pwm->label = NULL;
> +
> +	module_put(pwm->chip->owner);
> +out:
> +	mutex_unlock(&pwm_lock);
> +}
> +EXPORT_SYMBOL_GPL(pwm_free);
> +
> +/*
> + * pwm_config - change a PWM device configuration
> + */
> +int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)

duty_ns/period_ns should probably be an unsigned type. Is 32 bits enough
for all pwms?

> +{
> +	return pwm->chip->ops->config(pwm->chip, duty_ns, period_ns);
> +}
> +EXPORT_SYMBOL_GPL(pwm_config);
> +
> +/*
> + * pwm_enable - start a PWM output toggling
> + */
> +int pwm_enable(struct pwm_device *pwm)
> +{
> +	if (!test_and_set_bit(FLAG_ENABLED, &pwm->flags))
> +		return pwm->chip->ops->enable(pwm->chip);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(pwm_enable);
> +
> +/*
> + * pwm_disable - stop a PWM output toggling
> + */
> +void pwm_disable(struct pwm_device *pwm)
> +{
> +	if (test_and_clear_bit(FLAG_ENABLED, &pwm->flags))
> +		pwm->chip->ops->disable(pwm->chip);
> +}
> +EXPORT_SYMBOL_GPL(pwm_disable);
> diff --git a/include/linux/pwm.h b/include/linux/pwm.h
> index 7c77575..e3e2139 100644
> --- a/include/linux/pwm.h
> +++ b/include/linux/pwm.h
> @@ -28,4 +28,42 @@ int pwm_enable(struct pwm_device *pwm);
>   */
>  void pwm_disable(struct pwm_device *pwm);
>  
> +#ifdef CONFIG_PWMLIB
> +struct pwm_chip;
> +
> +/**
> + * struct pwm_ops - PWM operations
> + * @request: optional hook for requesting a PWM
> + * @free: optional hook for freeing a PWM
> + * @config: configure duty cycles and period length for this PWM
> + * @enable: enable PWM output toggling
> + * @disable: disable PWM output toggling
> + */
> +struct pwm_ops {
> +	int			(*request)(struct pwm_chip *chip);
> +	void			(*free)(struct pwm_chip *chip);
> +	int			(*config)(struct pwm_chip *chip, int duty_ns,
> +						int period_ns);
> +	int			(*enable)(struct pwm_chip *chip);
> +	void			(*disable)(struct pwm_chip *chip);
> +};
> +
> +/**
> + * struct pwm_chip - abstract a PWM
> + * @label: for diagnostics
> + * @owner: helps prevent removal of modules exporting active PWMs
> + * @ops: The callbacks for this PWM
> + */
> +struct pwm_chip {
> +	int			pwm_id;
> +	const char		*label;
> +	struct module		*owner;
> +	struct pwm_ops		*ops;
> +};
> +
> +int __must_check pwmchip_reserve(int npwms);
> +int pwmchip_add(struct pwm_chip *chip);
> +int pwmchip_remove(struct pwm_chip *chip);
> +#endif
> +
>  #endif /* __LINUX_PWM_H */


-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
