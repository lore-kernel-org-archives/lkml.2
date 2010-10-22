Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458Ab0JVSwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:52:18 -0400
Received: from kroah.org ([198.145.64.141]:45689 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756428Ab0JVSia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:38:30 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:35:58 2010
Message-Id: <20101022183558.303634758@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:34:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Gleixner <tglx@linutronix.de>,
        Yinghai Lu <yhlu.kernel@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [23/66] x86, irq: Plug memory leak in sparse irq
In-Reply-To: <20101022183711.GA23214@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 1cf180c94e9166cda083ff65333883ab3648e852 upstream.

free_irq_cfg() is not freeing the cpumask_vars in irq_cfg. Fixing this
triggers a use after free caused by the fact that copying struct
irq_cfg is done with memcpy, which copies the pointer not the cpumask.

Fix both places.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
LKML-Reference: <alpine.LFD.2.00.1009282052570.2416@localhost6.localdomain6>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/apic/io_apic.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -332,14 +332,19 @@ void arch_init_copy_chip_data(struct irq
 
 	old_cfg = old_desc->chip_data;
 
-	memcpy(cfg, old_cfg, sizeof(struct irq_cfg));
+	cfg->vector = old_cfg->vector;
+	cfg->move_in_progress = old_cfg->move_in_progress;
+	cpumask_copy(cfg->domain, old_cfg->domain);
+	cpumask_copy(cfg->old_domain, old_cfg->old_domain);
 
 	init_copy_irq_2_pin(old_cfg, cfg, node);
 }
 
-static void free_irq_cfg(struct irq_cfg *old_cfg)
+static void free_irq_cfg(struct irq_cfg *cfg)
 {
-	kfree(old_cfg);
+	free_cpumask_var(cfg->domain);
+	free_cpumask_var(cfg->old_domain);
+	kfree(cfg);
 }
 
 void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc)


