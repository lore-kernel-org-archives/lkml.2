Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab1JRS0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 14:26:00 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:47962 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751118Ab1JRSZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 14:25:59 -0400
Message-ID: <4E9DC496.3010909@metafoo.de>
Date: Tue, 18 Oct 2011 20:25:26 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linus.ml.walleij@gmail.com, zdevai@gmail.com, linux@arm.linux.org.uk,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com, gregkh@suse.de
Subject: Re: [PATCH 3/6] IIO:CORE add global list of registered IIO devices.
References: <1318951776-19393-1-git-send-email-jic23@cam.ac.uk> <1318951776-19393-4-git-send-email-jic23@cam.ac.uk>
In-Reply-To: <1318951776-19393-4-git-send-email-jic23@cam.ac.uk>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2011 05:29 PM, Jonathan Cameron wrote:
> Needed for inkernel interfaces.
> 

The bus_type structure keeps a list of all devices registered on that bus, so
you should be able to use bus_for_each_dev and bus_find_device for iterating
over the iio devices.

> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  drivers/iio/iio.c       |    9 +++++++++
>  include/linux/iio/iio.h |    1 +
>  2 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/iio/iio.c b/drivers/iio/iio.c
> index 9e6acc1..246a093 100644
> --- a/drivers/iio/iio.c
> +++ b/drivers/iio/iio.c
> @@ -15,6 +15,9 @@
>  #include <linux/iio/iio.h>
>  #include <linux/iio/sysfs.h>
>  
> +static DEFINE_MUTEX(iio_device_list_lock);
> +static LIST_HEAD(iio_device_list);
> +
>  static DEFINE_IDA(iio_ida);
>  
>  static struct bus_type iio_bus_type = {
> @@ -91,6 +94,9 @@ static void iio_dev_release(struct device *device)
>  {
>  	struct iio_dev *indio_dev = container_of(device, struct iio_dev, dev);
>  	iio_device_unregister_sysfs(indio_dev);
> +	mutex_lock(&iio_device_list_lock);
> +	list_del(&indio_dev->dev_list_entry);
> +	mutex_unlock(&iio_device_list_lock);
>  }
>  
>  static struct device_type iio_dev_type = {
> @@ -559,6 +565,9 @@ int iio_device_register(struct iio_dev *indio_dev)
>  	if (ret)
>  		goto error_free_sysfs;
>  
> +	mutex_lock(&iio_device_list_lock);
> +	list_add(&indio_dev->dev_list_entry, &iio_device_list);
> +	mutex_unlock(&iio_device_list_lock);
>  	return 0;
>  
>  error_free_sysfs:
> diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
> index beedc5c..f14e7dc 100644
> --- a/include/linux/iio/iio.h
> +++ b/include/linux/iio/iio.h
> @@ -192,6 +192,7 @@ struct iio_info {
>   * @info:		[DRIVER] callbacks and constant info from driver
>   * @groups:		[INTERN] attribute groups
>   * @groupcounter:	[INTERN] index of next attribute group
> + * @dev_list_entry:	[INTERN] entry in global list of iio devices
>   **/
>  struct iio_dev {
>  	int				id;

