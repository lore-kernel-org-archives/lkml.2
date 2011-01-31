Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab1AaHt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 02:49:27 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57328 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973Ab1AaHt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 02:49:26 -0500
Date: Mon, 31 Jan 2011 08:49:16 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.miao@linaro.org>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Hemanth V <hemanthv@ti.com>,
        Jean Delvare <khali@linux-fr.org>,
        linux-arm-kernel@lists.infradead.org,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Bill Gatliff <bgat@billgatliff.com>,
        Arun Murthy <arun.murthy@stericsson.com>
Subject: Re: [PATCH 1/2] pwmlib: add pwm support
Message-ID: <20110131074916.GG9041@pengutronix.de>
References: <1296217283-14531-1-git-send-email-s.hauer@pengutronix.de>
 <1296217283-14531-2-git-send-email-s.hauer@pengutronix.de>
 <4D45CF96.1090100@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D45CF96.1090100@bluewatersys.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 07:26:31 up 15 days, 16:33, 10 users,  load average: 0.11, 0.10,
 0.09
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, Jan 31, 2011 at 09:52:38AM +1300, Ryan Mallon wrote:
> On 01/29/2011 01:21 AM, Sascha Hauer wrote:
> > The barebone pwm API is present in the kernel for longer.
> > This patch adds pwmlib support to support dynamically registered
> > pwms. Porions of this code are inspired by the gpiolib support.
> 
> Hi Sascha,
> 
> A couple of comments below. I have added Bill and Arun to the Cc list.
> As somebody else pointed out there have been a couple of attempts to
> create a generic pwm framework so far. It would be good to try and
> consolidate the efforts.

Sorry, I was not aware of these attempts, otherwise I wouldn't have
implemented this myself. So yes, we should consolidate the efforts.
I will happily drop my patches and work on Bills version instead as
his version is more advanced than mine.

> > +
> > +/**
> > + * pwmchip_reserve() - reserve range of pwms to use with platform code only
> > + * @npwms: number of pwms to reserve
> > + * Context: platform init
> > + *
> > + * Maybe called only once. It reserves the first pwm_ids for platform use so
> > + * that they can refer to pwm_ids during compile time.
> > + */
> > +int __init pwmchip_reserve(int npwms)
> > +{
> 
> This concept is a bit ugly.
> 
> > +	if (next_pwm_id)
> > +		return -EBUSY;
> > +
> > +	next_pwm_id = npwms;
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * pwmchip_add() - register a new pwm
> > + * @chip: the pwm
> > + *
> > + * register a new pwm. pwm->pwm_id must be initialized. if pwm_id < 0 then
> > + * a dynamically assigned id will be used, otherwise the id specified,
> > + */
> > +int pwmchip_add(struct pwm_chip *chip)
> > +{
> > +	struct pwm_device *pwm;
> > +	int ret = 0;
> > +
> > +	mutex_lock(&pwm_lock);
> > +
> > +	if (chip->pwm_id >= 0 && find_pwm(chip->pwm_id)) {
> > +		ret = -EBUSY;
> > +		goto out;
> > +	}
> > +
> > +	pwm = kzalloc(sizeof(*pwm), GFP_KERNEL);
> > +	if (!pwm) {
> > +		ret = -ENOMEM;
> > +		goto out;
> > +	}
> > +
> > +	pwm->chip = chip;
> > +
> > +	if (chip->pwm_id < 0)
> > +		chip->pwm_id = next_pwm_id++;
> > +
> > +	list_add_tail(&pwm->node, &pwm_list);
> > +out:
> > +	mutex_unlock(&pwm_lock);
> 
> The locking here is a little heavier than it needs to be. Only the list
> lookup, incrementing next_pwm_id and the list add need to be protected.
> The pwm allocation and assignment of chip do not need to be protected by
> the mutex.
> 
> The performance difference is negligible, but it does make it more clear
> what the lock actually protects.
> 
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(pwmchip_add);
> > +
> > +/**
> > + * pwmchip_remove() - remove a pwm
> > + * @chip: the pwm
> > + *
> > + * remove a pwm. This function may return busy if the pwm is still requested.
> > + */
> > +int pwmchip_remove(struct pwm_chip *chip)
> > +{
> > +	struct pwm_device *pwm;
> > +	int ret = 0;
> > +
> > +	mutex_lock(&pwm_lock);
> > +
> > +	pwm = find_pwm(chip->pwm_id);
> > +	if (!pwm) {
> > +		ret = -ENOENT;
> > +		goto out;
> > +	}
> > +
> > +	if (test_bit(FLAG_REQUESTED, &pwm->flags)) {
> > +		ret = -EBUSY;
> > +		goto out;
> > +	}
> > +
> > +	list_del(&pwm->node);
> > +out:
> > +	mutex_unlock(&pwm_lock);
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(pwmchip_remove);
> > +
> > +/*
> > + * pwm_request - request a PWM device
> > + */
> > +struct pwm_device *pwm_request(int pwm_id, const char *label)
> > +{
> 
> What purpose does the label serve? It gets assigned but never used.
> Possibly it could be useful later in sysfs/debugfs output?

Yes, it was intended for debugfs. Note that this part of the existing
barebone pwm kernel API. I haven't changed it.

> 
> I think requesting pwm's by id is not particularly useful in practice.
> Drivers which need to request a pwm would need to know what the id of
> the correct pwm was, which may vary between platforms. A better approach
> would be to either use device associations (similar to the clock api) or
> to just use a string label for lookup.
> 
> > +	struct pwm_device *pwm;
> > +	int ret;
> > +
> > +	mutex_lock(&pwm_lock);
> > +
> > +	pwm = find_pwm(pwm_id);
> > +	if (!pwm) {
> > +		pwm = ERR_PTR(-ENOENT);
> > +		goto out;
> > +	}
> > +
> > +	if (test_bit(FLAG_REQUESTED, &pwm->flags)) {
> > +		pwm = ERR_PTR(-EBUSY);
> > +		goto out;
> > +	}
> > +
> > +	if (!try_module_get(pwm->chip->owner)) {
> > +		pwm = ERR_PTR(-ENODEV);
> > +		goto out;
> > +	}
> > +
> > +	if (pwm->chip->ops->request) {
> 
> The pwm driver you have provide does not have a request callback. Based
> on just the id/label why might a particular pwm driver refuse a request
> if the pwm core would grant it?

We can drop this and add later when we need it.

> 
> > +		ret = pwm->chip->ops->request(pwm->chip);
> > +		if (ret) {
> > +			pwm = ERR_PTR(ret);
> > +			goto out_put;
> > +		}
> > +	}
> > +
> > +	pwm->label = label;
> > +	set_bit(FLAG_REQUESTED, &pwm->flags);
> > +
> > +	goto out;
> > +
> > +out_put:
> > +	module_put(pwm->chip->owner);
> > +out:
> > +	mutex_unlock(&pwm_lock);
> > +
> > +	return pwm;
> > +}
> > +EXPORT_SYMBOL_GPL(pwm_request);
> > +
> > +/*
> > + * pwm_free - free a PWM device
> > + */
> > +void pwm_free(struct pwm_device *pwm)
> > +{
> > +	mutex_lock(&pwm_lock);
> > +
> > +	if (!test_and_clear_bit(FLAG_REQUESTED, &pwm->flags)) {
> > +		pr_warning("PWM device already freed\n");
> > +		goto out;
> > +	}
> > +
> > +	pwm->label = NULL;
> > +
> > +	module_put(pwm->chip->owner);
> > +out:
> > +	mutex_unlock(&pwm_lock);
> > +}
> > +EXPORT_SYMBOL_GPL(pwm_free);
> > +
> > +/*
> > + * pwm_config - change a PWM device configuration
> > + */
> > +int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
> 
> duty_ns/period_ns should probably be an unsigned type. Is 32 bits enough
> for all pwms?

Again, this is from the existing API. 32 bits is enough for 4 seconds
which is enough for the use cases I have in mind (backlight for LCDs),
but it is not enough to reflect the capabilities of some hardware which
allows for very high dividers.

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
