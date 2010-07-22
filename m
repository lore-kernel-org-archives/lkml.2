Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489Ab0GVOHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 10:07:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33478 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759370Ab0GVOHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 10:07:17 -0400
Date: Thu, 22 Jul 2010 10:07:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
cc: linux-kernel@vger.kernel.org,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCHv4 1/2] usb: gadget: storage: strict coversion of 'ro'
 parameter
In-Reply-To: <1279789128-11399-1-git-send-email-ext-andriy.shevchenko@nokia.com>
Message-ID: <Pine.LNX.4.44L0.1007221002510.1725-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jul 2010, Andy Shevchenko wrote:

> Bring a strict way to get the 'ro' parameter from the user.
> 
> The patch followed by this one adds another boolean parameter. To be consistent
> Michał Nazarewicz proposed to use simple_strtol() in both cases (correspondend
> discussion in LKML [1]). Due to simple_strtol() doesn't return error in a good
> way and we have a boolean parameter the strict_strtoul() is used.
> 
> [1] http://lkml.org/lkml/2010/7/14/169
> 
> Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: linux-usb@vger.kernel.org
> ---
>  drivers/usb/gadget/storage_common.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
> index 04c462f..7123929 100644
> --- a/drivers/usb/gadget/storage_common.c
> +++ b/drivers/usb/gadget/storage_common.c
> @@ -723,9 +723,9 @@ static ssize_t fsg_store_ro(struct device *dev, struct device_attribute *attr,
>  	ssize_t		rc = count;
>  	struct fsg_lun	*curlun = fsg_lun_from_dev(dev);
>  	struct rw_semaphore	*filesem = dev_get_drvdata(dev);
> -	int		i;
> +	unsigned long	ro;
>  
> -	if (sscanf(buf, "%d", &i) != 1)
> +	if (strict_strtoul(buf, 2, &ro))
>  		return -EINVAL;
>  
>  	/* Allow the write-enable status to change only while the backing file
> @@ -735,8 +735,8 @@ static ssize_t fsg_store_ro(struct device *dev, struct device_attribute *attr,
>  		LDBG(curlun, "read-only status change prevented\n");
>  		rc = -EBUSY;
>  	} else {
> -		curlun->ro = !!i;
> -		curlun->initially_ro = !!i;
> +		curlun->ro = ro;
> +		curlun->initially_ro = ro;
>  		LDBG(curlun, "read-only status set to %d\n", curlun->ro);
>  	}
>  	up_read(filesem);

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Strictly speaking, this changes the behavior when a non-binary value is
specified.  For example, if somebody were to write "10" then the old
code would set the value to True and the new code would set the value
to False -- and neither would reject it as they probably should.  
That's okay; people who write ambiguous or invalid values deserve what
they get.

Alan Stern

