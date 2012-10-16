Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab2JPBVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 21:21:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47181 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547Ab2JPBV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 21:21:26 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Colin Cross <ccross@google.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 7/7] kdb: Add kiosk mode
Date: Mon, 15 Oct 2012 18:18:05 -0700
Message-Id: <1350350285-3095-7-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <20121016011724.GB23146@lizard>
References: <20121016011724.GB23146@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By issuing 'echo 1 > /sys/module/kdb/parameters/kiosk' or
booting with kdb.kiosk=1 kernel command line option, one can still have
a somewhat usable debugging facility, but not fearing that the
debugger can be used to easily gain root access or dump sensitive data.

Without the kiosk mode, obtaining the root rights via KDB is a matter of
a few commands, and works everywhere. For example, log in as a normal
user:

cbou:~$ id
uid=1001(cbou) gid=1001(cbou) groups=1001(cbou)

Now enter KDB (for example via sysrq):

Entering kdb (current=0xffff8800065bc740, pid 920) due to Keyboard Entry
kdb> ps
23 sleeping system daemon (state M) processes suppressed,
use 'ps A' to see all.
Task Addr               Pid   Parent [*] cpu State Thread             Command
0xffff8800065bc740      920      919  1    0   R  0xffff8800065bca20 *bash

0xffff880007078000        1        0  0    0   S  0xffff8800070782e0  init
[...snip...]
0xffff8800065be3c0      918        1  0    0   S  0xffff8800065be6a0  getty
0xffff8800065b9c80      919        1  0    0   S  0xffff8800065b9f60  login
0xffff8800065bc740      920      919  1    0   R  0xffff8800065bca20 *bash

All we need is the offset of cred pointers. We can look up the offset in
the distro's kernel source, but it is unnecessary. We can just start
dumping init's task_struct, until we see the process name:

kdb> md 0xffff880007078000
0xffff880007078000 0000000000000001 ffff88000703c000   ................
0xffff880007078010 0040210000000002 0000000000000000   .....!@.........
[...snip...]
0xffff8800070782b0 ffff8800073e0580 ffff8800073e0580   ..>.......>.....
0xffff8800070782c0 0000000074696e69 0000000000000000   init............

^ Here, 'init'. Creds are just above it, so the offset is 0x02b0.

Now we set up init's creds for our non-privileged shell:

kdb> mm 0xffff8800065bc740+0x02b0 0xffff8800073e0580
0xffff8800065bc9f0 = 0xffff8800073e0580
kdb> mm 0xffff8800065bc740+0x02b8 0xffff8800073e0580
0xffff8800065bc9f8 = 0xffff8800073e0580

And thus gaining the root:

kdb> go
cbou:~$ id
uid=0(root) gid=0(root) groups=0(root)
cbou:~$ bash
root:~#

p.s. No distro enables kdb by default (although, with a nice KDB-over-KMS
feature availability, I would expect at least some would enable it), so
it's not actually some kind of a major issue.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 include/linux/kdb.h         |  1 +
 kernel/debug/kdb/kdb_main.c | 20 +++++++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/include/linux/kdb.h b/include/linux/kdb.h
index abe927c..3a2c554 100644
--- a/include/linux/kdb.h
+++ b/include/linux/kdb.h
@@ -63,6 +63,7 @@ extern atomic_t kdb_event;
 #define KDB_BADLENGTH	(-19)
 #define KDB_NOBP	(-20)
 #define KDB_BADADDR	(-21)
+#define KDB_NOPERM	(-22)
 
 /*
  * kdb_diemsg
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 83c3f60..36e4c2a 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/ctype.h>
+#include <linux/types.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/kmsg_dump.h>
@@ -23,6 +24,7 @@
 #include <linux/vmalloc.h>
 #include <linux/atomic.h>
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/kallsyms.h>
@@ -42,6 +44,12 @@
 #include <linux/slab.h>
 #include "kdb_private.h"
 
+#undef	MODULE_PARAM_PREFIX
+#define	MODULE_PARAM_PREFIX "kdb."
+
+static bool kdb_kiosk;
+module_param_named(kiosk, kdb_kiosk, bool, 0600);
+
 #define GREP_LEN 256
 char kdb_grep_string[GREP_LEN];
 int kdb_grepping_flag;
@@ -121,6 +129,7 @@ static kdbmsg_t kdbmsgs[] = {
 	KDBMSG(BADLENGTH, "Invalid length field"),
 	KDBMSG(NOBP, "No Breakpoint exists"),
 	KDBMSG(BADADDR, "Invalid address"),
+	KDBMSG(NOPERM, "Permission denied"),
 };
 #undef KDBMSG
 
@@ -987,6 +996,14 @@ int kdb_parse(const char *cmdstr)
 
 	if (i < kdb_max_commands) {
 		int result;
+
+		if (kdb_kiosk) {
+			if (!(tp->cmd_flags & (KDB_SAFE | KDB_SAFE_NO_ARGS)))
+				return KDB_NOPERM;
+			if (tp->cmd_flags & KDB_SAFE_NO_ARGS && argc > 1)
+				return KDB_NOPERM;
+		}
+
 		KDB_STATE_SET(CMD);
 		result = (*tp->cmd_func)(argc-1, (const char **)argv);
 		if (result && ignore_errors && result > KDB_CMD_GO)
@@ -1009,7 +1026,7 @@ int kdb_parse(const char *cmdstr)
 	 * obtaining the address of a variable, or the nearest symbol
 	 * to an address contained in a register.
 	 */
-	{
+	if (!kdb_kiosk) {
 		unsigned long value;
 		char *name = NULL;
 		long offset;
@@ -1025,6 +1042,7 @@ int kdb_parse(const char *cmdstr)
 		kdb_printf("\n");
 		return 0;
 	}
+	return KDB_NOPERM;
 }
 
 
-- 
1.7.12.3

