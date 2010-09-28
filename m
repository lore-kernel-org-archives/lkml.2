Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab0I1ItE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 04:49:04 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:39984 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab0I1ItC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 04:49:02 -0400
Message-ID: <4CA1ABA4.6070803@kernel.org>
Date: Tue, 28 Sep 2010 01:47:32 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] memblock: Fix big size with find_region()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When trying to find huge range for crashkernel, get

[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at arch/x86/mm/memblock.c:248 memblock_x86_reserve_range+0x40/0x7a()
[    0.000000] Hardware name: Sun Fire x4800
[    0.000000] memblock_x86_reserve_range: wrong range [0xffffffff37000000, 0x137000000)
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.36-rc5-tip-yh-01876-g1cac214-dirty #59
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff82816f7e>] ? memblock_x86_reserve_range+0x40/0x7a
[    0.000000]  [<ffffffff81078c2d>] warn_slowpath_common+0x85/0x9e
[    0.000000]  [<ffffffff81078d38>] warn_slowpath_fmt+0x6e/0x70
[    0.000000]  [<ffffffff8281e77c>] ? memblock_find_region+0x40/0x78
[    0.000000]  [<ffffffff8281eb1f>] ? memblock_find_base+0x9a/0xb9
[    0.000000]  [<ffffffff82816f7e>] memblock_x86_reserve_range+0x40/0x7a
[    0.000000]  [<ffffffff8280452c>] setup_arch+0x99d/0xb2a
[    0.000000]  [<ffffffff810a3e02>] ? trace_hardirqs_off+0xd/0xf
[    0.000000]  [<ffffffff81cec7d8>] ? _raw_spin_unlock_irqrestore+0x3d/0x4c
[    0.000000]  [<ffffffff827ffcec>] start_kernel+0xde/0x3f1
[    0.000000]  [<ffffffff827ff2d4>] x86_64_start_reservations+0xa0/0xa4
[    0.000000]  [<ffffffff827ff3de>] x86_64_start_kernel+0x106/0x10d
[    0.000000] ---[ end trace a7919e7f17c0a725 ]---
[    0.000000] Reserving 8192MB of memory at 17592186041200MB for crashkernel (System RAM: 526336MB)

Because memblock_find_region() can not handle size > end, base will be set to huge num.

Try to check size with end.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 mm/memblock.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6/mm/memblock.c
===================================================================
--- linux-2.6.orig/mm/memblock.c
+++ linux-2.6/mm/memblock.c
@@ -105,13 +105,18 @@ static phys_addr_t __init memblock_find_
 	phys_addr_t base, res_base;
 	long j;
 
+	/* In case, huge size is requested */
+	if (end < size)
+		return MEMBLOCK_ERROR;
+
+	base = memblock_align_down((end - size), align);
+
 	/* Prevent allocations returning 0 as it's also used to
 	 * indicate an allocation failure
 	 */
 	if (start == 0)
 		start = PAGE_SIZE;
 
-	base = memblock_align_down((end - size), align);
 	while (start <= base) {
 		j = memblock_overlaps_region(&memblock.reserved, base, size);
 		if (j < 0)
