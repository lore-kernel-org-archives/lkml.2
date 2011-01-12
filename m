Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab1ALGsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 01:48:23 -0500
Received: from mga03.intel.com ([143.182.124.21]:60428 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038Ab1ALGsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 01:48:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,312,1291622400"; 
   d="scan'208";a="373312143"
From: Feng Tang <feng.tang@intel.com>
To: linux-kernel@vger.kernel.org, gregkh@suse.de, alan@linux.intel.com,
        akpm@linux-foundation.org
Cc: Feng Tang <feng.tang@intel.com>
Subject: [PATCH] console: prevent registered consoles from dumping old kernel message over again
Date: Wed, 12 Jan 2011 14:48:46 +0800
Message-Id: <1294814926-1460-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For a platform with many consoles like:
 "console=tty1 console=ttyMFD2 console=ttyS0 earlyprintk=mrst"

Each time when the non "selected_console" (tty1 and ttyMFD2 here) get
registered, the existing kernel message will be printed out on registered
consoles again, the "mrst" early console will get some same message for
3 times, and "tty1" will get some for twice.

So try to temporarily disable registered console's printing when dump the
existing kernel messages to the new console.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 kernel/printk.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index f64b899..ba7186b 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1245,6 +1245,7 @@ void register_console(struct console *newcon)
 	int i;
 	unsigned long flags;
 	struct console *bcon = NULL;
+	struct console *con;
 
 	/*
 	 * before we register a new CON_BOOT console, make sure we don't
@@ -1357,8 +1358,20 @@ void register_console(struct console *newcon)
 		spin_lock_irqsave(&logbuf_lock, flags);
 		con_start = log_start;
 		spin_unlock_irqrestore(&logbuf_lock, flags);
+
+		/*
+		 * Disable the existing consoles temporarily to prevent it from
+		 * printing out kernel log again.
+		 */
+		for_each_console(con)
+			if (con != newcon)
+				con->flags &= ~CON_ENABLED;
 	}
 	release_console_sem();
+
+	for_each_console(con)
+		con->flags |= CON_ENABLED;
+
 	console_sysfs_notify();
 
 	/*
-- 
1.7.0.4

