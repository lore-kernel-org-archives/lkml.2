Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454Ab0HEOlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:41:04 -0400
Received: from mail.windriver.com ([147.11.1.11]:41666 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933426Ab0HEOkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:40:41 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        David Airlie <airlied@linux.ie>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/9] vt,console,kdb: implement atomic console enter/leave functions
Date: Thu,  5 Aug 2010 09:39:50 -0500
Message-Id: <1281019198-6777-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1281019198-6777-1-git-send-email-jason.wessel@windriver.com>
References: <1281019198-6777-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 05 Aug 2010 14:40:04.0139 (UTC) FILETIME=[17602FB0:01CB34AC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesse Barnes <jbarnes@virtuousgeek.org>

These functions allow the kernel debugger to save and restore the
state of the system console.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
CC: David Airlie <airlied@linux.ie>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/char/vt.c       |   61 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/console.h |   13 ++++++++++
 2 files changed, 74 insertions(+), 0 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 7cdb6ee..117ce99 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -187,10 +187,15 @@ static DECLARE_WORK(console_work, console_callback);
  * fg_console is the current virtual console,
  * last_console is the last used one,
  * want_console is the console we want to switch to,
+ * saved_* variants are for save/restore around kernel debugger enter/leave
  */
 int fg_console;
 int last_console;
 int want_console = -1;
+int saved_fg_console;
+int saved_last_console;
+int saved_want_console;
+int saved_vc_mode;
 
 /*
  * For each existing display, we have a pointer to console currently visible
@@ -3414,6 +3419,62 @@ int con_is_bound(const struct consw *csw)
 EXPORT_SYMBOL(con_is_bound);
 
 /**
+ * con_debug_enter - prepare the console for the kernel debugger
+ * @sw: console driver
+ *
+ * Called when the console is taken over by the kernel debugger, this
+ * function needs to save the current console state, then put the console
+ * into a state suitable for the kernel debugger.
+ *
+ * RETURNS:
+ * Zero on success, nonzero if a failure occurred when trying to prepare
+ * the console for the debugger.
+ */
+int con_debug_enter(struct vc_data *vc)
+{
+	int ret = 0;
+
+	saved_fg_console = fg_console;
+	saved_last_console = last_console;
+	saved_want_console = want_console;
+	saved_vc_mode = vc->vc_mode;
+	vc->vc_mode = KD_TEXT;
+	console_blanked = 0;
+	if (vc->vc_sw->con_debug_enter)
+		ret = vc->vc_sw->con_debug_enter(vc);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(con_debug_enter);
+
+/**
+ * con_debug_leave - restore console state
+ * @sw: console driver
+ *
+ * Restore the console state to what it was before the kernel debugger
+ * was invoked.
+ *
+ * RETURNS:
+ * Zero on success, nonzero if a failure occurred when trying to restore
+ * the console.
+ */
+int con_debug_leave(void)
+{
+	struct vc_data *vc;
+	int ret = 0;
+
+	fg_console = saved_fg_console;
+	last_console = saved_last_console;
+	want_console = saved_want_console;
+	vc_cons[fg_console].d->vc_mode = saved_vc_mode;
+
+	vc = vc_cons[fg_console].d;
+	if (vc->vc_sw->con_debug_leave)
+		ret = vc->vc_sw->con_debug_leave(vc);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(con_debug_leave);
+
+/**
  * register_con_driver - register console driver to console layer
  * @csw: console driver
  * @first: the first console to take over, minimum value is 0
diff --git a/include/linux/console.h b/include/linux/console.h
index dcca533..f76fc29 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -55,6 +55,16 @@ struct consw {
 	void	(*con_invert_region)(struct vc_data *, u16 *, int);
 	u16    *(*con_screen_pos)(struct vc_data *, int);
 	unsigned long (*con_getxy)(struct vc_data *, unsigned long, int *, int *);
+	/*
+	 * Prepare the console for the debugger.  This includes, but is not
+	 * limited to, unblanking the console, loading an appropriate
+	 * palette, and allowing debugger generated output.
+	 */
+	int	(*con_debug_enter)(struct vc_data *);
+	/*
+	 * Restore the console to its pre-debug state as closely as possible.
+	 */
+	int	(*con_debug_leave)(struct vc_data *);
 };
 
 extern const struct consw *conswitchp;
@@ -69,6 +79,9 @@ int register_con_driver(const struct consw *csw, int first, int last);
 int unregister_con_driver(const struct consw *csw);
 int take_over_console(const struct consw *sw, int first, int last, int deflt);
 void give_up_console(const struct consw *sw);
+int con_debug_enter(struct vc_data *vc);
+int con_debug_leave(void);
+
 /* scroll */
 #define SM_UP       (1)
 #define SM_DOWN     (2)
-- 
1.6.4.rc1

