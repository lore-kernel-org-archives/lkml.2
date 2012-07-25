Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899Ab2GYJRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 05:17:48 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:51234 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab2GYJRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 05:17:46 -0400
X-AuditID: 0ac90646-96ec1ba000003485-c1-500fb9b8f995
X-AuditID: 0ac90646-96ec1ba000003485-c1-500fb9b8f995
Message-ID: <500FB9C2.1030103@hitachi.com>
Date: Wed, 25 Jul 2012 18:17:54 +0900
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: tglx@linutronix.de, mingo@kernel.org
Cc: hpa@zytor.com, suresh.b.siddha@intel.com, yinghai@kernel.org,
        agordeev@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Subject: [PATCH] x86/ioapic: Fix NULL pointer dereference on CPU hotplug after
 disabling irqs
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In current Linux, percpu variable `vector_irq' is not always cleared when
a CPU is offlined. If the cpu that has the disabled irqs in vector_irq is
hotplugged again, __setup_vector_irq() hits invalid irq vector and may
crash.

Commit f6175f5bfb4c partially fixes this, but was not enough in
environments with IOMMU IRQ remapper.

This bug can be reproduced as following;
 # echo 0 > /sys/devices/system/cpu/cpu7/online
 # modprobe -r some_driver_using_interrupts     # vector_irq@cpu7 uncleared
 # echo 1 > /sys/devices/system/cpu/cpu7/online # kernel may crash

This patch fixes this bug by clearing vector_irq in __fixup_irqs() when
the cpu is offlined.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Alexander Gordeev <agordeev@redhat.com>
---
 arch/x86/kernel/irq.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 3dafc60..d27b27d 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -328,6 +328,7 @@ void fixup_irqs(void)
 				chip->irq_retrigger(data);
 			raw_spin_unlock(&desc->lock);
 		}
+		__this_cpu_write(vector_irq[vector], -1);
 	}
 }
 #endif
-- 
1.7.7.6
-- 
Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory

