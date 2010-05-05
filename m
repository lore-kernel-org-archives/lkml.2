Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934034Ab0EECKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 22:10:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:37015 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932853Ab0EECKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 22:10:06 -0400
Date: Wed, 5 May 2010 02:09:19 GMT
From: "tip-bot for Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, ebiederm@xmission.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, ebiederm@xmission.com
In-Reply-To: <1269936436-7039-10-git-send-email-ebiederm@xmission.com>
References: <1269936436-7039-10-git-send-email-ebiederm@xmission.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/irq] x86, ioapic: In mpparse use mp_register_ioapic
Message-ID: <tip-cf7500c0ea133d66f8449d86392d83f840102632@git.kernel.org>
Git-Commit-ID: cf7500c0ea133d66f8449d86392d83f840102632
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 May 2010 02:09:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf7500c0ea133d66f8449d86392d83f840102632
Gitweb:     http://git.kernel.org/tip/cf7500c0ea133d66f8449d86392d83f840102632
Author:     Eric W. Biederman <ebiederm@xmission.com>
AuthorDate: Tue, 30 Mar 2010 01:07:11 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 4 May 2010 13:34:59 -0700

x86, ioapic: In mpparse use mp_register_ioapic

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
---
 arch/x86/kernel/mpparse.c |   25 +------------------------
 1 files changed, 1 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index e81030f..5ae5d24 100644
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
