Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab1EKAXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 20:23:21 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:41787 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab1EKAXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 20:23:13 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, "Ted Ts'o" <tytso@mit.edu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: [PATCH 2/3] printk: Add %ptc to safely print a task's comm
Date: Tue, 10 May 2011 17:23:05 -0700
Message-Id: <1305073386-4810-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1305073386-4810-1-git-send-email-john.stultz@linaro.org>
References: <1305073386-4810-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acessing task->comm requires proper locking. However in the past
access to current->comm could be done without locking. This
is no longer the case, so all comm access needs to be done
while holding the comm_lock.

In my attempt to clean up unprotected comm access, I've noticed
most comm access is done for printk output. To simpify correct
locking in these cases, I've introduced a new %ptc format,
which will safely print the corresponding task's comm.

Example use:
printk("%ptc: unaligned epc - sending SIGBUS.\n", current);

CC: Ted Ts'o <tytso@mit.edu>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: David Rientjes <rientjes@google.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 lib/vsprintf.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index bc0ac6b..b9c97b8 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -797,6 +797,26 @@ char *uuid_string(char *buf, char *end, const u8 *addr,
 	return string(buf, end, uuid, spec);
 }
 
+static noinline_for_stack
+char *task_comm_string(char *buf, char *end, u8 *addr,
+			 struct printf_spec spec, const char *fmt)
+{
+	struct task_struct *tsk = (struct task_struct *) addr;
+	char *ret;
+	unsigned long seq;
+
+	do {
+		seq = read_seqbegin(&tsk->comm_lock);
+
+		ret = string(buf, end, tsk->comm, spec);
+
+	} while (read_seqretry(&tsk->comm_lock, seq));
+
+	return ret;
+}
+
+
+
 int kptr_restrict = 1;
 
 /*
@@ -864,6 +884,12 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	}
 
 	switch (*fmt) {
+	case 't':
+		switch (fmt[1]) {
+		case 'c':
+			return task_comm_string(buf, end, ptr, spec, fmt);
+		}
+		break;
 	case 'F':
 	case 'f':
 		ptr = dereference_function_descriptor(ptr);
@@ -1151,6 +1177,7 @@ qualifier:
  *   http://tools.ietf.org/html/draft-ietf-6man-text-addr-representation-00
  * %pU[bBlL] print a UUID/GUID in big or little endian using lower or upper
  *   case.
+ * %ptc outputs the task's comm name
  * %n is ignored
  *
  * The return value is the number of characters which would
-- 
1.7.3.2.146.gca209

