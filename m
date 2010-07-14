Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab0GNNpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 09:45:05 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60610 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab0GNNpB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 09:45:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jQqn4DzWtL28z8kUBc6rSMuzBSvJ/j/1R8+dVfvsv5p99kre0H6VHjOSpu0BKt0S1w
         DQWVT7+SJ39jzQd5Py379GSZbZ5G7Xq4UlfxSxLbmW1Qp9WbDCNIhzUx8wr6bEZvaSDu
         NGqA+eOrK0Y9/lhyKbX/xnBFMujp9tt8umZSo=
MIME-Version: 1.0
In-Reply-To: <op.vft2p6do7p4s8u@pikus>
References: <Pine.LNX.4.44L0.1007131003560.1568-100000@iolanthe.rowland.org>
	<1279098331-7872-1-git-send-email-ext-andriy.shevchenko@nokia.com>
	<op.vft2p6do7p4s8u@pikus>
Date: Wed, 14 Jul 2010 16:44:58 +0300
Message-ID: <AANLkTil1eG5yzBxvryf-TZINYjeGph-rNz8eELQtm5tj@mail.gmail.com>
Subject: Re: [PATCHv2] usb: gadget: storage: optional SCSI WRITE FUA bit
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: =?UTF-8?Q?Micha=C5=82_Nazarewicz?= <m.nazarewicz@samsung.com>
Cc: linux-kernel@vger.kernel.org,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        Denis Karpov <ext-denis.2.karpov@nokia.com>,
        Adrian Hunter <adrian.hunter@nokia.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/14 Michał Nazarewicz <m.nazarewicz@samsung.com>:
> On Wed, 14 Jul 2010 11:05:31 +0200, Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
>>
>> MS Windows mounts removable storage in "Removal optimized mode" by
>> default. All the writes to the media are synchronous which is achieved
>> by setting FUA (Force Unit Access) bit in SCSI WRITE(10,12) commands.
>> This prevents I/O requests aggregation in block layer dramatically
>> decreasing performance.
>
>> diff --git a/drivers/usb/gadget/file_storage.c
>> b/drivers/usb/gadget/file_storage.c
>> index b49d86e..45f58d9 100644
>> --- a/drivers/usb/gadget/file_storage.c
>> +++ b/drivers/usb/gadget/file_storage.c
>> @@ -93,6 +93,8 @@
>>  *     removable               Default false, boolean for removable media
>>  *     luns=N                  Default N = number of filenames, number of
>>  *                                     LUNs to support
>> + *     fua=b[,b...]            Default false, booleans for ignore FUA
>> flag
>> + *                                     in SCSI WRITE(6,10,12) commands
>
> I wonder if it makes sense to make it per-LUN.  I would imagine that it's
> great
> to ignore FUA if the device has its own power supply in which case after
> disconnect
> the data won't be lost.  This is a per-device property not really per-LUN.
>  As such
> I'd make this option global for the gadget.
Make sense only for removable media with one partition.
Otherwise. why we have sync option per partition f.e., not per device?

>> @@ -743,6 +752,24 @@ static ssize_t fsg_store_ro(struct device *dev,
>> struct device_attribute *attr,
>>        return rc;
>>  }
>> +static ssize_t fsg_store_fua(struct device *dev, struct device_attribute
>> *attr,
>> +                            const char *buf, size_t count)
>> +{
>> +       ssize_t         rc = count;
>
> Not really needed here.
See below

>
>> +       struct fsg_lun  *curlun = fsg_lun_from_dev(dev);
>> +       int             i;
>> +
>> +       if (sscanf(buf, "%d", &i) != 1)
>> +               return -EINVAL;
>
> Why not simple_strtol() directly?
I did it in the same way like fsg_store_ro() does.
I have no objections to back to previous solution.

>> +
>> +       if (curlun->fua)
>> +               fsg_lun_fsync_sub(curlun);
>
> Shouldn't that read something like:
>
> +       if (!curlun->fua && i)
> +               fsg_lun_fsync_sub(curlun);
>
> ie. there is no sense in syncing if FUA was active (in which case all
> writes were synced already, right?) or if the new value is false (since
> then user does not won't syncing).
The idea is to sync data before switching from async mode.
Actually fua = 1 means ignorance of that flag.


-- 
With Best Regards,
Andy Shevchenko
