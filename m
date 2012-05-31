Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab2EaVtx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 17:49:53 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:47896 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab2EaVtw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 17:49:52 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Thu, 31 May 2012 17:49:19 -0400
Subject: [Patch -tip]Skip spin_lock of pstore_dump in panic case
Thread-Topic: [Patch -tip]Skip spin_lock of pstore_dump in panic case
Thread-Index: Ac0/drD0aB/8YQaXReaQzEZfpjRBFg==
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2E5A22B984@USINDEVS01.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=11 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1205310250
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I would like to discuss a way to avoid deadlocking of pstore_dump(), kmsg_dump() and platform drivers.
At first, I post pstore_dump() part.

This patch is based on following comments on my previous patch.
http://marc.info/?l=linux-kernel&m=131914554220738&w=2
http://marc.info/?l=linux-kernel&m=132370565114963&w=2

The points are skipping spin_lock in panic case and adding WARN_ON in preparation for future change.

Any comments are welcome.

Seiji

[Patch Description]

This patch does followings.

   - Skip a spin_lock of pstore_dump() in panic case because pstore_dump() is serialized via smp_send_stop.

   - Add WARN_ON() in "in_nmi() and !panic" case into pstore_dump(). Currently, this condition never
     becomes true. But if someone adds new kmsg_dump() into NMI path in the future, error record may corrupt. 
     We can trap it and complain with it.


 Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>

---
 fs/pstore/platform.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c index 82c585f..e5a0354 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -31,6 +31,8 @@
 #include <linux/hardirq.h>
 #include <linux/workqueue.h>
 
+#include <asm-generic/bug.h>
+
 #include "internal.h"
 
 /*
@@ -107,15 +109,21 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 	int		hsize, ret;
 	unsigned int	part = 1;
 	unsigned long	flags = 0;
-	int		is_locked = 0;
 
 	why = get_reason_str(reason);
 
-	if (in_nmi()) {
-		is_locked = spin_trylock(&psinfo->buf_lock);
-		if (!is_locked)
-			pr_err("pstore dump routine blocked in NMI, may corrupt error record\n");
-	} else
+	/*
+	 * Currently, this condition never becomes true.
+	 * But if someone adds new kmsg_dump() into NMI path in the future,
+	 * error record may corrupt. We can trap it and complain with it.
+	 */
+	WARN_ON(in_nmi() && reason != KMSG_DUMP_PANIC);
+
+	/*
+	 * pstore_dump() is serialized in panic case.
+	 * So, we don't need to take any locks.
+	 */
+	if (reason != KMSG_DUMP_PANIC)
 		spin_lock_irqsave(&psinfo->buf_lock, flags);
 	oopscount++;
 	while (total < kmsg_bytes) {
@@ -145,10 +153,8 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 		total += l1_cpy + l2_cpy;
 		part++;
 	}
-	if (in_nmi()) {
-		if (is_locked)
-			spin_unlock(&psinfo->buf_lock);
-	} else
+
+	if (reason != KMSG_DUMP_PANIC)
 		spin_unlock_irqrestore(&psinfo->buf_lock, flags);  }
 
--
1.7.1
