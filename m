Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab1FGQye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 12:54:34 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:51596
	"EHLO CH1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756836Ab1FGQyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 12:54:32 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bh8275dhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMFISR-01-1XX-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Robert Richter <robert.richter@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        <stable@kernel.org>
Subject: [PATCH] oprofile, x86: Fix race in nmi handler while starting
Date: Tue, 7 Jun 2011 18:47:29 +0200
Message-ID: <1307465249-20055-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.5.rc3
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some rare cases, nmis are generated immediately after the nmi
handler of the cpu was started. This causes the counter not to be
enabled. Before enabling the nmi handlers we need to set variable
ctr_running first and make sure its value is written to memory.

Also, the patch makes all existing barriers a memory barrier instead
of a compiler barrier only.

Reported-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: <stable@kernel.org> # .35+
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index cf97500..68894fd 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -112,8 +112,10 @@ static void nmi_cpu_start(void *dummy)
 static int nmi_start(void)
 {
 	get_online_cpus();
-	on_each_cpu(nmi_cpu_start, NULL, 1);
 	ctr_running = 1;
+	/* make ctr_running visible to the nmi handler: */
+	smp_mb();
+	on_each_cpu(nmi_cpu_start, NULL, 1);
 	put_online_cpus();
 	return 0;
 }
@@ -504,15 +506,18 @@ static int nmi_setup(void)
 
 	nmi_enabled = 0;
 	ctr_running = 0;
-	barrier();
+	/* make variables visible to the nmi handler: */
+	smp_mb();
 	err = register_die_notifier(&profile_exceptions_nb);
 	if (err)
 		goto fail;
 
 	get_online_cpus();
 	register_cpu_notifier(&oprofile_cpu_nb);
-	on_each_cpu(nmi_cpu_setup, NULL, 1);
 	nmi_enabled = 1;
+	/* make nmi_enabled visible to the nmi handler: */
+	smp_mb();
+	on_each_cpu(nmi_cpu_setup, NULL, 1);
 	put_online_cpus();
 
 	return 0;
@@ -531,7 +536,8 @@ static void nmi_shutdown(void)
 	nmi_enabled = 0;
 	ctr_running = 0;
 	put_online_cpus();
-	barrier();
+	/* make variables visible to the nmi handler: */
+	smp_mb();
 	unregister_die_notifier(&profile_exceptions_nb);
 	msrs = &get_cpu_var(cpu_msrs);
 	model->shutdown(msrs);
-- 
1.7.5.rc3


