Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934181Ab1ETNhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:37:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:56446 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933851Ab1ETNhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:37:14 -0400
Date: Fri, 20 May 2011 13:36:58 GMT
From: tip-bot for Daniel J Blueman <daniel.blueman@gmail.com>
Message-ID: <tip-b64ce24daffb634b5b3133a2e411bd4de50654e8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        daniel.blueman@gmail.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        daniel.blueman@gmail.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110518233157.385970138@sbsiddha-MOBL3.sc.intel.com>
References: <20110518233157.385970138@sbsiddha-MOBL3.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, ioapic: Fix potential resume deadlock
Git-Commit-ID: b64ce24daffb634b5b3133a2e411bd4de50654e8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 20 May 2011 13:36:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b64ce24daffb634b5b3133a2e411bd4de50654e8
Gitweb:     http://git.kernel.org/tip/b64ce24daffb634b5b3133a2e411bd4de50654e8
Author:     Daniel J Blueman <daniel.blueman@gmail.com>
AuthorDate: Wed, 18 May 2011 16:31:31 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 May 2011 13:40:41 +0200

x86, ioapic: Fix potential resume deadlock

Fix a potential deadlock when resuming; here the calling
function has disabled interrupts, so we cannot sleep.

Change the memory allocation flag from GFP_KERNEL to GFP_ATOMIC.

TODO: We can do away with this memory allocation during resume
      by reusing the ioapic suspend/resume code that uses boot time
      allocated buffers, but we want to keep this -stable patch
      simple.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: <stable@kernel.org> # v2.6.38/39
Link: http://lkml.kernel.org/r/20110518233157.385970138@sbsiddha-MOBL3.sc.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/io_apic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 45fd33d..df63620 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -621,14 +621,14 @@ struct IO_APIC_route_entry **alloc_ioapic_entries(void)
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
