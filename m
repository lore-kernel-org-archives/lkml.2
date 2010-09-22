Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab0IVOIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 10:08:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43623 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab0IVOIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 10:08:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=On636Apv04jz61/IpV3O5rmSwW/8EScQfws7cTHvHJu05c0wPz6A22i5gVa1hlrO+R
         KnKEbFguoxd15K/Xv/iAdBbc27TndZCNWlGryADyGcNrXecAkx6b86woy1dJ5t5xhtkC
         zCavP4UUzjfAko5K0s3Q8eNhhogztSeUyZ4Gk=
Subject: Re: [REGRESSION] cdrom drive doesn't detect removal
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1285162900.3335.15.camel@maxim-laptop>
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
	 <1285110590.2822.9.camel@maxim-laptop>  <4C99B25D.20805@kernel.org>
	 <1285162900.3335.15.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Sep 2010 15:58:31 +0200
Message-ID: <1285163911.3159.5.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-22 at 15:41 +0200, Maxim Levitsky wrote: 
> On Wed, 2010-09-22 at 09:38 +0200, Tejun Heo wrote: 
> > Hello,
> > 
> > On 09/22/2010 01:09 AM, Maxim Levitsky wrote:
> > > I just did a strace on udisks, and it is pretty much self explanatory.
> > > (While CD is mounted).
> > > 
> > > open("/dev/sr0", O_RDONLY|O_EXCL|O_NONBLOCK) = -1 EBUSY (Device or resource busy)
> > > poll([{fd=5, events=POLLIN}, {fd=3, events=POLLIN}], 2, 1997) = 0 (Timeout)
> > > open("/dev/sr0", O_RDONLY|O_EXCL|O_NONBLOCK) = -1 EBUSY (Device or resource busy)
> > > poll([{fd=5, events=POLLIN}, {fd=3, events=POLLIN}], 2, 1997) = 0 (Timeout)
> > > open("/dev/sr0", O_RDONLY|O_EXCL|O_NONBLOCK) = -1 EBUSY (Device or resource busy)
> > > poll([{fd=5, events=POLLIN}, {fd=3, events=POLLIN}], 2, 1997) = 0 (Timeout)
> > > open("/dev/sr0", O_RDONLY|O_EXCL|O_NONBLOCK) = -1 EBUSY (Device or resource busy)
> > > 
> > > Sure, a filesystem is mounted, so exclusive access fails...
> > > 
> > > So, we end up with impossible to solve problem.  We want on one hand
> > > to guard the burner against polling programs that disturb it, but
> > > one the other hand we must do polling to check CD status.
> > >
> > > Unless the kernel does the polling, but then we also must stop it
> > > when burning is done.  I think that we need new ioctl in the CD
> > > driver that would give absolute access to the burning application,
> > > and lock it fully.
> > 
> > One thing I don't get is why the behavior changed after the claiming
> > block patch.  Can you please trace udisks from a previous working
> > kernel?
> 
> It shows pretty much same output.
> The difference here is, even though open fails, it still has a side
> effect of polling the driver, a bug that bisected commit fixed.
> 
> So problem is clear, but how to fix it, I don't know...
> 
> Also about the exclusive mode, how exactly is it defined?
> open manpage is somewhat sparse about it.
> 
> Regardless of the above a complete solution is:
> 
> 1. Make exclusive opens really exclusive.
> That is if someone opens a device with exclusive access, no more opens
> will succeed.
And as a follow-up, indeed hal first tries exclusive open, and if it
fails, it retries with non-exclusive open, and it succeeds.
And that somewhat makes me think that exclusive open is pretty much
useless.
Look if it fails. sure the device is open, but if doesn't fail, nothing
prevents a bit less honest clients (that don't use exclusive open) to
open the device. How exclusive such an open is then?

So I mean exclusive open should really block _all_ following opens of
the device, exclusive or not.
Btw I had few failed dual layer disk burns that failed just after write
of few MBs. I wouldn't be surprised if this was the cause.


> 
> 2. Add in-kernel polling, and stop it as as soon as an exclusive open is
> done.
> 
> 3. Make sure that userspace doesn't touch the cdrom device anymore.
> Few patches to udisks and hal will do.
> 

Best regards,
	Maxim Levitsky


