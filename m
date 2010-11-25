Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab0KYIqG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 03:46:06 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47893 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab0KYIqD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 03:46:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rsHmAEwZdseg2KYET9dqSC7nFBEH3ndKLyT92Vt2MQuynixwydvW3D6Hy4QgZaoqKu
         HKlqDclTr3joC8/3LZEu2o/KZEcTYKBSn1GncdwnkxDZUb66pSco31QxsQWgLBJhv9DR
         A3sb7rFT9xYKOe/nKkJna+aMa6wdESSQr9Tv4=
MIME-Version: 1.0
In-Reply-To: <1290519504-3958-7-git-send-email-akinobu.mita@gmail.com>
References: <1290519504-3958-1-git-send-email-akinobu.mita@gmail.com>
	<1290519504-3958-7-git-send-email-akinobu.mita@gmail.com>
Date: Thu, 25 Nov 2010 17:46:01 +0900
Message-ID: <AANLkTiktTunH50a2aPCUeJEspEiOP3-fyCy1aWt4pXbZ@mail.gmail.com>
Subject: Re: [PATCH v3 06/22] m68knommu: introduce little-endian bitops
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Roman Zippel <zippel@linux-m68k.org>,
        Andreas Schwab <schwab@linux-m68k.org>, linux-m68k@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Greg Ungerer <gerg@uclinux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/23 Akinobu Mita <akinobu.mita@gmail.com>:
> Introduce little-endian bit operations by renaming native ext2 bit
> operations. The ext2 bit operations are kept as wrapper macros using
> little-endian bit operations to maintain bisectability until the
> conversions are finished.

This breaks the build on m68knommu.

lib/find_next_bit.c:190: error: conflicting types for 'find_next_zero_le_bit'
/home/mita/scm/linux-2.6/arch/m68k/include/asm/bitops_no.h:286: error: previous
definition of 'find_next_zero_le_bit' was here

> @@ -271,10 +279,10 @@ static __inline__ int ext2_test_bit(int nr, const volatile void * addr)
>        return retval;
>  }
>
> -#define ext2_find_first_zero_bit(addr, size) \
> -        ext2_find_next_zero_bit((addr), (size), 0)
> +#define find_first_zero_le_bit(addr, size)     \
> +       find_next_zero_le_bit((addr), (size), 0)
>
> -static __inline__ unsigned long ext2_find_next_zero_bit(void *addr, unsigned long size, unsigned long offset)
> +static inline unsigned long find_next_zero_le_bit(void *addr, unsigned long size, unsigned long offset)
>  {
>        unsigned long *p = ((unsigned long *) addr) + (offset >> 5);
>        unsigned long result = offset & ~31UL;

Because m68knommu selects CONFIG_GENERIC_FIND_NEXT_BIT, it redefines
find_next_zero_le_bit() in lib/find_next_bit.c.

I'm going to fix it by introducing new CONFIG_GENERIC_FIND_LE_BIT option.

CONFIG_GENERIC_FIND_LE_BIT tells whether to use generic implementation of
find_*_le_bit() in lib/find_next_bit.c or not.  It will not be selected by
m68knommu to use the optimized find_next_zero_le_bit().
