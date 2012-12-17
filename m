Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab2LQU6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 15:58:13 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:55710 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab2LQU6M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 15:58:12 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>
CC: "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>
Subject: [PATCH v2 2/2] efi_pstore: Avoid deadlock in non-blocking paths
Thread-Topic: [PATCH v2 2/2] efi_pstore: Avoid deadlock in non-blocking paths
Thread-Index: Ac3cmR/1ASCEV/5GQgGdx063vyHRBg==
Date: Mon, 17 Dec 2012 20:57:52 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A22F28@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2012-12-17_04:2012-12-17,2012-12-17,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1212170193
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Issue]

There is a scenario which efi_pstore may hang up:

 - cpuA grabs efivars->lock
 - cpuB panics and calls smp_send_stop
 - smp_send_stop sends IRQ to cpuA
 - after 1 second, cpuB gives up on cpuA and sends an NMI instead
 - cpuA is now in an NMI handler while still holding efivars->lock
 - cpuB is deadlocked

This case may happen if a firmware has a bug and 
cpuA is stuck talking with it.

[Solution]

This patch changes a spin_lock to a spin_trylock in non-blocking paths.
and if the spin_lock has already taken by another cpu,
it returns without accessing to a firmware to avoid the deadlock.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
---
 drivers/firmware/efivars.c |   11 ++++++++++-
 fs/pstore/platform.c       |    6 +++---
 include/linux/pstore.h     |    6 ++++++
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 52c5d89..25d464e 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -1210,7 +1210,16 @@ static int efi_pstore_write(enum pstore_type_id type,
 	u64 storage_space, remaining_space, max_variable_size;
 	efi_status_t status = EFI_NOT_FOUND;
 
-	spin_lock(&efivars->lock);
+	if (pstore_is_non_blocking_path(reason)) {
+		/*
+		 * If the lock is taken by another cpu in non-blocking path,
+		 * this driver returns without entering firmware to avoid
+		 * hanging up.
+		 */
+		if (!spin_trylock(&efivars->lock))
+			return -EBUSY;
+	} else
+		spin_lock(&efivars->lock);
 
 	/*
 	 * Check if there is a space enough to log.
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index b87d1de..f959eba 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -96,7 +96,7 @@ static const char *get_reason_str(enum kmsg_dump_reason reason)
 	}
 }
 
-static bool is_non_blocking_path(enum kmsg_dump_reason reason)
+bool pstore_is_non_blocking_path(enum kmsg_dump_reason reason)
 {
 	/*
 	 * In case of NMI path, pstore shouldn't be blocked
@@ -134,7 +134,7 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 
 	why = get_reason_str(reason);
 
-	if (is_non_blocking_path(reason)) {
+	if (pstore_is_non_blocking_path(reason)) {
 		is_locked = spin_trylock_irqsave(&psinfo->buf_lock, flags);
 		if (!is_locked) {
 			pr_err("pstore dump routine blocked in %s path, may corrupt error record\n"
@@ -165,7 +165,7 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 		total += hsize + len;
 		part++;
 	}
-	if (is_non_blocking_path(reason)) {
+	if (pstore_is_non_blocking_path(reason)) {
 		if (is_locked)
 			spin_unlock_irqrestore(&psinfo->buf_lock, flags);
 	} else
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index 1788909..595a040 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -68,12 +68,18 @@ struct pstore_info {
 
 #ifdef CONFIG_PSTORE
 extern int pstore_register(struct pstore_info *);
+extern bool pstore_is_non_blocking_path(enum kmsg_dump_reason reason);
 #else
 static inline int
 pstore_register(struct pstore_info *psi)
 {
 	return -ENODEV;
 }
+static inline bool
+pstore_is_non_blocking_path(enum kmsg_dump_reason reason)
+{
+	return false;
+}
 #endif
 
 #endif /*_LINUX_PSTORE_H*/
-- 
1.7.1

