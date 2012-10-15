Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab2JOOfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 10:35:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40449 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab2JOOfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 10:35:52 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1210151013310.1702-100000@iolanthe.rowland.org>
References: <1350278059-14904-3-git-send-email-ming.lei@canonical.com>
	<Pine.LNX.4.44L0.1210151013310.1702-100000@iolanthe.rowland.org>
Date: Mon, 15 Oct 2012 22:35:50 +0800
Message-ID: <CACVXFVPy_yhNRnS1J7xmSErd+XkLkRHpTOLitSL+Nm=2S82whA@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] PM / Runtime: force memory allocation with no I/O
 during runtime_resume callbcack
From: Ming Lei <ming.lei@canonical.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-pm@vger.kernel.org,
        Oliver Neukum <oneukum@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 10:14 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 15 Oct 2012, Ming Lei wrote:
>
>> This patch applies the introduces tsk_memalloc_forbid_io() and
>> tsk_memalloc_allow_io() to force memory allocation with no I/O
>> during runtime_resume callback.
>>
>> Cc: Alan Stern <stern@rowland.harvard.edu>
>> Cc: Oliver Neukum <oneukum@suse.de>
>> Cc: Rafael J. Wysocki <rjw@sisk.pl>
>> Signed-off-by: Ming Lei <ming.lei@canonical.com>
>> ---
>>  drivers/base/power/runtime.c |   13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>
>> diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
>> index 3148b10..76836c1 100644
>> --- a/drivers/base/power/runtime.c
>> +++ b/drivers/base/power/runtime.c
>> @@ -652,7 +652,20 @@ static int rpm_resume(struct device *dev, int rpmflags)
>>       if (!callback && dev->driver && dev->driver->pm)
>>               callback = dev->driver->pm->runtime_resume;
>>
>> +     /*
>> +      * Deadlock might be caused if memory allocation with GFP_KERNEL
>> +      * happens inside runtime_resume callback of one block device's
>> +      * ancestor or the block device itself. The easiest approach is
>> +      * to forbid I/O inside runtime_resume of all devices.
>> +      *
>> +      * In fact, it can be done only if the deivce is a block device
>> +      * or there is one block device descendant. But that may become
>> +      * complicated and not efficient because device tree traversing
>> +      * is involved.
>> +      */
>> +     tsk_memalloc_forbid_io(current);
>>       retval = rpm_callback(callback, dev);
>> +     tsk_memalloc_allow_io(current);
>
> This is not so good.  What happens if I/O was already forbidden when
> this function was called?

You are right, the old flag should be saved before forbidding and restored
after allowing.

Thanks,
--
Ming Lei
