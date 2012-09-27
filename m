Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab2I0HXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 03:23:32 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:57922 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab2I0HXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 03:23:31 -0400
Date: Thu, 27 Sep 2012 00:20:49 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: mathieu.poirier@linaro.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 27/57] power: sysfs interface update
Message-ID: <20120927072049.GK8836@lizard>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
 <1348589574-25655-28-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1348589574-25655-28-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 10:12:24AM -0600, mathieu.poirier@linaro.org wrote:
> From: Michel JAOUEN <michel.jaouen@stericsson.com>
> 
> Add new sysfs interface to get current charge status
> 
> Signed-off-by: Michel JAOUEN <michel.jaouen@stericsson.com>
> Signed-off-by: Loic Pallardy <loic.pallardy@stericsson.com>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
> Reviewed-by: Olivier CLERGEAUD <olivier.clergeaud@stericsson.com>
> Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
> ---
>  drivers/power/ab8500_charger.c  |    3 +++
>  drivers/power/abx500_chargalg.c |   24 +++++++++++++++++++++++-
>  2 files changed, 26 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
> index 4129599..0a781a0 100644
> --- a/drivers/power/ab8500_charger.c
> +++ b/drivers/power/ab8500_charger.c
> @@ -2759,6 +2759,9 @@ static int ab8500_charger_usb_notifier_call(struct notifier_block *nb,
>  	enum ab8500_usb_state bm_usb_state;
>  	unsigned mA = *((unsigned *)power);
>  
> +	if (di == NULL)
> +		return NOTIFY_DONE;
> +

I'd write !di.

[...]
> +static ssize_t abx500_chargalg_sysfs_show(struct kobject *kobj,
> +	struct attribute *attr, char *buf)
> +{
> +	struct abx500_chargalg *di = container_of(kobj,
> +		struct abx500_chargalg, chargalg_kobject);
> +
> +	if ((di->susp_status.ac_suspended == true) &&
> +		(di->susp_status.usb_suspended == true))
> +		return sprintf(buf, "0\n");
> +	else
> +		return sprintf(buf, "1\n");

just

return sprintf(buf, "%d\n", di->susp_status.ac_suspended &&
			    di->susp_status.usb_suspended);

> +}
> +
>  /* Exposure to the sysfs interface */
>  
>  /**
> @@ -1749,7 +1770,7 @@ static ssize_t abx500_chargalg_sysfs_charger(struct kobject *kobj,
>  static struct attribute abx500_chargalg_en_charger = \
>  {
>  	.name = "chargalg",
> -	.mode = S_IWUGO,
> +	.mode = S_IRUGO | S_IWUSR,
>  };
>  
>  static struct attribute *abx500_chargalg_chg[] = {
> @@ -1758,6 +1779,7 @@ static struct attribute *abx500_chargalg_chg[] = {
>  };
>  
>  static const struct sysfs_ops abx500_chargalg_sysfs_ops = {
> +	.show = abx500_chargalg_sysfs_show,
>  	.store = abx500_chargalg_sysfs_charger,
>  };
>  
> -- 
> 1.7.5.4
