Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934911Ab2JXTmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 15:42:38 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:50048 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030218Ab2JXTmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 15:42:33 -0400
Date: Wed, 24 Oct 2012 12:42:29 -0700
From: Jonathan Nieder <jrnieder@gmail.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>, linbao.zhang@hp.com,
        "Eric W. Biederman" <ebiederm@xmission.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/3] x86, ioapic: In mpparse use mp_register_ioapic
Message-ID: <20121024194229.GE3120@elie.Belkin>
References: <1351102644.6017.72.camel@sbsiddha-desk.sc.intel.com>
 <20121024182546.GB3338@elie.Belkin>
 <1351103872.6017.80.camel@sbsiddha-desk.sc.intel.com>
 <20121024194114.GC3120@elie.Belkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024194114.GC3120@elie.Belkin>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Tue, 30 Mar 2010 01:07:11 -0700

commit cf7500c0ea133d66f8449d86392d83f84010263 upstream.

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
LKML-Reference: <1269936436-7039-10-git-send-email-ebiederm@xmission.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 arch/x86/kernel/mpparse.c | 25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 788d6cee0ab8..0d895d5d3031 100644
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
1.8.0

