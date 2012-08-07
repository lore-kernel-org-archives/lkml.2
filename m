Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab2HGO2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 10:28:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60242 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab2HGO2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 10:28:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
Date: Tue, 7 Aug 2012 14:28:15 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Russell King <rmk@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>, sameo@linux.intel.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org
References: <20120806213124.GB14594@flint.arm.linux.org.uk> <20120807121157.GA10166@flint.arm.linux.org.uk> <20120807132510.GE16861@opensource.wolfsonmicro.com>
In-Reply-To: <20120807132510.GE16861@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208071428.15739.arnd@arndb.de>
X-Provags-ID: V02:K0:uQM/U5q3HefnUjLUW888CQ1A4yb+814trr5INXE++8X
 kVpBuYL0Xj6uWiq7DOmGoRLy8dFZnt2oijCRm7HhbqvhO6aEwc
 1HxrEm+yvpiBzRFFqdG/a43SMlM/Uq1UMTkXJKYufdMYPtZlXw
 bu+dcuWhVKeT5hjms+to+LzhJiqIudaLoCmvFwkgbMeSXuoGeM
 vqzR6mJXjPFv4om3ycd+ek7GTbcia555egKaEKFiCYI6uPHAk1
 fRIo42p26fWepKdW+xlieic0ZR1RJXxT4B5QijJHXYplobUaXZ
 5ZHFwwzYJMmn8nYutkQfBGduDDa3LBfd/VTjY40qAgHVPAtR8V
 HnQsNLUITsG0LWRk2ppM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 August 2012, Mark Brown wrote:
> On Tue, Aug 07, 2012 at 01:11:57PM +0100, Russell King wrote:
> 
> > The only open questions on this are:
> > 1. Is there another driver you are concerned about.
> 
> As I said elsewhere 88pm* needs this as a stable bugfix and wm831x
> should be converted over too.

I've looked through the remaining MFD drivers and found one more,
max8925-core, which is using IORESOURCE_IO for something that is
not ISA/PCI IO-space.

> > 2. Choosing a better name.
> 
> I'm not sure we need one, _REG seems perfectly fine here unless we want
> to go with Arnd's suggestion of _OTHER.  Do you have any concerns with
> the use of reg?

BenH actually suggested _OTHER. I think either one is fine.

> > But I won't put question marks at the end of those because you never seem
> > to answer questions.  You will just produce yet more justifications why
> > this approach is not one you're willing to accept.  So I really don't know
> > why I wasted my time to produce this patch.
> 
> As I mentioned in my mail a few moments ago I had not replied to your
> mails asking these question about which drivers are affected because
> those mails have been arriving so quickly since the first one I saw with
> the question in that there has not been a chance to do so.
> 
> > index 589e0e7..bfee885 100644
> > --- a/include/linux/ioport.h
> > +++ b/include/linux/ioport.h
> > @@ -31,6 +31,7 @@ struct resource {
> >  #define IORESOURCE_TYPE_BITS 0x00001f00      /* Resource type */
> >  #define IORESOURCE_IO                0x00000100
> >  #define IORESOURCE_MEM               0x00000200
> > +#define IORESOURCE_REG               0x00000300      /* Register offsets */
> >  #define IORESOURCE_IRQ               0x00000400
> >  #define IORESOURCE_DMA               0x00000800
> >  #define IORESOURCE_BUS               0x00001000
> 
> As I've said before I'm fine with the driver changes.  I do feel that it
> would be better to also renumber all the existing resource types while
> we're at it in order to make it clear that these are just plain numbers,
> that's the reason nobody wrote this patch previously.  This will avoid
> any future confusion.

This gets into a lot more tricky territory: We have a bunch of drivers
doing their own bitmask operations on these, like drivers/video/offb.c
testing

        if ((flags & (IORESOURCE_IO | IORESOURCE_MEM)) == 0)
                return NULL;

or drivers/scsi/gdth.c doing

            if (!(base0 & IORESOURCE_MEM) ||
                !(base2 & IORESOURCE_MEM) ||
                !(base1 & IORESOURCE_IO)) 
                return -ENODEV;

Now I've looked at the three drivers with the immediate problem of
IORESOURCE_IO abuse (max8925, wm831x, 88pm860x) and none of them are
doing such bitmask operations, so I'm reasonably sure we are fine
for those drivers. I also agree that renumbering the resources in a
way that makes it impossible to use bitmasks is a good idea, but
that would actually be pretty invasive because then we have to rewrite
all the functions that currently do it.

	Arnd
