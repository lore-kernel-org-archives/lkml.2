Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782Ab0EFPXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 11:23:43 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:20573 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab0EFPXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 11:23:42 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzz6ff19hz32i2a8h87h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L20836-01-HH0-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 6/7] oprofile/x86: notify cpus only when daemon is running
Date: Thu, 6 May 2010 15:26:13 +0200
Message-ID: <1273152374-9392-7-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1273152374-9392-1-git-send-email-robert.richter@amd.com>
References: <1273152374-9392-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the cpu notifier registration from nmi_init() to
nmi_setup(). The corresponding unregistration function is now in
nmi_shutdown(). Thus, the hotplug code is only active, if the oprofile
daemon is running.

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 7de0572..2a08672 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -504,6 +504,7 @@ static int nmi_setup(void)
 		goto fail;
 
 	get_online_cpus();
+	register_cpu_notifier(&oprofile_cpu_nb);
 	on_each_cpu(nmi_cpu_setup, NULL, 1);
 	nmi_enabled = 1;
 	put_online_cpus();
@@ -519,6 +520,7 @@ static void nmi_shutdown(void)
 	struct op_msrs *msrs;
 
 	get_online_cpus();
+	unregister_cpu_notifier(&oprofile_cpu_nb);
 	on_each_cpu(nmi_cpu_shutdown, NULL, 1);
 	nmi_enabled = 0;
 	ctr_running = 0;
@@ -739,12 +741,6 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 		return -ENODEV;
 	}
 
-	get_online_cpus();
-	register_cpu_notifier(&oprofile_cpu_nb);
-	nmi_enabled = 0;
-	ctr_running = 0;
-	put_online_cpus();
-
 	/* default values, can be overwritten by model */
 	ops->create_files	= nmi_create_files;
 	ops->setup		= nmi_setup;
@@ -771,14 +767,8 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 
 void op_nmi_exit(void)
 {
-	if (using_nmi) {
+	if (using_nmi)
 		exit_sysfs();
-		get_online_cpus();
-		unregister_cpu_notifier(&oprofile_cpu_nb);
-		nmi_enabled = 0;
-		ctr_running = 0;
-		put_online_cpus();
-	}
 	if (model->exit)
 		model->exit();
 }
-- 
1.7.0.3


