Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662Ab2IUAa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:30:26 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41756 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932596Ab2IUA3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:29:45 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-security-module@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 20 Sep 2012 17:28:45 -0700
Message-Id: <1348187330-6616-9-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348187330-6616-1-git-send-email-ebiederm@xmission.com>
References: <87k3vote43.fsf@xmission.com>
 <1348187330-6616-1-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/Q4yX7utYAXBHKBgAGpnLmI0sR+zEX/Xs=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1056]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_14 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-security-module@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 09/14] userns: Convert binder ipc to use kuids
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Arve Hjønnevåg <arve@android.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/staging/android/binder.c |   14 +++++++-------
 init/Kconfig                     |    3 ---
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 574e992..8e35d4b 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -47,7 +47,7 @@ static HLIST_HEAD(binder_dead_nodes);
 static struct dentry *binder_debugfs_dir_entry_root;
 static struct dentry *binder_debugfs_dir_entry_proc;
 static struct binder_node *binder_context_mgr_node;
-static uid_t binder_context_mgr_uid = -1;
+static kuid_t binder_context_mgr_uid = INVALID_UID;
 static int binder_last_id;
 static struct workqueue_struct *binder_deferred_workqueue;
 
@@ -356,7 +356,7 @@ struct binder_transaction {
 	unsigned int	flags;
 	long	priority;
 	long	saved_priority;
-	uid_t	sender_euid;
+	kuid_t	sender_euid;
 };
 
 static void
@@ -2427,7 +2427,7 @@ retry:
 		}
 		tr.code = t->code;
 		tr.flags = t->flags;
-		tr.sender_euid = t->sender_euid;
+		tr.sender_euid = from_kuid(current_user_ns(), t->sender_euid);
 
 		if (t->from) {
 			struct task_struct *sender = t->from->proc->tsk;
@@ -2705,12 +2705,12 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			ret = -EBUSY;
 			goto err;
 		}
-		if (binder_context_mgr_uid != -1) {
-			if (binder_context_mgr_uid != current->cred->euid) {
+		if (uid_valid(binder_context_mgr_uid)) {
+			if (!uid_eq(binder_context_mgr_uid, current->cred->euid)) {
 				pr_err("binder: BINDER_SET_"
 				       "CONTEXT_MGR bad uid %d != %d\n",
-				       current->cred->euid,
-				       binder_context_mgr_uid);
+				       from_kuid(&init_user_ns, current->cred->euid),
+				       from_kuid(&init_user_ns, binder_context_mgr_uid));
 				ret = -EPERM;
 				goto err;
 			}
diff --git a/init/Kconfig b/init/Kconfig
index 570cd33..8691098 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -952,9 +952,6 @@ config UIDGID_CONVERTED
 	depends on UFS_FS = n
 	depends on XFS_FS = n
 
-	# The rare drivers that won't build
-	depends on ANDROID_BINDER_IPC = n
-
 config UIDGID_STRICT_TYPE_CHECKS
 	bool "Require conversions between uid/gids and their internal representation"
 	depends on UIDGID_CONVERTED
-- 
1.7.5.4

