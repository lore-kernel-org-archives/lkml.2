Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab0FNLDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 07:03:33 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48704 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab0FNLDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 07:03:32 -0400
Subject: [PATCH] mtd: Fix bug using smp_processor_id() in preemptible
 ubi_bgt1d kthread
From: Philby John <pjohn@mvista.com>
Reply-To: pjohn@mvista.com
To: linux-mtd@lists.infradead.org
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 14 Jun 2010 16:34:17 +0530
Message-Id: <1276513457.16642.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mtd: Fix bug using smp_processor_id() in preemptible ubi_bgt1d kthread

On a MIPS Cavium Octeon CN5020 when trying to create a UBI volume,
on the NOR flash, the kernel thread ubi_bgt1d calls
cfi_amdstd_write_buffers() --> do_write_buffer() -->
INVALIDATE_CACHE_UDELAY --> __udelay(). Its __udelay() that calls
smp_processor_id() in preemptible code, which you are not supposed to.
Fix the problem by disabling preemption.

The kernel error messages seen when trying to create UBI volume is
BUG: using smp_processor_id() in preemptible [00000000] code: ubi_bgt1d/843
caller is __udelay+0x14/0x70
Call Trace:
[<ffffffff8110b0d4>] dump_stack+0x8/0x34
[<ffffffff812ee1ac>] debug_smp_processor_id+0x114/0x130
[<ffffffff812e9274>] __udelay+0x14/0x70
[<ffffffff81337c0c>] cfi_amdstd_write_buffers+0xa9c/0xd70
[<ffffffff8134cab0>] ubi_io_sync_erase+0x248/0x390
[<ffffffff8134d714>] erase_worker+0x6c/0x4f8
[<ffffffff8134e4fc>] do_work+0xac/0x138
[<ffffffff8134e6a0>] ubi_thread+0x118/0x1a8
[<ffffffff8115ebe0>] kthread+0x88/0x90
[<ffffffff81115650>] kernel_thread_helper+0x10/0x18

Signed-off-by: Philby John <pjohn@mvista.com>
---
 include/linux/mtd/cfi.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/mtd/cfi.h b/include/linux/mtd/cfi.h
index 574d9ee..9673213 100644
--- a/include/linux/mtd/cfi.h
+++ b/include/linux/mtd/cfi.h
@@ -495,7 +495,9 @@ static inline void cfi_udelay(int us)
 	if (us >= 1000) {
 		msleep((us+999)/1000);
 	} else {
+		preempt_disable();
 		udelay(us);
+		preempt_enable();
 		cond_resched();
 	}
 }
-- 
1.6.3.3.333.g4d53f



