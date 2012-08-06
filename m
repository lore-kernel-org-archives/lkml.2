Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab2HFRkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 13:40:47 -0400
Received: from smtp-out-181.synserver.de ([212.40.185.181]:1055 "EHLO
	smtp-out-181.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab2HFRkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 13:40:45 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 3788
Message-ID: <5020029E.6090607@metafoo.de>
Date: Mon, 06 Aug 2012 19:45:02 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: anish kumar <anish198519851985@gmail.com>
CC: cw00.choi@samsung.com, myungjoo.ham@samsung.com, jic23@cam.ac.uk,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        anish kumar <anish.singh@samsung.com>
Subject: Re: Extcon: adc_jack: adc-jack driver to support 3.5 pi or simliar
 devices
References: <1344272343-23953-1-git-send-email-anish198519851985@gmail.com>
In-Reply-To: <1344272343-23953-1-git-send-email-anish198519851985@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2012 06:59 PM, anish kumar wrote:
> From: anish kumar <anish198519851985@gmail.com>
> 
> External connector devices that decides connection information based on
> ADC values may use adc-jack device driver. The user simply needs to
> provide a table of adc range and connection states. Then, extcon
> framework will automatically notify others.
> 
> Changes in this version:
> added Lars-Peter Clausen suggested changes:
> Using macros to get rid of boiler plate code such as devm_kzalloc
> and module_platform_driver.Other changes suggested are related to
> coding guidelines.

Looks mostly good.

> 
> Signed-off-by: anish kumar <anish.singh@samsung.com>
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> ---
> [...]
> +
> +static int adc_jack_probe(struct platform_device *pdev)

__devinit

> +{
> [...]
> +
> +	data->irq = platform_get_irq(pdev, 0);

platform_get_irq may return an error, you should check that.

> +
> +	err = request_any_context_irq(data->irq, adc_jack_irq_thread,
> +				pdata->irq_flags, pdata->name, data);
> +
> +	if (err) {
> +		dev_err(&pdev->dev, "error: irq %d\n", data->irq);
> +		err = -EINVAL;
> +		goto err_irq;
> +	}
> +
> +	goto out;
> +
> +err_irq:
> +	extcon_dev_unregister(&data->edev);
> +err_initwork:
> +	cancel_delayed_work_sync(&data->handler);

It does not hurt, but since the work is only scheduled from the interrupt
handler this should not be necessary.

> +err_alloc:
> +	kfree(data);

Since it is allocated with devm_kzalloc now you shouldn't manually free it.

> +out:
> +	return err;
> +}
> +
> +static int __devexit adc_jack_remove(struct platform_device *pdev)
> +{
> +	struct adc_jack_data *data = platform_get_drvdata(pdev);
> +
> +	extcon_dev_unregister(&data->edev);
> +	if (data->irq)

Since the IRQ is now requested unconditionally this check can also be remove.

> +		free_irq(data->irq, data);

Since you access the extcon device from within the IRQ handler it makes
sense to free the IRQ handler before the extcon device.

> +
> +	return 0;
> +}
> +
[...]
> diff --git a/include/linux/extcon/adc_jack.h b/include/linux/extcon/adc_jack.h
> new file mode 100644
> index 0000000..ca4d1cd
> --- /dev/null
> +++ b/include/linux/extcon/adc_jack.h
> @@ -0,0 +1,77 @@
> +/*
> [...]
> +struct adc_jack_pdata {
> +	const char *name;
> +	const char *consumer_channel;
> +	/*
> +	 * NULL if standard extcon names are used.
> +	 * The last entry should be NULL
> +	 */
> +	const char **cable_names;
> +	/* The last entry's state should be 0 */
> +	struct adc_jack_cond *adc_condition;
> +
> +	unsigned long irq_flags;
> +	unsigned long handling_delay_ms; /* in ms */
> +
> +	/* When we have ADC subsystem, this can be generalized. */
> +	int (*get_adc)(u32 *value);

Huh, looks like it sneaked in again.


> +};
> +
> +#endif /* _EXTCON_ADC_JACK_H */

