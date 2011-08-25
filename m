Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab1HYXGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 19:06:13 -0400
Received: from smtp-out.google.com ([74.125.121.67]:19756 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab1HYXF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 19:05:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=h0ihqKNn/aSROoFMjmnqFNUvdqNSBmLqGwhyxBvIfCc+hA7J9pXbhxNyBd2hGWCc0
	WTqVzeOyK8NFyzwK2X1UQ==
Subject: [PATCH 2/2] x86, ioapic: Announce resources reserved for IOAPICs
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org
Date: Thu, 25 Aug 2011 17:05:45 -0600
Message-ID: <20110825230545.5355.65085.stgit@bhelgaas.mtv.corp.google.com>
In-Reply-To: <20110825230539.5355.13851.stgit@bhelgaas.mtv.corp.google.com>
References: <20110825230539.5355.13851.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delay the IOAPIC output a bit so we can print the actual resources we
reserve.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/x86/kernel/apic/io_apic.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 8eb863e..914027e 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3876,6 +3876,7 @@ void __init ioapic_and_gsi_init(void)
 {
 	unsigned long ioapic_phys, idx = FIX_IO_APIC_BASE_0;
 	struct resource *ioapic_res;
+	struct mp_ioapic_gsi *gsi_cfg;
 	int i;
 
 	ioapic_res = ioapic_setup_resources(nr_ioapics);
@@ -3908,6 +3909,13 @@ fake_ioapic_page:
 
 		ioapic_res->start = ioapic_phys;
 		ioapic_res->end = ioapic_phys + IO_APIC_SLOT_SIZE - 1;
+
+		gsi_cfg = mp_ioapic_gsi_routing(i);
+
+		printk(KERN_INFO "IOAPIC[%d]: id %d v%d %pR GSI %d-%d\n",
+		       i, mpc_ioapic_id(i), mpc_ioapic_ver(i), ioapic_res,
+		       gsi_cfg->gsi_base, gsi_cfg->gsi_end);
+
 		ioapic_res++;
 	}
 
@@ -4016,11 +4024,6 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	if (gsi_cfg->gsi_end >= gsi_top)
 		gsi_top = gsi_cfg->gsi_end + 1;
 
-	printk(KERN_INFO "IOAPIC[%d]: apic_id %d, version %d, address 0x%x, "
-	       "GSI %d-%d\n", idx, mpc_ioapic_id(idx),
-	       mpc_ioapic_ver(idx), mpc_ioapic_addr(idx),
-	       gsi_cfg->gsi_base, gsi_cfg->gsi_end);
-
 	nr_ioapics++;
 }
 

