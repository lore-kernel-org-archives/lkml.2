Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab0ESBoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:44:12 -0400
Received: from mail.windriver.com ([147.11.1.11]:41203 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756853Ab0ESBkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:40:19 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 25/25] kdb,debug_core: Allow the debug core to receive a panic notification
Date: Tue, 18 May 2010 20:39:35 -0500
Message-Id: <1274233175-3675-26-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
References: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 19 May 2010 01:40:02.0688 (UTC) FILETIME=[33510000:01CAF6F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is highly desirable to trap into kdb on panic.  The debug core will
attempt to register as the first in line for the panic notifier.

CC: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/debug_core.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index b38bb25..64b5588 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -762,11 +762,28 @@ static struct sysrq_key_op sysrq_dbg_op = {
 };
 #endif
 
+static int kgdb_panic_event(struct notifier_block *self,
+			    unsigned long val,
+			    void *data)
+{
+	if (dbg_kdb_mode)
+		kdb_printf("PANIC: %s\n", (char *)data);
+	kgdb_breakpoint();
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block kgdb_panic_event_nb = {
+       .notifier_call	= kgdb_panic_event,
+       .priority	= INT_MAX,
+};
+
 static void kgdb_register_callbacks(void)
 {
 	if (!kgdb_io_module_registered) {
 		kgdb_io_module_registered = 1;
 		kgdb_arch_init();
+		atomic_notifier_chain_register(&panic_notifier_list,
+					       &kgdb_panic_event_nb);
 #ifdef CONFIG_MAGIC_SYSRQ
 		register_sysrq_key('g', &sysrq_dbg_op);
 #endif
@@ -786,6 +803,8 @@ static void kgdb_unregister_callbacks(void)
 	 */
 	if (kgdb_io_module_registered) {
 		kgdb_io_module_registered = 0;
+		atomic_notifier_chain_unregister(&panic_notifier_list,
+					       &kgdb_panic_event_nb);
 		kgdb_arch_exit();
 #ifdef CONFIG_MAGIC_SYSRQ
 		unregister_sysrq_key('g', &sysrq_dbg_op);
-- 
1.6.3.3

