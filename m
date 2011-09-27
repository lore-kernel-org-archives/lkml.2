Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab1I0RP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 13:15:27 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:45582 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab1I0RPZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 13:15:25 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>, Matthew Garrett <mjg@redhat.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "gong.chen@intel.com" <gong.chen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Tue, 27 Sep 2011 13:14:59 -0400
Subject: [RFC][PATCH -next] pstore: replace spin_lock with
 spin_trylock_irqsave in panic path
Thread-Topic: [RFC][PATCH -next] pstore: replace spin_lock with
 spin_trylock_irqsave in panic path
Thread-Index: Acx9OPxJPOhv1H5RSk2cuaOlYcdmNA==
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C56C9B823@USINDEVS01.corp.hds.com>
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
 definitions=main-1109270174
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[Problem]
Currently, pstore takes spin_trylock(&psinfo->buf_lock) in NMI context.
And it takes spin_lock(&psinfo->buf_lock) in other cases.

If there are some bugs in pstore and kernel panics, spin_lock(&psinfo->buf_lock) causes deadlock 
and panic_notifier_chain will not work.

[Patch Description]
For solving this problem, this patch replaces spin_lock with spin_trylock_irqsave in panic path.

Dead lock in panic path will not happen by applying this patch.

 Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>

---
 fs/pstore/platform.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c index 0472924..9882892 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -97,12 +97,15 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 	else
 		why = "Unknown";
 
-	if (in_nmi()) {
-		is_locked = spin_trylock(&psinfo->buf_lock);
-		if (!is_locked)
-			pr_err("pstore dump routine blocked in NMI, may corrupt error record\n");
+	if (reason == KMSG_DUMP_PANIC) {
+		is_locked = spin_trylock_irqsave(&psinfo->buf_lock, flags);
+		if (!is_locked) {
+			pr_err("pstore dump routine skipped in panic path\n");
+			return;
+		}
 	} else
 		spin_lock_irqsave(&psinfo->buf_lock, flags);
+
 	oopscount++;
 	while (total < kmsg_bytes) {
 		dst = psinfo->buf;
@@ -131,11 +134,7 @@ static void pstore_dump(struct kmsg_dumper *dumper,
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
--
1.7.1

