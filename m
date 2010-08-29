Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab0H2Swl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 14:52:41 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35471 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753907Ab0H2Swk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 14:52:40 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will.deacon@arm.com>,
        Robert Richter <robert.richter@amd.com>,
        Matt Fleming <matt@console-pimps.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/3] oprofile: don't call arch exit code from init code on failure
Date: Sun, 29 Aug 2010 19:51:59 +0100
Message-Id: <1283107921-21464-2-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1283107921-21464-1-git-send-email-will.deacon@arm.com>
References: <1283107921-21464-1-git-send-email-will.deacon@arm.com>
X-OriginalArrivalTime: 29 Aug 2010 18:52:17.0751 (UTC) FILETIME=[4DA01E70:01CB47AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oprofile_init calls oprofile_arch_init to initialise the architecture-specific
backend code. If this backend code returns failure, oprofile_arch_exit is
called immediately, making it difficult to allocate and free resources
correctly.

This patch removes the oprofile_arch_exit call from oprofile_init,
meaning that all architectures must ensure that oprofile_arch_init
cleans up any mess it's made before returning an error. As far as
I can tell, this only affects the code for ARM and x86.

Cc: Robert Richter <robert.richter@amd.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 drivers/oprofile/oprof.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
index b336cd9..b4a6857 100644
--- a/drivers/oprofile/oprof.c
+++ b/drivers/oprofile/oprof.c
@@ -257,16 +257,9 @@ static int __init oprofile_init(void)
 		printk(KERN_INFO "oprofile: using timer interrupt.\n");
 		err = oprofile_timer_init(&oprofile_ops);
 		if (err)
-			goto out_arch;
+			return err;
 	}
-	err = oprofilefs_register();
-	if (err)
-		goto out_arch;
-	return 0;
-
-out_arch:
-	oprofile_arch_exit();
-	return err;
+	return oprofilefs_register();
 }
 
 
-- 
1.6.3.3

