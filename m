Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376Ab2FAJz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:55:59 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:38146 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758807Ab2FAJz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:55:58 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 14/27] ia64: Move holding of vector_lock to
 __setup_vector_irq()
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com
Cc: rusty@rustcorp.com.au, mingo@kernel.org, yong.zhang0@gmail.com,
        akpm@linux-foundation.org, vatsa@linux.vnet.ibm.com, rjw@sisk.pl,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Frysinger <vapier@gentoo.org>, linux-ia64@vger.kernel.org
Date: Fri, 01 Jun 2012 14:43:28 +0530
Message-ID: <20120601091319.31979.93871.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12053123-6102-0000-0000-0000019CE97D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__setup_vector_irq() expects that its caller holds the vector_lock.
As of now there is only one caller - smp_callin(); and acquiring the lock
in smp_callin() around the call to __setup_vector_irq() obstructs the
conversion of ia64 to generic smp booting code. So move the lock acquisition
to __setup_vector_irq() itself (mimicking what x86 does).

Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: linux-ia64@vger.kernel.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/ia64/kernel/irq_ia64.c |    5 +++--
 arch/ia64/kernel/smpboot.c  |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/kernel/irq_ia64.c b/arch/ia64/kernel/irq_ia64.c
index 5c3e088..6ac99c8 100644
--- a/arch/ia64/kernel/irq_ia64.c
+++ b/arch/ia64/kernel/irq_ia64.c
@@ -241,13 +241,13 @@ reserve_irq_vector (int vector)
 }
 
 /*
- * Initialize vector_irq on a new cpu. This function must be called
- * with vector_lock held.
+ * Initialize vector_irq on a new cpu.
  */
 void __setup_vector_irq(int cpu)
 {
 	int irq, vector;
 
+	spin_lock(&vector_lock);
 	/* Clear vector_irq */
 	for (vector = 0; vector < IA64_NUM_VECTORS; ++vector)
 		per_cpu(vector_irq, cpu)[vector] = -1;
@@ -258,6 +258,7 @@ void __setup_vector_irq(int cpu)
 		vector = irq_to_vector(irq);
 		per_cpu(vector_irq, cpu)[vector] = irq;
 	}
+	spin_unlock(&vector_lock);
 }
 
 #if defined(CONFIG_SMP) && (defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_DIG))
diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
index df00a3c..709ce07 100644
--- a/arch/ia64/kernel/smpboot.c
+++ b/arch/ia64/kernel/smpboot.c
@@ -378,10 +378,10 @@ smp_callin (void)
 	set_numa_node(cpu_to_node_map[cpuid]);
 	set_numa_mem(local_memory_node(cpu_to_node_map[cpuid]));
 
-	spin_lock(&vector_lock);
 	/* Setup the per cpu irq handling data structures */
 	__setup_vector_irq(cpuid);
 	notify_cpu_starting(cpuid);
+	spin_lock(&vector_lock);
 	set_cpu_online(cpuid, true);
 	per_cpu(cpu_state, cpuid) = CPU_ONLINE;
 	spin_unlock(&vector_lock);

