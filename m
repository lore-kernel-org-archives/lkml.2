Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab0DMIje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 04:39:34 -0400
Received: from ns2.intersolute.de ([193.110.43.67]:60909 "EHLO
	ns2.intersolute.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab0DMIjc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 04:39:32 -0400
Message-ID: <4BC42DB5.3050106@lumino.de>
Date: Tue, 13 Apr 2010 10:39:17 +0200
From: Michael Schnell <mschnell@lumino.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-2.3 Thunderbird/3.0.4
MIME-Version: 1.0
To: nios2-dev@sopc.et.ntust.edu.tw
CC: =?ISO-8859-1?Q?Fr=E9d=E9ric_LAMBERT?= <frdrc66@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Nios2-dev] atomic RAM ?
References: <4BBD86A5.5030109@lumino.de> <201004081615.01151.arnd@arndb.de>	<4BBEECC8.10005@lumino.de> <201004091714.04990.arnd@arndb.de>	<4BC2EEBD.3070504@lumino.de> <u2j42b5547a1004120845x87d7f2f7wd4acea1144153dd6@mail.gmail.com>
In-Reply-To: <u2j42b5547a1004120845x87d7f2f7wd4acea1144153dd6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2010 05:45 PM, Frédéric LAMBERT wrote:
> I'm pretty sure
> than one can access memory directly from a custom instruction.
>   
Of course you are right that custom instructions can access the Avalon
Bus (similar as a DMA-ip's can access it) and thus the memory that is
used by Linux, too. But as with DMA this access bypasses the cache and
the MMU.

The problem this discussion is about is, that the
architecture-independent code Linux provides (e.g. in FUTEX Kernel code
and in user-land "atomic" macros) defines the memory-words to be
accessed in an atomic way just somewhere in the user-land address space
and accesses them as well via the "atomic" macros (that _are_
arch-depending and thus can be done appropriately for NIOS) as with
normal read and write operations done in C.

If the arch-independent Code could be modified in a way that _all_
accesses (including memory allocation and "free") to the memory-words to
be accessed in an atomic way, is done through arch-depending macros, an
"atomic" RAM could be managed that is accessed thread- and SMP-safe and
very fast as well in user-land as in Kernel code (with NIOS is this
supposedly would be done via (a set of) custom instructions.

Of course this "atomic RAM" _could_ be just a portion of normal
Avalon-based RAM, but as it can't use the cache, it would be very slow
if allocated in DRAM.

But as all this is about a speed optimization, the "atomic RAM" should
be _internal_ and now, as it never would be accessed by the CPU in
"normal" way, the AVALON bus could be avoided altogether.

> If _this_ area is accessed only through the custom instruction, i.e. not
> from the processor, so no through cache and/or MMU, aren't we able to build
> a mechanism that permits your FUTEX implementation?
>   
Unfortunately (AFAIK) the arch independent Linux code currently does not
provide for avoiding normal CPU access for FUTEX variables. Otherwise
this discussion could be done completely here in the NIOS group instead
of in the Linux Kernel mailing list.
> Moreover, I can't imagine that a custom instruction be "interruptible": so
> why shouldn't it be impossible to add a TAS (Test And Set) instruction?
>   
Yep. A custom instruction is not interruptible in a non-SMP system. That
is why it can do any of the necessary atomic read-modify-write
operations. That is why implementing FUTEX (etc) with same is possible.
But with additional normal CPU instructions accessing the same memory
word, the data path can provide unexpected results, especially if the
data cache is active. And deactivating or invalidating the cache
(impossible with user land code) would slow down the performance more
than just not providing FUTEX.

With SMP of course a normal read-modify-write is not good enough. here
we need bus locking additionally. Maybe the Avalon bus can do this, but
the current cache design can't. Implementing a custom instruction with
it's own dedicated memory space of course easily can provide SMP-safe
read-modify write on same.

-Michael
