Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab0EOPPy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 11:15:54 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:63887 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab0EOPPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 11:15:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pOhIHUA19cLW0Np4bK68jErcC5SQ4S4ukhcfSrSCWnI/RMel9nKulq2WQy+ndKE+a5
         jRfO4hejivTAo3hmqWSUduxcweAOO7TntDtUJ3BCG0iqaDbp/Jus0nkr/92dPfMqBy1B
         u3l6+ddiW8tXg7dLIKdQelon8uVVibty5JBz0=
From: =?utf-8?q?Leonardo=20de=20S=C3=A1=20Alt?= <leonardoaltt@gmail.com>
To: venkatesh.pallipadi@intel.com
Cc: linux-kernel@vger.kernel.org,
       =?utf-8?q?Leonardo=20de=20S=C3=A1=20Alt?= <leonardoaltt@gmail.com>
Subject: [PATCH] x86:hpet.c: Changed delayed_work to work when delay is 0
Date: Sat, 15 May 2010 12:15:45 -0300
Message-Id: <1273936545-10963-1-git-send-email-leonardoaltt@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here a delayed_work was used with delay 0, so it was changed to work.
It avoids a timer set up and the work is directly queued, providing
less use of memory and more performance.

Signed-off-by: Leonardo de Sá Alt <leonardoaltt@gmail.com>

---
 arch/x86/kernel/hpet.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index a198b7c..4516ba1 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -724,12 +724,10 @@ static int hpet_cpuhp_notify(struct notifier_block *n,
 
 	switch (action & 0xf) {
 	case CPU_ONLINE:
-		INIT_DELAYED_WORK_ON_STACK(&work.work, hpet_work);
+		INIT_WORK_ON_STACK(&work.work.work, hpet_work);
 		init_completion(&work.complete);
-		/* FIXME: add schedule_work_on() */
-		schedule_delayed_work_on(cpu, &work.work, 0);
+		schedule_work_on(cpu, &work.work.work);
 		wait_for_completion(&work.complete);
-		destroy_timer_on_stack(&work.work.timer);
 		break;
 	case CPU_DEAD:
 		if (hdev) {
-- 
1.6.0.4

