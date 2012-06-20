Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab2FTWDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 18:03:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61584 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab2FTWDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 18:03:19 -0400
From: mandeep.baines@gmail.com
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Cc: Mandeep Singh Baines <msb@chromium.org>, x86@kernel.org,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Christoph Lameter <cl@gentwo.org>, Olof Johansson <olofj@chromium.org>
Subject: [PATCH] x86, mm: only wait for flushes from online cpus
Date: Wed, 20 Jun 2012 15:03:04 -0700
Message-Id: <1340229784-3686-1-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mandeep Singh Baines <msb@chromium.org>

A cpu in the mm_cpumask could go offline before we send the
invalidate IPI causing us to wait forever.

Bug Trace:

<4>[10222.234548] WARNING: at ../../arch/x86/kernel/apic/ipi.c:113 default_send_IPI_mask_logical+0x58/0x73()
<5>[10222.234633] Pid: 23605, comm: lmt-udev Tainted: G         C   3.2.7 #1
<5>[10222.234639] Call Trace:
<5>[10222.234651]  [<8102e666>] warn_slowpath_common+0x68/0x7d
<5>[10222.234661]  [<81016c36>] ? default_send_IPI_mask_logical+0x58/0x73
<5>[10222.234670]  [<8102e68f>] warn_slowpath_null+0x14/0x18
<5>[10222.234678]  [<81016c36>] default_send_IPI_mask_logical+0x58/0x73
<5>[10222.234687]  [<8101eec2>] flush_tlb_others_ipi+0x86/0xba
<5>[10222.234696]  [<8101f0bb>] flush_tlb_mm+0x5e/0x62
<5>[10222.234703]  [<8101e36c>] pud_populate+0x2c/0x31
<5>[10222.234711]  [<8101e409>] pgd_alloc+0x98/0xc7
<5>[10222.234719]  [<8102c881>] mm_init.isra.38+0xcc/0xf3
<5>[10222.234727]  [<8102cbc2>] dup_mm+0x68/0x34e
<5>[10222.234736]  [<8139bbae>] ? _cond_resched+0xd/0x21
<5>[10222.234745]  [<810a5b7c>] ? kmem_cache_alloc+0x26/0xe2
<5>[10222.234753]  [<8102d421>] ? copy_process+0x556/0xda6
<5>[10222.234761]  [<8102d641>] copy_process+0x776/0xda6
<5>[10222.234770]  [<8102dd5e>] do_fork+0xcb/0x1d4
<5>[10222.234778]  [<810a8c96>] ? do_sync_write+0xd3/0xd3
<5>[10222.234786]  [<810a94ab>] ? vfs_read+0x95/0xa2
<5>[10222.234795]  [<81008850>] sys_clone+0x20/0x25
<5>[10222.234804]  [<8139d8c5>] ptregs_clone+0x15/0x30
<5>[10222.234812]  [<8139d7f7>] ? sysenter_do_call+0x12/0x26
<4>[10222.234818] ---[ end trace 31e095600f50fd48 ]---
<3>[10234.880183] BUG: soft lockup - CPU#0 stuck for 11s! [lmt-udev:23605]

Addresses http://crosbug.com/31737

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Olof Johansson <olofj@chromium.org>
---
 arch/x86/mm/tlb.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 5e57e11..010090d 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -194,8 +194,13 @@ static void flush_tlb_others_ipi(const struct cpumask *cpumask,
 		apic->send_IPI_mask(to_cpumask(f->flush_cpumask),
 			      INVALIDATE_TLB_VECTOR_START + sender);
 
-		while (!cpumask_empty(to_cpumask(f->flush_cpumask)))
+		while (!cpumask_empty(to_cpumask(f->flush_cpumask))) {
+			/* Only wait for online cpus */
+			cpumask_and(to_cpumask(f->flush_cpumask),
+				    to_cpumask(f->flush_cpumask),
+				    cpu_online_mask);
 			cpu_relax();
+		}
 	}
 
 	f->flush_mm = NULL;
-- 
1.7.3.4

