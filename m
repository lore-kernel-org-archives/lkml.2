Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab0DADsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 23:48:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:51277 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab0DADry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 23:47:54 -0400
Message-ID: <4BB41689.9090502@kernel.org>
Date: Wed, 31 Mar 2010 20:44:09 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -v4 1/2] nobootmem, x86: Fix 32bit numa system without RAM
 on Node0
References: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org> <4BB2EB1B.8090303@zytor.com> <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org> <4BB3C739.2020106@kernel.org> <20100331221341.GA20441@elte.hu> <4BB3C9B0.4000205@kernel.org> <20100331224108.GA11284@elte.hu> <4BB3D0F4.902@kernel.org> <4BB3DC23.50005@zytor.com> <4BB3E0CA.5060405@kernel.org> <4BB3EA55.50505@zytor.com> <4BB3FEA6.8030309@kernel.org> <ca9eedfe-479e-4ccf-9663-66afcd2bbd69@email.android.com>
In-Reply-To: <ca9eedfe-479e-4ccf-9663-66afcd2bbd69@email.android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



on one system without RAM on nod0, got following dump with 32bit numa kernel

early_node_map[4] active PFN ranges
    1: 0x00000010 -> 0x00000099
    1: 0x00000100 -> 0x0007da00
    1: 0x0007e800 -> 0x0007ffa0
    1: 0x0007ffae -> 0x0007ffb0
...
Subtract (29 early reservations)
  #000 [0000001000 - 0000002000]
  #001 [0000089000 - 000008f000]
  #002 [0000091000 - 0000093500]
...
  #027 [007cbfef40 - 007e800000]
  #028 [007e9ca000 - 007ff95000]
(0 free memory ranges)
Initializing HighMem for node 0 (00000000:00000000)
Initializing HighMem for node 1 (00000000:00000000)
Memory: 0k/2096832k available (6662k kernel code, 2096300k reserved, 4829k data, 484k init, 0k highmem)
...
Checking if this processor honours the WP bit even in supervisor mode...Ok.
swapper: page allocation failure. order:0, mode:0x0
Pid: 0, comm: swapper Not tainted 2.6.34-rc3-tip-03818-g4b1ea6c-dirty #35
Call Trace:
 [<4087a5dc>] ? printk+0xf/0x11
 [<40286728>] __alloc_pages_nodemask+0x417/0x487
 [<402a9ce1>] new_slab+0xe2/0x1fe
 [<402aa5b2>] kmem_cache_open+0x185/0x358
 [<402abbc0>] T.954+0x1c/0x60
 [<40d52a29>] kmem_cache_init+0x24/0x113
 [<40d39738>] start_kernel+0x166/0x2e4
 [<40d3940e>] ? unknown_bootoption+0x0/0x18e
 [<40d390ce>] i386_start_kernel+0xce/0xd5
Mem-Info:
Node 1 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
Node 1 Normal per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
active_anon:0 inactive_anon:0 isolated_anon:0
 active_file:0 inactive_file:0 isolated_file:0
 unevictable:0 dirty:0 writeback:0 unstable:0
 free:0 slab_reclaimable:0 slab_unreclaimable:0
 mapped:0 shmem:0 pagetables:0 bounce:0

When 32bit numa is used, free_all_bootmem() will still only go over with
node id 0.

If node 0 doesn't have RAM installed, We need to go with node1
because early_node_map still use 1 for all ranges, and ram from node1
become low ram.

Try to use MAX_NUMNODES like 64 numa does.

Note: BOOTMEM path has the same problem.
      this bug exist before We have NO_BOOTMEM support.

-v3: add more comments, and fix bootmem path too.
-v4: seperate bootmem path fix

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 mm/bootmem.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6/mm/bootmem.c
===================================================================
--- linux-2.6.orig/mm/bootmem.c
+++ linux-2.6/mm/bootmem.c
@@ -303,7 +303,14 @@ unsigned long __init free_all_bootmem_no
 unsigned long __init free_all_bootmem(void)
 {
 #ifdef CONFIG_NO_BOOTMEM
-	return free_all_memory_core_early(NODE_DATA(0)->node_id);
+	/*
+	 * We need to use MAX_NUMNODES instead of NODE_DATA(0)->node_id
+	 *  because in some case like Node0 doesnt have RAM installed
+	 *  low ram will be on Node1
+	 * Use MAX_NUMNODES will make sure all ranges in early_node_map[]
+	 *  will be used instead of only Node0 related
+	 */
+	return free_all_memory_core_early(MAX_NUMNODES);
 #else
 	return free_all_bootmem_core(NODE_DATA(0)->bdata);
 #endif
