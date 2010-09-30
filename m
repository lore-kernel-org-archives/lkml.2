Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab0I3ORl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 10:17:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38755 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab0I3ORk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 10:17:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NGYeyDqxffMr48W9LOIjbNU18FpDzTgHSbJBVMsu54w/bic5pl1s18ZZ0zotBvEqLy
         YC4uRg9D1QkFBP82twVSqLtMYX0AekRbJX6bAUokHVswpnrp5cLcuU5fH5jTAKg0rgYK
         JE0e/HZXR0IZy0b9M4gonRntpq65iPvW0c5Lk=
Subject: Re: [REGRESSION] cdrom drive doesn't detect removal
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Florian Mickler <florian@mickler.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Tejun Heo <tj@kernel.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20100930133823.39353d23@schatten.dmk.lab>
References: <1284284969.2928.18.camel@maxim-laptop>
	 <4C8F2699.3020509@kernel.org>
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
	 <1285110590.2822.9.camel@maxim-laptop> <4C99B25D.20805@kernel.org>
	 <1285162900.3335.15.camel@maxim-laptop>
	 <1285163911.3159.5.camel@maxim-laptop> <4C9B141F.3050908@kernel.org>
	 <AANLkTim31g84J6eeuh_6MiEw0w8zOi5sOWrL_WnoaueP@mail.gmail.com>
	 <20100930083020.62b56218@schatten.dmk.lab>
	 <AANLkTi=G42-0X0MWsgTaDKEnHocFEa+9Cmw4pfCMAk5=@mail.gmail.com>
	 <20100930133823.39353d23@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 16:17:32 +0200
Message-ID: <1285856252.26846.12.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-30 at 13:38 +0200, Florian Mickler wrote:
> On Thu, 30 Sep 2010 09:48:50 +0200
> Kay Sievers <kay.sievers@vrfy.org> wrote:
> > >
> > > So, is the $subject problem solved now? Normally, we shouldn't break
> > > stuff with new kernels... If this is only a temporary breakage on
> > > the other hand, we should keep track of it...
> > > I ask, because this is listed as https://bugzilla.kernel.org/show_bug.cgi?id=18522.
> > > If it should stay listed, we may need an ETA for the fix...
> > 
> > Hmm, I still don't think that's a bug or regression.
> > 
> > Optical drives are not supposed to report media changes without
> > constantly being polled. Why Tejun's seems to have an influence in
> > Maxim's setup, is likely more a timing-related issue, or some other
> > thing, we never really got an idea why it could change anything.
> > 
> > The current behavior is the expected and correct behavior, and for me
> > also the older kernels behave like this.
> > 
> > Kay
> 
> So I'm gonna close this as invalid then. Please shout, if that's
> not ok.
Its not invalid at all.

Let me explain again the problem:

Indeed cdrom drivers need to be polled.
And yes, both udisks and hal _do_ poll the drive.

However, udisks uses O_EXCL, when it opens the drive, and that fails s
soon as filesystem is mounted, therefore effectively, as soon as disk is
inserted, polling stops.

Without the bisected commit, O_EXCL would still fail, however due to the
bug that commit fixed, the drive will still be polled.

Hal also polls the drive, but it has a workaround, that is if open with
O_EXCL fails, it retries the open without it.

This is pretty much all, there are no unknowns left.


However the reason behind O_EXCL is that we don't want polling while a
disk is being written (burned), but we do want polling while disk is
mounted.

So just 'fixing' udisk to not take O_EXCL will bring us to square one,
as well as reverting the commit.

Therefore this problem doesn't have a simple solution.
I think that the best solution is to move polling to the kernel, and
introduce a way for burning application to take absolute exclusive
access to the device and as a part of that disable that in-kernel
polling.
A new ioctl will suffice, or the meaning of O_EXCL can be changed for
cdrom driver only (if somebody has it open with O_EXCL, fail all opens,
including the ones that don't have O_EXCL).


Best regards,
	Maxim Levitsky

