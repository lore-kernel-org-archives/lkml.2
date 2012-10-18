Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab2JRLDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 07:03:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:54470 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932652Ab2JRLDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 07:03:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,606,1344236400"; 
   d="scan'208";a="157620882"
From: dragos.tatulea@intel.com
To: ccross@android.com, keescook@chromium.org, tony.luck@intel.com,
        cbouatmailru@gmail.com, linux-kernel@vger.kernel.org
Cc: adrian.hunter@intel.com, octavian.purdila@intel.com,
        Dragos Tatulea <dragos.tatulea@intel.com>
Subject: [PATCH v3 8/9] pstore: max out console log level during sysfs dump switch
Date: Thu, 18 Oct 2012 14:06:06 +0300
Message-Id: <1350558367-31801-9-git-send-email-dragos.tatulea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350558367-31801-1-git-send-email-dragos.tatulea@intel.com>
References: <1350558367-31801-1-git-send-email-dragos.tatulea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dragos Tatulea <dragos.tatulea@intel.com>

Otherwise we might miss out on some pstore dumpers that use
printks below current log level.

Signed-off-by: Dragos Tatulea <dragos.tatulea@intel.com>
---
 fs/pstore/platform.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 25f59ed..e3ad13e 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -267,6 +267,7 @@ static DEFINE_SPINLOCK(dbg_lock);
 static int dbg_dump(void *data, u64 val)
 {
 	unsigned long flags;
+	int saved_loglevel;
 
 	switch (val) {
 	case KMSG_DUMP_PANIC:
@@ -276,7 +277,10 @@ static int dbg_dump(void *data, u64 val)
 	case KMSG_DUMP_HALT:
 	case KMSG_DUMP_POWEROFF:
 		spin_lock_irqsave(&dbg_lock, flags);
+		saved_loglevel = console_loglevel;
+		console_loglevel =  15;
 		kmsg_dump(val);
+		console_loglevel = saved_loglevel;
 		spin_unlock_irqrestore(&dbg_lock, flags);
 		return 0;
 	}
-- 
1.7.9.5

