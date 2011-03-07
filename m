Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab1CGEUu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 23:20:50 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41691 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755252Ab1CGEUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 23:20:49 -0500
X-Sasl-enc: bRxBOg1UWLBvJaDr2zJ/QXIEKT8HkLzA1kqSIuTNJ5Ho 1299471648
Message-ID: <4D745D1F.2070808@fastmail.fm>
Date: Mon, 07 Mar 2011 04:20:47 +0000
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-GB; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Bill Gatliff <bgat@billgatliff.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PWM v6 1/3] PWM: Implement a generic PWM framework
References: <1299385050-13674-1-git-send-email-bgat@billgatliff.com> <1299385050-13674-2-git-send-email-bgat@billgatliff.com>
In-Reply-To: <1299385050-13674-2-git-send-email-bgat@billgatliff.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2011 04:17, Bill Gatliff wrote:
> +The Generic PWM Device API framework is implemented in
> +include/linux/pwm/pwm.h and drivers/pwm/pwm.c.  The functions therein
> +use information from pwm_device and pwm__config structures to invoke

Could you fix that to be pwm_config please.

[snip]

> --- /dev/null
> +++ b/drivers/pwm/Kconfig
> @@ -0,0 +1,10 @@
> +#
> +# PWM infrastructure and devices
> +#
> +
> +menuconfig GENERIC_PWM
> +	tristate "PWM Support"
> +	help
> +	  Enables PWM device support implemented via a generic
> +	  framework.  If unsure, say N.
> +

Does this need help text? Can't we just select GENERIC_PWM for the
drivers / users that need it?

> diff --git a/drivers/pwm/pwm.c b/drivers/pwm/pwm.c

[snip]

> +static int __pwm_request(struct pwm_device *p, const char *label)
> +{
> +	int ret;
> +
> +	ret = test_and_set_bit(FLAG_REQUESTED, &p->flags);
> +	if (ret) {
> +		ret = -EBUSY;
> +		goto done;
> +	}
> +
> +	p->label = label;
> +
> +	if (p->ops->request) {
> +		ret = p->ops->request(p);
> +		if (ret) {
> +			clear_bit(FLAG_REQUESTED, &p->flags);
> +			goto done;

You don't need this goto here.

> +		}
> +	}
> +
> +done:
> +	return ret;
> +}
> +

[snip]

> +struct pwm_device *pwm_request(const char *bus_id, int id, const char *label)
> +{
> +	char name[256];
> +	int ret;
> +
> +	if (id == -1)
> +		ret = scnprintf(name, sizeof name, "%s", bus_id);

Kernel doc comment for the function to describe the id == -1 case?

> +	else
> +		ret = scnprintf(name, sizeof name, "%s:%d", bus_id, id);
> +	if (ret <= 0 || ret >= sizeof name)
> +		return ERR_PTR(-EINVAL);
> +
> +	return pwm_request_byname(name, label);
> +}
> +EXPORT_SYMBOL(pwm_request);

[snip]

> +int pwm_config(struct pwm_device *p, struct pwm_config *c)
> +{
> +	int ret = 0;

	might_sleep() ?

[snip]

> +static void pwm_handler(struct work_struct *w)
> +{
> +	struct pwm_device *p = container_of(w, struct pwm_device,
> +					    handler_work);

	You could just not queue the work if !p->handler

> +	if (p->handler)
> +		p->handler(p, p->handler_data);
> +}
> +
> +void pwm_callback(struct pwm_device *p)
> +{
> +	queue_work(pwm_handler_workqueue, &p->handler_work);
> +}
> +EXPORT_SYMBOL(pwm_callback);
> +

[snip]

> +int pwm_register(struct pwm_device *p, struct device *parent, int id)
> +{
> +	int ret;
> +	char name[256];
> +
> +	if (IS_ERR_OR_NULL(parent))
> +		return -EINVAL;
> +
> +	if (id == -1)
> +		ret = scnprintf(name, sizeof name, "%s", dev_name(parent));

A kernel doc comment to explain id == -1 would be nice.

> +	else
> +		ret = scnprintf(name, sizeof name, "%s:%d", dev_name(parent), id);
> +	if (ret <= 0 || ret >= sizeof name)
> +		return -EINVAL;
> +
> +	return pwm_register_byname(p, parent, name);
> +}
> +EXPORT_SYMBOL(pwm_register);
> +

Very nice framework!

Would be nice to have kernel doc comments for the functions but that can
follow on later.

Thanks,

Jack
