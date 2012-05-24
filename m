Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046Ab2EXPLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 11:11:51 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:33575 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab2EXPLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 11:11:50 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 1/2] smpboot,
 idle: Optimize calls to smp_processor_id() in idle_threads_init()
To: tglx@linutronix.de
Cc: suresh.b.siddha@intel.com, venki@google.com, nikunj@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Date: Thu, 24 May 2012 20:40:55 +0530
Message-ID: <20120524151055.2549.64309.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12052415-3864-0000-0000-0000030A7456
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While trying to initialize idle threads for all cpus, idle_threads_init()
calls smp_processor_id() in a loop, which is unnecessary. The intent
is to initialize idle threads for all non-boot cpus. So just use a variable
to note the boot cpu and use it in the loop.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/smpboot.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index e1a797e..0f2162f 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -52,10 +52,12 @@ static inline void idle_init(unsigned int cpu)
  */
 void __init idle_threads_init(void)
 {
-	unsigned int cpu;
+	unsigned int cpu, boot_cpu;
+
+	boot_cpu = smp_processor_id();
 
 	for_each_possible_cpu(cpu) {
-		if (cpu != smp_processor_id())
+		if (cpu != boot_cpu)
 			idle_init(cpu);
 	}
 }

