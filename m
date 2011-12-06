Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344Ab1LFQEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 11:04:12 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:35005 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab1LFQEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 11:04:10 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 2/2] PM: Use the freezer_count() functions in
 [un]lock_system_sleep() APIs
To: rjw@sisk.pl
Cc: pavel@ucw.cz, len.brown@intel.com, tj@kernel.org, oleg@redhat.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Date: Tue, 06 Dec 2011 21:34:02 +0530
Message-ID: <20111206160353.16729.91096.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20111206160251.16729.62719.stgit@srivatsabhat.in.ibm.com>
References: <20111206160251.16729.62719.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11120606-5140-0000-0000-00000061A959
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that freezer_count() and freezer_do_not_count() don't have the restriction
that they are effective only when called by userspace processes, use
them in lock_system_sleep() and unlock_system_sleep() instead of open-coding
their parts.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/suspend.h |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 1f7fff4..906d62c 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -6,6 +6,7 @@
 #include <linux/init.h>
 #include <linux/pm.h>
 #include <linux/mm.h>
+#include <linux/freezer.h>
 #include <asm/errno.h>
 
 #ifdef CONFIG_VT
@@ -380,16 +381,14 @@ static inline void unlock_system_sleep(void) {}
 
 static inline void lock_system_sleep(void)
 {
-	/* simplified freezer_do_not_count() */
-	current->flags |= PF_FREEZER_SKIP;
+	freezer_do_not_count();
 	mutex_lock(&pm_mutex);
 }
 
 static inline void unlock_system_sleep(void)
 {
 	mutex_unlock(&pm_mutex);
-	/* simplified freezer_count() */
-	current->flags &= ~PF_FREEZER_SKIP;
+	freezer_count();
 }
 #endif
 

