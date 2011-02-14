Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab1BNQhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:37:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53218 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755202Ab1BNQho convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:37:44 -0500
MIME-Version: 1.0
In-Reply-To: <m139nqsk3q.fsf@fess.ebiederm.org>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
 <m1hbce46fw.fsf@fess.ebiederm.org> <AANLkTikJL_4-7F_2oSuefSpL7ak3+OWLk7F+bDqWT8XJ@mail.gmail.com>
 <m1bp2ly41q.fsf@fess.ebiederm.org> <AANLkTimGH5mU+OLRKb=H3WgLXPZaSc5heR+4w5gj2aD4@mail.gmail.com>
 <AANLkTikj-ZTS58uAqUmKQEWzdD3f5DJeox=gOJ9z8rSb@mail.gmail.com>
 <AANLkTinjsimbe6-YgcSK0-zqDuoZ=8xCReHnKZoG4GU9@mail.gmail.com>
 <m14o87wev8.fsf@fess.ebiederm.org> <AANLkTimO3h80Wk44OhpfkjzxpzdDKnf6emj2fNObn_jD@mail.gmail.com>
 <m1r5bbthan.fsf@fess.ebiederm.org> <m1fwrrtc0m.fsf@fess.ebiederm.org> <m139nqsk3q.fsf@fess.ebiederm.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 14 Feb 2011 08:37:21 -0800
Message-ID: <AANLkTikt-PhqRHT8+Zp+ZuGoVNaP8G3yqxMHpGZ_Z98w@mail.gmail.com>
Subject: Re: Heads up Linux 2.6.38-rc4 compile problems.
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alex Riesen <raa.lkml@gmail.com>, David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 7:37 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> 795abaf1e4e188c4171e3cd3dbb11a9fcacaf505  is not fairing too well.
>
> The Bad PMDs may be happening more frequently but the oops that killed
> me was a NULL pointer dereference in acct_collect this time.  Ugh.

So you also have a fair amount of those user-level SIGSEGV reports.
Which is consistent with memory corruption - most of the time the
corruption is not something that gets caught as a kernel data
structure corruption, but some random other data.

The PTE corruption does show a interesting patterns, though:

 - it's always two consecutive page table entries (that have the same
value, and it looks like a kernel pointer)

   This implies to me that it's a list operation. Please enable
CONFIG_DEBUG_LIST.

   The fact that the words are the same also tends to imply that it's
likely a bogus "list_init()" on free'd (or re-used) memory.

 - The values have a pattern, they look like this:

   ffff88000aea5748
   ffff88000af0d748
   ffff88000af0f748
   ffff88001dae1748
   ffff88004b41f748
   ffff8800aeb67748
   ffff8801178f5748
   ffff880192d85748
   ffff8801e07a9748
   ffff8801e50ef748
   ffff880282177748

   which means that they are always at the same offset (0x1748) of a
8kB allocation

 - The page table addresses have a pattern too (the count there is the
uniq count - there's one pair of addresses that shows up twice):

      1 00000000082e9000
      1 00000000082ea000
      1 000000000bae9000
      1 000000000baea000
      1 00000000c2ce9000
      1 00000000c2cea000
      1 00000000eeae9000
      1 00000000eeaea000
      1 00000000ef4e9000
      1 00000000ef4ea000
      1 00000000f04e9000
      1 00000000f04ea000
      1 00000000f3ce9000
      1 00000000f3cea000
      1 00000000f42e9000
      1 00000000f42ea000
      2 00000000f50e9000
      2 00000000f50ea000
      1 00000000f66e9000
      1 00000000f66ea000

   and turning "virtual address" into "page table address" (shift down
by page size, shift up by page table entry size), you get

      00041748
      00041750
      0005d748
      0005d750
      00616748
      00616750
      00775748
      00775750
      0077a748
      0077a750
      00782748
      00782750
      0079e748
      0079e750
      007a1748
      007a1750
      007a8748
      007a8750
      007b3748
      007b3750

  which shows the same 0x748 pattern (the "1750" pattern is just the
next word address). Which is *exactly* what you'd expect from an empty
list (list pointer pointing to itself, and the low 12 bits are
identical in virtual address - the high bits will obviously differ,
since they are all about the allocation of the page tables
themselves).

In other words: I can pretty much guarantee that this is a "struct
list" that is in a 8kB allocation at offset 0x1748. And that gets
re-initialized after it got freed.

Now, I don't know what the actual 8kB allocation is. And most
structures end up having very different offsets based on various
config options, so I can't even guess. And it is possible that there
is some other reason for the 8kB thing (for example, you clearly are
doing things with networking and promiscuous mode, and maybe the
particular skb allocation pattern or something ends up using a SLUB
entry that is always two pages etc.

Can anybody see any other patterns?

                                              Linus
