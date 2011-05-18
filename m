Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab1ERJwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 05:52:38 -0400
Received: from mailgw10.se.ericsson.net ([193.180.251.61]:52056 "EHLO
	mailgw10.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab1ERJwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 05:52:37 -0400
X-AuditID: c1b4fb3d-b7c86ae000000b90-61-4dd396e40efe
From: Kerstin Jonsson <kerstin.jonsson@ericsson.com>
To: <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
CC: Kerstin Jonsson <kerstin.jonsson@ericsson.com>,
        Paul Mackerras <paulus@samba.org>, Michael Neuling <mikey@neuling.org>,
        Darren Hart <dvhltc@us.ibm.com>,
        Will Schmidt <will_schmidt@vnet.ibm.com>
Subject: [PATCH] PPC_47x SMP fix
Date: Wed, 18 May 2011 11:51:57 +0200
Message-ID: <1305712318-21590-1-git-send-email-kerstin.jonsson@ericsson.com>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 commit c56e58537d504706954a06570b4034c04e5b7500 breaks SMP support in PPC_47x chip.
 secondary_ti must be set to current thread info before callin kick_cpu or else
 start_secondary_47x will jump into void when trying to return to c-code.
 In the current setup secondary_ti is initialized before the CPU idle task is started
 and only the boot core will start. I am not sure this is the correct solution, but it
 makes SMP possible in my chip.
 Note! The HOTPLUG support probably need some fixing to, There is no trampoline code
 available in head_44x.S - start_secondary_resume?


Signed-off-by: Kerstin Jonsson <kerstin.jonsson@ericsson.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Neuling <mikey@neuling.org>
Cc: Darren Hart <dvhltc@us.ibm.com>
Cc: Will Schmidt <will_schmidt@vnet.ibm.com>
---
 arch/powerpc/kernel/smp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index cbdbb14..f2dcab7 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -410,8 +410,6 @@ int __cpuinit __cpu_up(unsigned int cpu)
 {
 	int rc, c;
 
-	secondary_ti = current_set[cpu];
-
 	if (smp_ops == NULL ||
 	    (smp_ops->cpu_bootable && !smp_ops->cpu_bootable(cpu)))
 		return -EINVAL;
@@ -421,6 +419,8 @@ int __cpuinit __cpu_up(unsigned int cpu)
 	if (rc)
 		return rc;
 
+	secondary_ti = current_set[cpu];
+
 	/* Make sure callin-map entry is 0 (can be leftover a CPU
 	 * hotplug
 	 */
-- 
1.7.2.3

