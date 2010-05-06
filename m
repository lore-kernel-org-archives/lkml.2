Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab0EFPYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 11:24:37 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:9681 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758601Ab0EFPXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 11:23:43 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzz6ff19hz32i87h2a8h64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L20836-01-HH2-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 3/7] oprofile/x86: protect cpu hotplug sections
Date: Thu, 6 May 2010 15:26:10 +0200
Message-ID: <1273152374-9392-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1273152374-9392-1-git-send-email-robert.richter@amd.com>
References: <1273152374-9392-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reworks oprofile cpu hotplug code as follows:

Introduce ctr_running variable to check, if counters are running or
not. The state must be known for taking a cpu on or offline and when
switching counters during counter multiplexing.

Protect on_each_cpu() sections with get_online_cpus()/put_online_cpu()
functions. This is necessary if notifiers or states are
modified. Within these sections the cpu mask may not change.

Switch only between counters in nmi_cpu_switch(), if counters are
running. Otherwise the switch may restart a counter though they are
disabled.

Add nmi_cpu_setup() and nmi_cpu_shutdown() to cpu hotplug code. The
function must also be called to avoid uninitialzed counter usage.

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |   52 ++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index c5df8ee..b56601e 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -31,8 +31,9 @@ static struct op_x86_model_spec *model;
 static DEFINE_PER_CPU(struct op_msrs, cpu_msrs);
 static DEFINE_PER_CPU(unsigned long, saved_lvtpc);
 
-/* 0 == registered but off, 1 == registered and on */
-static int nmi_enabled = 0;
+/* must be protected with get_online_cpus()/put_online_cpus(): */
+static int nmi_enabled;
+static int ctr_running;
 
 struct op_counter_config counter_config[OP_MAX_COUNTER];
 
@@ -103,7 +104,10 @@ static void nmi_cpu_start(void *dummy)
 
 static int nmi_start(void)
 {
+	get_online_cpus();
 	on_each_cpu(nmi_cpu_start, NULL, 1);
+	ctr_running = 1;
+	put_online_cpus();
 	return 0;
 }
 
@@ -118,7 +122,10 @@ static void nmi_cpu_stop(void *dummy)
 
 static void nmi_stop(void)
 {
+	get_online_cpus();
 	on_each_cpu(nmi_cpu_stop, NULL, 1);
+	ctr_running = 0;
+	put_online_cpus();
 }
 
 #ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
@@ -258,7 +265,10 @@ static int nmi_switch_event(void)
 	if (nmi_multiplex_on() < 0)
 		return -EINVAL;		/* not necessary */
 
-	on_each_cpu(nmi_cpu_switch, NULL, 1);
+	get_online_cpus();
+	if (ctr_running)
+		on_each_cpu(nmi_cpu_switch, NULL, 1);
+	put_online_cpus();
 
 	return 0;
 }
@@ -386,8 +396,11 @@ static int nmi_setup(void)
 	if (err)
 		goto fail;
 
+	get_online_cpus();
 	on_each_cpu(nmi_cpu_setup, NULL, 1);
 	nmi_enabled = 1;
+	put_online_cpus();
+
 	return 0;
 fail:
 	free_msrs();
@@ -433,8 +446,11 @@ static void nmi_shutdown(void)
 {
 	struct op_msrs *msrs;
 
-	nmi_enabled = 0;
+	get_online_cpus();
 	on_each_cpu(nmi_cpu_shutdown, NULL, 1);
+	nmi_enabled = 0;
+	ctr_running = 0;
+	put_online_cpus();
 	unregister_die_notifier(&profile_exceptions_nb);
 	msrs = &get_cpu_var(cpu_msrs);
 	model->shutdown(msrs);
@@ -442,6 +458,22 @@ static void nmi_shutdown(void)
 	put_cpu_var(cpu_msrs);
 }
 
+static void nmi_cpu_up(void *dummy)
+{
+	if (nmi_enabled)
+		nmi_cpu_setup(dummy);
+	if (ctr_running)
+		nmi_cpu_start(dummy);
+}
+
+static void nmi_cpu_down(void *dummy)
+{
+	if (ctr_running)
+		nmi_cpu_stop(dummy);
+	if (nmi_enabled)
+		nmi_cpu_shutdown(dummy);
+}
+
 static int nmi_create_files(struct super_block *sb, struct dentry *root)
 {
 	unsigned int i;
@@ -478,10 +510,10 @@ static int oprofile_cpu_notifier(struct notifier_block *b, unsigned long action,
 	switch (action) {
 	case CPU_DOWN_FAILED:
 	case CPU_ONLINE:
-		smp_call_function_single(cpu, nmi_cpu_start, NULL, 0);
+		smp_call_function_single(cpu, nmi_cpu_up, NULL, 0);
 		break;
 	case CPU_DOWN_PREPARE:
-		smp_call_function_single(cpu, nmi_cpu_stop, NULL, 1);
+		smp_call_function_single(cpu, nmi_cpu_down, NULL, 1);
 		break;
 	}
 	return NOTIFY_DONE;
@@ -699,7 +731,11 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 		return -ENODEV;
 	}
 
+	get_online_cpus();
 	register_cpu_notifier(&oprofile_cpu_nb);
+	nmi_enabled = 0;
+	ctr_running = 0;
+	put_online_cpus();
 
 	/* default values, can be overwritten by model */
 	ops->create_files	= nmi_create_files;
@@ -729,7 +765,11 @@ void op_nmi_exit(void)
 {
 	if (using_nmi) {
 		exit_sysfs();
+		get_online_cpus();
 		unregister_cpu_notifier(&oprofile_cpu_nb);
+		nmi_enabled = 0;
+		ctr_running = 0;
+		put_online_cpus();
 	}
 	if (model->exit)
 		model->exit();
-- 
1.7.0.3


