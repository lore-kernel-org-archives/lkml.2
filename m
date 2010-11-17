Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759096Ab0KQWLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 17:11:33 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:55330 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758893Ab0KQWLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 17:11:32 -0500
Date: Thu, 18 Nov 2010 00:11:26 +0200
From: Alexander Shishkin <virtuoso@slind.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Colin Cross <ccross@android.com>, Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Dmitry Torokhov <dtor@mail.ru>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Alexander Shishkin <virtuoso@slind.org>
Subject: Re: [PATCH RFC] ARM ETM driver: Do not deref potentially null
 pointer and don't allocate and free mem while holding lock.
Message-ID: <20101117221126.GD26184@shisha.kicks-ass.net>
Mail-Followup-To: Jesper Juhl <jj@chaosbits.net>,
	Colin Cross <ccross@android.com>,
	Russell King <linux@arm.linux.org.uk>,
	Jason Wessel <jason.wessel@windriver.com>,
	Dmitry Torokhov <dtor@mail.ru>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <alpine.LNX.2.00.1011071952510.26247@swampdragon.chaosbits.net>
 <AANLkTinJF3uYibP9QNXNU3WavThzkZ17w30+6m2DKgjb@mail.gmail.com>
 <alpine.LNX.2.00.1011072133210.26247@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.00.1011072133210.26247@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 07, 2010 at 09:38:55PM +0100, Jesper Juhl wrote:
> On Sun, 7 Nov 2010, Colin Cross wrote:
> 
> > On Sun, Nov 7, 2010 at 11:12 AM, Jesper Juhl <jj@chaosbits.net> wrote:
> > > Hello,
> > >
> > > Looking at etb_read() in arch/arm/kernel/etm.c I noticed two things.
> > >
> > > š1. We are allocting and freeing 'buf' with vmalloc() while holding a
> > > š šmutex locked. I cannot see any reason why we have to hold the mutex
> > > š šjust to allocate and free a bit of memory, so I moved it outside the
> > > š šlock.
> > >
> > > š2. If the memory allocation fails we'll dereference a null pointer
> > > š šfurther down since we never check the vmalloc() return value.
> > > š š š šfor (i = 0; i < length / 4; i++)
> > > š š š š š š š šbuf[i] = etb_readl(t, ETBR_READMEM);
> > > š šThe best way I could find to handle this was to simply return 0 when
> > > š šwe can't allocate memory, but there might be a better option that I
> > > š šjust couldn't find - in any case it is better than crashing the
> > > š škernel.
> > >
> > > Please consider merging, but please also review carefully first since I'm
> > > not familliar with this code.
> > >
> > > CC me on replies please.
> > >
> > >
> > > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > > ---
> > > šetm.c | š š8 +++++---
> > > š1 file changed, 5 insertions(+), 3 deletions(-)
> > >
> > > šnote: completely untested patch since I have neither hardware nor
> > > štoolchain to test it, so please review carefully and test before applying
> > > šit.
> > >
> > > diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
> > > index 11db628..30f845b 100644
> > > --- a/arch/arm/kernel/etm.c
> > > +++ b/arch/arm/kernel/etm.c
> > > @@ -274,7 +274,10 @@ static ssize_t etb_read(struct file *file, char __user *data,
> > > š š š šlong length;
> > > š š š šstruct tracectx *t = file->private_data;
> > > š š š šu32 first = 0;
> > > - š š š u32 *buf;
> > > + š š š u32 *buf = vmalloc(length);
> > You can't move the vmalloc out of the lock, length is uninitialized here
> > 
> > > +
> > > + š š š if (!buf)
> > > + š š š š š š š return 0;
> > ssize_t is signed so you can return -ENOMEM
> > 
> 
> Ohh crap, you are of course right in both cases. Not being able to build 
> stuff sucks, gcc would have caught this for me :-(
> 
> How about this instead?

This looks good. Thanks!

> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Acked-by: Alexander Shishkin <virtuoso@slind.org>

> ---
>  etm.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
> index 11db628..41bd60d 100644
> --- a/arch/arm/kernel/etm.c
> +++ b/arch/arm/kernel/etm.c
> @@ -293,6 +293,10 @@ static ssize_t etb_read(struct file *file, char __user *data,
>  
>  	length = min(total * 4, (int)len);
>  	buf = vmalloc(length);
> +	if (!buf) {
> +		mutex_unlock(&t->mutex);
> +		return -ENOMEM;
> +	}
>  
>  	dev_dbg(t->dev, "ETB buffer length: %d\n", total);
>  	dev_dbg(t->dev, "ETB status reg: %x\n", etb_readl(t, ETBR_STATUS));
> 

Regards,
--
Alex

