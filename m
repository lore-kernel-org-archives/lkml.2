Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab1DLIg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 04:36:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133Ab1DLIgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 04:36:25 -0400
Date: Tue, 12 Apr 2011 14:06:13 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org, Markus Armbruster <armbru@redhat.com>
Subject: Re: [PATCH] sr: Ensure disk is revalidated when media changes
Message-ID: <20110412083613.GI26678@amit-x200.redhat.com>
References: <8d830b21c0b944d26f29dc1e0c42c0bef8d448c2.1301595169.git.amit.shah@redhat.com>
 <20110401154327.GA6593@mtj.dyndns.org>
 <20110405065129.GC2872@amit-x200.redhat.com>
 <20110406100620.GA4142@mtj.dyndns.org>
 <BANLkTinpRJHr+293kPzS1=hCWRPamOOGfw@mail.gmail.com>
 <20110408162041.GB3871@mtj.dyndns.org>
 <BANLkTimYBDvcUO9Z2wdk4VFk88NpGJiZJA@mail.gmail.com>
 <20110408165207.GD3871@mtj.dyndns.org>
 <20110412045146.GE26678@amit-x200.redhat.com>
 <BANLkTi=2344xaNM=YjY_GZbyp8yayyM2nA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=2344xaNM=YjY_GZbyp8yayyM2nA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) 12 Apr 2011 [09:16:41], Stefan Hajnoczi wrote:
> On Tue, Apr 12, 2011 at 5:51 AM, Amit Shah <amit.shah@redhat.com> wrote:
> > On (Fri) 08 Apr 2011 [09:52:07], Tejun Heo wrote:
> >> Hello,
> >>
> >> On Fri, Apr 08, 2011 at 05:43:16PM +0100, Stefan Hajnoczi wrote:
> >> > >> I think it would make sense to refresh the inode size on media change
> >> > >> so that even open file descriptors see the new size and a single
> >> > >> process cannot force a stale value for all other userspace processes
> >> > >> on the system.
> >> > >
> >> > > Hmmm... I don't know.  Maybe we can but I'm not sure whether there's a
> >> > > good reason for it.  cdrom is locked while opened after all.  Are
> >> > > there actual problems?
> >> >
> >> > Yeah, sorry I didn't explain what the use case was.  With QEMU you can
> >> > pass through the physical CD-ROM into the virtual machine.
> >> >
> >> > QEMU opens /dev/cdrom with O_NONBLOCK | O_RDONLY.  The guest can test
> >> > if the medium is present and QEMU will do ioctl(fd,
> >> > CDROM_DRIVE_STATUS, CDSL_CURRENT).  The guest can also lock the tray
> >> > and eject, again using the respective ioctls.  Read operations are
> >> > serviced by performing a read on the file descriptor in QEMU.  And
> >> > finally the medium size is queried by QEMU using lseek(fd, 0,
> >> > SEEK_END).
> >> >
> >> > Today QEMU cannot keep /dev/cdrom open across media change because it
> >> > will have an outdated inode size returned from lseek(fd, 0, SEEK_END).
> >> >  But if the cdrom driver (or sr) refresh the inode size on media
> >> > change then there is no need to work around this from userspace.
> >>
> >> Hmmm... ISTR there was some discussion about changing inode size on
> >> the fly quite a while ago.  I didn't follow the discussion but it
> >> seemed to have rather nasty/delicate implications.
> >
> > I don't necessarily agree with having to modify inode sizes on the
> > fly, but the main bug here is that the inode doesn't get invalidated
> > if a CDROM is ejected while a process has an fd to the CDROM device
> > opened.  So as in the original case, if a CD is swapped with one
> > having more data, lseek continues to report the original media's size
> > in the process that keeps the fd open across eject/insert.
> >
> > I haven't tried this on physical systems, so can't count out it being
> > a qemu bug as well.
> 
> Amit,
> This sounds exactly like the bug that I described and it happens on
> bare metal without virtualization.

Oh OK -- just wanted to get the qemu passthrough out of the equation.

Thanks.

		Amit
