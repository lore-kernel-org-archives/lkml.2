Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab2CZTvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 15:51:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33342 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab2CZTvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 15:51:31 -0400
Date: Mon, 26 Mar 2012 12:51:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Douglas W Jones <jones@cs.uiowa.edu>,
        Michal Nazarewicz <mnazarewicz@google.com>
Subject: Re: [PATCH 1/1] vsprintf: optimize decimal conversion (again)
Message-Id: <20120326125129.78975baf.akpm@linux-foundation.org>
In-Reply-To: <201203262051.24271.vda.linux@googlemail.com>
References: <201203262047.17865.vda.linux@googlemail.com>
	<201203262051.24271.vda.linux@googlemail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2012 20:51:24 +0200
Denys Vlasenko <vda.linux@googlemail.com> wrote:

> commit 01a2904d31d2373886f489429ec662c9be64a6ab
> Author: Denys Vlasenko <vda.linux@googlemail.com>
> Date:   Mon Mar 26 20:40:53 2012 +0200
> 
>     vsprintf: optimize decimal conversion (again)
>     
>     Previous code was using optimizations which were developed
>     to work well even on narrow-word CPUs (by today's standards).
>     But Linux runs only on 32-bit and wider CPUs. We can use that.
>     
>     First: using 32x32->64 multiply and trivial 32-bit shift,
>     we can correctly divide by 10 much larger numbers, and thus
>     we can print groups of 9 digits instead of groups of 5 digits.
>     
>     Next: there are two algorithms to print larger numbers.
>     One is generic: divide by 1000000000 and repeatedly print
>     groups of (up to) 9 digits. It's conceptually simple,
>     but requires an (unsigned long long) / 1000000000 division.
>     
>     Second algorithm splits 64-bit unsigned long long into 16-bit chunks,
>     manipulates them cleverly and generates groups of 4 decimal digits.
>     It so happens that it does NOT require long long division.
>     
>     If long is > 32 bits, division of 64-bit values is relatively easy,
>     and we will use the first algorithm.
>     If long long is > 64 bits (strange architecture with VERY large long long),
>     second algorithm can't be used, and we again use the first one.
>     
>     Else (if long is 32 bits and long long is 64 bits) we use second one.
>     
>     And third: there is a simple optimization which takes fast path
>     not only for zero as was done before, but for all one-digit numbers.
>     
>     In all tested cases new code is faster than old one, in many cases by 30%,
>     in few cases by more than 50% (for example, on x86-32, conversion of 12345678).
>     Code growth is ~0 in 32-bit case and ~130 bytes in 64-bit case.
>     

This patch is so nutty that I like it.

> +#if BITS_PER_LONG != 32 || (~(0ULL)>>1) != ((1ULL<<63)-1)

What's this for?

