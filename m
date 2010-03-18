Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab0CRJIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 05:08:55 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60065 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab0CRJIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 05:08:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ER6Ytpg+M9+gv6m+ElEXqmrbhCzGS8hD40hi0KsHy1POb9av2c+ZEw5jkIoisTqeAr
         RyegKJukUdYTjDJw/IoosIG3X91qjcsvGlou0xGzP7OYkpfDIsFmgjG0DAJbD8Rh4DoK
         QKvgXGlgdfXu5iVw/OCbKg3+aH9FNaWrryYoQ=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
       linux-s390@vger.kernel.org
Subject: [PATCH 10/12] s390: convert cpu notifier to return encapsulate errno value
Date: Thu, 18 Mar 2010 18:05:22 +0900
Message-Id: <1268903124-10237-10-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1268903124-10237-1-git-send-email-akinobu.mita@gmail.com>
References: <1268903124-10237-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the previous modification, the cpu notifier can return encapsulate
errno value. This converts the cpu notifiers for s390.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
---
 arch/s390/kernel/smp.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 29f65bc..5c5ba7b 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -943,21 +943,21 @@ static int __cpuinit smp_cpu_notify(struct notifier_block *self,
 	struct cpu *c = &per_cpu(cpu_devices, cpu);
 	struct sys_device *s = &c->sysdev;
 	struct s390_idle_data *idle;
+	int err = 0;
 
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		idle = &per_cpu(s390_idle, cpu);
 		memset(idle, 0, sizeof(struct s390_idle_data));
-		if (sysfs_create_group(&s->kobj, &cpu_online_attr_group))
-			return NOTIFY_BAD;
+		err = sysfs_create_group(&s->kobj, &cpu_online_attr_group);
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		sysfs_remove_group(&s->kobj, &cpu_online_attr_group);
 		break;
 	}
-	return NOTIFY_OK;
+	return notifier_from_errno(err);
 }
 
 static struct notifier_block __cpuinitdata smp_cpu_nb = {
-- 
1.6.0.6

