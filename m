Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708Ab1FPVHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 17:07:55 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:50776 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab1FPVHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 17:07:53 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Date: Thu, 16 Jun 2011 14:07:49 -0700
Message-ID: <m162o5bi3e.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19kiv/JB19F0EBWIxnd1pvcQOp8fPhwnE8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>,
	<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [git pull] proc oops fix
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus please pull.

git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/linux-2.6-nsfd.git

This prevents a much too easily triggered oops.

Eric



>From 793925334f32e9026c22baee5c3c340f47d4ef7e Mon Sep 17 00:00:00 2001
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 15 Jun 2011 12:47:04 -0700
Subject: [PATCH] proc: Fix Oops on stat of /proc/<zombie pid>/ns/net

Don't call iput with the inode half setup to be a namespace filedescriptor.
Instead rearrange the code so that we don't initialize ei->ns_ops until
after I ns_ops->get succeeds, preventing us from invoking ns_ops->put
when ns_ops->get failed.

Reported-by: Ingo Saitz <Ingo.Saitz@stud.uni-hannover.de>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/namespaces.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index 781dec5..be177f7 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -38,18 +38,21 @@ static struct dentry *proc_ns_instantiate(struct inode *dir,
 	struct inode *inode;
 	struct proc_inode *ei;
 	struct dentry *error = ERR_PTR(-ENOENT);
+	void *ns;
 
 	inode = proc_pid_make_inode(dir->i_sb, task);
 	if (!inode)
 		goto out;
 
+	ns = ns_ops->get(task);
+	if (!ns)
+		goto out_iput;
+
 	ei = PROC_I(inode);
 	inode->i_mode = S_IFREG|S_IRUSR;
 	inode->i_fop  = &ns_file_operations;
 	ei->ns_ops    = ns_ops;
-	ei->ns	      = ns_ops->get(task);
-	if (!ei->ns)
-		goto out_iput;
+	ei->ns	      = ns;
 
 	dentry->d_op = &pid_dentry_operations;
 	d_add(dentry, inode);
-- 
1.7.5.1.217.g4e3aa

