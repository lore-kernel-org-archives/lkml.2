Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab1DLIQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 04:16:45 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:38284 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab1DLIQm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 04:16:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UqeGBETP0GQLvfS4tmreXkBcZ+KgdeSUwv/u5pKmoBpgC0SjnXGrXqCvNL+xcKTF3F
         B0WXvYzHRMR4rv/75sKvnaKc2o8fVXH5iuk1+vHECNDdL3hO7MlYH0qgBpbvt3KXTkex
         ZSJ6UrmDeXpeusaHI0U/npNe/YvrjIK0uPErA=
MIME-Version: 1.0
In-Reply-To: <20110412045146.GE26678@amit-x200.redhat.com>
References: <8d830b21c0b944d26f29dc1e0c42c0bef8d448c2.1301595169.git.amit.shah@redhat.com>
	<20110401154327.GA6593@mtj.dyndns.org>
	<20110405065129.GC2872@amit-x200.redhat.com>
	<20110406100620.GA4142@mtj.dyndns.org>
	<BANLkTinpRJHr+293kPzS1=hCWRPamOOGfw@mail.gmail.com>
	<20110408162041.GB3871@mtj.dyndns.org>
	<BANLkTimYBDvcUO9Z2wdk4VFk88NpGJiZJA@mail.gmail.com>
	<20110408165207.GD3871@mtj.dyndns.org>
	<20110412045146.GE26678@amit-x200.redhat.com>
Date: Tue, 12 Apr 2011 09:16:41 +0100
Message-ID: <BANLkTi=2344xaNM=YjY_GZbyp8yayyM2nA@mail.gmail.com>
Subject: Re: [PATCH] sr: Ensure disk is revalidated when media changes
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org, Markus Armbruster <armbru@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 5:51 AM, Amit Shah <amit.shah@redhat.com> wrote:
> On (Fri) 08 Apr 2011 [09:52:07], Tejun Heo wrote:
>> Hello,
>>
>> On Fri, Apr 08, 2011 at 05:43:16PM +0100, Stefan Hajnoczi wrote:
>> > >> I think it would make sense to refresh the inode size on media change
>> > >> so that even open file descriptors see the new size and a single
>> > >> process cannot force a stale value for all other userspace processes
>> > >> on the system.
>> > >
>> > > Hmmm... I don't know.  Maybe we can but I'm not sure whether there's a
>> > > good reason for it.  cdrom is locked while opened after all.  Are
>> > > there actual problems?
>> >
>> > Yeah, sorry I didn't explain what the use case was.  With QEMU you can
>> > pass through the physical CD-ROM into the virtual machine.
>> >
>> > QEMU opens /dev/cdrom with O_NONBLOCK | O_RDONLY.  The guest can test
>> > if the medium is present and QEMU will do ioctl(fd,
>> > CDROM_DRIVE_STATUS, CDSL_CURRENT).  The guest can also lock the tray
>> > and eject, again using the respective ioctls.  Read operations are
>> > serviced by performing a read on the file descriptor in QEMU.  And
>> > finally the medium size is queried by QEMU using lseek(fd, 0,
>> > SEEK_END).
>> >
>> > Today QEMU cannot keep /dev/cdrom open across media change because it
>> > will have an outdated inode size returned from lseek(fd, 0, SEEK_END).
>> >  But if the cdrom driver (or sr) refresh the inode size on media
>> > change then there is no need to work around this from userspace.
>>
>> Hmmm... ISTR there was some discussion about changing inode size on
>> the fly quite a while ago.  I didn't follow the discussion but it
>> seemed to have rather nasty/delicate implications.
>
> I don't necessarily agree with having to modify inode sizes on the
> fly, but the main bug here is that the inode doesn't get invalidated
> if a CDROM is ejected while a process has an fd to the CDROM device
> opened.  So as in the original case, if a CD is swapped with one
> having more data, lseek continues to report the original media's size
> in the process that keeps the fd open across eject/insert.
>
> I haven't tried this on physical systems, so can't count out it being
> a qemu bug as well.

Amit,
This sounds exactly like the bug that I described and it happens on
bare metal without virtualization.

Stefan
