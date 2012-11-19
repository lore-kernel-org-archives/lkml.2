Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab2KSPRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:17:09 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:35508 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab2KSPRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:17:05 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Mon, 19 Nov 2012 07:12:37 -0800
Message-Id: <1353337961-12962-12-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353337961-12962-1-git-send-email-ebiederm@xmission.com>
References: <87lidx8wbo.fsf@xmission.com>
 <1353337961-12962-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1/sAryCx1jfLmZos0T6Ba8M2CmcWI95rBY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1631]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 12/16] userns: For /proc/self/{uid,gid}_map derive the lower userns from the struct file
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

To keep things sane in the context of file descriptor passing derive the
user namespace that uids are mapped into from the opener of the file
instead of from current.

When writing to the maps file the lower user namespace must always
be the parent user namespace, or setting the mapping simply does
not make sense.  Enforce that the opener of the file was in
the parent user namespace or the user namespace whose mapping
is being set.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/user_namespace.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index ce92f7e..89f6eae 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -391,7 +391,7 @@ static int uid_m_show(struct seq_file *seq, void *v)
 	struct user_namespace *lower_ns;
 	uid_t lower;
 
-	lower_ns = current_user_ns();
+	lower_ns = seq_user_ns(seq);
 	if ((lower_ns == ns) && lower_ns->parent)
 		lower_ns = lower_ns->parent;
 
@@ -412,7 +412,7 @@ static int gid_m_show(struct seq_file *seq, void *v)
 	struct user_namespace *lower_ns;
 	gid_t lower;
 
-	lower_ns = current_user_ns();
+	lower_ns = seq_user_ns(seq);
 	if ((lower_ns == ns) && lower_ns->parent)
 		lower_ns = lower_ns->parent;
 
@@ -688,10 +688,14 @@ ssize_t proc_uid_map_write(struct file *file, const char __user *buf, size_t siz
 {
 	struct seq_file *seq = file->private_data;
 	struct user_namespace *ns = seq->private;
+	struct user_namespace *seq_ns = seq_user_ns(seq);
 
 	if (!ns->parent)
 		return -EPERM;
 
+	if ((seq_ns != ns) && (seq_ns != ns->parent))
+		return -EPERM;
+
 	return map_write(file, buf, size, ppos, CAP_SETUID,
 			 &ns->uid_map, &ns->parent->uid_map);
 }
@@ -700,10 +704,14 @@ ssize_t proc_gid_map_write(struct file *file, const char __user *buf, size_t siz
 {
 	struct seq_file *seq = file->private_data;
 	struct user_namespace *ns = seq->private;
+	struct user_namespace *seq_ns = seq_user_ns(seq);
 
 	if (!ns->parent)
 		return -EPERM;
 
+	if ((seq_ns != ns) && (seq_ns != ns->parent))
+		return -EPERM;
+
 	return map_write(file, buf, size, ppos, CAP_SETGID,
 			 &ns->gid_map, &ns->parent->gid_map);
 }
-- 
1.7.5.4

