Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631Ab0JFG2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 02:28:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:34856 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758584Ab0JFG2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 02:28:53 -0400
Date: Wed, 6 Oct 2010 06:28:37 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de
In-Reply-To: <4CAA4DD3.1080401@kernel.org>
References: <4CAA4DD3.1080401@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/memblock] memblock: Fix wraparound in find_region()
Message-ID: <tip-f1af98c7629a1b76fd7336decbc776acdeed2120@git.kernel.org>
Git-Commit-ID: f1af98c7629a1b76fd7336decbc776acdeed2120
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 06 Oct 2010 06:28:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f1af98c7629a1b76fd7336decbc776acdeed2120
Gitweb:     http://git.kernel.org/tip/f1af98c7629a1b76fd7336decbc776acdeed2120
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 4 Oct 2010 14:57:39 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 5 Oct 2010 21:45:35 -0700

memblock: Fix wraparound in find_region()

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

This is caused by a wraparound in the test due to size > end;
explicitly check for this condition and fail.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4CAA4DD3.1080401@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 mm/memblock.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index d5d63ac..9ad3969 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -105,13 +105,18 @@ static phys_addr_t __init memblock_find_region(phys_addr_t start, phys_addr_t en
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
