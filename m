Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab0C3ILi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 04:11:38 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:36260 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233Ab0C3IHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 04:07:23 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>, len.brown@intel.com,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-acpi@vger.kernel.org, Iranna D Ankad <iranna.ankad@in.ibm.com>,
       Gary Hade <garyhade@us.ibm.com>,
       Natalie Protasevich <protasnb@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 10/15] x86 ioapic: In mpparse use mp_register_ioapic
Date: Tue, 30 Mar 2010 01:07:11 -0700
Message-Id: <1269936436-7039-10-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m1oci6qlmr.fsf_-_@fess.ebiederm.org>
References: <m1oci6qlmr.fsf_-_@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: hpa@zytor.com, tglx@linutronix.de, mingo@elte.hu, akpm@linux-foundation.org, jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org, trenn@suse.de, suresh.b.siddha@intel.com, len.brown@intel.com, tony.luck@intel.com, fenghua.yu@intel.com, linux-acpi@vger.kernel.org, iranna.ankad@in.ibm.com, garyhade@us.ibm.com, protasnb@gmail.com, ebiederm@xmission.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Long ago MP_ioapic_info was the primary way of setting up our
ioapic data structures and mp_register_ioapic was a compatibility
shim for acpi code.  Now the situation is reversed and
and mp_register_ioapic is the primary way of setting up our
ioapic data structures.

Keep the setting up of ioapic data structures uniform by
having mp_register_ioapic call mp_register_ioapic.

This changes a few fields:

- type: is now hardset to MP_IOAPIC but type had to
  bey MP_IOAPIC or MP_ioapic_info would not have been called.

- flags: is now hard coded to MPC_APIC_USABLE.
  We require flags to contain at least MPC_APIC_USEBLE in
  MP_ioapic_info and we don't ever examine flags so dropping
  a few flags that might possibly exist that we have never
  used is harmless.

- apicaddr: Unchanged

- apicver: Read from the ioapic instead of using the cached
  hardware value in the MP table.  The real hardware value
  will be more accurate.

- apicid: Now verified to be unique and changed if it is not.
  If the BIOS got this right this is a noop.  If the BIOS did
  not fixing things appears to be the better solution.

This adds gsi_base and gsi_end values to our ioapics defined with
the mpatable, which will make our lives simpler later since
we can always assume gsi_base and gsi_end are valid.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86/kernel/mpparse.c |   25 +------------------------
 1 files changed, 1 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index a2c1edd..22ba4f3 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -115,21 +115,6 @@ static void __init MP_bus_info(struct mpc_bus *m)
 		printk(KERN_WARNING "Unknown bustype %s - ignoring\n", str);
 }
 
-static int bad_ioapic(unsigned long address)
-{
-	if (nr_ioapics >= MAX_IO_APICS) {
-		printk(KERN_ERR "ERROR: Max # of I/O APICs (%d) exceeded "
-		       "(found %d)\n", MAX_IO_APICS, nr_ioapics);
-		panic("Recompile kernel with bigger MAX_IO_APICS!\n");
-	}
-	if (!address) {
-		printk(KERN_ERR "WARNING: Bogus (zero) I/O APIC address"
-		       " found in table, skipping!\n");
-		return 1;
-	}
-	return 0;
-}
-
 static void __init MP_ioapic_info(struct mpc_ioapic *m)
 {
 	if (!(m->flags & MPC_APIC_USABLE))
@@ -138,15 +123,7 @@ static void __init MP_ioapic_info(struct mpc_ioapic *m)
 	printk(KERN_INFO "I/O APIC #%d Version %d at 0x%X.\n",
 	       m->apicid, m->apicver, m->apicaddr);
 
-	if (bad_ioapic(m->apicaddr))
-		return;
-
-	mp_ioapics[nr_ioapics].apicaddr = m->apicaddr;
-	mp_ioapics[nr_ioapics].apicid = m->apicid;
-	mp_ioapics[nr_ioapics].type = m->type;
-	mp_ioapics[nr_ioapics].apicver = m->apicver;
-	mp_ioapics[nr_ioapics].flags = m->flags;
-	nr_ioapics++;
+	mp_register_ioapic(m->apicid, m->apicaddr, gsi_end + 1);
 }
 
 static void print_MP_intsrc_info(struct mpc_intsrc *m)
-- 
1.6.5.2.143.g8cc62

