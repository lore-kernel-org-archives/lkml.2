Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934203Ab0KQGYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 01:24:17 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33254 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933276Ab0KQGYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 01:24:16 -0500
Date: Tue, 16 Nov 2010 23:24:12 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of: Request module by alias in of_i2c.c
Message-ID: <20101117062412.GK12813@angua.secretlab.ca>
References: <1289947334-14375-1-git-send-email-ddaney@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289947334-14375-1-git-send-email-ddaney@caviumnetworks.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 02:42:14PM -0800, David Daney wrote:
> If we are registering an i2c device that has a device tree node like
> this real-world example:
> 
>       rtc@68 {
>         compatible = "dallas,ds1337";
>         reg = <0x68>;
>       };
> 
> of_i2c_register_devices() will try to load a module called ds1337.ko.
> There is no such module, so it will fail.  If we look in modules.alias
> we will find entries like these:
> 
> .
> .
> .
> alias i2c:ds1339 rtc_ds1307
> alias i2c:ds1338 rtc_ds1307
> alias i2c:ds1337 rtc_ds1307
> alias i2c:ds1307 rtc_ds1307
> alias i2c:ds1374 rtc_ds1374
> .
> .
> .
> 
> The module we want is really called rtc_ds1307.ko.  If we request a
> module called "i2c:ds1337", the userspace module loader will do the
> right thing (unless it is busybox) and load rtc_ds1307.ko.  So we add
> the I2C_MODULE_PREFIX to the request_module() string.
> 
> Signed-off-by: David Daney <ddaney@caviumnetworks.com>

Applied, thanks.

g.

> ---
>  drivers/of/of_i2c.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/of/of_i2c.c b/drivers/of/of_i2c.c
> index c85d3c7..f37fbeb 100644
> --- a/drivers/of/of_i2c.c
> +++ b/drivers/of/of_i2c.c
> @@ -61,7 +61,7 @@ void of_i2c_register_devices(struct i2c_adapter *adap)
>  		info.of_node = of_node_get(node);
>  		info.archdata = &dev_ad;
>  
> -		request_module("%s", info.type);
> +		request_module("%s%s", I2C_MODULE_PREFIX, info.type);
>  
>  		result = i2c_new_device(adap, &info);
>  		if (result == NULL) {
> -- 
> 1.7.2.3
> 
