Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab0CYOaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 10:30:11 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:29769 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754637Ab0CYOaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 10:30:09 -0400
From: Vitaliy Gusev <vgusev@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] bsdacct: delete timer with sync intension
Date: Thu, 25 Mar 2010 17:35:10 +0300
User-Agent: KMail/1.10.3 (Linux/2.6.27.45-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <201003251735.10907.vgusev@openvz.org>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acct_exit_ns --> acct_file_reopen deletes timer without
check timer execution on other CPUs. So acct_timeout() can
change an unmapped memory.

Signed-off-by: Vitaliy Gusev <vgusev@openvz.org>

---
 kernel/acct.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index a6605ca..6ac80ca 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -353,17 +353,18 @@ restart:
 
 void acct_exit_ns(struct pid_namespace *ns)
 {
-	struct bsd_acct_struct *acct;
+	struct bsd_acct_struct *acct = ns->bacct;
 
-	spin_lock(&acct_lock);
-	acct = ns->bacct;
-	if (acct != NULL) {
-		if (acct->file != NULL)
-			acct_file_reopen(acct, NULL, NULL);
+	if (acct == NULL)
+		return;
 
-		kfree(acct);
-	}
+	del_timer_sync(&acct->timer);
+	spin_lock(&acct_lock);
+	if (acct->file != NULL)
+		acct_file_reopen(acct, NULL, NULL);
 	spin_unlock(&acct_lock);
+
+	kfree(acct);
 }
 
 /*
