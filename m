Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab2AERif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 12:38:35 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:45677 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195Ab2AERie convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 12:38:34 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Luck, Tony" <tony.luck@intel.com>, Don Zickus <dzickus@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Chen, Gong" <gong.chen@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        "'ying.huang@intel.com'" <'ying.huang@intel.com'>,
        "'ak@linux.intel.com'" <'ak@linux.intel.com'>,
        "'hughd@chromium.org'" <'hughd@chromium.org'>,
        "'mingo@elte.hu'" <'mingo@elte.hu'>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Thu, 5 Jan 2012 12:38:08 -0500
Subject: [RFC][PATCH v4 -next 2/4] Skip spin_locks in panic case and Add
 WARN_ON()
Thread-Topic: [RFC][PATCH v4 -next 2/4] Skip spin_locks in panic case and
 Add WARN_ON()
Thread-Index: AczL0HMFUhgCH34WQWyA76ETk3pYJwAAC3+A
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C5827AF83@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C5827AF7F@USINDEVS01.corp.hds.com>
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C5827AF7F@USINDEVS01.corp.hds.com>
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
 definitions=main-1201050179
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does followings.

   - Skip spin_locks in panic case in both kmsg_dump() and pstore_dump() because they are 
     serialized via smp_send_stop

   - Add WARN_ON() in "in_nmi() and !panic" case into kmsg_dump(). Currently, this case never 
     happens because only kmsg_dump(KMSG_DUMP_PANIC) is called in NMI case.
     But if someone adds new kmsg_dump() into NMI path in the future, kmsg_dump() may deadlock. 
     We can trap it and complain with this WARN_ON().
     

 With this patch, kmsg_dump()/pstore_dump() work as follows.
   panic case (KMSG_DUMP_PANIC):
     - don't take lock because they are serialized.

   not panic case (KMSG_DUMP_OOPS/KMSG_DUMP_EMERG/KMSG_DUMP_RESTART/KMSG_DUMP_HALT):
     - take locks normally
 
 Regarding as NMI case,
    - kmsg_dump()/pstore_dump() don't take locks, so deadlock issue will not happen
      because kmsg_dump() is called in just panic case with current implementation.
    - If someone adds new kmsg_dump() into NMI path, WARN_ON() is called.
      So we can trap it and ask to fix it.

 Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>

---
 fs/pstore/platform.c |   16 ++++++----------
 kernel/printk.c      |   20 ++++++++++++++++++--
 2 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 9ec22d3..426e77d 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -90,18 +90,17 @@ static void pstore_dump(struct kmsg_dumper *dumper,
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
+	/*
+	 * pstore_dump() is serialized in panic path.
+	 * So, we don't need to take any locks.
+	 */
+	if (reason != KMSG_DUMP_PANIC)
 		spin_lock_irqsave(&psinfo->buf_lock, flags);
 	oopscount++;
 	while (total < kmsg_bytes) {
@@ -131,10 +130,7 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 		total += l1_cpy + l2_cpy;
 		part++;
 	}
-	if (in_nmi()) {
-		if (is_locked)
-			spin_unlock(&psinfo->buf_lock);
-	} else
+	if (reason != KMSG_DUMP_PANIC)
 		spin_unlock_irqrestore(&psinfo->buf_lock, flags);
 }
 
diff --git a/kernel/printk.c b/kernel/printk.c
index 13c0a11..5294426 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1732,13 +1732,29 @@ void kmsg_dump(enum kmsg_dump_reason reason)
 	unsigned long l1, l2;
 	unsigned long flags;
 
+	/*
+	 * Currently, "in_nmi() && reason != KMSG_DUMP_PANIC" case never happens
+	 * because ,in NMI path, only kmsg_dump(KMSG_DUMP_PANIC) is called.
+	 * But if someone adds new kmsg_dump() into NMI path in the future,
+	 * kmsg_dump() may deadlock. We can trap it and complain
+	 * with this WARN_ON().
+	 */
+	WARN_ON(in_nmi() && reason != KMSG_DUMP_PANIC);
+
 	/* Theoretically, the log could move on after we do this, but
 	   there's not a lot we can do about that. The new messages
 	   will overwrite the start of what we dump. */
-	raw_spin_lock_irqsave(&logbuf_lock, flags);
+
+	/*
+	 * kmsg_dump(KMSG_DUMP_PANIC) is serialized.
+	 * So, we don't need to take any locks.
+	 */
+	if (reason != KMSG_DUMP_PANIC)
+		raw_spin_lock_irqsave(&logbuf_lock, flags);
 	end = log_end & LOG_BUF_MASK;
 	chars = logged_chars;
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+	if (reason != KMSG_DUMP_PANIC)
+		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
 	if (chars > end) {
 		s1 = log_buf + log_buf_len - chars + end;
-- 
1.7.1

