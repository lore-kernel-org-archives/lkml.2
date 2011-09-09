Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933821Ab1IILXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 07:23:15 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52941 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933497Ab1IILXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 07:23:14 -0400
Message-ID: <4E69F71D.3030905@gmail.com>
Date: Fri, 09 Sep 2011 13:23:09 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@amd64.org>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        Ingo Molnar <mingo@elte.hu>, melwyn lobo <linux.melwyn@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: x86 memcpy performance
References: <CAHSGOutFRcXWtn9d2zwLbkQG==kwPEUZh-ZigKS5AnMN6ty2-w@mail.gmail.com> <20110812195220.GA29051@elte.hu> <20110814095910.GA18809@liondog.tnic> <6296.1313462075@turing-police.cc.vt.edu> <20110816121604.GA29251@aftab> <4E5FA18A.7010205@gmail.com> <CA+55aFz1RRY6KcqVVZ9tBH7PDXfBwkZ1AhJcSHPABLXMkNJCOA@mail.gmail.com> <20110908083551.GA5646@liondog.tnic> <4E689FC5.8010005@gmail.com> <20110909081407.GA29251@liondog.tnic> <4E69E675.1010809@gmail.com>
In-Reply-To: <4E69E675.1010809@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey just a followup on btrfs,

On 09/09/2011 12:12 PM, Maarten Lankhorst wrote:
> Hey,
>
> On 09/09/2011 10:14 AM, Borislav Petkov wrote:
>> On Thu, Sep 08, 2011 at 12:58:13PM +0200, Maarten Lankhorst wrote:
>>> I have changed your sse memcpy to test various alignments with
>>> source/destination offsets instead of random, from that you can
>>> see that you don't really get a speedup at all. It seems to be more
>>> a case of 'kernel memcpy is significantly slower with some alignments',
>>> than 'avx memcpy is just that much faster'.
>>>
>>> For example 3754 with src misalignment 4 and target misalignment 20
>>> takes 1185 units on avx memcpy, but 1480 units with kernel memcpy
>> Right, so the idea is to check whether with the bigger buffer sizes
>> (and misaligned, although this should not be that often the case in
>> the kernel) the SSE version would outperform a "rep movs" with ucode
>> optimizations not kicking in.
>>
>> With your version modified back to SSE memcpy (don't have an AVX box
>> right now) I get on an AMD F10h:
>>
>> ...
>> 16384(12/40)    4756.24         7867.74         1.654192552
>> 16384(40/12)    5067.81         6068.71         1.197500008
>> 16384(12/44)    4341.3          8474.96         1.952172387
>> 16384(44/12)    4277.13         7107.64         1.661777347
>> 16384(12/48)    4989.16         7964.54         1.596369011
>> 16384(48/12)    4644.94         6499.5          1.399264281
>> ...
>>
>> which looks like pretty nice numbers to me. I can't say whether there
>> ever is 16K buffer we copy in the kernel but if there were... But <16K
>> buffers also show up to 1.5x speedup. So I'd say it's a uarch thing.
>> As I said, best it would be to put it in the kernel and run a bunch of
>> benchmarks...
> I think for bigger memcpy's it might make sense to demand stricter
> alignment. What are your numbers for (0/0) ? In my case it seems
> that kernel memcpy is always faster for that. In fact, it seems
> src&63 == dst&63 is generally faster with kernel memcpy.
>
> Patching my tree to WARN_ON_ONCE for when this condition isn't true, I get the following warnings:
>
> WARNING: at arch/x86/kernel/head64.c:49 x86_64_start_reservations+0x3b/0x18d()
> WARNING: at arch/x86/kernel/head64.c:52 x86_64_start_reservations+0xcb/0x18d()
> WARNING: at arch/x86/kernel/e820.c:1077 setup_memory_map+0x3b/0x72()
> WARNING: at kernel/fork.c:938 copy_process+0x148f/0x1550()
> WARNING: at arch/x86/vdso/vdso32-setup.c:306 sysenter_setup+0xd4/0x301()
> WARNING: at mm/util.c:72 kmemdup+0x75/0x80()
> WARNING: at fs/btrfs/disk-io.c:1742 open_ctree+0x1ab5/0x1bb0()
> WARNING: at fs/btrfs/disk-io.c:1744 open_ctree+0x1b35/0x1bb0()
> WARNING: at fs/btrfs/extent_io.c:3634 write_extent_buffer+0x209/0x240()
> WARNING: at fs/exec.c:1002 flush_old_exec+0x6c3/0x750()
> WARNING: at fs/btrfs/extent_io.c:3496 read_extent_buffer+0x1b1/0x1e0()
> WARNING: at kernel/module.c:2585 load_module+0x1933/0x1c30()
> WARNING: at fs/btrfs/extent_io.c:3748 memcpy_extent_buffer+0x2aa/0x2f0()
> WARNING: at fs/btrfs/disk-io.c:2276 write_dev_supers+0x34e/0x360()
> WARNING: at lib/swiotlb.c:367 swiotlb_bounce+0xc6/0xe0()
> WARNING: at fs/btrfs/transaction.c:1387 btrfs_commit_transaction+0x867/0x8a0()
> WARNING: at drivers/tty/serial/serial_core.c:527 uart_write+0x14a/0x160()
> WARNING: at mm/memory.c:3830 __access_remote_vm+0x251/0x270()
>
> The most persistent one appears to be the btrfs' *_extent_buffer,
> it gets the most warnings on my system. Apart from that on my
> system there's not much to gain, since the alignment is already
> close to optimal.
>
> My ext4 /home doesn't throw warnings, so I'd gain the most
> by figuring out if I could improve btrfs/extent_io.c in some way.
> The patch for triggering those warnings is below, change to WARN_ON
> if you want to see which one happens the most for you.
>
> I was pleasantly surprised though.
The btrfs one which happens far more often than all others is read_extent_buffer,
but most of them are page aligned on destination. This means that for me,
avx memcpy might be 10% slower or 10% faster, depending on the specific source
alignment, so avx memcpy wouldn't help much.

This specific one happened far more than any of the other memcpy usages, and
ignoring the check when destination is page aligned, most of them are gone.

In short: I don't think I can get a speedup by using avx memcpy in-kernel.

YMMV, if it does speed up for you, I'd love to see concrete numbers. And not only worst
case, but for the common aligned cases too. Or some concrete numbers that misaligned
happens a lot for you.

~Maarten
