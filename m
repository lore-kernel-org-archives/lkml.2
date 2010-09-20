Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab0ITH5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 03:57:10 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:59402 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567Ab0ITH5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 03:57:08 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>
References: <m1aanc3l3e.fsf@fess.ebiederm.org>
Date: Mon, 20 Sep 2010 00:57:03 -0700
In-Reply-To: <m1aanc3l3e.fsf@fess.ebiederm.org> (Eric W. Biederman's message
	of "Mon, 20 Sep 2010 00:55:33 -0700")
Message-ID: <m1vd6026gg.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@suse.de>
X-Spam-Relay-Country: 
Subject: [PATCH 2/2] sysfs: only access bin file vm_ops with the active lock
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


bb->vm_ops is a cached copy of the vm_ops of the underlying
sysfs bin file, which means that after sysfs_bin_remove_file
completes it is only longer valid to deference bb->vm_ops.

So move all of the tests of bb->vm_ops inside of where
we hold the sysfs active lock.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/bin.c |   42 ++++++++++++++++++++++++++----------------
 1 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index d31d7b7..a475983 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -179,13 +179,14 @@ static void bin_vma_open(struct vm_area_struct *vma)
 	struct bin_buffer *bb = file->private_data;
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 
-	if (!bb->vm_ops || !bb->vm_ops->open)
+	if (!bb->vm_ops)
 		return;
 
 	if (!sysfs_get_active(attr_sd))
 		return;
 
-	bb->vm_ops->open(vma);
+	if (bb->vm_ops->open)
+		bb->vm_ops->open(vma);
 
 	sysfs_put_active(attr_sd);
 }
@@ -197,13 +198,15 @@ static int bin_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	int ret;
 
-	if (!bb->vm_ops || !bb->vm_ops->fault)
+	if (!bb->vm_ops)
 		return VM_FAULT_SIGBUS;
 
 	if (!sysfs_get_active(attr_sd))
 		return VM_FAULT_SIGBUS;
 
-	ret = bb->vm_ops->fault(vma, vmf);
+	ret = VM_FAULT_SIGBUS;
+	if (bb->vm_ops->fault)
+		ret = bb->vm_ops->fault(vma, vmf);
 
 	sysfs_put_active(attr_sd);
 	return ret;
@@ -219,13 +222,12 @@ static int bin_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	if (!bb->vm_ops)
 		return VM_FAULT_SIGBUS;
 
-	if (!bb->vm_ops->page_mkwrite)
-		return 0;
-
 	if (!sysfs_get_active(attr_sd))
 		return VM_FAULT_SIGBUS;
 
-	ret = bb->vm_ops->page_mkwrite(vma, vmf);
+	ret = 0;
+	if (bb->vm_ops->page_mkwrite)
+		ret = bb->vm_ops->page_mkwrite(vma, vmf);
 
 	sysfs_put_active(attr_sd);
 	return ret;
@@ -239,13 +241,15 @@ static int bin_access(struct vm_area_struct *vma, unsigned long addr,
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	int ret;
 
-	if (!bb->vm_ops || !bb->vm_ops->access)
+	if (!bb->vm_ops)
 		return -EINVAL;
 
 	if (!sysfs_get_active(attr_sd))
 		return -EINVAL;
 
-	ret = bb->vm_ops->access(vma, addr, buf, len, write);
+	ret = -EINVAL;
+	if (bb->vm_ops->access)
+		ret = bb->vm_ops->access(vma, addr, buf, len, write);
 
 	sysfs_put_active(attr_sd);
 	return ret;
@@ -259,13 +263,15 @@ static int bin_set_policy(struct vm_area_struct *vma, struct mempolicy *new)
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	int ret;
 
-	if (!bb->vm_ops || !bb->vm_ops->set_policy)
+	if (!bb->vm_ops)
 		return 0;
 
 	if (!sysfs_get_active(attr_sd))
 		return -EINVAL;
 
-	ret = bb->vm_ops->set_policy(vma, new);
+	ret = 0;
+	if (bb->vm_ops->set_policy)
+		ret = bb->vm_ops->set_policy(vma, new);
 
 	sysfs_put_active(attr_sd);
 	return ret;
@@ -279,13 +285,15 @@ static struct mempolicy *bin_get_policy(struct vm_area_struct *vma,
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	struct mempolicy *pol;
 
-	if (!bb->vm_ops || !bb->vm_ops->get_policy)
+	if (!bb->vm_ops)
 		return vma->vm_policy;
 
 	if (!sysfs_get_active(attr_sd))
 		return vma->vm_policy;
 
-	pol = bb->vm_ops->get_policy(vma, addr);
+	pol = vma->vm_policy;
+	if (bb->vm_ops->get_policy)
+		pol = bb->vm_ops->get_policy(vma, addr);
 
 	sysfs_put_active(attr_sd);
 	return pol;
@@ -299,13 +307,15 @@ static int bin_migrate(struct vm_area_struct *vma, const nodemask_t *from,
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	int ret;
 
-	if (!bb->vm_ops || !bb->vm_ops->migrate)
+	if (!bb->vm_ops)
 		return 0;
 
 	if (!sysfs_get_active(attr_sd))
 		return 0;
 
-	ret = bb->vm_ops->migrate(vma, from, to, flags);
+	ret = 0;
+	if (bb->vm_ops->migrate)
+		ret = bb->vm_ops->migrate(vma, from, to, flags);
 
 	sysfs_put_active(attr_sd);
 	return ret;
-- 
1.7.2.2

