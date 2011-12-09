Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280Ab1LIKRJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 05:17:09 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62628 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab1LIKRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 05:17:06 -0500
Date: Fri, 9 Dec 2011 14:17:00 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Hughes <hughsient@gmail.com>,
        Daniel Nicoletti <dantti12@gmail.com>, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, vojtech@ucw.cz,
        Przemo Firszt <przemo@firszt.eu>, Richard Hughes <richard@hughsie.com>
Subject: Re: [GIT PULL] power_supply: add power supply scope
Message-ID: <20111209101700.GA20100@oksana.dev.rtsoft.ru>
References: <CACo8zOd45i3EnCVMyJoDPP4bx2AnD9mEjDiC=bJKvmX=TWfXGg@mail.gmail.com>
 <4ED90E6D.8090402@goop.org>
 <CACo8zOcvKwr0wDkytvJfqyx4kV0ceYyCt+qnDqiSgxNywpzeHg@mail.gmail.com>
 <4ED9BDF8.3010600@goop.org>
 <CAD2FfiE-rg-1bMmVpYzBhnQcBMKKKO4WPnu0bvx+pvdFnpARrQ@mail.gmail.com>
 <4EDE4C7A.1010802@goop.org>
 <CAD2FfiHWuEmVTa54YqfJDk5zHpSQuM_nwPT=mR6NoWpajpydpg@mail.gmail.com>
 <4EDFA192.7000602@goop.org>
 <CAD2FfiF+fVoLPWpPyGGKdnoGhx1f=Loh2Ju-vdU58Y=2kf6C3g@mail.gmail.com>
 <4EE015D1.5070005@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4EE015D1.5070005@goop.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few more minor nits...

On Wed, Dec 07, 2011 at 05:41:37PM -0800, Jeremy Fitzhardinge wrote:
[...]
> diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
> index 329b46b..bacf327 100644
> --- a/drivers/power/power_supply_core.c
> +++ b/drivers/power/power_supply_core.c
> @@ -147,6 +147,12 @@ struct power_supply *power_supply_get_by_name(char *name)
>  }
>  EXPORT_SYMBOL_GPL(power_supply_get_by_name);
>  
> +

Needless newline. :-)

> +int power_supply_powers(struct power_supply *psy, struct device *dev)
> +{
> +	return sysfs_create_link_nowarn(&psy->dev->kobj, &dev->kobj, "powers");
> +}

- This surely creates an important ABI to the userland. This has to be
  documented via Documentation/ABI (or at least via commit message that
  I don't see in this email :-).

- This functionality isn't used anywhere as of now (i.e. I don't see
  anyone calling this function), so let's omit it for now?

- I still don't think that this should be a single symlink, to me the
  more universal (so that we don't have to break ABI in the future)
  way would be 'powers' directory with symlinks in it.
  But maybe I'm not following where exactly the link will be created?
  Documentation or an example of the new sysfs structure would help.

> +
>  static void power_supply_dev_release(struct device *dev)
>  {
>  	pr_debug("device: '%s': %s\n", dev_name(dev), __func__);
> @@ -202,6 +208,7 @@ EXPORT_SYMBOL_GPL(power_supply_register);
>  void power_supply_unregister(struct power_supply *psy)
>  {
>  	cancel_work_sync(&psy->changed_work);
> +	sysfs_remove_link(&psy->dev->kobj, "powers");
>  	power_supply_remove_triggers(psy);
>  	device_unregister(psy->dev);
>  }
> diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
> index e15d4c9..21178eb 100644
> --- a/drivers/power/power_supply_sysfs.c
> +++ b/drivers/power/power_supply_sysfs.c
> @@ -63,6 +63,9 @@ static ssize_t power_supply_show_property(struct device *dev,
>  	static char *capacity_level_text[] = {
>  		"Unknown", "Critical", "Low", "Normal", "High", "Full"
>  	};
> +	static char *scope_text[] = {
> +		"Unknown", "System", "Device"
> +	};
>  	ssize_t ret = 0;
>  	struct power_supply *psy = dev_get_drvdata(dev);
>  	const ptrdiff_t off = attr - power_supply_attrs;
> @@ -95,6 +98,8 @@ static ssize_t power_supply_show_property(struct device *dev,
>  		return sprintf(buf, "%s\n", capacity_level_text[value.intval]);
>  	else if (off == POWER_SUPPLY_PROP_TYPE)
>  		return sprintf(buf, "%s\n", type_text[value.intval]);
> +	else if (off == POWER_SUPPLY_PROP_SCOPE)
> +		return sprintf(buf, "%s\n", scope_text[value.intval]);

Should we really handle the PROP_SCOPE as a dynamic property?
Maybe do it similar to PROP_TYPE, so that drivers will only need to
specity the scope during registration, and not bother w/ handling
it in theirs get_property() callbacks?

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
