Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab2F0Hyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 03:54:50 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:56191 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483Ab2F0Hyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 03:54:49 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] frv: Kill used but uninitialized variable
Date: Wed, 27 Jun 2012 09:54:44 +0200
Message-Id: <1340783684-2203-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6afe1a1fe8ff83f6ac2726b04665e76ba7b14f3e ("PM: Remove legacy PM")
removed the initialization of retval, causing:

arch/frv/kernel/pm.c: In function 'sysctl_pm_do_suspend':
arch/frv/kernel/pm.c:165:5: warning: 'retval' may be used uninitialized in this function [-Wuninitialized]

Remove the variable completely to fix this, and convert to a proper
switch (...) { ... } construct to improve readability.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/frv/kernel/pm.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/frv/kernel/pm.c b/arch/frv/kernel/pm.c
index 5fa3889..0b57992 100644
--- a/arch/frv/kernel/pm.c
+++ b/arch/frv/kernel/pm.c
@@ -153,23 +153,22 @@ static int user_atoi(char __user *ubuf, size_t len)
 static int sysctl_pm_do_suspend(ctl_table *ctl, int write,
 				void __user *buffer, size_t *lenp, loff_t *fpos)
 {
-	int retval, mode;
+	int mode;
 
 	if (*lenp <= 0)
 		return -EIO;
 
 	mode = user_atoi(buffer, *lenp);
-	if ((mode != 1) && (mode != 5))
-		return -EINVAL;
+	switch (mode) {
+	case 1:
+	    return pm_do_suspend();
 
-	if (retval == 0) {
-		if (mode == 5)
-		    retval = pm_do_bus_sleep();
-		else
-		    retval = pm_do_suspend();
-	}
+	case 5:
+	    return pm_do_bus_sleep();
 
-	return retval;
+	default:
+	    return -EINVAL;
+	}
 }
 
 static int try_set_cmode(int new_cmode)
-- 
1.7.0.4

