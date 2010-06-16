Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab0FPOyv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 10:54:51 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54936 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab0FPOyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 10:54:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=g4J5NkFxBWtptxQVXH8uUm+efYxvooxxr0xO2cCWQVjI1hP5Qpf3ElNFNlBXRfOX7A
         sK4pHeN543kzFLUPYIEmsy4FmZWpeucJU2mC8sS1bodKAtO+LAiUWXc/tyKPuArJj72P
         wAKCjn1ek5ny5NQCxzfM62nI9hXmdYFcpX5jg=
From: =?utf-8?q?Leonardo=20de=20S=C3=A1=20Alt?= <leonardoaltt@gmail.com>
To: venki@google.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, leonardoaltt@gmail.com
Subject: [PATCH] x86, hpet.c: Changed type of field work of hpet_work_struct (delayed_work to work_struct)
Date: Wed, 16 Jun 2010 11:55:02 -0300
Message-Id: <1276700102-18254-1-git-send-email-leonardoaltt@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Venki,
here the new patch with the changes you requested.

Thanks.

The hpet_work_struct has a delayed_work (field work), but it doesn't use 
delay. So this field type was changed for work_struct, and its utilizations
as delayed_work were adapted to work_struct.

Signed-off-by: Leonardo de Sá Alt <leonardoaltt@gmail.com>

---
 arch/x86/kernel/hpet.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index a198b7c..b05935f 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -696,7 +696,7 @@ static struct hpet_dev *hpet_get_unused_timer(void)
 }
 
 struct hpet_work_struct {
-	struct delayed_work work;
+	struct work_struct work;
 	struct completion complete;
 };
 
@@ -706,7 +706,7 @@ static void hpet_work(struct work_struct *w)
 	int cpu = smp_processor_id();
 	struct hpet_work_struct *hpet_work;
 
-	hpet_work = container_of(w, struct hpet_work_struct, work.work);
+	hpet_work = container_of(w, struct hpet_work_struct, work);
 
 	hdev = hpet_get_unused_timer();
 	if (hdev)
@@ -724,12 +724,10 @@ static int hpet_cpuhp_notify(struct notifier_block *n,
 
 	switch (action & 0xf) {
 	case CPU_ONLINE:
-		INIT_DELAYED_WORK_ON_STACK(&work.work, hpet_work);
+		INIT_WORK_ON_STACK(&work.work, hpet_work);
 		init_completion(&work.complete);
-		/* FIXME: add schedule_work_on() */
-		schedule_delayed_work_on(cpu, &work.work, 0);
+		schedule_work_on(cpu, &work.work);
 		wait_for_completion(&work.complete);
-		destroy_timer_on_stack(&work.work.timer);
 		break;
 	case CPU_DEAD:
 		if (hdev) {
-- 
1.6.3.3

