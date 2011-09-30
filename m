Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab1I3RxV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 13:53:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60815 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab1I3RxT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 13:53:19 -0400
MIME-Version: 1.0
In-Reply-To: <1317385117.2993.7.camel@dabdike.hansenpartnership.com>
References: <CADDb1s2Qhy1dNmjk+DhU=rf46A4X6kPdQ2rdpwK9zinY4Yv1mw@mail.gmail.com>
	<CADDb1s3KjMugBGwLmjoPv93hJVBCjkD81o8F0CZxJXXt+-Fk2A@mail.gmail.com>
	<1317245383.22022.23.camel@dabdike.hansenpartnership.com>
	<CADDb1s0naC9bKYDuvxMK1R+ey9KB+Sh8e-9KNJXH-EuTNueueQ@mail.gmail.com>
	<1317320825.3190.70.camel@dabdike.hansenpartnership.com>
	<1317321077.3190.71.camel@dabdike.hansenpartnership.com>
	<CADDb1s3CSvmqNGA48sHyOJ-pGpB1ix3WEVd0KV4b+s5yE3abLw@mail.gmail.com>
	<1317385117.2993.7.camel@dabdike.hansenpartnership.com>
Date: Fri, 30 Sep 2011 23:23:17 +0530
Message-ID: <CADDb1s0_6fTa-e6WubVGfcyn2fe3ohss=FvMh9r6q76uUOsXMw@mail.gmail.com>
Subject: =?windows-1252?Q?Re=3A_BUG_in_kernel=3A_Wrong_Handling_of_USB_HDD=92s_in_?=
	=?windows-1252?Q?scsiglue=28slave=5Fconfigure=29_and_scsi=2Fsd=28sd=5Fread=5Fcache=5Ftype=29?=
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 5:48 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Fri, 2011-09-30 at 12:26 +0530, Amit Sahrawat wrote:
>> Now, for the USB HDD which do have write cache - sginfo is showing
>> them to Write Cache Enabled as false.
>> Why do the result of hdparm identification and sginfo varies- (I know
>> they have different interface to work with and hdparm takes care of
>> that by using SG_IO interface from it's code)? hdparm showed me
>> correct results - that lead me to digging in the kernel code and
>> checking the performance for USB HDD with Write cache enabled/disabled
>> - which also showed that QUEUE ordering chosen for USB HDD is not
>> correct.
>
> Well, what all this means is the SATL in the USB device is implemented
> wrongly.  Since USB devices only preset SCSI interfaces, that's what we
> have to believe.
>
> hdparm when used correctly sends an ATA inquiry command wrapped in an
> ATA_12 or ATA_16 SCSI command.  A large number of legacy SATLs are known
> to crash on these commands.
>
> Are you sure the ATA command is reporting correctly?  A write back cache
> is a remarkably silly thing to enable for a USB device because they're
> highly likely to be surprise ejected which powers the device down.
>
In addition to the problem reported - there is one more thing I have
noticed with USB HDD - they should be shown as 'removable' but the
removable is marked only for USB PEN Drives. This seems to be a bit of
confusing, any mass storage media connected on USB port should be
recognized as removable.
So, for handling the issue, I would consider adding the handling in
slave_configure()(usb/storage/scsiglue) which marks the HDD/pen drives
as removable also signifying them to be USB based.
Then, as part of sd_revalidation – how about adding the ATA_IDENTIFY
command part if the device is USB HDD? As far as the result of
ATA_IDENTIFY is concerned – they return proper ‘256’ bytes - response
and the Words – 82, 85 used for feature supported and enabled/disabled
returns proper values for the USB HDD’s I have seen. In case of USB
pen drives – they return failure – I did not see any crash – maybe I
don’t have one of the legacy SATL based disk.
Since, I am new to this – I will check more on this to get a viable
solution. Please add your opinion. Can you share the name of the
device which causes crash with these ATA commands, If I am able to get
one I can try on that also.

>> I have a large number of USB HDD's - with different vendors, and for
>> all of them - it is showing Write Cache Enabled as false.
>> The code works only for the Pen Drives or the USB HDD which do not
>> have internal cache.
>>
>> Also, for journalling filesystem being used on USB HDD - it does
>> becomes a cause of concern.
>>
>> Please share your opinion, I guess we need a change for mode sensing
>> in the kernel code for USB HDD.
>
> Well that's a nastily complex problem.  It really needs to be
> whitelisted in the USB stack, but if every drive is doing it, that's
> quite a task.
>
> The question becomes how do we detect in a SCSI fashion that the device
> has a write back cache if none of the standard SCSI mechanisms reports
> it?
As far as detecting in SCSI fashion – I wonder using that I would have
never reached the conclusion that it is the Write Cache of USB HDD
which is causing problem instead I would have been focusing on
particular file system (XFS in my case –which in itself is complex) –
there BARRIER support and also the Queue handling in the elevator with
I/O scheduler.
None of the sg utils is showing anything related with the Write Cache
in USB HDD – which provide any hint that the Cache is enabled – this
is a bit surprising because most of the high end USB mass storages
device in the market have Write Cache in them.

Thanks & Regards,
Amit Sahrawat
>
> James
>
>
>
