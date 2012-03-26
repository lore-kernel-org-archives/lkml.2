Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab2CZT5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 15:57:00 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54164 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab2CZT47 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 15:56:59 -0400
MIME-Version: 1.0
In-Reply-To: <20120326125129.78975baf.akpm@linux-foundation.org>
References: <201203262047.17865.vda.linux@googlemail.com> <201203262051.24271.vda.linux@googlemail.com>
 <20120326125129.78975baf.akpm@linux-foundation.org>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Mon, 26 Mar 2012 21:56:38 +0200
Message-ID: <CAK1hOcNZ1QdsT2Gajv1y-yAfF85hOTH=18vqqH4itURLtgYfdQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] vsprintf: optimize decimal conversion (again)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Douglas W Jones <jones@cs.uiowa.edu>,
        Michal Nazarewicz <mnazarewicz@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 9:51 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 26 Mar 2012 20:51:24 +0200
> Denys Vlasenko <vda.linux@googlemail.com> wrote:
>
>> commit 01a2904d31d2373886f489429ec662c9be64a6ab
>> Author: Denys Vlasenko <vda.linux@googlemail.com>
>> Date:   Mon Mar 26 20:40:53 2012 +0200
>>
>>     vsprintf: optimize decimal conversion (again)
>>
>>     Previous code was using optimizations which were developed
>>     to work well even on narrow-word CPUs (by today's standards).
>>     But Linux runs only on 32-bit and wider CPUs. We can use that.
>>
>>     First: using 32x32->64 multiply and trivial 32-bit shift,
>>     we can correctly divide by 10 much larger numbers, and thus
>>     we can print groups of 9 digits instead of groups of 5 digits.
>>
>>     Next: there are two algorithms to print larger numbers.
>>     One is generic: divide by 1000000000 and repeatedly print
>>     groups of (up to) 9 digits. It's conceptually simple,
>>     but requires an (unsigned long long) / 1000000000 division.
>>
>>     Second algorithm splits 64-bit unsigned long long into 16-bit chunks,
>>     manipulates them cleverly and generates groups of 4 decimal digits.
>>     It so happens that it does NOT require long long division.
>>
>>     If long is > 32 bits, division of 64-bit values is relatively easy,
>>     and we will use the first algorithm.
>>     If long long is > 64 bits (strange architecture with VERY large long long),
>>     second algorithm can't be used, and we again use the first one.
>>
>>     Else (if long is 32 bits and long long is 64 bits) we use second one.
>>
>>     And third: there is a simple optimization which takes fast path
>>     not only for zero as was done before, but for all one-digit numbers.
>>
>>     In all tested cases new code is faster than old one, in many cases by 30%,
>>     in few cases by more than 50% (for example, on x86-32, conversion of 12345678).
>>     Code growth is ~0 in 32-bit case and ~130 bytes in 64-bit case.
>>
>
> This patch is so nutty that I like it.
>
>> +#if BITS_PER_LONG != 32 || (~(0ULL)>>1) != ((1ULL<<63)-1)
>
> What's this for?

The second check should be just BITS_PER_LONG_LONG != 64,
but we don't have BITS_PER_LONG_LONG.

-- 
vda
