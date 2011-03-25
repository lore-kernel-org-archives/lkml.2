Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab1CYNfp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:35:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44313 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670Ab1CYNfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:35:44 -0400
Date: Fri, 25 Mar 2011 14:35:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20110325133538.GA20374@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Rakib Mullick (1):
      x86, mpparse: Move check_slot into CONFIG_X86_IO_APIC context

Thomas Gleixner (2):
      x86: DT: Fix return condition in irq_create_of_mapping()
      x86: DT: Cleanup namespace and call irq_set_irq_type() unconditional


 arch/x86/kernel/devicetree.c |    6 ++----
 arch/x86/kernel/mpparse.c    |    8 ++++----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 7a8cebc..706a9fb 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -65,12 +65,10 @@ unsigned int irq_create_of_mapping(struct device_node *controller,
 		return 0;
 	ret = ih->xlate(ih, intspec, intsize, &virq, &type);
 	if (ret)
-		return ret;
+		return 0;
 	if (type == IRQ_TYPE_NONE)
 		return virq;
-	/* set the mask if it is different from current */
-	if (type == (irq_to_desc(virq)->status & IRQF_TRIGGER_MASK))
-		set_irq_type(virq, type);
+	irq_set_irq_type(virq, type);
 	return virq;
 }
 EXPORT_SYMBOL_GPL(irq_create_of_mapping);
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 6f789a8..5a532ce 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -714,10 +714,6 @@ static void __init check_irq_src(struct mpc_intsrc *m, int *nr_m_spare)
 		*nr_m_spare += 1;
 	}
 }
-#else /* CONFIG_X86_IO_APIC */
-static
-inline void __init check_irq_src(struct mpc_intsrc *m, int *nr_m_spare) {}
-#endif /* CONFIG_X86_IO_APIC */
 
 static int
 check_slot(unsigned long mpc_new_phys, unsigned long mpc_new_length, int count)
@@ -731,6 +727,10 @@ check_slot(unsigned long mpc_new_phys, unsigned long mpc_new_length, int count)
 
 	return ret;
 }
+#else /* CONFIG_X86_IO_APIC */
+static
+inline void __init check_irq_src(struct mpc_intsrc *m, int *nr_m_spare) {}
+#endif /* CONFIG_X86_IO_APIC */
 
 static int  __init replace_intsrc_all(struct mpc_table *mpc,
 					unsigned long mpc_new_phys,
