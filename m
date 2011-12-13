Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab1LME42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 23:56:28 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59485 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752640Ab1LME4X convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 23:56:23 -0500
MIME-Version: 1.0
In-Reply-To: <CADDb1s2SOK5sC3N0OOdkBrPuDKc2d2A4z4yso4jYs=1rbxNmkA@mail.gmail.com>
References: <1323688722-25400-1-git-send-email-amit.sahrawat83@gmail.com>
	<1323694267.20451.5.camel@dabdike>
	<CAKYAXd-3LYJUWbAqaT4XfbNXJ_F0L1Lxu1evUxLyu=poHLMFug@mail.gmail.com>
	<CADDb1s2SOK5sC3N0OOdkBrPuDKc2d2A4z4yso4jYs=1rbxNmkA@mail.gmail.com>
Date: Tue, 13 Dec 2011 10:26:21 +0530
Message-ID: <CADDb1s0jFem00eqmm-jp0-0YCzS0bows6yvS77UuaEj=5GYdEw@mail.gmail.com>
Subject: Re: [PATCH 1/1] scsi: retrieve cache mode using ATA_16 if normal
 routine fails
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Nam-Jae Jeon <namjae.jeon@samsung.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 10:24 AM, Amit Sahrawat
<amit.sahrawat83@gmail.com> wrote:
>
> Hi James,
>
>
>
> We verified the changes by actually putting the setup through a series of test cases. There were test cases where-in we were able to reduce the filesystem corruption by 100%.
>
> Yes, In normal operation SYNC_CACHE gets called up when we do a safe removal of the device. But, Setting WCE also takes cares of sending the SYNC_CACHE command in between the operations also.
>
>
>
> What we are making sure is, that by providing this interface we can have WCE enabled for some HDD –that will mark QUEUE ORDERING to QUEUE_ORDERED_DRAIN_FLUSH(Preflush-Postflush)(i.e., flushing will occur for all the Mass Storage devices - which in turn will keep on calling SYNC_CACHE for these devices.
>
>
>
> We checked this on USB HDD’s, USB SSD, and USB Flash from a number of vendors – all seemed to work pretty well with these changes.
>
>
>
> Please share your opinion.
>
>
>
> Thanks & Regards,
>
> Amit Sahrawat
>
>
>
>
> On Tue, Dec 13, 2011 at 5:50 AM, Namjae Jeon <linkinjeon@gmail.com> wrote:
>>
>> 2011/12/12 James Bottomley <James.Bottomley@hansenpartnership.com>:
>> > On Mon, 2011-12-12 at 16:48 +0530, Amit Sahrawat wrote:
>> >> It has been observed that a number of USB HDD's do not respond correctly
>> >> to SCSI mode sense command(retrieve caching pages) which results in their
>> >> Write Cache being discarded by queue requests i.e., WCE if left set to
>> >> '0'(disabled).
>> >> This results in a number of Filesystem corruptions, when the device
>> >> is unplugged abruptly.
>> >
>> > Um, how would knowing the caching type correctly help?  If you surprise
>> > unplug the device, we can't send a flush to it anyway ...
>> Hi. James.
>> We can get device specification buffer to use ata_16 cmd.So we are
>> able to distinguish caching type by using 85byte of buffer.
>> And filesystem is using write barrier function to protect important
>> data like journaling data.
>> If filesystem is able to use write barrier by correctly setting WCE,
>> ordering can be guaranteed to flush data(preflush/postflush) to
>> internal write cache in hdd before power off. so filesystem can get
>> consistency and reliability by sudden plug and power off.
>> >
>> >> So, in order to identify the devices correctly - give it
>> >> a last try using ATA_16 after failure from normal routine.
>> >> Introduce a mechanism to store write-cache type using /sys/class/
>> >> interface, so that the normal code continues to function without errors.
>> >>
>> >> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
>> >> Signed-off-by: Nam-Jae Jeon <namjae.jeon@samsung.com>
>> >
>> > This whole patch looks like a layering violation.  Why not just update
>> > the SAT layer to translate the MODE SENSE correctly?
>> Would plz you explain more ? I didn't clearly understand your point yet.
>> >
>> > James
>> >
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > Please read the FAQ at  http://www.tux.org/lkml/
>
>
