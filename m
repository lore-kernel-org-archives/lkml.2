Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109Ab0KSWEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:04:21 -0500
Received: from kroah.org ([198.145.64.141]:52905 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758029Ab0KSWEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:04:13 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 14:01:24 2010
Message-Id: <20101119220123.977814812@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 14:00:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Weidong Han <weidong.han@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [22/66] x86, intr-remap: Set redirection hint in the IRTE
In-Reply-To: <20101119220309.GA15562@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Suresh Siddha <suresh.b.siddha@intel.com>

commit 75e3cfbed6f71a8f151dc6e413b6ce3c390030cb upstream.

Currently the redirection hint in the interrupt-remapping table entry
is set to 0, which means the remapped interrupt is directed to the
processors listed in the destination. So in logical flat mode
in the presence of intr-remapping, this results in a single
interrupt multi-casted to multiple cpu's as specified by the destination
bit mask. But what we really want is to send that interrupt to one of the cpus
based on the lowest priority delivery mode.

Set the redirection hint in the IRTE to '1' to indicate that we want
the remapped interrupt to be directed to only one of the processors
listed in the destination.

This fixes the issue of same interrupt getting delivered to multiple cpu's
in the logical flat mode in the presence of interrupt-remapping. While
there is no functional issue observed with this behavior, this will
impact performance of such configurations (<=8 cpu's using logical flat
mode in the presence of interrupt-remapping)

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20100827181049.013051492@sbsiddha-MOBL3.sc.intel.com>
Cc: Weidong Han <weidong.han@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/apic/io_apic.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1397,6 +1397,7 @@ int setup_ioapic_entry(int apic_id, int
 		irte.dlvry_mode = apic->irq_delivery_mode;
 		irte.vector = vector;
 		irte.dest_id = IRTE_DEST(destination);
+		irte.redir_hint = 1;
 
 		/* Set source-id of interrupt request */
 		set_ioapic_sid(&irte, apic_id);
@@ -3348,6 +3349,7 @@ static int msi_compose_msg(struct pci_de
 		irte.dlvry_mode = apic->irq_delivery_mode;
 		irte.vector = cfg->vector;
 		irte.dest_id = IRTE_DEST(dest);
+		irte.redir_hint = 1;
 
 		/* Set source-id of interrupt request */
 		if (pdev)


