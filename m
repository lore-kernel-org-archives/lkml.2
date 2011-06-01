Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab1FAJSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:18:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:43619 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161727Ab1FAIND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:13:03 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:40 2011
Message-Id: <20110601080339.446818171@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:00:12 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel J Blueman <daniel.blueman@gmail.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [076/146] x86, ioapic: Fix potential resume deadlock
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel J Blueman <daniel.blueman@gmail.com>

commit b64ce24daffb634b5b3133a2e411bd4de50654e8 upstream.

Fix a potential deadlock when resuming; here the calling
function has disabled interrupts, so we cannot sleep.

Change the memory allocation flag from GFP_KERNEL to GFP_ATOMIC.

TODO: We can do away with this memory allocation during resume
      by reusing the ioapic suspend/resume code that uses boot time
      allocated buffers, but we want to keep this -stable patch
      simple.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/20110518233157.385970138@sbsiddha-MOBL3.sc.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/apic/io_apic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -615,14 +615,14 @@ struct IO_APIC_route_entry **alloc_ioapi
 	struct IO_APIC_route_entry **ioapic_entries;
 
 	ioapic_entries = kzalloc(sizeof(*ioapic_entries) * nr_ioapics,
-				GFP_KERNEL);
+				GFP_ATOMIC);
 	if (!ioapic_entries)
 		return 0;
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
 		ioapic_entries[apic] =
 			kzalloc(sizeof(struct IO_APIC_route_entry) *
-				nr_ioapic_registers[apic], GFP_KERNEL);
+				nr_ioapic_registers[apic], GFP_ATOMIC);
 		if (!ioapic_entries[apic])
 			goto nomem;
 	}


