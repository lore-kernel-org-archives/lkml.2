Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab1IOHfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 03:35:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53338 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab1IOHfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 03:35:22 -0400
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: linux-kernel@vger.kernel.org
Cc: Gilad Ben-Yossef <gilad@benyossef.com>, Jiri Kosina <trivial@kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH v2][Trivial] Match on_each_cpu behaviour on UP to SMP
Date: Thu, 15 Sep 2011 10:34:40 +0300
Message-Id: <1316072080-20497-1-git-send-email-gilad@benyossef.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment in the SMP implementation of on_each_cpu says:
 "May be used during early boot while
  early_boot_irqs_disabled is set.  Use local_irq_save/restore() instead
  of local_irq_disable/enable()."

but the existing UP macro version uses local_irq_disable/enable().

Do the safe thing - make the UP version match the SMP one.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
CC: Jiri Kosina <trivial@kernel.org>
CC: Randy Dunlap <rdunlap@xenotime.net>

---

This version fixes the silly typo from the previous version.

I boot tested it on x86 UP (with PREEMPT).

---
 include/linux/smp.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 8cc38d3..ecbce67 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -127,9 +127,10 @@ static inline int up_smp_call_function(smp_call_func_t func, void *info)
 			(up_smp_call_function(func, info))
 #define on_each_cpu(func,info,wait)		\
 	({					\
-		local_irq_disable();		\
+		unsigned long __flags;		\
+		local_irq_save(__flags);	\
 		func(info);			\
-		local_irq_enable();		\
+		local_irq_restore(__flags);	\
 		0;				\
 	})
 static inline void smp_send_reschedule(int cpu) { }
-- 
1.7.0.4

