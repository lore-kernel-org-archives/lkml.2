Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab0HQLH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 07:07:58 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:2465 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab0HQLH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 07:07:57 -0400
Date: Tue, 17 Aug 2010 13:07:47 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Thomas <pthomas8589@gmail.com>, lm-sensors@lm-sensors.org
Subject: Re: [PATCH] hwmon: (ads7871) Fix ads7871_probe error path
Message-ID: <20100817130747.3ee0efb9@hyperion.delvare>
In-Reply-To: <1281922277.26991.3.camel@mola>
References: <1281922277.26991.3.camel@mola>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On Mon, 16 Aug 2010 09:31:17 +0800, Axel Lin wrote:
> We need to call hwmon_device_unregister() if an error is detected after
> sucessfully register hwmon device.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/hwmon/ads7871.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hwmon/ads7871.c b/drivers/hwmon/ads7871.c
> index b300a20..303db92 100644
> --- a/drivers/hwmon/ads7871.c
> +++ b/drivers/hwmon/ads7871.c
> @@ -201,11 +201,13 @@ static int __devinit ads7871_probe(struct spi_device *spi)
>  	we need to make sure we really have a chip*/
>  	if (val != ret) {
>  		err = -ENODEV;
> -		goto error_remove;
> +		goto error_unregister;
>  	}
>  
>  	return 0;
>  
> +error_unregister:
> +	hwmon_device_unregister(pdata->hwmon_dev);
>  error_remove:
>  	sysfs_remove_group(&spi->dev.kobj, &ads7871_group);
>  error_free:

The bug is real, but I don't think the fix is correct. You should never
have to unregister the hwmon device in the error path, because you
should ensure the hardware is there and working _before_ you register
the hwmon device.

User-space could watch for hwmon devices being added or removed, and
you don't want to trigger such events for a device which isn't going to
work.

So I would suggest reworking the order in which things are done,
leaving hwmon_device_register() at the end of the function. This won't
only fix the error path, this will also close a race window, as for the
moment, the device is exposed to user-space _before_ it it properly
initialized, which is wrong.

Please send an updated patch and I'll be happy to apply it.

-- 
Jean Delvare
