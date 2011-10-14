Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab1JNUxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 16:53:40 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:55279 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab1JNUxj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 16:53:39 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, Don Zickus <dzickus@redhat.com>,
        Matthew Garrett <mjg@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Chen, Gong" <gong.chen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "hughd@chromium.org" <hughd@chromium.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Fri, 14 Oct 2011 16:53:05 -0400
Subject: [RFC][PATCH -next] make pstore/kmsg_dump run after stopping other
 cpus in panic path
Thread-Topic: [RFC][PATCH -next] make pstore/kmsg_dump run after stopping
 other cpus in panic path
Thread-Index: AcyKs0VO9qZUh8RlSGGlCD9bOxy/JA==
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C5747DC7B@USINDEVS01.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1110140259
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
 
 As Don mentioned in following thread, it would be nice for pstore/kmsg_dump to serialize 
 panic path and have one cpu running because they can log messages reliably. 
 
 https://lkml.org/lkml/2011/10/13/427
 
 For realizing this idea, we have to move kmsg_dump below smp_send_stop() and bust some locks 
 of kmsg_dump/pstore in panic path.

 This patch does followings.

  - moving kmsg_dump(KMSG_DUMP_PANIC) below smp_send_stop.
  - busting logbuf_lock of kmsg_dump() in panic path for avoiding deadlock.
  - busting psinfo->buf_lock of pstore_dump() in panic path for avoiding deadlock.

Any comments are welcome.

 Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>

---
 fs/pstore/platform.c |   22 ++++++++++------------
 kernel/panic.c       |    4 ++--
 kernel/printk.c      |    7 +++++++
 3 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 2bd620f..e73d940 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -90,19 +90,21 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 	int		hsize, ret;
 	unsigned int	part = 1;
 	unsigned long	flags = 0;
-	int		is_locked = 0;
 
 	if (reason < ARRAY_SIZE(reason_str))
 		why = reason_str[reason];
 	else
 		why = "Unknown";
 
-	if (in_nmi()) {
-		is_locked = spin_trylock(&psinfo->buf_lock);
-		if (!is_locked)
-			pr_err("pstore dump routine blocked in NMI, may corrupt error record\n");
-	} else
-		spin_lock_irqsave(&psinfo->buf_lock, flags);
+	/*
+	 * pstore_dump() is called after smp_send_stop() in panic path.
+	 * So, spin_lock should be bust for avoiding deadlock.
+	 */
+	if (reason == KMSG_DUMP_PANIC)
+		spin_lock_init(&psinfo->buf_lock);
+
+	spin_lock_irqsave(&psinfo->buf_lock, flags);
+
 	oopscount++;
 	while (total < kmsg_bytes) {
 		dst = psinfo->buf;
@@ -131,11 +133,7 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 		total += l1_cpy + l2_cpy;
 		part++;
 	}
-	if (in_nmi()) {
-		if (is_locked)
-			spin_unlock(&psinfo->buf_lock);
-	} else
-		spin_unlock_irqrestore(&psinfo->buf_lock, flags);
+	spin_unlock_irqrestore(&psinfo->buf_lock, flags);
 }
 
 static struct kmsg_dumper pstore_dumper = {
diff --git a/kernel/panic.c b/kernel/panic.c
index d7bb697..41bf6ad 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -88,8 +88,6 @@ NORET_TYPE void panic(const char * fmt, ...)
 	 */
 	crash_kexec(NULL);
 
-	kmsg_dump(KMSG_DUMP_PANIC);
-
 	/*
 	 * Note smp_send_stop is the usual smp shutdown function, which
 	 * unfortunately means it may not be hardened to work in a panic
@@ -97,6 +95,8 @@ NORET_TYPE void panic(const char * fmt, ...)
 	 */
 	smp_send_stop();
 
+	kmsg_dump(KMSG_DUMP_PANIC);
+
 	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
 
 	bust_spinlocks(0);
diff --git a/kernel/printk.c b/kernel/printk.c
index 1455a0d..e1e57db 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1732,6 +1732,13 @@ void kmsg_dump(enum kmsg_dump_reason reason)
 	unsigned long l1, l2;
 	unsigned long flags;
 
+	/*
+	 *  kmsg_dump() is called after smp_send_stop() in panic path.
+	 *  So, spin_lock should be bust for avoiding deadlock.
+	 */
+	if (reason == KMSG_DUMP_PANIC)
+		raw_spin_lock_init(&logbuf_lock);
+
 	/* Theoretically, the log could move on after we do this, but
 	   there's not a lot we can do about that. The new messages
 	   will overwrite the start of what we dump. */
-- 
1.7.1
