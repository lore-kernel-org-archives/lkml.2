Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab1EFGpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 02:45:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:47430 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221Ab1EFGpP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 02:45:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,325,1301900400"; 
   d="scan'208";a="688991993"
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
CC: Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "JBeulich@novell.com" <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Date: Fri, 6 May 2011 14:43:56 +0800
Subject: [PATCH v2 2/2] x86: don't unmask disabled irqs when migrating them
Thread-Topic: [PATCH v2 2/2] x86: don't unmask disabled irqs when migrating
 them
Thread-Index: AcwLuH5jTtgKfhrsS1eB8mp4E9uMGg==
Message-ID: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E3@shsmsx502.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: don't unmask disabled irqs when migrating them

it doesn't make sense to mask/unmask a disabled irq when migrating it
from offlined cpu to another, because it's not expected to handle
any instance of it. Current mask/set_affinity/unmask steps may trigger
unexpected instance on disabled irq which then simply bug on when there
is no handler for it. One failing example is observed in Xen. Xen pvops 
guest marks a special type of irqs as disabled, which are simply used 
as a notification mechanism to wake up blocked guest in event polling
state. Absolutely unmask them may cause the notification instance 
instead injected into the guest and then cause trouble.

Signed-off-by: Fengzhe Zhang <fengzhe.zhang@intel.com>
Signed-off-by: Kevin Tian <kevin.tian@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Ian Campbell <Ian.Campbell@citrix.com>
CC: Jan Beulich <JBeulich@novell.com>

--- linux-2.6.39-rc6.orig/arch/x86/kernel/irq.c	2011-05-04 10:59:13.000000000 +0800
+++ linux-2.6.39-rc6/arch/x86/kernel/irq.c	2011-05-06 09:20:25.563963000 +0800
@@ -237,6 +237,7 @@ void fixup_irqs(void)
 	for_each_irq_desc(irq, desc) {
 		int break_affinity = 0;
 		int set_affinity = 1;
+		int do_mask;
 		const struct cpumask *affinity;
 
 		if (!desc)
@@ -268,7 +269,9 @@ void fixup_irqs(void)
 		}
 
 		chip = irq_data_get_irq_chip(data);
-		if (!irqd_can_move_in_process_context(data) && chip->irq_mask)
+		do_mask = !irqd_irq_disabled(data) &&
+			!irqd_can_move_in_process_context(data) && chip->irq_mask;
+		if (do_mask)
 			chip->irq_mask(data);
 
 		if (chip->irq_set_affinity)
@@ -276,7 +279,7 @@ void fixup_irqs(void)
 		else if (!(warned++))
 			set_affinity = 0;
 
-		if (!irqd_can_move_in_process_context(data) && chip->irq_unmask)
+		if (do_mask)
 			chip->irq_unmask(data);
 
 		raw_spin_unlock(&desc->lock);
