Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934881Ab2C3VF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:05:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34386 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934848Ab2C3VFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:14 -0400
Message-Id: <20120330195728.103944328@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:58:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?=C3=81lvaro=20Castillo?= <midgoon@gmail.com>,
        Jon Dufresne <jon@jondufresne.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Josh Boyer <jwboyer@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: [ 042/108] x86/ioapic: Add register level checks to detect bogus io-apic entries
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suresh Siddha <suresh.b.siddha@intel.com>

commit 73d63d038ee9f769f5e5b46792d227fe20e442c5 upstream.

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
Link: http://lkml.kernel.org/r/1331577393.31585.94.camel@sbsiddha-desk.sc.intel.com
[ Performed minor cleanup of affected code. ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/apic/io_apic.c |   40 ++++++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3927,18 +3927,36 @@ int mp_find_ioapic_pin(int ioapic, u32 g
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
@@ -3955,6 +3973,12 @@ void __init mp_register_ioapic(int id, u
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
 
@@ -3975,10 +3999,10 @@ void __init mp_register_ioapic(int id, u
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


