Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab1LBWOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 17:14:18 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:53504 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007Ab1LBWOR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 17:14:17 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, Don Zickus <dzickus@redhat.com>,
        Matthew Garrett <mjg@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Chen, Gong" <gong.chen@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "'ying.huang@intel.com'" <'ying.huang@intel.com'>,
        "'ak@linux.intel.com'" <'ak@linux.intel.com'>,
        "'hughd@chromium.org'" <'hughd@chromium.org'>,
        "'mingo@elte.hu'" <'mingo@elte.hu'>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Fri, 2 Dec 2011 17:12:43 -0500
Subject: [RFC][PATCH v3 3/3]skip subsequent kmsg_dump() function calls in
 panic path
Thread-Topic: [RFC][PATCH v3 3/3]skip subsequent kmsg_dump() function calls
 in panic path
Thread-Index: AcyxPu4fSl+qdT7oRSamPJnbrxOQwwAAEjeA
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C57DC0D11@USINDEVS01.corp.hds.com>
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
 definitions=main-1112020256
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch skips subsequent kmsg_dump() function calls in panic path

With this patch, we can avoid deadlock due to the subsequent calls.
Actually, kmsg_dump(KMSG_DUMP_EMERG) is called after kmsg_dump(KMSG_DUMP_PANIC) 
when panic_timeout variable is set.

 Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>

---
 kernel/printk.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index bc5ac61..25d6dc1 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1731,6 +1731,16 @@ void kmsg_dump(enum kmsg_dump_reason reason)
 	const char *s1, *s2;
 	unsigned long l1, l2;
 	unsigned long flags;
+	static bool panicked;
+
+	/*
+	 * kmsg_dump() is skipped because we already got panic log.
+	 */
+	if (panicked)
+		return;
+
+	if (reason == KMSG_DUMP_PANIC)
+		panicked = true;
 
 	WARN_ON(in_nmi() && reason != KMSG_DUMP_PANIC);
 
-- 
1.7.1


