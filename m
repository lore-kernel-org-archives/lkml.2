Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab1JUV0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 17:26:43 -0400
Received: from usindpps05.hds.com ([207.126.252.18]:60882 "EHLO
	usindpps05.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab1JUV0k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 17:26:40 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Chen, Gong" <gong.chen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, Matthew Garrett <mjg@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "hughd@chromium.org" <hughd@chromium.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        Don Zickus <dzickus@redhat.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Fri, 21 Oct 2011 17:21:35 -0400
Subject: [RFC][PATCH v2 -next 2/2] Adding lock operations to
 kmsg_dump()/pstore_dump()
Thread-Topic: [RFC][PATCH v2 -next 2/2] Adding lock operations to
 kmsg_dump()/pstore_dump()
Thread-Index: AcyQNw89n12xggQmR/WpacFE5kCaEQAAAVKAAAAJqpA=
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C576122A9@USINDEVS01.corp.hds.com>
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
 definitions=main-1110210254
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pstore_dump()/kmsg_dump() may be called everywhere in kernel.
So we have to care about following cases.

  - Panic path
    In this case, Logging message process is serialized via smp_send_stop().
    So, we can bust spin_locks.

    Currently, kmsg_dump() may be called twice (KMSG_DUMP_PANIC and KMSG_DUMP_EMERGY)
    So, for avoiding deadlock, I suggest to bust locks rather than skipping them.

  - NMI context 
     While a cpu is in NMI handler, other cpus may be running.
     So, trylock should be called so that lockdep cheking works.
 
  - Process context
    In this case, we can simply take locks.

Patch Descriptions:
  Adding a lock operation below in pstore_dump()
  - busting psinfo->buf_lock of pstore_dump() in panic path for avoiding deadlock.

  Adding lock operations below in kmsg_dump()
  - busting logbuf_lock of kmsg_dump() in panic path for avoiding deadlock.
  - Adding trylock for taking logbuf_lock of kmsg_dump() in NMI context. 
  

 Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>

---
 fs/pstore/platform.c |   11 +++++++++++
 kernel/printk.c      |   28 +++++++++++++++++++++++++---
 2 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 2bd620f..91ef164 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -97,6 +97,17 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 	else
 		why = "Unknown";
 
+	/*
+	 * pstore_dump() is called after smp_send_stop() in panic path.
+	 * So, spin_lock should be bust for avoiding deadlock.
+	 */
+	if (reason == KMSG_DUMP_PANIC)
+		spin_lock_init(&psinfo->buf_lock);
+
+	/*
+	 * While a cpu is in NMI handler, other cpus may be running.
+	 * So, trylock should be called so that lockdep checking works.
+	 */
 	if (in_nmi()) {
 		is_locked = spin_trylock(&psinfo->buf_lock);
 		if (!is_locked)
diff --git a/kernel/printk.c b/kernel/printk.c
index 1455a0d..f51f547 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1730,15 +1730,37 @@ void kmsg_dump(enum kmsg_dump_reason reason)
 	struct kmsg_dumper *dumper;
 	const char *s1, *s2;
 	unsigned long l1, l2;
-	unsigned long flags;
+	unsigned long flags = 0;
+	int is_locked = 0;
 
 	/* Theoretically, the log could move on after we do this, but
 	   there's not a lot we can do about that. The new messages
 	   will overwrite the start of what we dump. */
-	raw_spin_lock_irqsave(&logbuf_lock, flags);
+
+	/*
+	 * kmsg_dump() is called after smp_send_stop() in panic path.
+	 * So, spin_lock should be bust for avoiding deadlock.
+	 */
+	if (reason == KMSG_DUMP_PANIC)
+		raw_spin_lock_init(&logbuf_lock);
+	/*
+	 * While a cpu is in NMI handler, other cpus may be running.
+	 * So, trylock should be called so that lockdep checking works.
+	 */
+	if (in_nmi())
+		is_locked = raw_spin_trylock(&logbuf_lock);
+	else
+		raw_spin_lock_irqsave(&logbuf_lock, flags);
+
 	end = log_end & LOG_BUF_MASK;
 	chars = logged_chars;
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+
+	if (in_nmi()) {
+		if (is_locked)
+			raw_spin_unlock(&logbuf_lock);
+	} else
+		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+
 
 	if (chars > end) {
 		s1 = log_buf + log_buf_len - chars + end;
-- 1.7.1
