Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759551Ab0LNQZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:25:29 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:42574 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759499Ab0LNQZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:25:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TZ5T3t/B3shyR23KaE9KYQ7FfrOS4ddt9ktgNZhHzpCIpaDTcnrfV+usH9QMrGNwtZ
         PWY7z4wB5QZcRgWPxZTi8h5Td6WnJs1o6eZL3JSXwksxLW8joSRqo378WYlNzb4fT8Dx
         juz9pOcfPp/k2QxMo7R3/dOPDdqSekOCSSewc=
Subject: Re: [PATCH] mtd: allow mtd and jffs2 when ARCH=um
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jason Lunz <lunz@acm.org>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>, David Woodhouse <dwmw2@infradead.org>,
        atom ota <atomota@sleepyhammer.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        Jeff Dike <jdike@addtoit.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org, Rob Landley <rob@landley.net>
In-Reply-To: <20101207182012.GA10546@falooley.org>
References: <22c797d00709272118i33d32b9dy93d5f5ec8f8edd30@mail.gmail.com>
	 <20071024011712.GA3762@falooley.org>
	 <1193208689.26096.48.camel@pmac.infradead.org>
	 <20071227181524.GA19051@falooley.org>
	 <20071228174853.GA4252@uranus.ravnborg.org>
	 <20101207072919.GA8511@falooley.org>
	 <AANLkTineLxHdcDKZEUGiqVNAauSX_xyQrs49kKaqhiWo@mail.gmail.com>
	 <20101207182012.GA10546@falooley.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Dec 2010 18:24:38 +0200
Message-ID: <1292343878.2538.80.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-07 at 10:20 -0800, Jason Lunz wrote:
> On Tue, Dec 07, 2010 at 10:39:41AM +0100, richard -rw- weinberger wrote:
> > On Tue, Dec 7, 2010 at 8:29 AM, Jason Lunz <lunz@acm.org> wrote:
> > >
> > > Allow parts of drivers/mtd to compile on uml by pushing the HAS_IOMEM
> > > dependencies down closer to the parts of mtd that actually need it.
> > > This allows enough of mtd to build to let jffs2 be used on uml.
> > >
> > > Signed-off-by: Jason Lunz <lunz@acm.org>
> > > ---
> > >  arch/um/Kconfig.rest        |    4 +---
> > >  drivers/mtd/Kconfig         |    1 -
> > >  drivers/mtd/Makefile        |    3 ++-
> > >  drivers/mtd/chips/Kconfig   |    4 ++++
> > >  drivers/mtd/devices/Kconfig |    8 ++++++++
> > >  drivers/mtd/maps/Kconfig    |    4 ++++
> > >  drivers/mtd/mtdchar.c       |    4 ++++
> > >  drivers/mtd/nand/Kconfig    |    3 +++
> > >  drivers/mtd/onenand/Kconfig |    3 +++
> > >  include/linux/mtd/map.h     |    2 ++
> > >  10 files changed, 31 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/arch/um/Kconfig.rest b/arch/um/Kconfig.rest
> > > index 0ccad0f..e34f399 100644
> > > --- a/arch/um/Kconfig.rest
> > > +++ b/arch/um/Kconfig.rest
> > > @@ -28,9 +28,7 @@ source "drivers/scsi/Kconfig"
> > >
> > >  source "drivers/md/Kconfig"
> > >
> > > -if BROKEN
> > > -       source "drivers/mtd/Kconfig"
> > > -endif
> > > +source "drivers/mtd/Kconfig"
> > 
> > drivers/mtd was already marked as broken when we moved over to git (2.6.12-rc2).
> > 
> > Do you exactly know why it was marked and fixes this patch all issues?
> 
> I don't know exactly why it was originally marked BROKEN. I imagine it
> was because most of the low-level mtd drivers need readb/writeb and
> friends, which don't exist on uml. But now that mtd has virtual ram- and
> blockdev-backed drivers, that's no longer sufficient reason to omit the
> whole subsystem.
> 
> I can't claim that this fixes all possible issues of course, but I've
> privately been using this patch to run block2mtd under uml for years. My
> original motivation was to allow the use of jffs2 in a uml-based test
> environment and for that it's worked very well.

But I think your solution is a bit dirty, because it adds a great deal
of little 'if HAS_IOMEM' and '#ifdef CONFIG_HAS_IOMEM' to many places.
This is error-prone.

Instead, you should solve this problem in UML code. I do not know how,
but may be you can add readb/writeb there which actually do nothing or
print a scary warning, or do BUG(), and let things which use them just
fail run-time.

Anyway, please, think about a solution which needs few changes in UML
code instead of myriads of small little changes in many places.

Thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

