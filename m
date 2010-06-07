Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab0FGXOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 19:14:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:30299 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135Ab0FGXOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 19:14:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,381,1272870000"; 
   d="scan'208";a="628347206"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Alan Cox <alan@linux.intel.com>, Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Feng Tang <feng.tang@intel.com>,
       Len Brown <len.brown@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH] x86/sfi: fix ioapic gsi range
Date: Mon,  7 Jun 2010 16:07:24 -0700
Message-Id: <1275952044-27996-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SFI based platforms should have zero based gsi_base for IOAPICs found in SFI
tables. The current code sets gsi_base starting from 1 when registering ioapic.
The result is that Moorestown platform would have wrong mp_gsi_routing for each
ioapic.

Background:
In Moorestown/Medfield platforms, there is no legacy IRQs, all gsis and irqs
are one to one mapped, including those < 16. Specifically, IRQ0 and IRQ1 are
used for per-cpu timers. So without this patch, IOAPIC pin to IRQ mapping is
off by one.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/kernel/sfi.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/sfi.c b/arch/x86/kernel/sfi.c
index 7ded578..8d31950 100644
--- a/arch/x86/kernel/sfi.c
+++ b/arch/x86/kernel/sfi.c
@@ -87,14 +87,17 @@ static int __init sfi_parse_ioapic(struct sfi_table_header *table)
 	struct sfi_table_simple *sb;
 	struct sfi_apic_table_entry *pentry;
 	int i, num;
+	u32 gsi_base;
 
 	sb = (struct sfi_table_simple *)table;
 	num = SFI_GET_NUM_ENTRIES(sb, struct sfi_apic_table_entry);
 	pentry = (struct sfi_apic_table_entry *)sb->pentry;
 
+	gsi_base = gsi_end;
 	for (i = 0; i < num; i++) {
-		mp_register_ioapic(i, pentry->phys_addr, gsi_end + 1);
+		mp_register_ioapic(i, pentry->phys_addr, gsi_base);
 		pentry++;
+		gsi_base = gsi_end + 1;
 	}
 
 	WARN(pic_mode, KERN_WARNING
-- 
1.6.3.3

