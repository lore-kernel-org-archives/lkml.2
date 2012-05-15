Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344Ab2EOVfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 17:35:40 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:32769 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab2EOVfi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 17:35:38 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Tue, 15 May 2012 17:35:09 -0400
Subject: [PATCH -tip] Move kmsg_dump(KMSG_DUMP_PANIC) below smp_send_stop()
Thread-Topic: [PATCH -tip] Move kmsg_dump(KMSG_DUMP_PANIC) below
 smp_send_stop()
Thread-Index: Ac0y4lSR7cToQJVcS0e3D0gDV6eysg==
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2E4D7A5CE2@USINDEVS01.corp.hds.com>
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
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1205150264
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

 As Don mentioned in following thread, it would be nice for pstore/kmsg_dump to serialize  
panic path because they can log messages reliably.

 https://lkml.org/lkml/2011/10/13/427

 This patch is based on Don's proposal switching smp_send_stop() from REBOOT_VECTOR to NMI 
 which has already merged to -tip tree.
 
 https://lkml.org/lkml/2012/5/14/145

[Patch Description]
This patch just moves kmsg_dump(KMSG_DUMP_PANIC) below smp_send_stop  for serializing 
logging process via smp_send_stop.

 Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
 Acked-by: Don Zickus <dzickus@redhat.com>

---
 kernel/panic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c index 80aed44..da585b8 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -108,8 +108,6 @@ void panic(const char *fmt, ...)
 	 */
 	crash_kexec(NULL);
 
-	kmsg_dump(KMSG_DUMP_PANIC);
-
 	/*
 	 * Note smp_send_stop is the usual smp shutdown function, which
 	 * unfortunately means it may not be hardened to work in a panic @@ -117,6 +115,8 @@ void panic(const char *fmt, ...)
 	 */
 	smp_send_stop();
 
+	kmsg_dump(KMSG_DUMP_PANIC);
+
 	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
 
 	bust_spinlocks(0);
-- 1.7.1
