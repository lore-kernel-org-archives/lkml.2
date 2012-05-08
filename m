Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113Ab2EHHYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 03:24:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:21801 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756553Ab2EHHX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 03:23:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="150413116"
Subject: Re: [PATCH] x86 apic: only compile local function if used
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20120507131229.GF23858@gmail.com>
References: <4F89FD7C.2060707@freemail.hu>
	 <20120507131229.GF23858@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel
Date: Tue, 08 May 2012 00:24:20 -0700
Message-ID: <1336461860.2296.3.camel@sbsiddha-mobl2>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-07 at 15:12 +0200, Ingo Molnar wrote:
> * Németh Márton <nm127@freemail.hu> wrote:
> 
> > From: Márton Németh <nm127@freemail.hu>
> > 
> > The local function io_apic_level_ack_pending() is only called from
> > io_apic_level_ack_pending(). The later function is only compiled
> > if CONFIG_GENERIC_PENDING_IRQ is defined. Use this define around
> > io_apic_level_ack_pending() function as well.
> > 
> > This will remove the following warning message during compiling
> > without CONFIG_GENERIC_PENDING_IRQ defined:
> >  * arch/x86/kernel/apic/io_apic.c:382: warning: ‘io_apic_level_ack_pending’ defined but not used
> > 
> > Signed-off-by: Márton Németh <nm127@freemail.hu>
> > ---
> > diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> > index e88300d..9b85009 100644
> > --- a/arch/x86/kernel/apic/io_apic.c
> > +++ b/arch/x86/kernel/apic/io_apic.c
> > @@ -379,6 +379,7 @@ static void __io_apic_modify(unsigned int apic, unsigned int reg, unsigned int v
> >  	writel(value, &io_apic->data);
> >  }
> > 
> > +#ifdef CONFIG_GENERIC_PENDING_IRQ
> >  static bool io_apic_level_ack_pending(struct irq_cfg *cfg)
> >  {
> >  	struct irq_pin_list *entry;
> > @@ -401,6 +402,7 @@ static bool io_apic_level_ack_pending(struct irq_cfg *cfg)
> > 
> >  	return false;
> >  }
> > +#endif
> > 
> >  union entry_union {
> >  	struct { u32 w1, w2; };
> 
> it would be better/cleaner to just move this function into the 
> already existing #ifdef CONFIG_GENERIC_PENDING_IRQ block.

Sorry missed this patch to review before. Appended the modified patch
with an updated changelog.
---

From: Márton Németh <nm127@freemail.hu>
Subject: x86, ioapic: Fix the warning with !CONFIG_GENERIC_PENDING_IRQ

The local function io_apic_level_ack_pending() is only called from
io_apic_level_ack_pending(). The later function is only compiled
if CONFIG_GENERIC_PENDING_IRQ is defined. Move the
io_apic_level_ack_pending() to the existing #ifdef CONFIG_GENERIC_PENDING_IRQ
code block.

This will remove the following warning message during compiling
without CONFIG_GENERIC_PENDING_IRQ defined:
 * arch/x86/kernel/apic/io_apic.c:382: warning: ‘io_apic_level_ack_pending’ defined but not used

Signed-off-by: Márton Németh <nm127@freemail.hu>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   46 ++++++++++++++++++++--------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 4b7a795..ffdc152 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -362,29 +362,6 @@ void native_io_apic_modify(unsigned int apic, unsigned int reg, unsigned int val
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
@@ -2406,6 +2383,29 @@ static void ack_apic_edge(struct irq_data *data)
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


