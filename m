Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab1I2PhQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 11:37:16 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:51778 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755201Ab1I2PhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 11:37:15 -0400
Message-ID: <1317310634.1854.25.camel@Joe-Laptop>
Subject: Re: [PATCHv4] fat: don't use custom hex_to_bin()
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Thu, 29 Sep 2011 08:37:14 -0700
In-Reply-To: <f176b6be3c0de274839e813d6ac514d6f7736e77.1317308975.git.andriy.shevchenko@linux.intel.com>
References: <87ipob8l4l.fsf@devron.myhome.or.jp>
	 <f176b6be3c0de274839e813d6ac514d6f7736e77.1317308975.git.andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.92- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-29 at 18:10 +0300, Andy Shevchenko wrote:
> diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
[]
> @@ -526,28 +526,16 @@ xlate_to_uni(const unsigned char *name, int len, unsigned char *outname,
>  			     *outlen += 1)
>  			{
>  				if (escape && (*ip == ':')) {
> +					u8 uc[2];
> +
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
> +					if (hex2bin(uc, ip + 1, 2) < 0)
>  						return -EINVAL;
> -					}
> -					*op++ = ec & 0xFF;
> -					*op++ = ec >> 8;
> +
> +					*(wchar_t *)op++ = uc[0] << 8 | uc[1];

perhaps:

	__le16	foo;

	if (hex2bin((u8 *)&foo, ip + 1, 2) < 0)
		return -EINVAL;
	*(u16 *)op = le16_to_cpu(foo);

	op += 2;

