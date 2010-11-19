Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab0KSXEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 18:04:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757006Ab0KSXEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 18:04:32 -0500
Date: Fri, 19 Nov 2010 15:04:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: michalj@gmail.com
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>, linux-kernel@vger.kernel.org,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>
Subject: Re: abs() vs. abs64() (was: Re: [PATCH] fbdev: fix nearest mode
 search)
Message-Id: <20101119150411.81092e94.akpm@linux-foundation.org>
In-Reply-To: <20101119222823.GA28797@quadria>
References: <AANLkTimYDAJr9x00sjGGnDF2vOVXU12qmbnmfuzA5_0h@mail.gmail.com>
	<20101119140721.33576c61.akpm@linux-foundation.org>
	<20101119222823.GA28797@quadria>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Nov 2010 23:28:23 +0100
Michal Januszewski <michalj@gmail.com> wrote:

> On Fri, Nov 19, 2010 at 02:07:21PM -0800, Andrew Morton wrote:
> > On Thu, 18 Nov 2010 07:40:19 +0100
> > Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> 
> > > > 'c' will end up with a value of 0xffffffff instead of the expected 0x1.
> > > 
> > > This happens on 64-bit only, right?
> 
> Absolutely, I should have mentioned it in the patch description.
> 
> > How does this look?
> >
> > [..]
> > 
> > Reported-by: Michal Januszewski <michalj@gmail.com>
> > Cc: Rolf Eike Beer <eike-kernel@sf-tec.de
> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  include/linux/kernel.h |   13 ++++++++++---
> >  1 file changed, 10 insertions(+), 3 deletions(-)
> > 
> > diff -puN include/linux/kernel.h~include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit include/linux/kernel.h
> > --- a/include/linux/kernel.h~include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit
> > +++ a/include/linux/kernel.h
> > @@ -143,9 +143,16 @@ extern int _cond_resched(void);
> >  
> >  #define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
> >  
> > -#define abs(x) ({				\
> > -		long __x = (x);			\
> > -		(__x < 0) ? -__x : __x;		\
> > +#define abs(x) ({						\
> > +		long ret;					\
> > +		if (sizeof(x) == sizeof(long)) {		\
> > +			long __x = (x);				\
> > +			ret = (__x < 0) ? -__x : __x;		\
> > +		} else {					\
> > +			int __x = (x);				\
> > +			ret = (__x < 0) ? -__x : __x;		\
> > +		}						\
> > +		ret;						\
> >  	})
> >  
> >  #define abs64(x) ({				\
> > _
> 
> Looks good to me.  I posted essentially the same thing some 3 months ago
> (http://marc.info/?l=linux-kernel&m=128033094822201&w=2) but it then
> failed to get any traction.  At any rate, I like your version better as
> it seems more readable.
> 

I spose we should document it.   Does this look complete and accurate?

--- a/include/linux/kernel.h~include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix
+++ a/include/linux/kernel.h
@@ -143,6 +143,13 @@ extern int _cond_resched(void);
 
 #define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
 
+/*
+ * abs() handles unsigned and signed longs, ints, shorts and chars.  For long
+ * types it returns a signed long.  For int, short and char types it returns a
+ * signed int.
+ * abs() should not be used for 64-bit types (s64, u64, long long) - use abs64()
+ * for those.
+ */
 #define abs(x) ({						\
 		long ret;					\
 		if (sizeof(x) == sizeof(long)) {		\
_

