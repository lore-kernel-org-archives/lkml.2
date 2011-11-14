Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab1KNXN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 18:13:26 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41600 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529Ab1KNXNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 18:13:23 -0500
Message-ID: <4EC1A0BE.3000901@solonet.org.ua>
Date: Tue, 15 Nov 2011 01:14:06 +0200
From: Denis Kuzmenko <linux@solonet.org.ua>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Stephen Warren <swarren@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio/gpio-sysfs: Try to export busy GPIO line leads to
 wrong GPIO line exporting
References: <4EBF1DD1.8090600@solonet.org.ua> <74CDBE0F657A3D45AFBB94109FB122FF1740805B5B@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1740805B5B@HQMAIL01.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2011 10:45 PM, Stephen Warren wrote:
> Denis Kuzmenko wrote at Saturday, November 12, 2011 6:31 PM:
>>
>> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
>> index a971e3d..ccec497 100644
>> --- a/drivers/gpio/gpiolib.c
>> +++ b/drivers/gpio/gpiolib.c
>> @@ -633,7 +633,7 @@ static ssize_t export_store(struct class *class,
>>  done:
>>  	if (status)
>>  		pr_debug("%s: status %d\n", __func__, status);
>> -	return status ? : len;
>> +	return len;
>>  }
> 
> I assume that when the error occurs, status is negative. Is it some
> special value like EINTR, EAGAIN? I'm surprised that the retried write
> is smaller than the whole original buffer.
> 
> What's actually retrying the failed write? Is it user-space in response
> to the previous failed write, in a (mistaken?) attempt to handle shorter-
> than-expected-writes? You could confirm this with strace.
> 
> If the patch above really is correct, there are other places it'd be
> needed; it looks like e.g. drivers/video/backlight/backlight.c would
> have the same issue if you gave too-large integers to its sysfs files.
> 

Hi,

Looks like userspace doesn't retries write. Here is trace:

open("/sys/class/gpio/export", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 3
ioctl(3, SNDCTL_TMR_TIMEBASE or TCGETS, 0xbef76c64) = -1 ENOTTY (Inappropriate ioctl for device)
brk(0x30e000)                           = 0x30e000
write(3, "37\n", 3)                     = -1 EBUSY (Device or resource busy)
close(3)                                = 0
exit(0)                                 = ?

this was made by simple self-written program:
	fopen("/sys/class/gpio/export", "w"); fprintf(fp, "37\n");


additional kernel-trace (WARN_ON(0 > status)) was also added before function return:

WARNING: at drivers/gpio/gpiolib.c:637 export_store+0xa0/0xb4()
Modules linked in:
[<c0028064>] (unwind_backtrace+0x0/0xf0) from [<c0039234>] (warn_slowpath_common+0x48/0x60)
[<c0039234>] (warn_slowpath_common+0x48/0x60) from [<c0039268>] (warn_slowpath_null+0x1c/0x24)
[<c0039268>] (warn_slowpath_null+0x1c/0x24) from [<c0182da8>] (export_store+0xa0/0xb4)
[<c0182da8>] (export_store+0xa0/0xb4) from [<c01b17e0>] (class_attr_store+0x1c/0x28)
[<c01b17e0>] (class_attr_store+0x1c/0x28) from [<c00db9ac>] (sysfs_write_file+0xfc/0x180)
[<c00db9ac>] (sysfs_write_file+0xfc/0x180) from [<c0093304>] (vfs_write+0xac/0x13c)
[<c0093304>] (vfs_write+0xac/0x13c) from [<c0093578>] (sys_write+0x40/0x6c)
[<c0093578>] (sys_write+0x40/0x6c) from [<c0023ffc>] (__sys_trace_return+0x0/0x24)
---[ end trace 8141a98436c712ec ]---

I'll try digg into functions in backtrace and find retry if any.

Best regards, Denis Kuzmenko.
