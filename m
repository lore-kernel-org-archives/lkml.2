Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843Ab1LFBdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 20:33:11 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41412 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932780Ab1LFBdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 20:33:10 -0500
Date: Tue, 6 Dec 2011 05:33:06 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 5/5] power: sbs-battery: Change power supply name
Message-ID: <20111206013305.GB3065@oksana.dev.rtsoft.ru>
References: <1323129487-24859-1-git-send-email-rklein@nvidia.com>
 <1323129487-24859-5-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1323129487-24859-5-git-send-email-rklein@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 03:58:07PM -0800, Rhyland Klein wrote:
>  static int sbs_read_word_data(struct i2c_client *client, u8 address)
> @@ -681,15 +682,25 @@ static int __devinit sbs_probe(struct i2c_client *client,
>  	struct sbs_platform_data *pdata = client->dev.platform_data;
>  	int rc;
>  	int irq;
> +	char *name;
>  
> -	chip = kzalloc(sizeof(struct sbs_info), GFP_KERNEL);
> -	if (!chip)
> +	name = kasprintf(GFP_KERNEL, "%s-%s", "sbs", dev_name(&client->dev));

Mm... why not just

kasprintf(GFP_KERNEL, "sbs-%s", dev_name(&client->dev)) ?

> +	if (!name) {
> +		dev_err(&client->dev, "Failed to allocate device name\n");
>  		return -ENOMEM;
> +	}
> +
> +	chip = kzalloc(sizeof(struct sbs_info), GFP_KERNEL);
> +	if (!chip) {
> +		rc = -ENOMEM;
> +		goto exit_free_name;
> +	}
>  
>  	chip->client = client;
>  	chip->enable_detection = false;
>  	chip->gpio_detect = false;
> -	chip->power_supply.name = "battery";
> +	chip->name = name;
> +	chip->power_supply.name = name;
>  	chip->power_supply.type = POWER_SUPPLY_TYPE_BATTERY;
>  	chip->power_supply.properties = sbs_properties;
>  	chip->power_supply.num_properties = ARRAY_SIZE(sbs_properties);
> @@ -774,6 +785,9 @@ exit_psupply:
>  
>  	kfree(chip);
>  
> +exit_free_name:
> +	kfree(name);
> +
>  	return rc;
>  }
>  
> @@ -790,6 +804,7 @@ static int __devexit sbs_remove(struct i2c_client *client)
>  
>  	cancel_delayed_work_sync(&chip->work);
>  
> +	kfree(chip->name);

I think you don't really need chip->name.

power_supply_unregister() won't touch power_supply.name, so
you can kfree(chip->power_supply.name);

Otherwise, the patch looks great.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
