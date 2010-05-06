Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851Ab0EFPYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 11:24:32 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:14517 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab0EFPXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 11:23:45 -0400
X-SpamScore: 2
X-BigFish: VPS2(zzab9bh8c8aizz1202hzz6ff19hz32i87h2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L20836-01-HH4-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 4/7] oprofile/x86: stop disabled counters in nmi handler
Date: Thu, 6 May 2010 15:26:11 +0200
Message-ID: <1273152374-9392-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1273152374-9392-1-git-send-email-robert.richter@amd.com>
References: <1273152374-9392-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds checks to the nmi handler. Now samples are only
generated and counters reenabled, if the counters are running.
Otherwise the counters are stopped, if oprofile is using the nmi. In
other cases it will ignore the nmi notification.

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index b56601e..94b5481 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -62,12 +62,16 @@ static int profile_exceptions_notify(struct notifier_block *self,
 {
 	struct die_args *args = (struct die_args *)data;
 	int ret = NOTIFY_DONE;
-	int cpu = smp_processor_id();
 
 	switch (val) {
 	case DIE_NMI:
 	case DIE_NMI_IPI:
-		model->check_ctrs(args->regs, &per_cpu(cpu_msrs, cpu));
+		if (ctr_running)
+			model->check_ctrs(args->regs, &__get_cpu_var(cpu_msrs));
+		else if (!nmi_enabled)
+			break;
+		else
+			model->stop(&__get_cpu_var(cpu_msrs));
 		ret = NOTIFY_STOP;
 		break;
 	default:
@@ -392,6 +396,9 @@ static int nmi_setup(void)
 		mux_clone(cpu);
 	}
 
+	nmi_enabled = 0;
+	ctr_running = 0;
+	barrier();
 	err = register_die_notifier(&profile_exceptions_nb);
 	if (err)
 		goto fail;
@@ -451,6 +458,7 @@ static void nmi_shutdown(void)
 	nmi_enabled = 0;
 	ctr_running = 0;
 	put_online_cpus();
+	barrier();
 	unregister_die_notifier(&profile_exceptions_nb);
 	msrs = &get_cpu_var(cpu_msrs);
 	model->shutdown(msrs);
-- 
1.7.0.3


