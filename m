Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab0ITH4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 03:56:32 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:33734 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563Ab0ITH4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 03:56:31 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>
References: <m1aanc3l3e.fsf@fess.ebiederm.org>
Date: Mon, 20 Sep 2010 00:56:27 -0700
In-Reply-To: <m1aanc3l3e.fsf@fess.ebiederm.org> (Eric W. Biederman's message
	of "Mon, 20 Sep 2010 00:55:33 -0700")
Message-ID: <m1zkvc26hg.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@suse.de>
X-Spam-Relay-Country: 
Subject: [PATCH 1/2] sysfs: Fail bin file mmap if vma close is implemented.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It is not reasonably possible to wrap vma->close().  To correctly
wrap close would imply calling close on any vmas that remain when
sysfs_remove_bin_file is called.  Finding the proper lists walking
them getting the locking right etc, requires deep knowledge of the
mm subsystem and as such would require assistence from the mm
subsystem to implement.  That assistence does not currently exist.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/bin.c |   26 ++++++++------------------
 1 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index 4e321f7..d31d7b7 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -190,23 +190,6 @@ static void bin_vma_open(struct vm_area_struct *vma)
 	sysfs_put_active(attr_sd);
 }
 
-static void bin_vma_close(struct vm_area_struct *vma)
-{
-	struct file *file = vma->vm_file;
-	struct bin_buffer *bb = file->private_data;
-	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
-
-	if (!bb->vm_ops || !bb->vm_ops->close)
-		return;
-
-	if (!sysfs_get_active(attr_sd))
-		return;
-
-	bb->vm_ops->close(vma);
-
-	sysfs_put_active(attr_sd);
-}
-
 static int bin_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct file *file = vma->vm_file;
@@ -331,7 +314,6 @@ static int bin_migrate(struct vm_area_struct *vma, const nodemask_t *from,
 
 static const struct vm_operations_struct bin_vm_ops = {
 	.open		= bin_vma_open,
-	.close		= bin_vma_close,
 	.fault		= bin_fault,
 	.page_mkwrite	= bin_page_mkwrite,
 	.access		= bin_access,
@@ -377,6 +359,14 @@ static int mmap(struct file *file, struct vm_area_struct *vma)
 	if (bb->mmapped && bb->vm_ops != vma->vm_ops)
 		goto out_put;
 
+	/*
+	 * It is not possible to successfully wrap close.
+	 * So error if someone is trying to use close.
+	 */
+	rc = -EINVAL;
+	if (vma->vm_ops && vma->vm_ops->close)
+		goto out_put;
+
 	rc = 0;
 	bb->mmapped = 1;
 	bb->vm_ops = vma->vm_ops;
-- 
1.7.2.2

