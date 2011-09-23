Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab1IWMMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 08:12:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:43130 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538Ab1IWML7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 08:11:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,430,1312182000"; 
   d="scan'208";a="69105788"
Subject: Re: [PATCH] fat: don't use custom hex_to_bin()
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Fri, 23 Sep 2011 15:11:21 +0300
In-Reply-To: <CAK1hOcNus4RKQOF=eivuCXFEM5Lqb+jBdOD4YrMA_5bL2EB6yA@mail.gmail.com>
References: <e23268a9c837d75a24c2d209f1623c505371eb1d.1316777507.git.andriy.shevchenko@linux.intel.com>
	 <e1a466eb82a79c91f3ec103b8308f2f81bfcbd69.1316777398.git.andriy.shevchenko@linux.intel.com>
	 <CAK1hOcNus4RKQOF=eivuCXFEM5Lqb+jBdOD4YrMA_5bL2EB6yA@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316779881.2676.44.camel@smile>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 14:05 +0200, Denys Vlasenko wrote: 
> On Fri, Sep 23, 2011 at 1:32 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> > ---
> >  fs/fat/namei_vfat.c |   22 ++++++----------------
> >  1 files changed, 6 insertions(+), 16 deletions(-)
> >
> > diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
> > index bb3f29c..09cec4c 100644
> > --- a/fs/fat/namei_vfat.c
> > +++ b/fs/fat/namei_vfat.c
> > @@ -21,6 +21,8 @@
> >  #include <linux/slab.h>
> >  #include <linux/buffer_head.h>
> >  #include <linux/namei.h>
> > +#include <linux/kernel.h>
> > +
> >  #include "fat.h"
> >
> >  /*
> > @@ -505,7 +507,6 @@ xlate_to_uni(const unsigned char *name, int len, unsigned char *outname,
> >             struct nls_table *nls)
> >  {
> >        const unsigned char *ip;
> > -       unsigned char nc;
> >        unsigned char *op;
> >        unsigned int ec;
> >        int i, k, fill;
> > @@ -530,21 +531,10 @@ xlate_to_uni(const unsigned char *name, int len, unsigned char *outname,
> >                                                return -EINVAL;
> >                                        ec = 0;
> >                                        for (k = 1; k < 5; k++) {
> > -                                               nc = ip[k];
> > -                                               ec <<= 4;
> > -                                               if (nc >= '0' && nc <= '9') {
> > -                                                       ec |= nc - '0';
> > -                                                       continue;
> > -                                               }
> > -                                               if (nc >= 'a' && nc <= 'f') {
> > -                                                       ec |= nc - ('a' - 10);
> > -                                                       continue;
> > -                                               }
> > -                                               if (nc >= 'A' && nc <= 'F') {
> > -                                                       ec |= nc - ('A' - 10);
> > -                                                       continue;
> > -                                               }
> > -                                               return -EINVAL;
> > +                                               int val = hex_to_bin(ip[k]);
> > +                                               if (val < 0)
> > +                                                       return -EINVAL;
> > +                                               ec = (ec << 4) | val;
> >                                        }
> >                                        *op++ = ec & 0xFF;
> >                                        *op++ = ec >> 8;
> 
> Function call per byte?
4 times in our case per 16 bit.

> That's expensive!
By the way, you can do those optimizations across the kernel. There are
dozens of places where one or few bytes are converted per half-byte.

> Can't we have a function which converts many sequential bytes?
We have one, but it doesn't return any error. We could wait until Mimi
integrates his patch series.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
