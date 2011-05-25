Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932919Ab1EYQnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 12:43:17 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:53588 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757457Ab1EYQnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 12:43:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=LfgxiARImz5NPXXJXElhlz6q/2yDN0Z4jhOiNMl8bjZM1RWtjGSlCjRpb1QpkiGW1RDoXK1eQ/ay0/F4/06ybS8NBcL4PWe9arTqgnQnUr38Zv1Ly716oyDpkklLhgHN;
Date: Wed, 25 May 2011 09:43:04 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Arend van Spriel" <arend@broadcom.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Dan Carpenter" <error27@gmail.com>,
        "George Spelvin" <linux@horizon.com>
Subject: Re: [RFC V4] lib: crc8: add new library module providing crc8
 algorithm
Message-Id: <20110525094304.0769a189.rdunlap@xenotime.net>
In-Reply-To: <1306320099-17970-1-git-send-email-arend@broadcom.com>
References: <1306320099-17970-1-git-send-email-arend@broadcom.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011 12:41:39 +0200 Arend van Spriel wrote:

>  include/linux/crc8.h |  101 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  lib/Kconfig          |    7 +++
>  lib/Makefile         |    1 +
>  lib/crc8.c           |   84 +++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 193 insertions(+), 0 deletions(-)
>  create mode 100644 include/linux/crc8.h
>  create mode 100644 lib/crc8.c


[snip]

> diff --git a/lib/crc8.c b/lib/crc8.c
> new file mode 100644
> index 0000000..0ce4238
> --- /dev/null
> +++ b/lib/crc8.c
> @@ -0,0 +1,84 @@
> +/*
> + * Copyright (c) 2011 Broadcom Corporation
> + *
> + * Permission to use, copy, modify, and/or distribute this software for any
> + * purpose with or without fee is hereby granted, provided that the above
> + * copyright notice and this permission notice appear in all copies.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
> + * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
> + * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
> + * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> + */

insert blank line here, please.

> +#define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
> +#include <linux/module.h>
> +#include <linux/crc8.h>
> +#include <linux/printk.h>
> +
> +/*
> + * crc8_populate_msb - fill crc table for given polynomial in reverse bit order.
> + *
> + * table:	table to be filled.
> + * polynomial:	polynomial for which table is to be filled.
> + */

Please convert all of these function comments to kernel-doc, like the header file has.

> +void crc8_populate_msb(u8 table[CRC8_TABLE_SIZE], u8 polynomial)
> +{
> +	int i, j;
> +	const u8 msbit = 0x80;
> +	u8 t = msbit;
> +
> +	table[0] = 0;
> +
> +	for (i = 1; i < CRC8_TABLE_SIZE; i *= 2) {
> +		t = (t << 1) ^ (t & msbit ? polynomial : 0);
> +		for (j = 0; j < i; j++)
> +			table[i+j] = table[j] ^ t;
> +	}
> +}
> +EXPORT_SYMBOL(crc8_populate_msb);
> +
> +/*
> + * crc8_populate_lsb - fill crc table for given polynomial in regular bit order.
> + *
> + * table:	table to be filled.
> + * polynomial:	polynomial for which table is to be filled.
> + */
> +void crc8_populate_lsb(u8 table[CRC8_TABLE_SIZE], u8 polynomial)
> +{
> +	int i, j;
> +	u8 t = 1;
> +
> +	table[0] = 0;
> +
> +	for (i = (CRC8_TABLE_SIZE >> 1); i; i >>= 1) {
> +		t = (t >> 1) ^ (t & 1 ? polynomial : 0);
> +		for (j = 0; j < CRC8_TABLE_SIZE; j += 2*i)
> +			table[i+j] = table[j] ^ t;
> +	}
> +}
> +EXPORT_SYMBOL(crc8_populate_lsb);
> +
> +/*
> + * crc8 - calculate a crc8 over the given input data.
> + *
> + * table: crc table used for calculation.
> + * pdata: pointer to data buffer.
> + * nbytes: number of bytes in data buffer.
> + * crc:	previous returned crc8 value.
> + */
> +u8 crc8(const u8 table[CRC8_TABLE_SIZE], u8 *pdata, size_t nbytes, u8 crc)
> +{
> +	/* loop over the buffer data */
> +	while (nbytes-- > 0)
> +		crc = table[(crc ^ *pdata++) & 0xff];
> +
> +	return crc;
> +}
> +EXPORT_SYMBOL(crc8);
> +
> +MODULE_DESCRIPTION("CRC8 (by Williams, Ross N.) function");
> +MODULE_AUTHOR("Broadcom Corporation");
> +MODULE_LICENSE("Dual BSD/GPL");
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
