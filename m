Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631Ab1FAIrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:47:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162499Ab1FAIVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:21:50 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:35 2011
Message-Id: <20110601081135.028953314@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:10:46 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel J Blueman <daniel.blueman@gmail.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [076/165] x86, ioapic: Fix potential resume deadlock
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1478
Lines: 44

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
@@ -621,14 +621,14 @@ struct IO_APIC_route_entry **alloc_ioapi
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


