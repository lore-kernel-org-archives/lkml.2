Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab0EPFjv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 01:39:51 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59669 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab0EPFju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 01:39:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=ewP+XV2qWEmxovam6J093FocN4D4sfzcuvT7VGStpgsm6ir4k6uGtt3JGFUadcTo+A
         HegbsqwF7asxqTZLlH/OLFa/r62GTfHJwpcnsSYaHM/xKiIZesDtGer3MN/8fbzg6YFc
         LUX83n+oh7WdhBG7+Cv+6AlJXYAg+c45B51WI=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH] lktdm: Bring support for hardlockup, softlockup and hung task crashes
Date: Sun, 16 May 2010 07:39:51 +0200
Message-Id: <1273988391-16401-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds three new types of kernel "crashes" in the lkdtm
driver to trigger hardlockups, softlockups and task hung
states at will.

The two formers are useful to test the new generic lockup
detector and check its further regressions. The latter one
is a bonus to check the hung task detector regressions even
though it's not currently in rework.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
---
 drivers/misc/lkdtm.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index 31a9911..5bfb2a2 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -75,6 +75,9 @@ enum ctype {
 	UNALIGNED_LOAD_STORE_WRITE,
 	OVERWRITE_ALLOCATION,
 	WRITE_AFTER_FREE,
+	SOFTLOCKUP,
+	HARDLOCKUP,
+	HUNG_TASK,
 };
 
 static char* cp_name[] = {
@@ -99,6 +102,9 @@ static char* cp_type[] = {
 	"UNALIGNED_LOAD_STORE_WRITE",
 	"OVERWRITE_ALLOCATION",
 	"WRITE_AFTER_FREE",
+	"SOFTLOCKUP",
+	"HARDLOCKUP",
+	"HUNG_TASK",
 };
 
 static struct jprobe lkdtm;
@@ -320,6 +326,20 @@ static void lkdtm_do_action(enum ctype which)
 		memset(data, 0x78, len);
 		break;
 	}
+	case SOFTLOCKUP:
+		preempt_disable();
+		for (;;)
+			cpu_relax();
+		break;
+	case HARDLOCKUP:
+		local_irq_disable();
+		for (;;)
+			cpu_relax();
+		break;
+	case HUNG_TASK:
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule();
+		break;
 	case NONE:
 	default:
 		break;
-- 
1.6.2.3

