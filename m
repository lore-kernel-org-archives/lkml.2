Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133Ab1KRQRG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 11:17:06 -0500
Received: from smtp151.dfw.emailsrvr.com ([67.192.241.151]:47399 "EHLO
	smtp151.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab1KRQRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 11:17:04 -0500
Message-ID: <4EC684FF.7000408@calxeda.com>
Date: Fri, 18 Nov 2011 10:17:03 -0600
From: Rob Herring <rob.herring@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Wojciech Baranowski <baranowski@chromium.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of/device: Obtain platform dev name and id from bus_id
References: <1321630233.21392.43.camel@zalecze.wat.corp.google.com>
In-Reply-To: <1321630233.21392.43.camel@zalecze.wat.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2011 09:30 AM, Wojciech Baranowski wrote:
> When adding new platform device, parse platform_device.dev.bus_id (used as
> device name) to get platform_device.name and platform_device.id before
> calling device_add. If bus_id cannot be split into name and id, fallback to
> the old way.
> 
> Currently the name is being set to bus_id and id is being set to -1, even
> when bus_id is in the form "some_name.some_number". This might lead to
> problems with device-driver matching and index out of bounds error. It is
> also not consistent with how the bus_id is generated from name and id.
> 
> Signed-off-by: Wojciech Baranowski <baranowski@chromium.org>
> ---

This has come up before and been rejected. Drivers should not rely on id
as an index. The main case I've seen where an index is needed is serial
consoles and aliases supports that case.

Do you have a specific problem you are trying to solve?

Rob

>  drivers/of/device.c |   43 +++++++++++++++++++++++++++++++++++++++----
>  1 files changed, 39 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/of/device.c b/drivers/of/device.c
> index 62b4b32..8758c3f 100644
> --- a/drivers/of/device.c
> +++ b/drivers/of/device.c
> @@ -47,14 +47,49 @@ void of_dev_put(struct platform_device *dev)
>  }
>  EXPORT_SYMBOL(of_dev_put);
>  
> +static int of_dev_parse_devname(struct platform_device *ofdev)
> +{
> +	const char *name;
> +	const char *dot_pos;
> +	char *short_name;
> +
> +	name = dev_name(&ofdev->dev);
> +	if (!name)
> +		goto std_out;
> +
> +	dot_pos = strrchr(name, '.');
> +	if (!dot_pos)
> +		goto std_out;
> +
> +	short_name = kmalloc(dot_pos - name + 1, GFP_KERNEL);
> +	if (!short_name)
> +		return -ENOMEM;
> +
> +	strlcpy(short_name, name, dot_pos - name + 1);
> +	ofdev->name = short_name;
> +
> +	if (kstrtoint(dot_pos + 1, 10, &ofdev->id))
> +		goto kfree_out;
> +
> +	return 0;
> +
> +kfree_out:
> +	kfree(short_name);
> +std_out:
> +	ofdev->name = name;
> +	ofdev->id = -1;
> +	return 0;
> +}
> +
>  int of_device_add(struct platform_device *ofdev)
>  {
> +	int ret;
> +
>  	BUG_ON(ofdev->dev.of_node == NULL);
>  
> -	/* name and id have to be set so that the platform bus doesn't get
> -	 * confused on matching */
> -	ofdev->name = dev_name(&ofdev->dev);
> -	ofdev->id = -1;
> +	ret = of_dev_parse_devname(ofdev);
> +	if (ret)
> +		return ret;
>  
>  	/* device_add will assume that this device is on the same node as
>  	 * the parent. If there is no parent defined, set the node

