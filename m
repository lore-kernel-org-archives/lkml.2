Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692Ab1LPUHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 15:07:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44921 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760671Ab1LPTtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:49:11 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:45:58 2011
Message-Id: <20111216194558.238199484@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:45:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Christoph Hellwig <hch@lst.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [26/53] target/file: walk properly over sg list
In-Reply-To: <20111216194613.GA18395@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 9649fa1b8764f64c8cc4293e197e14cd46fe7205 upstream.

This patch changes fileio to use for_each_sg() when walking se_task->task_sg
memory passed into from loopback LLD struct scsi_cmnd scatterlist memory.

This addresses an issue where FILEIO backends with loopback where hitting the
following OOPs with mkfs.ext2:

|kernel BUG at include/linux/scatterlist.h:97!
|invalid opcode: 0000 [#1] PREEMPT SMP
|Modules linked in: sd_mod tcm_loop target_core_stgt scsi_tgt target_core_pscsi target_core_file target_core_iblock target_core_mod configfs scsi_mod
|
|Pid: 671, comm: LIO_fileio Not tainted 3.1.0-rc10+ #139 Bochs Bochs
|EIP: 0060:[<e0afd746>] EFLAGS: 00010202 CPU: 0
|EIP is at fd_do_task+0x396/0x420 [target_core_file]
| [<e0aa7884>] __transport_execute_tasks+0xd4/0x190 [target_core_mod]
| [<e0aa797c>] transport_execute_tasks+0x3c/0xf0 [target_core_mod]
|EIP: [<e0afd746>] fd_do_task+0x396/0x420 [target_core_file] SS:ESP 0068:dea47e90

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/target/target_core_file.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -288,9 +288,9 @@ static int fd_do_readv(struct se_task *t
 		return -ENOMEM;
 	}
 
-	for (i = 0; i < task->task_sg_nents; i++) {
-		iov[i].iov_len = sg[i].length;
-		iov[i].iov_base = sg_virt(&sg[i]);
+	for_each_sg(task->task_sg, sg, task->task_sg_nents, i) {
+		iov[i].iov_len = sg->length;
+		iov[i].iov_base = sg_virt(sg);
 	}
 
 	old_fs = get_fs();
@@ -340,9 +340,9 @@ static int fd_do_writev(struct se_task *
 		return -ENOMEM;
 	}
 
-	for (i = 0; i < task->task_sg_nents; i++) {
-		iov[i].iov_len = sg[i].length;
-		iov[i].iov_base = sg_virt(&sg[i]);
+	for_each_sg(task->task_sg, sg, task->task_sg_nents, i) {
+		iov[i].iov_len = sg->length;
+		iov[i].iov_base = sg_virt(sg);
 	}
 
 	old_fs = get_fs();


