Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab0IUXJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 19:09:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33284 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab0IUXJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 19:09:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pQ6bXFtACGtKfQJ+S8B1iJd666ul98pY+1aUsr/yh8/p6ND0vjWOzkfKg5InkCzJCP
         xbpoVF898TBWMZT6Jjml3LzBnDGFE7ZbgjrG5jO8haHPxMzo1+4kUlyPdwBLEcwSOr6C
         NUMMnExeBYd6vJ/Cl4i4AOTwLzuaixAHDbmmI=
Subject: Re: [REGRESSION] cdrom drive doesn't detect removal
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Tejun Heo <tj@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1285069338.3124.4.camel@maxim-laptop>
References: <1284284969.2928.18.camel@maxim-laptop>
	 <1284427621.4127.7.camel@maxim-laptop> <4C8F2699.3020509@kernel.org>
	 <AANLkTinGHB9fbLw1Cm5wvPLGy8QEuoBBmFiqpnvXiZ8R@mail.gmail.com>
	 <1284507516.4963.2.camel@maxim-laptop>
	 <AANLkTimFpyYab69=XQVZc+P50v6_uVr6UbA246Fnm3-u@mail.gmail.com>
	 <1284511071.3551.1.camel@maxim-laptop>
	 <AANLkTikF37hN7dFqPbCp-gcim7SarveaTrjXipnGpJM7@mail.gmail.com>
	 <20100915132731.GA20558@khazad-dum.debian.net>
	 <AANLkTinGDUxsgaGey7EnYOu3kKP-YRE00gL33hiKvAWj@mail.gmail.com>
	 <1284589207.4672.3.camel@maxim-laptop>
	 <AANLkTin37rbEbcGDejhcsnxZNYhhUWGy+x=v4Y=s0_Qx@mail.gmail.com>
	 <1285069338.3124.4.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Sep 2010 01:09:50 +0200
Message-ID: <1285110590.2822.9.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-21 at 13:42 +0200, Maxim Levitsky wrote: 
> On Thu, 2010-09-16 at 08:51 +0200, Kay Sievers wrote: 
> > On Thu, Sep 16, 2010 at 00:20, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > > So it makes the sense.
> > > It turns out that hal is still running on ubuntu systems, and yes, it
> > > still polls the drives, and yes I disabled that feature....
> > > So restoring that polling feature indeed fixes that problem for now.
> > > Yet, why without that commit detection did work?
> > 
> > Really, I have no idea how this can happen. You could only find out
> > with blocktrace, if something else is trying to open the device. The
> > state change in the drive should not be able to get known to the host
> > unless something is causing i/o with open().
> > 
> > Kay
> 
> Due to some unexplained laziness, I didn't put a printk to cdrom_open to
> figure out if drive is polled or not without hal.
> Today I finally found why kgdb didn't work (it was conflict with nmi
> watchdog), and just for fun I have put a breakpoint to cdrom_open.
> Well udisks *does* poll the drive, every few seconds, and therefore this
> is a regression.
> I will soon look at udisk source to see how it polls the drive.
> (Maybe it uses exclusive open and hal doesn't or something like that.)

I just did a strace on udisks, and it is pretty much self explanatory.
(While CD is mounted).


open("/dev/sr0", O_RDONLY|O_EXCL|O_NONBLOCK) = -1 EBUSY (Device or resource busy)
poll([{fd=5, events=POLLIN}, {fd=3, events=POLLIN}], 2, 1997) = 0 (Timeout)
open("/dev/sr0", O_RDONLY|O_EXCL|O_NONBLOCK) = -1 EBUSY (Device or resource busy)
poll([{fd=5, events=POLLIN}, {fd=3, events=POLLIN}], 2, 1997) = 0 (Timeout)
open("/dev/sr0", O_RDONLY|O_EXCL|O_NONBLOCK) = -1 EBUSY (Device or resource busy)
poll([{fd=5, events=POLLIN}, {fd=3, events=POLLIN}], 2, 1997) = 0 (Timeout)
open("/dev/sr0", O_RDONLY|O_EXCL|O_NONBLOCK) = -1 EBUSY (Device or resource busy)

Sure, a filesystem is mounted, so exclusive access fails...

So, we end up with impossible to solve problem.
We want on one hand to guard the burner against polling programs that disturb it, but one the other hand
we must do polling to check CD status.

Unless the kernel does the polling, but then we also must stop it when burning is done.
I think that we need new ioctl in the CD driver that would give absolute access to the burning application, and lock it fully.

What to do?

Best regards,
	Maxim Levitsky


