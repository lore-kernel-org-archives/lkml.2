Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423188Ab2CPRCM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 13:02:12 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:41712 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422649Ab2CPRCL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 13:02:11 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Adrian Hunter <adrian.hunter@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Chen Gong (gong.chen@linux.intel.com)" <gong.chen@linux.intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Fri, 16 Mar 2012 13:01:49 -0400
Subject: [Patch]Introduce get_reason_str() to pstore
Thread-Topic: [Patch]Introduce get_reason_str() to pstore
Thread-Index: Ac0Dlj2HPuOwl29EToeTHpI635UcRg==
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2E32064CDF@USINDEVS01.corp.hds.com>
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
 definitions=main-1203160157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Recently, there has been some changes in kmsg_dump() below and they have been applied to linus-tree. 
 (1) kmsg_dump(KMSG_DUMP_KEXEC) was removed.
     http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=a3dd3323058d281abd584b15ad4c5b65064d7a61

 (2) A order of "enum kmsg_dump_reason" was modified.
     http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=c22ab332902333f83766017478c1ef6607ace681

 This patch removes reason_str array and add get_reason_str() in accordance with Adrian's comment below.
 https://lkml.org/lkml/2012/3/16/63

 Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
 Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

---
 fs/pstore/platform.c |   30 ++++++++++++++++++++++--------
 1 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c index 9ec22d3..82c585f 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -68,9 +68,25 @@ void pstore_set_kmsg_bytes(int bytes)
 /* Tag each group of saved records with a sequence number */
 static int	oopscount;
 
-static char *reason_str[] = {
-	"Oops", "Panic", "Kexec", "Restart", "Halt", "Poweroff", "Emergency"
-};
+static const char *get_reason_str(enum kmsg_dump_reason reason) {
+	switch (reason) {
+	case KMSG_DUMP_PANIC:
+		return "Panic";
+	case KMSG_DUMP_OOPS:
+		return "Oops";
+	case KMSG_DUMP_EMERG:
+		return "Emergency";
+	case KMSG_DUMP_RESTART:
+		return "Restart";
+	case KMSG_DUMP_HALT:
+		return "Halt";
+	case KMSG_DUMP_POWEROFF:
+		return "Poweroff";
+	default:
+		return "Unknown";
+	}
+}
 
 /*
  * callback from kmsg_dump. (s2,l2) has the most recently @@ -85,17 +101,15 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 	unsigned long	s1_start, s2_start;
 	unsigned long	l1_cpy, l2_cpy;
 	unsigned long	size, total = 0;
-	char		*dst, *why;
+	char		*dst;
+	const char	*why;
 	u64		id;
 	int		hsize, ret;
 	unsigned int	part = 1;
 	unsigned long	flags = 0;
 	int		is_locked = 0;
 
-	if (reason < ARRAY_SIZE(reason_str))
-		why = reason_str[reason];
-	else
-		why = "Unknown";
+	why = get_reason_str(reason);
 
 	if (in_nmi()) {
 		is_locked = spin_trylock(&psinfo->buf_lock);
--
1.7.1
