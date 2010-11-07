Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab0KGUuP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 15:50:15 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21924 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab0KGUuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 15:50:14 -0500
Date: Sun, 7 Nov 2010 21:38:55 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Colin Cross <ccross@android.com>
cc: Alexander Shishkin <virtuoso@slind.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Dmitry Torokhov <dtor@mail.ru>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] ARM ETM driver: Do not deref potentially null pointer
 and don't allocate and free mem while holding lock.
In-Reply-To: <AANLkTinJF3uYibP9QNXNU3WavThzkZ17w30+6m2DKgjb@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1011072133210.26247@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1011071952510.26247@swampdragon.chaosbits.net> <AANLkTinJF3uYibP9QNXNU3WavThzkZ17w30+6m2DKgjb@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-484230828-1289162335=:26247"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-484230828-1289162335=:26247
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Sun, 7 Nov 2010, Colin Cross wrote:

> On Sun, Nov 7, 2010 at 11:12 AM, Jesper Juhl <jj@chaosbits.net> wrote:
> > Hello,
> >
> > Looking at etb_read() in arch/arm/kernel/etm.c I noticed two things.
> >
> >  1. We are allocting and freeing 'buf' with vmalloc() while holding a
> >    mutex locked. I cannot see any reason why we have to hold the mutex
> >    just to allocate and free a bit of memory, so I moved it outside the
> >    lock.
> >
> >  2. If the memory allocation fails we'll dereference a null pointer
> >    further down since we never check the vmalloc() return value.
> >        for (i = 0; i < length / 4; i++)
> >                buf[i] = etb_readl(t, ETBR_READMEM);
> >    The best way I could find to handle this was to simply return 0 when
> >    we can't allocate memory, but there might be a better option that I
> >    just couldn't find - in any case it is better than crashing the
> >    kernel.
> >
> > Please consider merging, but please also review carefully first since I'm
> > not familliar with this code.
> >
> > CC me on replies please.
> >
> >
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> >  etm.c |    8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> >  note: completely untested patch since I have neither hardware nor
> >  toolchain to test it, so please review carefully and test before applying
> >  it.
> >
> > diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
> > index 11db628..30f845b 100644
> > --- a/arch/arm/kernel/etm.c
> > +++ b/arch/arm/kernel/etm.c
> > @@ -274,7 +274,10 @@ static ssize_t etb_read(struct file *file, char __user *data,
> >        long length;
> >        struct tracectx *t = file->private_data;
> >        u32 first = 0;
> > -       u32 *buf;
> > +       u32 *buf = vmalloc(length);
> You can't move the vmalloc out of the lock, length is uninitialized here
> 
> > +
> > +       if (!buf)
> > +               return 0;
> ssize_t is signed so you can return -ENOMEM
> 

Ohh crap, you are of course right in both cases. Not being able to build 
stuff sucks, gcc would have caught this for me :-(

How about this instead?


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 etm.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index 11db628..41bd60d 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -293,6 +293,10 @@ static ssize_t etb_read(struct file *file, char __user *data,
 
 	length = min(total * 4, (int)len);
 	buf = vmalloc(length);
+	if (!buf) {
+		mutex_unlock(&t->mutex);
+		return -ENOMEM;
+	}
 
 	dev_dbg(t->dev, "ETB buffer length: %d\n", total);
 	dev_dbg(t->dev, "ETB status reg: %x\n", etb_readl(t, ETBR_STATUS));


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-484230828-1289162335=:26247--
