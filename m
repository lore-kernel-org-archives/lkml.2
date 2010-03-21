Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab0CUHSS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 03:18:18 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:46906 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab0CUHSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 03:18:00 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 09/20] x86: set nr_irqs_gsi only in probe_nr_irqs_gsi
Date: Sun, 21 Mar 2010 00:13:10 -0700
Message-Id: <1269155601-18247-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269155601-18247-1-git-send-email-yinghai@kernel.org>
References: <1269155601-18247-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4BA5C78D.006B,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

don't clear that in arch_early_irq_init

probe_nr_irqs_gsi is always called when ioapic is selected in config.

so even for mrst, print out from probe_nr_irqs_gsi is report correct
nr_irqs_gsi

-v2: remove io_apic_irqs assignement, setup_IO_APIC will do that.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/apic/io_apic.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 61b59ef..ba469f8 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -153,11 +153,6 @@ int __init arch_early_irq_init(void)
 	int node;
 	int i;
 
-	if (!legacy_pic->nr_legacy_irqs) {
-		nr_irqs_gsi = 0;
-		io_apic_irqs = ~0UL;
-	}
-
 	cfg = irq_cfgx;
 	count = ARRAY_SIZE(irq_cfgx);
 	node= cpu_to_node(boot_cpu_id);
@@ -3938,6 +3933,8 @@ void __init probe_nr_irqs_gsi(void)
 {
 	int nr = 0;
 
+	nr_irqs_gsi = legacy_pic->nr_legacy_irqs;
+
 	nr = acpi_probe_gsi();
 	if (nr > nr_irqs_gsi) {
 		nr_irqs_gsi = nr;
-- 
1.6.4.2

