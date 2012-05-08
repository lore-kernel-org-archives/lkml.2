Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab2EHKEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 06:04:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53411 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab2EHKEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 06:04:39 -0400
Date: Tue, 8 May 2012 03:04:12 -0700
From: "=?UTF-8?B?dGlwLWJvdCBmb3IgTcOhcnRvbiBOw6ltZXRo?=" 
	<nm127@freemail.hu>
Message-ID: <tip-d1ecad6eee8629c6b425580aad76cf99b85956e9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, nagananda.chumbalkar@hp.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, nm127@freemail.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, suresh.b.siddha@intel.com,
        nagananda.chumbalkar@hp.com, tglx@linutronix.de, nm127@freemail.hu
In-Reply-To: <1336461860.2296.3.camel@sbsiddha-mobl2>
References: <1336461860.2296.3.camel@sbsiddha-mobl2>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic:
  Only compile local function if used with !CONFIG_GENERIC_PENDING_IRQ
Git-Commit-ID: d1ecad6eee8629c6b425580aad76cf99b85956e9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 03:04:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d1ecad6eee8629c6b425580aad76cf99b85956e9
Gitweb:     http://git.kernel.org/tip/d1ecad6eee8629c6b425580aad76cf99b85956e9
Author:     Márton Németh <nm127@freemail.hu>
AuthorDate: Tue, 8 May 2012 00:24:20 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 8 May 2012 11:23:15 +0200

x86/apic: Only compile local function if used with !CONFIG_GENERIC_PENDING_IRQ

The local function io_apic_level_ack_pending() is only called
from io_apic_level_ack_pending(). The later function is only
compiled if CONFIG_GENERIC_PENDING_IRQ is defined. Move the
io_apic_level_ack_pending() to the existing #ifdef
CONFIG_GENERIC_PENDING_IRQ code block.

This will remove the following warning message during compiling
without CONFIG_GENERIC_PENDING_IRQ defined:

 * arch/x86/kernel/apic/io_apic.c:382: warning: ‘io_apic_level_ack_pending’ defined but not used

Signed-off-by: Márton Németh <nm127@freemail.hu>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Link: http://lkml.kernel.org/r/1336461860.2296.3.camel@sbsiddha-mobl2
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/apic/io_apic.c |   46 ++++++++++++++++++++--------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 973539c..e245365 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -346,29 +346,6 @@ void native_io_apic_modify(unsigned int apic, unsigned int reg, unsigned int val
 	writel(value, &io_apic->data);
 }
 
-static bool io_apic_level_ack_pending(struct irq_cfg *cfg)
-{
-	struct irq_pin_list *entry;
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	for_each_irq_pin(entry, cfg->irq_2_pin) {
-		unsigned int reg;
-		int pin;
-
-		pin = entry->pin;
-		reg = io_apic_read(entry->apic, 0x10 + pin*2);
-		/* Is the remote IRR bit set? */
-		if (reg & IO_APIC_REDIR_REMOTE_IRR) {
-			raw_spin_unlock_irqrestore(&ioapic_lock, flags);
-			return true;
-		}
-	}
-	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
-
-	return false;
-}
-
 union entry_union {
 	struct { u32 w1, w2; };
 	struct IO_APIC_route_entry entry;
@@ -2519,6 +2496,29 @@ static void ack_apic_edge(struct irq_data *data)
 atomic_t irq_mis_count;
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
+static bool io_apic_level_ack_pending(struct irq_cfg *cfg)
+{
+	struct irq_pin_list *entry;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
+	for_each_irq_pin(entry, cfg->irq_2_pin) {
+		unsigned int reg;
+		int pin;
+
+		pin = entry->pin;
+		reg = io_apic_read(entry->apic, 0x10 + pin*2);
+		/* Is the remote IRR bit set? */
+		if (reg & IO_APIC_REDIR_REMOTE_IRR) {
+			raw_spin_unlock_irqrestore(&ioapic_lock, flags);
+			return true;
+		}
+	}
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
+
+	return false;
+}
+
 static inline bool ioapic_irqd_mask(struct irq_data *data, struct irq_cfg *cfg)
 {
 	/* If we are moving the irq we need to mask it */
