Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab1DHQnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 12:43:21 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56476 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab1DHQnT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 12:43:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HqOFoVySqzcM0TXZ8ULBf8/cMYKHArs1Hmj920uM3mmMDfex7QiP4Cma1plVoJcn2r
         HZRyOlP8bpCUI2hf/255LrkDlpmW/peMO4MqDT63e4qjZ00CUJ5gZeXE452iV86KZtkf
         fK7J7Eje1uXhVyHOSbUmqKUJap3fNTH39EKKI=
MIME-Version: 1.0
In-Reply-To: <20110408162041.GB3871@mtj.dyndns.org>
References: <8d830b21c0b944d26f29dc1e0c42c0bef8d448c2.1301595169.git.amit.shah@redhat.com>
	<20110401154327.GA6593@mtj.dyndns.org>
	<20110405065129.GC2872@amit-x200.redhat.com>
	<20110406100620.GA4142@mtj.dyndns.org>
	<BANLkTinpRJHr+293kPzS1=hCWRPamOOGfw@mail.gmail.com>
	<20110408162041.GB3871@mtj.dyndns.org>
Date: Fri, 8 Apr 2011 17:43:16 +0100
Message-ID: <BANLkTimYBDvcUO9Z2wdk4VFk88NpGJiZJA@mail.gmail.com>
Subject: Re: [PATCH] sr: Ensure disk is revalidated when media changes
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Amit Shah <amit.shah@redhat.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org, Markus Armbruster <armbru@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 8, 2011 at 5:20 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Fri, Apr 08, 2011 at 12:37:56PM +0100, Stefan Hajnoczi wrote:
>> There is a related issue I have been discussing with Amit:
>> https://lkml.org/lkml/2011/3/23/156
>>
>> On media change the inode size is not updated by the sr driver or the
>> universal cdrom driver.  A userspace process that holds a /dev/sr0
>> file descriptor open across media change causes all processes on the
>> system to see the old medium size when they do lseek(fd, 0, SEEK_END).
>>
>> I think it would make sense to refresh the inode size on media change
>> so that even open file descriptors see the new size and a single
>> process cannot force a stale value for all other userspace processes
>> on the system.
>
> Hmmm... I don't know.  Maybe we can but I'm not sure whether there's a
> good reason for it.  cdrom is locked while opened after all.  Are
> there actual problems?

Yeah, sorry I didn't explain what the use case was.  With QEMU you can
pass through the physical CD-ROM into the virtual machine.

QEMU opens /dev/cdrom with O_NONBLOCK | O_RDONLY.  The guest can test
if the medium is present and QEMU will do ioctl(fd,
CDROM_DRIVE_STATUS, CDSL_CURRENT).  The guest can also lock the tray
and eject, again using the respective ioctls.  Read operations are
serviced by performing a read on the file descriptor in QEMU.  And
finally the medium size is queried by QEMU using lseek(fd, 0,
SEEK_END).

Today QEMU cannot keep /dev/cdrom open across media change because it
will have an outdated inode size returned from lseek(fd, 0, SEEK_END).
 But if the cdrom driver (or sr) refresh the inode size on media
change then there is no need to work around this from userspace.

Stefan
