Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058Ab0JVUr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 16:47:59 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40976 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab0JVUr6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 16:47:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=uiyC0O+ncrns3rnscZ53frQFkfOaQIfx9HjBqnHJhAwndYXKcpywVoxzuSt5zU6y+a
         wxut9FIfc9HnNc7GMyy3lDg1nVD2gkS6WuuQBfoEFCuvLZ/HPwyxwGL2WNFjYSEpRcDK
         1f6DqoZ73J9uq2We8IFqdCd8VeHFN3V+7VSnU=
MIME-Version: 1.0
In-Reply-To: <20101022133138.6d82f79a.akpm@linux-foundation.org>
References: <1287250035-30404-1-git-send-email-vapier@gentoo.org>
 <20101021150250.f6499506.akpm@linux-foundation.org> <201010211823.38287.vapier@gentoo.org>
 <20101021155528.b3d6d027.akpm@linux-foundation.org> <AANLkTim6AFDw_1V9rtF4e_2tmgctbKHziQa-1e3=q7og@mail.gmail.com>
 <20101021162410.5c0d6720.akpm@linux-foundation.org> <AANLkTikGbK7=eW9L4A62Rin-E3usq4Ke_dPoCdStDyEw@mail.gmail.com>
 <20101022133138.6d82f79a.akpm@linux-foundation.org>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 22 Oct 2010 16:47:36 -0400
X-Google-Sender-Auth: yJvS2srMPyPkIPG90Ct6HLOxj34
Message-ID: <AANLkTi=MRU3Qi6NQfqnCwX34sHL2Rx8AyaqRwrxNVQoM@mail.gmail.com>
Subject: Re: [PATCH] lib/atomic64_test: do not build on non-atomic64 systems
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Luca Barbieri <luca@luca-barbieri.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 16:31, Andrew Morton wrote:
> On Fri, 22 Oct 2010 16:14:49 -0400 Mike Frysinger wrote:
>> On Thu, Oct 21, 2010 at 19:24, Andrew Morton wrote:
>> > On Thu, 21 Oct 2010 19:04:36 -0400 Mike Frysinger wrote:
>> >> you can say "lazy" all you like. __i dont see the point in going that route.
>> >
>> > Try
>> >
>> > __ __ __ __grep HAVE arch/x86/Kconfig
>> >
>> > If all of those were instead to use some random #define which the
>> > particular feature happened to define in some header file then we would
>> > have a mess on our hands.
>>
>> fun times.  new tact.
>>
>> Luca: your new atomic64_t test build fails on all arches that lack
>> atomic64_t.  please fix.
>
> That's only part of the problem.  The following won't build also:
>
> net/rds

not true.  that code base is already using my suggestion:
net/rds/rds.h:
#ifdef ATOMIC64_INIT
#define KERNEL_HAS_ATOMIC64
#endif

but this isnt a matter of "use atomic64_t or atomic_t" ... this code
manually takes care of doing a spinlock around a u64 member.  i
imagine if you'd notice this before it was merged you'd have made them
fix this cleanly.

> kernel/perf_event.c

also not true -- this requires arches to opt in to HAVE_PERF_EVENTS
and only arches which have validated it works (i.e. they have
atomic64) have done that

> drivers/staging/octeon

not an issue -- this depends on CPU_CAVIUM_OCTEON which is only
provided by mips which provides atomic64

> drivers/infiniband/hw

the only code usage of atomic64 is in code that already depends on the
Kconfig symbol 64BIT

as for why it depends on this, i dont know ... maybe it's because of atomic64_t

> Or, much better, we implement atomic64 on the offending architectures.

i dont want to give people the impression that 64 atomics are free to
use if in reality they're pretty expensive.  on a Blackfin system, i'd
need to implement every access with basically a spinlock.

> with more to come.  These things should be made dependent upon
> CONFIG_HAVE_ATOMIC64 in Kconfig.  (Can't use #ifdef ATOMIC64_INIT for this!)

these are actually compelling arguments unlike the original one.  even
if all these examples ended up not really being true (only the new
atomic64_t test code is available to build on arches that lack
atomic64).
-mike
