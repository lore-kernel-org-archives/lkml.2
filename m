Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab2LTPMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 10:12:30 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:54164 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab2LTPMZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 10:12:25 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>
CC: "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>
Subject: [PATCH v3 1/2] pstore: Avoid deadlock in panic and
 emergency-restart path
Thread-Topic: [PATCH v3 1/2] pstore: Avoid deadlock in panic and
 emergency-restart path
Thread-Index: Ac3exFdBKrlqfcQKQf24y8a+iQwKcA==
Date: Thu, 20 Dec 2012 15:12:12 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A2A05C@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2012-12-20_05:2012-12-20,2012-12-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1212200121
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Issue]

When pstore is in panic and emergency-restart paths, it may be blocked
in those paths because it simply takes spin_lock.

This is an example scenario which pstore may hang up in a panic path:

 - cpuA grabs psinfo->buf_lock
 - cpuB panics and calls smp_send_stop
 - smp_send_stop sends IRQ to cpuA
 - after 1 second, cpuB gives up on cpuA and sends an NMI instead
 - cpuA is now in an NMI handler while still holding buf_lock
 - cpuB is deadlocked

This case may happen if a firmware has a bug and 
cpuA is stuck talking with it more than one second.

Also, this is a similar scenario in an emergency-restart path:
 
 - cpuA grabs psinfo->buf_lock and stucks in a firmware
 - cpuB kicks emergency-restart via either sysrq-b or hangcheck timer.
   And then, cpuB is deadlocked by taking psinfo->buf_lock again.

[Solution]

This patch avoids the deadlocking issues in both panic and emergency_restart
paths by introducing a function, pstore_cannot_block_path(), to check if a cpu 
can be blocked in current path.

With this patch, pstore is not blocked even if another cpu has 
taken a spin_lock, in those paths by changing from spin_lock_irqsave 
to spin_trylock_irqsave.

In addition, according to a comment of emergency_restart() in kernel/sys.c,
spin_lock shouldn't be taken in an emergency_restart path to avoid
deadlock. This patch fits the comment below.

<snip>
/**
 *      emergency_restart - reboot the system
 *
 *      Without shutting down any hardware or taking any locks
 *      reboot the system.  This is called when we know we are in
 *      trouble so this is our best effort to reboot.  This is
 *      safe to call in interrupt context.
 */
void emergency_restart(void)
<snip>

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
---
 fs/pstore/platform.c   |   34 ++++++++++++++++++++++++++++------
 include/linux/pstore.h |    6 ++++++
 2 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 5ea2e77..6bd3369 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -96,6 +96,26 @@ static const char *get_reason_str(enum kmsg_dump_reason reason)
 	}
 }
 
+bool pstore_cannot_block_path(enum kmsg_dump_reason reason)
+{
+	/*
+	 * In case of NMI path, pstore shouldn't be blocked
+	 * regardless of reason.
+	 */
+	if (in_nmi())
+		return true;
+
+	switch (reason) {
+	/* In panic case, other cpus are stopped by smp_send_stop(). */
+	case KMSG_DUMP_PANIC:
+	/* Emergency restart shouldn't be blocked by spin lock. */
+	case KMSG_DUMP_EMERG:
+		return true;
+	default:
+		return false;
+	}
+}
+
 /*
  * callback from kmsg_dump. (s2,l2) has the most recently
  * written bytes, older bytes are in (s1,l1). Save as much
@@ -114,10 +134,12 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 
 	why = get_reason_str(reason);
 
-	if (in_nmi()) {
-		is_locked = spin_trylock(&psinfo->buf_lock);
-		if (!is_locked)
-			pr_err("pstore dump routine blocked in NMI, may corrupt error record\n");
+	if (pstore_cannot_block_path(reason)) {
+		is_locked = spin_trylock_irqsave(&psinfo->buf_lock, flags);
+		if (!is_locked) {
+			pr_err("pstore dump routine blocked in %s path, may corrupt error record\n"
+				       , in_nmi() ? "NMI" : why);
+		}
 	} else
 		spin_lock_irqsave(&psinfo->buf_lock, flags);
 	oopscount++;
@@ -143,9 +165,9 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 		total += hsize + len;
 		part++;
 	}
-	if (in_nmi()) {
+	if (pstore_cannot_block_path(reason)) {
 		if (is_locked)
-			spin_unlock(&psinfo->buf_lock);
+			spin_unlock_irqrestore(&psinfo->buf_lock, flags);
 	} else
 		spin_unlock_irqrestore(&psinfo->buf_lock, flags);
 }
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index 1788909..75d0176 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -68,12 +68,18 @@ struct pstore_info {
 
 #ifdef CONFIG_PSTORE
 extern int pstore_register(struct pstore_info *);
+extern bool pstore_cannot_block_path(enum kmsg_dump_reason reason);
 #else
 static inline int
 pstore_register(struct pstore_info *psi)
 {
 	return -ENODEV;
 }
+static inline bool
+pstore_cannot_block_path(enum kmsg_dump_reason reason)
+{
+	return false;
+}
 #endif
 
 #endif /*_LINUX_PSTORE_H*/
-- 1.7.1


