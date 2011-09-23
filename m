Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab1IWMFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 08:05:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61851 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab1IWMFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 08:05:34 -0400
MIME-Version: 1.0
In-Reply-To: <e1a466eb82a79c91f3ec103b8308f2f81bfcbd69.1316777398.git.andriy.shevchenko@linux.intel.com>
References: <e23268a9c837d75a24c2d209f1623c505371eb1d.1316777507.git.andriy.shevchenko@linux.intel.com>
 <e1a466eb82a79c91f3ec103b8308f2f81bfcbd69.1316777398.git.andriy.shevchenko@linux.intel.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Fri, 23 Sep 2011 14:05:13 +0200
Message-ID: <CAK1hOcNus4RKQOF=eivuCXFEM5Lqb+jBdOD4YrMA_5bL2EB6yA@mail.gmail.com>
Subject: Re: [PATCH] fat: don't use custom hex_to_bin()
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p8NC5imV004187

On Fri, Sep 23, 2011 at 1:32 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> ---
>  fs/fat/namei_vfat.c |   22 ++++++----------------
>  1 files changed, 6 insertions(+), 16 deletions(-)
>
> diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
> index bb3f29c..09cec4c 100644
> --- a/fs/fat/namei_vfat.c
> +++ b/fs/fat/namei_vfat.c
> @@ -21,6 +21,8 @@
>  #include <linux/slab.h>
>  #include <linux/buffer_head.h>
>  #include <linux/namei.h>
> +#include <linux/kernel.h>
> +
>  #include "fat.h"
>
>  /*
> @@ -505,7 +507,6 @@ xlate_to_uni(const unsigned char *name, int len, unsigned char *outname,
>             struct nls_table *nls)
>  {
>        const unsigned char *ip;
> -       unsigned char nc;
>        unsigned char *op;
>        unsigned int ec;
>        int i, k, fill;
> @@ -530,21 +531,10 @@ xlate_to_uni(const unsigned char *name, int len, unsigned char *outname,
>                                                return -EINVAL;
>                                        ec = 0;
>                                        for (k = 1; k < 5; k++) {
> -                                               nc = ip[k];
> -                                               ec <<= 4;
> -                                               if (nc >= '0' && nc <= '9') {
> -                                                       ec |= nc - '0';
> -                                                       continue;
> -                                               }
> -                                               if (nc >= 'a' && nc <= 'f') {
> -                                                       ec |= nc - ('a' - 10);
> -                                                       continue;
> -                                               }
> -                                               if (nc >= 'A' && nc <= 'F') {
> -                                                       ec |= nc - ('A' - 10);
> -                                                       continue;
> -                                               }
> -                                               return -EINVAL;
> +                                               int val = hex_to_bin(ip[k]);
> +                                               if (val < 0)
> +                                                       return -EINVAL;
> +                                               ec = (ec << 4) | val;
>                                        }
>                                        *op++ = ec & 0xFF;
>                                        *op++ = ec >> 8;

Function call per byte? That's expensive!
Can't we have a function which converts many sequential bytes?

-- 
vda
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
