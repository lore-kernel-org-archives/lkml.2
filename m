Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab1CZLr6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 07:47:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47247 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab1CZLr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 07:47:57 -0400
Date: Sat, 26 Mar 2011 12:47:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Christoph Lameter <cl@linux.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tj@kernel.org, npiggin@kernel.dk, rientjes@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] slub: Disable the lockless allocator
Message-ID: <20110326114736.GA8251@elte.hu>
References: <alpine.DEB.2.00.1103221635400.4521@tiger>
 <20110324142146.GA11682@elte.hu>
 <alpine.DEB.2.00.1103240940570.32226@router.home>
 <AANLkTikb8rtSX5hQG6MQF4quymFUuh5Tw97TcpB0YfwS@mail.gmail.com>
 <20110324172653.GA28507@elte.hu>
 <20110324185258.GA28370@elte.hu>
 <alpine.LFD.2.00.1103242005530.31464@localhost6.localdomain6>
 <20110324192247.GA5477@elte.hu>
 <AANLkTinBwM9egao496WnaNLAPUxhMyJmkusmxt+ARtnV@mail.gmail.com>
 <20110326112725.GA28612@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110326112725.GA28612@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The commit below solves this crash for me. Could we please apply this simple 
patch, until the real bug has been found, to keep upstream debuggable? The 
eventual fix can then re-enable the lockless allocator.

Thanks,

	Ingo

--------------->
>From bb764182707216faeb815c3bbdf6a9e9992a459a Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 26 Mar 2011 12:40:30 +0100
Subject: [PATCH] slub: Disable the lockless allocator

This boot crash:

Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Memory: 1011352k/1048512k available (11595k kernel code, 452k absent, 36708k reserved, 6343k data, 1024k init)
BUG: unable to handle kernel paging request at ffff87ffc1fdd020
IP: [<ffffffff812b50c2>] this_cpu_cmpxchg16b_emu+0x2/0x1c
PGD 0
Oops: 0000 [#1]
last sysfs file:
CPU 0
Pid: 0, comm: swapper Not tainted 2.6.38-08569-g16c29da #110593 System manufacturer System Product Name/A8N-E
RIP: 0010:[<ffffffff812b50c2>]  [<ffffffff812b50c2>] this_cpu_cmpxchg16b_emu+0x2/0x1c
RSP: 0000:ffffffff82003e78  EFLAGS: 00010086
RAX: ffff88003f8020c0 RBX: ffff88003f802180 RCX: 0000000000000002
RDX: 0000000000000001 RSI: ffff88003ffc2020 RDI: ffffffff8219be43
RBP: ffffffff82003ed8 R08: 0000000000000000 R09: ffffea0000de40d0
R10: ffffffff821666b0 R11: ffffffff821666b0 R12: ffff88003f8020c0
R13: ffff88003f802000 R14: ffffffffffffffff R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff8201b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff87ffc1fdd020 CR3: 000000000200b000 CR4: 00000000000006b0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff82002000, task ffffffff82015300)
Stack:
 0000000000000086 ffffffff810dcd03 ffffffffffffffff 0000000000093e30
 ffffffff82003ef8 0000000000000000 00000000000000c0 0000000000000000
 ffff88003f800000 ffff88003f8000c0 ffffffffffffffff 0000000000093e30
Call Trace:
 [<ffffffff810dcd03>] ? kmem_cache_alloc+0x53/0x130
 [<ffffffff8219be43>] kmem_cache_init+0xeb/0x2b0
 [<ffffffff821869eb>] start_kernel+0x1cb/0x322
 [<ffffffff82186338>] x86_64_start_reservations+0xfe/0x102
 [<ffffffff82186140>] ? early_idt_handlers+0x140/0x140
 [<ffffffff82186409>] x86_64_start_kernel+0xcd/0xdc
Code: 47 08 48 89 47 10 48 89 47 18 48 89 47 20 48 89 47 28 48 89 47 30 48 89 47 38 48 8d 7f 40 75 d9 90 c3 90 90 90 90 90 90 90 9c fa
 48 3b 06 75 14 65 48 3b 56 08 75 0d 65 48 89 1e 65 48 89 4e
RIP  [<ffffffff812b50c2>] this_cpu_cmpxchg16b_emu+0x2/0x1c
 RSP <ffffffff82003e78>
CR2: ffff87ffc1fdd020
---[ end trace a7919e7f17c0a725 ]---

Occurs due to:

  8a5ec0ba42c4: Lockless (and preemptless) fastpaths for slub

Disable this code for now, it's not yet fully cooked.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 mm/slub.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index f881874..37ccf77 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -30,6 +30,7 @@
 
 #include <trace/events/kmem.h>
 
+#undef CONFIG_CMPXCHG_LOCAL
 /*
  * Lock order:
  *   1. slab_lock(page)
