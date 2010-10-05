Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab0JET27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 15:28:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754568Ab0JET25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 15:28:57 -0400
Date: Tue, 5 Oct 2010 12:22:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arun Murthy <arun.murthy@stericsson.com>
Cc: <lars@metafoo.de>, <kernel@pengutronix.de>, <philipp.zabel@gmail.com>,
        <robert.jarzmik@free.fr>, <marek.vasut@gmail.com>,
        <eric.y.miao@gmail.com>, <rpurdie@rpsys.net>, <sameo@linux.intel.com>,
        <kgene.kim@samsung.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-mips@linux-mips.org>, <STEricsson_nomadik_linux@list.st.com>,
        <bgat@billgatliff.com>
Subject: Re: [PATCHv2 1/7] pwm: Add pwm core driver
Message-Id: <20101005122225.6dda30ff.akpm@linux-foundation.org>
In-Reply-To: <1286280002-1636-2-git-send-email-arun.murthy@stericsson.com>
References: <1286280002-1636-1-git-send-email-arun.murthy@stericsson.com>
	<1286280002-1636-2-git-send-email-arun.murthy@stericsson.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Oct 2010 17:29:56 +0530
Arun Murthy <arun.murthy@stericsson.com> wrote:

> The existing pwm based led and backlight driver makes use of the
> pwm(include/linux/pwm.h). So all the board specific pwm drivers will
> be exposing the same set of function name as in include/linux/pwm.h.
> Consder a platform with multi Soc or having more than one pwm module, in
> such a case, there exists more than one pwm driver for a platform. Each
> of these pwm drivers export the same set of function and hence leads to
> re-declaration build error.
> 
> In order to overcome this issue all the pwm drivers must register to
> some core pwm driver with function pointers for pwm operations (i.e
> pwm_config, pwm_enable, pwm_disable).
> 
> The clients of pwm device will have to call pwm_request, wherein
> they will get the pointer to struct pwm_ops. This structure include
> function pointers for pwm_config, pwm_enable and pwm_disable.
> 

Have we worked out who will be merging this work, if it gets merged?

>
> ...
>
> +struct pwm_dev_info {
> +	struct pwm_device *pwm_dev;
> +	struct list_head list;
> +};
> +static struct pwm_dev_info *di;

We could just do

	static struct pwm_dev_info {
		...
	} *di;

> +DECLARE_RWSEM(pwm_list_lock);

This can/should be static.

> +void __deprecated pwm_free(struct pwm_device *pwm)
> +{
> +}

Why are we adding a new function and already deprecating it?

Probably this was already addressed in earlier review, but I'm asking
again, because there's no comment explaining the reasons.  Lesson
learned, please add a comment.

Oh, I see that pwm_free() already exists.  This patch adds a new copy
and doesn't remove the old function.  Does this all actually work?

It still needs a comment explaining why it's deprecated.

> +int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
> +{
> +	if (!pwm->pops)
> +		-EFAULT;
> +	return pwm->pops->pwm_config(pwm, duty_ns, period_ns);
> +}
> +EXPORT_SYMBOL(pwm_config);
> +
> +int pwm_enable(struct pwm_device *pwm)
> +{
> +	if (!pwm->pops)
> +		-EFAULT;
> +	return pwm->pops->pwm_enable(pwm);
> +}
> +EXPORT_SYMBOL(pwm_enable);
> +
> +void pwm_disable(struct pwm_device *pwm)
> +{
> +	if (!pwm->pops)
> +		-EFAULT;
> +	pwm->pops->pwm_disable(pwm);
> +}
> +EXPORT_SYMBOL(pwm_disable);
> +
> +int pwm_device_register(struct pwm_device *pwm_dev)
> +{
> +	struct pwm_dev_info *pwm;
> +
> +	down_write(&pwm_list_lock);
> +	pwm = kzalloc(sizeof(struct pwm_dev_info), GFP_KERNEL);
> +	if (!pwm) {
> +		up_write(&pwm_list_lock);
> +		return -ENOMEM;
> +	}

The allocation attempt can be moved outside the lock, making the code
faster, cleaner and shorter.

> +	pwm->pwm_dev = pwm_dev;
> +	list_add_tail(&pwm->list, &di->list);
> +	up_write(&pwm_list_lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(pwm_device_register);
> +
> +int pwm_device_unregister(struct pwm_device *pwm_dev)
> +{
> +	struct pwm_dev_info *tmp;
> +	struct list_head *pos, *tmp_lst;
> +
> +	down_write(&pwm_list_lock);
> +	list_for_each_safe(pos, tmp_lst, &di->list) {
> +		tmp = list_entry(pos, struct pwm_dev_info, list);
> +		if (tmp->pwm_dev == pwm_dev) {
> +			list_del(pos);
> +			kfree(tmp);
> +			up_write(&pwm_list_lock);
> +			return 0;
> +		}
> +	}
> +	up_write(&pwm_list_lock);
> +	return -ENOENT;
> +}
> +EXPORT_SYMBOL(pwm_device_unregister);
> +
> +struct pwm_device *pwm_request(int pwm_id, const char *name)
> +{
> +	struct pwm_dev_info *pwm;
> +	struct list_head *pos;
> +
> +	down_read(&pwm_list_lock);
> +	list_for_each(pos, &di->list) {
> +		pwm = list_entry(pos, struct pwm_dev_info, list);
> +		if ((!strcmp(pwm->pwm_dev->pops->name, name)) &&
> +				(pwm->pwm_dev->pwm_id == pwm_id)) {
> +			up_read(&pwm_list_lock);
> +			return pwm->pwm_dev;
> +		}
> +	}
> +	up_read(&pwm_list_lock);
> +	return ERR_PTR(-ENOENT);
> +}
> +EXPORT_SYMBOL(pwm_request);

We have a new kernel-wide exported-to-modules formal API.  We prefer
that such things be fully documented, please.  kerneldoc is a suitable
way but please avoid falling into the kerneldoc trap of filling out
fields with obvious boilerplate and not actually telling people
anything interesting or useful.

> +static int __init pwm_init(void)
> +{
> +	struct pwm_dev_info *pwm;
> +
> +	pwm = kzalloc(sizeof(struct pwm_dev_info), GFP_KERNEL);
> +	if (!pwm)
> +		return -ENOMEM;
> +	INIT_LIST_HEAD(&pwm->list);
> +	di = pwm;
> +	return 0;
> +}

OK, this looks wrong.

AFACIT you've created a dummy pwm_dev_info as a singleton, kernel-wide
anchor for a list of all pwm_dev_info's.  So this "anchor" pwm_dev_info
never actually gets used for anything.

The way to do this is to remove `di' altogether and instead use a
singleton, kernel-wide list_head as the anchor for all the
dynamically-allocated pwm_dev_info's.

> +subsys_initcall(pwm_init);
> +
> +static void __exit pwm_exit(void)
> +{
> +	kfree(di);
> +}
> +
> +module_exit(pwm_exit);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Arun R Murthy");
> +MODULE_ALIAS("core:pwm");
> +MODULE_DESCRIPTION("Core pwm driver");
> diff --git a/include/linux/pwm.h b/include/linux/pwm.h
> index 7c77575..6e7da1f 100644
> --- a/include/linux/pwm.h
> +++ b/include/linux/pwm.h
> @@ -3,6 +3,13 @@
>  
>  struct pwm_device;
>  
> +struct pwm_ops {
> +	int (*pwm_config)(struct pwm_device *pwm, int duty_ns, int period_ns);
> +	int (*pwm_enable)(struct pwm_device *pwm);
> +	int (*pwm_disable)(struct pwm_device *pwm);
> +	char *name;
> +};

This also should be documented.

>
> ...
>

I suggest that you work on Kevin's comments before making any code
changes though.
