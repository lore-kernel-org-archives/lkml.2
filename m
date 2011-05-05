Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab1EEIPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 04:15:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:25556 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab1EEIPp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 04:15:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,318,1301900400"; 
   d="scan'208";a="688488838"
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "JBeulich@novell.com" <JBeulich@novell.com>
Date: Thu, 5 May 2011 16:15:39 +0800
Subject: [PATCH] x86: skip migrating percpu irq in fixup_irqs
Thread-Topic: [PATCH] x86: skip migrating percpu irq in fixup_irqs
Thread-Index: AcwK/FZdhy3fbjQSQb2hVXQj97IFXA==
Message-ID: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F327@shsmsx502.ccr.corp.intel.com>
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

x86: skip migrating percpu irq in fixup_irqs

IRQF_PER_CPU is used by Xen for a set of virtual interrupts binding to
a specific vcpu, but it's not recognized in fixup_irqs which simply
atempts to migrate it to other vcpus. In most cases this just works,
because Xen event channel chip silently fails the set_affinity ops for
irqs marked as IRQF_PER_CPU. But there's a special category (like used
for pv spinlock) also adds a IRQ_DISABLED flag, used as polled only event
channels which don't expect any instance injected. However fixup_irqs
absolutely masks/unmasks irqs which makes such special type irq injected
unexpectely while there's no handler for it.

This error is triggered on some box when doing reboot. The fix is to
recognize IRQF_PER_CPU flag early before the affinity change, which
actually matches the rationale of IRQF_PER_CPU.

Signed-off-by: Fengzhe Zhang <fengzhe.zhang@intel.com>
Signed-off-by: Kevin Tian <kevin.tian@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Ian Campbell <Ian.Campbell@citrix.com>
CC: Jan Beulich <JBeulich@novell.com>

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 1cb0b9f..544efe2 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -249,7 +249,7 @@ void fixup_irqs(void)

                data = irq_desc_get_irq_data(desc);
                affinity = data->affinity;
-               if (!irq_has_action(irq) ||
+               if (!irq_has_action(irq) || irqd_is_per_cpu(data) ||
                    cpumask_subset(affinity, cpu_online_mask)) {
                        raw_spin_unlock(&desc->lock);
                        continue;
