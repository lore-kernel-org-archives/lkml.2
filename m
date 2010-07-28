Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab0G1QlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 12:41:01 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34087 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814Ab0G1Qk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 12:40:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=sUPN3IvOrkmoK5mMuzA9KBqJesK4va1DRdzu6kl1n8PWHylyZQltJZjA8yHz3c8vP/
         eRi+RVf3Zvv8uM3Z9QkeY8n1WbYYlByMMXlHkzE069/HP27Pfhbo4r039sOcE16u2Uz+
         q/hXa867mXf5mw10keIPHLBvzhHW5VpgkXtrg=
MIME-Version: 1.0
Date: Wed, 28 Jul 2010 17:40:52 +0100
Message-ID: <AANLkTin-9jtHP1xmhUp4uUQNZD64pN3Ee5Kn2cqH64Go@mail.gmail.com>
Subject: [2.6.35-rc6 patch] increase kmemleak robustness at boot
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Catalin Marinas <catalin.marinas@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

I've consistently been experiencing kmemleak exhaust it's 400-entry
early-boot buffer and disabling itself; there have been reports of
this also, and I'm finding this on x86-64 with various debug options
enabled.

If we issue a warning and allow the buffer to wrap, we don't need to
hit the kill-switch. While we lose track of some early potential
leaks, it's better than no functionality.

Let me know if it's acceptable, and many thanks for such an excellent tool,
  Daniel

---

Allow the early-boot buffer to wrap, rather than disabling kmemleak
and losing the functionality.

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 2c0d032..93bf8a3 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -786,13 +786,6 @@ static void __init log_early(int op_type, const
void *ptr, size_t size,
 	unsigned long flags;
 	struct early_log *log;

-	if (crt_early_log >= ARRAY_SIZE(early_log)) {
-		pr_warning("Early log buffer exceeded, "
-			   "please increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE\n");
-		kmemleak_disable();
-		return;
-	}
-
 	/*
 	 * There is no need for locking since the kernel is still in UP mode
 	 * at this stage. Disabling the IRQs is enough.
@@ -805,7 +798,13 @@ static void __init log_early(int op_type, const
void *ptr, size_t size,
 	log->min_count = min_count;
 	if (op_type == KMEMLEAK_ALLOC)
 		log->trace_len = __save_stack_trace(log->trace);
+
 	crt_early_log++;
+	if (crt_early_log >= ARRAY_SIZE(early_log)) {
+		pr_warning("Early log buffer exhausted - wrapping\n");
+		crt_early_log = 0;
+	}
+	
 	local_irq_restore(flags);
 }

-- 
Daniel J Blueman
