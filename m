Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031000Ab2LGVla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 16:41:30 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:39793 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030990Ab2LGVl2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 16:41:28 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>
CC: "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: [RFC][PATCH] pstore: Skip spinlock when just one cpu is online
Thread-Topic: [RFC][PATCH] pstore: Skip spinlock when just one cpu is online
Thread-Index: Ac3UwvCZixvXisXmRfC/Xc8ha8nnHA==
Date: Fri, 7 Dec 2012 21:41:13 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A1B7B2@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8185,1.0.431,0.0.0000
 definitions=2012-12-07_04:2012-12-07,2012-12-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1212070211
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Issue]

If one cpu ,which is taking a psinfo->buf_lock, 
receive NMI from a panicked cpu via smp_send_stop(),
the panicked cpu hangs up in pstore_dump() called by kmsg_dump(KMSG_DUMP_PANIC)
because the psinfo->buf_lock is taken again in it.

To avoid the deadlock, an easy solution is moving kmsg_dump above
smp_send_stop() in panic path.

But, it is not safe to kick pstore while multiple cpus are running in panic case,
because they may touch corrupted data/variables and unnecessary failures may happen.
In that case, we can't guarantee that a panicked cpu can log messages reliably
because it may have harmful effects due to the failures.

[Solution]

This patch skips taking a psinfo->buf_lock when just one cpu is online
because stopped cpus turn to offline via smp_send_stop()
in some architectures like x86, powerpc or arm64.

It may be a hack but solves my concern deadlocking in x86 architecture.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
---
 fs/pstore/platform.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 947fbe0..ca4d2ab 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -107,7 +107,7 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 	unsigned long	total = 0;
 	const char	*why;
 	u64		id;
-	unsigned int	part = 1;
+	unsigned int	part = 1, cpu_num = num_online_cpus();
 	unsigned long	flags = 0;
 	int		is_locked = 0;
 	int		ret;
@@ -118,8 +118,14 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 		is_locked = spin_trylock(&psinfo->buf_lock);
 		if (!is_locked)
 			pr_err("pstore dump routine blocked in NMI, may corrupt error record\n");
-	} else
+	} else if (cpu_num > 1) {
+		/*
+		 * Take a spin lock only when multiple cpus are online.
+		 */
 		spin_lock_irqsave(&psinfo->buf_lock, flags);
+	} else
+		local_irq_save(flags);
+
 	oopscount++;
 	while (total < kmsg_bytes) {
 		char *dst;
@@ -146,8 +152,10 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 	if (in_nmi()) {
 		if (is_locked)
 			spin_unlock(&psinfo->buf_lock);
-	} else
+	} else if (cpu_num > 1) {
 		spin_unlock_irqrestore(&psinfo->buf_lock, flags);
+	} else
+		local_irq_restore(flags);
 }
 
 static struct kmsg_dumper pstore_dumper = {
-- 1.7.1
