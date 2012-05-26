Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab2EZNXk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 09:23:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58205 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab2EZNWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 09:22:49 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 10/11] pstore/platform: Make automatic updates interval configurable
Date: Sat, 26 May 2012 06:20:28 -0700
Message-Id: <1338038429-21945-10-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <20120526131747.GA15054@lizard>
References: <20120526131747.GA15054@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no behavioural change, the default value is still 60 seconds.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Acked-by: Kees Cook <keescook@chromium.org>
---
 fs/pstore/platform.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 61461ed..34ca314 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -31,6 +31,7 @@
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/hardirq.h>
+#include <linux/jiffies.h>
 #include <linux/workqueue.h>
 
 #include "internal.h"
@@ -40,7 +41,10 @@
  * whether the system is actually still running well enough
  * to let someone see the entry
  */
-#define	PSTORE_INTERVAL	(60 * HZ)
+static int pstore_update_ms = 60000;
+module_param_named(update_ms, pstore_update_ms, int, 0600);
+MODULE_PARM_DESC(update_ms, "milliseconds before pstore updates its content "
+		 "(default is 60000; -1 means runtime updates are disabled)");
 
 static int pstore_new_entry;
 
@@ -231,8 +235,11 @@ int pstore_register(struct pstore_info *psi)
 	kmsg_dump_register(&pstore_dumper);
 	pstore_register_console();
 
-	pstore_timer.expires = jiffies + PSTORE_INTERVAL;
-	add_timer(&pstore_timer);
+	if (pstore_update_ms >= 0) {
+		pstore_timer.expires = jiffies +
+			msecs_to_jiffies(pstore_update_ms);
+		add_timer(&pstore_timer);
+	}
 
 	return 0;
 }
@@ -291,7 +298,7 @@ static void pstore_timefunc(unsigned long dummy)
 		schedule_work(&pstore_work);
 	}
 
-	mod_timer(&pstore_timer, jiffies + PSTORE_INTERVAL);
+	mod_timer(&pstore_timer, jiffies + msecs_to_jiffies(pstore_update_ms));
 }
 
 module_param(backend, charp, 0444);
-- 
1.7.9.2

