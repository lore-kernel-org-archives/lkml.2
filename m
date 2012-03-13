Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760249Ab2CMJll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 05:41:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37767 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759774Ab2CMJlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 05:41:31 -0400
Date: Tue, 13 Mar 2012 02:40:51 -0700
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-73d63d038ee9f769f5e5b46792d227fe20e442c5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jon@jondufresne.org, midgoon@gmail.com, jwboyer@redhat.com,
        stable@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jwboyer@redhat.com, midgoon@gmail.com, jon@jondufresne.org,
        stable@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1331577393.31585.94.camel@sbsiddha-desk.sc.intel.com>
References: <1331577393.31585.94.camel@sbsiddha-desk.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/ioapic:
  Add register level checks to detect bogus io-apic entries
Git-Commit-ID: 73d63d038ee9f769f5e5b46792d227fe20e442c5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Mar 2012 02:40:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  73d63d038ee9f769f5e5b46792d227fe20e442c5
Gitweb:     http://git.kernel.org/tip/73d63d038ee9f769f5e5b46792d227fe20e442c5
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 12 Mar 2012 11:36:33 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 13 Mar 2012 05:52:02 +0100

x86/ioapic: Add register level checks to detect bogus io-apic entries

With the recent changes to clear_IO_APIC_pin() which tries to
clear remoteIRR bit explicitly, some of the users started to see
"Unable to reset IRR for apic .." messages.

Close look shows that these are related to bogus IO-APIC entries
which return's all 1's for their io-apic registers. And the
above mentioned error messages are benign. But kernel should
have ignored such io-apic's in the first place.

Check if register 0, 1, 2 of the listed io-apic are all 1's and
ignore such io-apic.

Reported-by: Álvaro Castillo <midgoon@gmail.com>
Tested-by: Jon Dufresne <jon@jondufresne.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: yinghai@kernel.org
Cc: kernel-team@fedoraproject.org
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: <stable@kernel.org>
Link: http://lkml.kernel.org/r/1331577393.31585.94.camel@sbsiddha-desk.sc.intel.com
[ Performed minor cleanup of affected code. ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/io_apic.c |   40 ++++++++++++++++++++++++++++++++--------
 1 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index fb07275..6d10a66 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3967,18 +3967,36 @@ int mp_find_ioapic_pin(int ioapic, u32 gsi)
 static __init int bad_ioapic(unsigned long address)
 {
 	if (nr_ioapics >= MAX_IO_APICS) {
-		printk(KERN_WARNING "WARNING: Max # of I/O APICs (%d) exceeded "
-		       "(found %d), skipping\n", MAX_IO_APICS, nr_ioapics);
+		pr_warn("WARNING: Max # of I/O APICs (%d) exceeded (found %d), skipping\n",
+			MAX_IO_APICS, nr_ioapics);
 		return 1;
 	}
 	if (!address) {
-		printk(KERN_WARNING "WARNING: Bogus (zero) I/O APIC address"
-		       " found in table, skipping!\n");
+		pr_warn("WARNING: Bogus (zero) I/O APIC address found in table, skipping!\n");
 		return 1;
 	}
 	return 0;
 }
 
+static __init int bad_ioapic_register(int idx)
+{
+	union IO_APIC_reg_00 reg_00;
+	union IO_APIC_reg_01 reg_01;
+	union IO_APIC_reg_02 reg_02;
+
+	reg_00.raw = io_apic_read(idx, 0);
+	reg_01.raw = io_apic_read(idx, 1);
+	reg_02.raw = io_apic_read(idx, 2);
+
+	if (reg_00.raw == -1 && reg_01.raw == -1 && reg_02.raw == -1) {
+		pr_warn("I/O APIC 0x%x registers return all ones, skipping!\n",
+			mpc_ioapic_addr(idx));
+		return 1;
+	}
+
+	return 0;
+}
+
 void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 {
 	int idx = 0;
@@ -3995,6 +4013,12 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	ioapics[idx].mp_config.apicaddr = address;
 
 	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
+
+	if (bad_ioapic_register(idx)) {
+		clear_fixmap(FIX_IO_APIC_BASE_0 + idx);
+		return;
+	}
+
 	ioapics[idx].mp_config.apicid = io_apic_unique_id(id);
 	ioapics[idx].mp_config.apicver = io_apic_get_version(idx);
 
@@ -4015,10 +4039,10 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	if (gsi_cfg->gsi_end >= gsi_top)
 		gsi_top = gsi_cfg->gsi_end + 1;
 
-	printk(KERN_INFO "IOAPIC[%d]: apic_id %d, version %d, address 0x%x, "
-	       "GSI %d-%d\n", idx, mpc_ioapic_id(idx),
-	       mpc_ioapic_ver(idx), mpc_ioapic_addr(idx),
-	       gsi_cfg->gsi_base, gsi_cfg->gsi_end);
+	pr_info("IOAPIC[%d]: apic_id %d, version %d, address 0x%x, GSI %d-%d\n",
+		idx, mpc_ioapic_id(idx),
+		mpc_ioapic_ver(idx), mpc_ioapic_addr(idx),
+		gsi_cfg->gsi_base, gsi_cfg->gsi_end);
 
 	nr_ioapics++;
 }
