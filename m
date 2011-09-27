Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab1I0RUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 13:20:04 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:38752 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1I0RUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 13:20:03 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCHv2] fat: don't use custom hex_to_bin()
References: <CAK1hOcNus4RKQOF=eivuCXFEM5Lqb+jBdOD4YrMA_5bL2EB6yA@mail.gmail.com>
	<542eeafb16d173360eb79f8188f967cc3dcc9252.1317124046.git.andriy.shevchenko@linux.intel.com>
Date: Wed, 28 Sep 2011 02:19:59 +0900
In-Reply-To: <542eeafb16d173360eb79f8188f967cc3dcc9252.1317124046.git.andriy.shevchenko@linux.intel.com>
	(Andy Shevchenko's message of "Tue, 27 Sep 2011 14:48:46 +0300")
Message-ID: <87hb3xj41s.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Shevchenko <andriy.shevchenko@linux.intel.com> writes:

Looks good to me.

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Or if it's needed, I'll apply this to fat tree.

> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> ---
>  fs/fat/namei_vfat.c |   30 ++++++++----------------------
>  1 files changed, 8 insertions(+), 22 deletions(-)
>
> diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
> index bb3f29c..cf0fd96 100644
> --- a/fs/fat/namei_vfat.c
> +++ b/fs/fat/namei_vfat.c
> @@ -21,6 +21,8 @@
>  #include <linux/slab.h>
>  #include <linux/buffer_head.h>
>  #include <linux/namei.h>
> +#include <linux/kernel.h>
> +
>  #include "fat.h"
>  
>  /*
> @@ -505,10 +507,8 @@ xlate_to_uni(const unsigned char *name, int len, unsigned char *outname,
>  	     struct nls_table *nls)
>  {
>  	const unsigned char *ip;
> -	unsigned char nc;
>  	unsigned char *op;
> -	unsigned int ec;
> -	int i, k, fill;
> +	int i, rc, fill;
>  	int charlen;
>  
>  	if (utf8) {
> @@ -528,26 +528,12 @@ xlate_to_uni(const unsigned char *name, int len, unsigned char *outname,
>  				if (escape && (*ip == ':')) {
>  					if (i > len - 5)
>  						return -EINVAL;
> -					ec = 0;
> -					for (k = 1; k < 5; k++) {
> -						nc = ip[k];
> -						ec <<= 4;
> -						if (nc >= '0' && nc <= '9') {
> -							ec |= nc - '0';
> -							continue;
> -						}
> -						if (nc >= 'a' && nc <= 'f') {
> -							ec |= nc - ('a' - 10);
> -							continue;
> -						}
> -						if (nc >= 'A' && nc <= 'F') {
> -							ec |= nc - ('A' - 10);
> -							continue;
> -						}
> +
> +					rc = hex2bin(op, ip + 1, 2);
> +					if (rc < 0)
>  						return -EINVAL;
> -					}
> -					*op++ = ec & 0xFF;
> -					*op++ = ec >> 8;
> +
> +					op += 2;
>  					ip += 5;
>  					i += 5;
>  				} else {

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
