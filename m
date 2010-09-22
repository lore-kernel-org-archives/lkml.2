Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797Ab0IVIJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 04:09:33 -0400
Received: from nm28-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.22]:42523 "HELO
	nm28-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751316Ab0IVIJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 04:09:32 -0400
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Sep 2010 04:09:32 EDT
X-Yahoo-Newman-Id: 913354.4939.bm@omp1023.mail.ne1.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: DhsfIaUVM1nTcyD5d1uSGlfpkPKVQ8MXPdx5sbrrTBLZHBN
 tuJJNXA9lqVdCc6sVc3fJFMnIMQUI0EwpcxuEAF5eeFznuhnaSUE.t1gLIye
 AaubQqw35xguGJnXH7q46HEv4KgciK2uMFiRZU7TwoUMXmIR3pz6QNHedfK6
 wke3EYBWlWqHea.zwjIf05fhmL3EM9KH5hkVBeCe2QNUEMbe9TIDlCcpiw9q
 27PKb_GcvNkslUJ6ZtDjTinU12iM3UZJLfodfuiIIrNrr.6YDTfzUDaIurHt
 fgkuM_lbRtJGJ2az25bOycAdFgtsjdZqe3ofXPsq56mHiFCjyy_B2yi4-
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>
Cc: Fubo Chen <fubo.chen@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH] tcm/fileio: Convert to iov allocations for fd_do_readv() and fd_do_writev()
Date: Wed, 22 Sep 2010 01:02:38 -0700
Message-Id: <1285142558-13219-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings all,

This patch converts target_core_file.c fd_do_readv() and fd_do_writev() code to
use dynamic allocation for *iov[] instead of local scope static memory to
properly handle cases with TCM_Loop that can potentially exceed the 8K stack
on 64-bit kernels with per 1:1 struct scatterlist <-> 512-byte block_size SGL length
mapping up to the current FD_MAX_SECTORS=1024.  For more information please see:

http://lkml.org/lkml/2010/9/22/42

Many thanks to Fubo Chen for spotting this one!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_file.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 221b41e..93d3f63 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -476,12 +476,16 @@ static int fd_do_readv(struct fd_request *req, struct se_task *task)
 {
 	struct file *fd = req->fd_dev->fd_file;
 	struct scatterlist *sg = task->task_sg;
-	struct iovec iov[req->fd_sg_count];
+	struct iovec *iov;
 	mm_segment_t old_fs;
 	loff_t pos = (req->fd_lba * DEV_ATTRIB(task->se_dev)->block_size);
 	int ret = 0, i;
 
-	memset(iov, 0, sizeof(struct iovec) * req->fd_sg_count);
+	iov = kzalloc(sizeof(struct iovec) * req->fd_sg_count, GFP_KERNEL);
+	if (!(iov)) {
+		printk(KERN_ERR "Unable to allocate fd_do_readv iov[]\n");
+		return -1;
+	}
 
 	for (i = 0; i < req->fd_sg_count; i++) {
 		iov[i].iov_len = sg[i].length;
@@ -492,6 +496,8 @@ static int fd_do_readv(struct fd_request *req, struct se_task *task)
 	set_fs(get_ds());
 	ret = vfs_readv(fd, &iov[0], req->fd_sg_count, &pos);
 	set_fs(old_fs);
+
+	kfree(iov);
 	/*
 	 * Return zeros and GOOD status even if the READ did not return
 	 * the expected virt_size for struct file w/o a backing struct
@@ -583,12 +589,16 @@ static int fd_do_writev(struct fd_request *req, struct se_task *task)
 {
 	struct file *fd = req->fd_dev->fd_file;
 	struct scatterlist *sg = task->task_sg;
-	struct iovec iov[req->fd_sg_count];
+	struct iovec *iov;
 	mm_segment_t old_fs;
 	loff_t pos = (req->fd_lba * DEV_ATTRIB(task->se_dev)->block_size);
 	int ret, i = 0;
 
-	memset(iov, 0, sizeof(struct iovec) * req->fd_sg_count);
+	iov = kzalloc(sizeof(struct iovec) * req->fd_sg_count, GFP_KERNEL);
+	if (!(iov)) {
+		printk(KERN_ERR "Unable to allocate fd_do_writev iov[]\n");
+		return -1;
+	}
 
 	for (i = 0; i < req->fd_sg_count; i++) {
 		iov[i].iov_len = sg[i].length;
@@ -600,6 +610,8 @@ static int fd_do_writev(struct fd_request *req, struct se_task *task)
 	ret = vfs_writev(fd, &iov[0], req->fd_sg_count, &pos);
 	set_fs(old_fs);
 
+	kfree(iov);
+
 	if (ret < 0 || ret != req->fd_size) {
 		printk(KERN_ERR "vfs_writev() returned %d\n", ret);
 		return -1;
-- 
1.5.6.5

