Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab0GNMhP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 08:37:15 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:12685 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab0GNMhN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 08:37:13 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Wed, 14 Jul 2010 14:38:20 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv2] usb: gadget: storage: optional SCSI WRITE FUA bit
In-reply-to: <1279098331-7872-1-git-send-email-ext-andriy.shevchenko@nokia.com>
To: linux-kernel@vger.kernel.org, Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        Denis Karpov <ext-denis.2.karpov@nokia.com>,
        Adrian Hunter <adrian.hunter@nokia.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Message-id: <op.vft2p6do7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <Pine.LNX.4.44L0.1007131003560.1568-100000@iolanthe.rowland.org>
 <1279098331-7872-1-git-send-email-ext-andriy.shevchenko@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jul 2010 11:05:31 +0200, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
> MS Windows mounts removable storage in "Removal optimized mode" by
> default. All the writes to the media are synchronous which is achieved
> by setting FUA (Force Unit Access) bit in SCSI WRITE(10,12) commands.
> This prevents I/O requests aggregation in block layer dramatically
> decreasing performance.

> diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
> index b49d86e..45f58d9 100644
> --- a/drivers/usb/gadget/file_storage.c
> +++ b/drivers/usb/gadget/file_storage.c
> @@ -93,6 +93,8 @@
>   *	removable		Default false, boolean for removable media
>   *	luns=N			Default N = number of filenames, number of
>   *					LUNs to support
> + *	fua=b[,b...]		Default false, booleans for ignore FUA flag
> + *					in SCSI WRITE(6,10,12) commands

I wonder if it makes sense to make it per-LUN.  I would imagine that it's great
to ignore FUA if the device has its own power supply in which case after disconnect
the data won't be lost.  This is a per-device property not really per-LUN.  As such
I'd make this option global for the gadget.

> @@ -743,6 +752,24 @@ static ssize_t fsg_store_ro(struct device *dev, struct device_attribute *attr,
>  	return rc;
>  }
>+static ssize_t fsg_store_fua(struct device *dev, struct device_attribute *attr,
> +			     const char *buf, size_t count)
> +{
> +	ssize_t		rc = count;

Not really needed here.

> +	struct fsg_lun	*curlun = fsg_lun_from_dev(dev);
> +	int		i;
> +
> +	if (sscanf(buf, "%d", &i) != 1)
> +		return -EINVAL;

Why not simple_strtol() directly?

> +
> +	if (curlun->fua)
> +		fsg_lun_fsync_sub(curlun);

Shouldn't that read something like:

+	if (!curlun->fua && i)
+		fsg_lun_fsync_sub(curlun);

ie. there is no sense in syncing if FUA was active (in which case all
writes were synced already, right?) or if the new value is false (since
then user does not won't syncing).

> +
> +	curlun->fua = !!i;
> +
> +	return rc;

Just plain:

+	return count;

> +}
> +
>  static ssize_t fsg_store_file(struct device *dev, struct device_attribute *attr,
>  			      const char *buf, size_t count)
>  {


-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
