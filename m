Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803Ab2FAKEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 06:04:00 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:47734 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932711Ab2FAKD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 06:03:58 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 02/27] smpboot: Add provisions for arch-specific locking
 around cpu_online_mask
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com
Cc: rusty@rustcorp.com.au, mingo@kernel.org, yong.zhang0@gmail.com,
        akpm@linux-foundation.org, vatsa@linux.vnet.ibm.com, rjw@sisk.pl,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>
Date: Fri, 01 Jun 2012 14:40:30 +0530
Message-ID: <20120601091024.31979.23253.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12053123-0260-0000-0000-000001465E80
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to make smp booting as generic as possible and remove code
duplication in arch/ directories.

While manipulating the cpu_online_mask, x86 uses an additional lock, i.e.,
'vector_lock'. So provide a generic way to implement such arch-specific
extra locking, by providing weakly defined functions arch_vector_lock()
and arch_vector_unlock() which can be overriden by different architectures
suitably.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/smpboot.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index 6c26133..5ae1805 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -107,6 +107,13 @@ void __weak __cpu_pre_online(void *arg) {}
 void __weak __cpu_post_online(void *arg) {}
 #endif
 
+/*
+ * Optional arch-specific locking for manipulating cpu_online_mask while
+ * bringing up secondary CPUs.
+ */
+void __weak arch_vector_lock(void) {}
+void __weak arch_vector_unlock(void) {}
+
 
 /**
  * smpboot_start_secondary - Generic way to boot secondary processors
@@ -129,8 +136,10 @@ void __cpuinit smpboot_start_secondary(void *arg)
 
 	__cpu_pre_online(arg);
 
-	/* Set the CPU in the cpu_online_mask */
+	/* Set the CPU in the cpu_online_mask with required locks held */
+	arch_vector_lock();
 	set_cpu_online(cpu, true);
+	arch_vector_unlock();
 
 	__cpu_post_online(arg);
 

