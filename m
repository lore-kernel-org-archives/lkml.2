Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885Ab2CZQHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 12:07:09 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:52915 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540Ab2CZQHH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 12:07:07 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Adrian Hunter (adrian.hunter@intel.com)" <adrian.hunter@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "Chen Gong (gong.chen@linux.intel.com)" <gong.chen@linux.intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Mon, 26 Mar 2012 12:06:44 -0400
Subject: [PATCH -next] pstore: make reason_str robust for future
 re-arrangements of the enum values
Thread-Topic: [PATCH -next] pstore: make reason_str robust for future
 re-arrangements of the enum values
Thread-Index: Ac0LahopW88duHo8SlmKS3wYxugnHg==
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2E4B8EFF90@USINDEVS01.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=2 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1203260165
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Recently, there has been some changes in kmsg_dump() below and they have been applied to linus-tree. 
 (1) kmsg_dump(KMSG_DUMP_KEXEC) was removed.
     http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=a3dd3323058d281abd584b15ad4c5b65064d7a61

 (2) A order of "enum kmsg_dump_reason" was modified.
     http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=c22ab332902333f83766017478c1ef6607ace681

 This patch replaces get_reason_str() with reason_str array in accordance with akpm's comment below.
 https://lkml.org/lkml/2012/3/24/18

 It will not be broken by future re-arrangements of the enum values.

 Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>

---
 fs/pstore/platform.c |   32 ++++++++++++--------------------
 1 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 82c585f..e8a14cd 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -68,25 +68,14 @@ void pstore_set_kmsg_bytes(int bytes)
 /* Tag each group of saved records with a sequence number */
 static int	oopscount;
 
-static const char *get_reason_str(enum kmsg_dump_reason reason)
-{
-	switch (reason) {
-	case KMSG_DUMP_PANIC:
-		return "Panic";
-	case KMSG_DUMP_OOPS:
-		return "Oops";
-	case KMSG_DUMP_EMERG:
-		return "Emergency";
-	case KMSG_DUMP_RESTART:
-		return "Restart";
-	case KMSG_DUMP_HALT:
-		return "Halt";
-	case KMSG_DUMP_POWEROFF:
-		return "Poweroff";
-	default:
-		return "Unknown";
-	}
-}
+static const char * const reason_str[] = {
+	[KMSG_DUMP_PANIC] = "Panic",
+	[KMSG_DUMP_OOPS] = "Oops",
+	[KMSG_DUMP_EMERG] = "Emergency",
+	[KMSG_DUMP_RESTART] = "Restart",
+	[KMSG_DUMP_HALT] = "Halt",
+	[KMSG_DUMP_POWEROFF] = "Poweroff",
+};
 
 /*
  * callback from kmsg_dump. (s2,l2) has the most recently
@@ -109,7 +98,10 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 	unsigned long	flags = 0;
 	int		is_locked = 0;
 
-	why = get_reason_str(reason);
+	if (reason < ARRAY_SIZE(reason_str))
+		why = reason_str[reason];
+	else
+		why = "Unknown";
 
 	if (in_nmi()) {
 		is_locked = spin_trylock(&psinfo->buf_lock);
-- 1.7.1
