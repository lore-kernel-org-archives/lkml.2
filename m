Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab2IQIqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 04:46:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:3248 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299Ab2IQIqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 04:46:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,434,1344236400"; 
   d="scan'208";a="193814356"
Subject: [PATCH] pstore: avoid recursive spinlocks in the oops_in_progress
 case
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: gregkh@linuxfoundation.org, anton.vorontsov@linaro.org
Cc: keescook@chromium.org, tony.luck@intel.com, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Sep 2012 01:43:44 +0800
Message-ID: <1347903824.29767.15.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like 8250 driver, when pstore is registered as a console,
to avoid recursive spinlocks when panic happening, change the
spin_lock_irqsave to spin_trylock_irqsave when oops_in_progress
is true.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 fs/pstore/platform.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 29996e8..cbcb5fc 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -164,7 +164,12 @@ static void pstore_console_write(struct console *con, const char *s, unsigned c)
 
 		if (c > psinfo->bufsize)
 			c = psinfo->bufsize;
-		spin_lock_irqsave(&psinfo->buf_lock, flags);
+
+		if (oops_in_progress) {
+			if (!spin_trylock_irqsave(&psinfo->buf_lock, flags))
+				break;
+		} else
+			spin_lock_irqsave(&psinfo->buf_lock, flags);
 		memcpy(psinfo->buf, s, c);
 		psinfo->write(PSTORE_TYPE_CONSOLE, 0, NULL, 0, c, psinfo);
 		spin_unlock_irqrestore(&psinfo->buf_lock, flags);
-- 
1.7.0.4



