Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab1HOTCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 15:02:53 -0400
Received: from lucidpixels.com ([72.73.18.11]:44273 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790Ab1HOTCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 15:02:53 -0400
Date: Mon, 15 Aug 2011 15:02:52 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Hugh Dickins <hughd@google.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: kernel 3.0: BUG: soft lockup: find_get_pages+0x51/0x110
In-Reply-To: <alpine.LSU.2.00.1108151109240.1524@sister.anvils>
Message-ID: <alpine.DEB.2.02.1108151450190.30763@p34.internal.lan>
References: <alpine.DEB.2.02.1108151241370.32349@p34.internal.lan> <alpine.LSU.2.00.1108151109240.1524@sister.anvils>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Aug 2011, Hugh Dickins wrote:

> On Mon, 15 Aug 2011, Justin Piszcz wrote:
>> Hello,
>>
>> What causes this(?) -- am I out of memory(?) or is this a kernel bug?
>
> It would be a kernel bug to lock up even if you are out of memory.
This machine has 48GB of RAM and its just a linux router and some gqview's
running..

>
> It does look like you're under memory pressure, but I don't see any OOM.
>
> Is this something you've noticed just once, or does it happen repeatedly?
This has happened once before (I've e-mailed LKML about it last weekend or
thereabouts but nobody responded)

It is here:
http://lkml.org/lkml/2011/8/12/54 (down?)
http://comments.gmane.org/gmane.linux.kernel/1178570

>
> Does it always hit somewhere in find_get_pages(), or does the loop span
> wider than that?
Per: http://comments.gmane.org/gmane.linux.kernel/1178570

Slightly different (From August 12)

   75 [330509.718763] Call Trace:
   76 [330509.718771]  [<ffffffff81089e15>] ? pagevec_lookup+0x15/0x20
   77 [330509.718776]  [<ffffffff8108b905>] ? invalidate_mapping_pages+0x55/0x130
   78 [330509.718784]  [<ffffffff810d6835>] ? shrink_icache_memory+0x2c5/0x310
   79 [330509.718788]  [<ffffffff8108c254>] ? shrink_slab+0x104/0x170
   80 [330509.718793]  [<ffffffff8108eda2>] ? balance_pgdat+0x492/0x600
   81 [330509.718798]  [<ffffffff8108efbc>] ? kswapd+0xac/0x250
   82 [330509.718803]  [<ffffffff81050fd0>] ? abort_exclusive_wait+0xb0/0xb0
   83 [330509.718807]  [<ffffffff8108ef10>] ? balance_pgdat+0x600/0x600
   84 [330509.718811]  [<ffffffff8105082e>] ? kthread+0x7e/0x90
   85 [330509.718818]  [<ffffffff815b4e14>] ? kernel_thread_helper+0x4/0x10
   86 [330509.718822]  [<ffffffff810507b0>] ? kthread_worker_fn+0x120/0x120
   87 [330509.718825]  [<ffffffff815b4e10>] ? gs_change+0xb/0xb

The first time it happened was when running a lot of I/O \
(dumps and streams/backups over SSH).

>
> I'm answering out of interest in find_get_pages(): which does contain
> a number of gotos which could result in endless looping; except that
> they're all supposed to be for very transitory conditions which a
> second glance at the RCU-protected tree should correct.
I am using 'server' for the workload type, not 'low latency' -- which exposes
more bugs/problems..

>
> But if a radix_tree node got corrupted, then yes, it could loop forever.
>
> If it's repeatable, please try again with slab poisoning (and frame
> pointers) enabled?
I will enable frame pointers and wait for the next error/problem and report
back if/when it recurs, thanks!

Justin.

