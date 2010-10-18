Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab0JREvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 00:51:55 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42209 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab0JREvx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 00:51:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=khgM71IROKAW0ROYggtZ7y2ePrbRDuO/i8Muz/s9cdWcNPAYy2Hv2s3Dz6/YtHSzO8
         xsIWEOmWh5ovMa2WBjlZ0kKkib6OgmLy/LAhNdQwFc1sXDMyLd66vLTeQSLjrd/ENKg8
         s+k5HUq1MutBR8aSD8UYXE1ssdRm18HX7Fi6o=
MIME-Version: 1.0
In-Reply-To: <201010151312.30843.arnd@arndb.de>
References: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com>
	<1287135981-17604-4-git-send-email-akinobu.mita@gmail.com>
	<201010151312.30843.arnd@arndb.de>
Date: Mon, 18 Oct 2010 13:51:52 +0900
Message-ID: <AANLkTi=H+c0drWP20JhSs74+V3q2aChgTA1L86pT=FzH@mail.gmail.com>
Subject: Re: [PATCH 03/22] s390: introduce little endian bitops
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/15 Arnd Bergmann <arnd@arndb.de>:
> On Friday 15 October 2010, Akinobu Mita wrote:
>> +#define __set_le_bit(nr, addr) \
>> +       __set_bit((nr)^(__BITOPS_WORDSIZE - 8), (addr))
>> +#define __clear_le_bit(nr, addr)       \
>> +       __clear_bit((nr)^(__BITOPS_WORDSIZE - 8), (addr))
>> +#define __test_and_set_le_bit(nr, addr)        \
>> +       __test_and_set_bit((nr)^(__BITOPS_WORDSIZE - 8), (addr))
>> +#define test_and_set_le_bit(lock, nr, addr)    \
>> +       test_and_set_bit((nr)^(__BITOPS_WORDSIZE - 8), (addr))
>> +#define __test_and_clear_le_bit(nr, addr)      \
>> +       __test_and_clear_bit((nr)^(__BITOPS_WORDSIZE - 8), (addr))
>> +#define test_and_clear_le_bit(lock, nr, addr)  \
>> +       test_and_clear_bit((nr)^(__BITOPS_WORDSIZE - 8), (addr))
>> +#define test_le_bit(nr, addr)  \
>> +       test_bit((nr)^(__BITOPS_WORDSIZE - 8), (addr))
>
> The test_and_clear_le_bit and test_and_set_le_bit calling conventions
> are a little surprising here. I would not pass the lock argument
> here but leave that to the ext2 wrapper:
>
> #define test_and_set_le_bit(nr, addr)    \
>       test_and_set_bit((nr)^(__BITOPS_WORDSIZE - 8), (addr))
> #define test_and_clear_le_bit(nr, addr)  \
>       test_and_clear_bit((nr)^(__BITOPS_WORDSIZE - 8), (addr))
>
> #define ext2_set_bit_atomic(lock, nr, addr)       \
>       test_and_set_le_bit((nr), (unsigned long *)(addr))
> #define ext2_clear_bit_atomic(lock, nr, addr)     \
>       test_and_clear_le_bit((nr), (unsigned long *)(addr))
>
> Same thing on arm and m68k.

Oops,
test_and_{set,clear}_le_bit() is only used by ext2_{set,clear}_bit_atomic
and I had one additional patch that cleans up these definisions across
the architectures. So I didn't realize that mistake when I did cross
compile.
