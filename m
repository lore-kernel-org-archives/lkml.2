Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab2L1TnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:43:00 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55285 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932080Ab2L1TSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:18:22 -0500
Message-Id: <20121228190352.897309171@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:18 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 108/173] target/file: Fix 32-bit highmem breakage for SGL -> iovec mapping
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 40ff2c3b3da35dd3a00ac6722056a59b4b3f2caf upstream.

This patch changes vectored file I/O to use kmap + kunmap when mapping
incoming SGL memory -> struct iovec in order to properly support 32-bit
highmem configurations.  This is because an extra bounce buffer may be
required when processing scatterlist pages allocated with GFP_KERNEL.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[bwh: Backported to 3.2: use task->task_sg{,_nents} for iteration]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/target_core_file.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -300,7 +300,7 @@ static int fd_do_readv(struct se_task *t
 
 	for_each_sg(task->task_sg, sg, task->task_sg_nents, i) {
 		iov[i].iov_len = sg->length;
-		iov[i].iov_base = sg_virt(sg);
+		iov[i].iov_base = kmap(sg_page(sg)) + sg->offset;
 	}
 
 	old_fs = get_fs();
@@ -308,6 +308,8 @@ static int fd_do_readv(struct se_task *t
 	ret = vfs_readv(fd, &iov[0], task->task_sg_nents, &pos);
 	set_fs(old_fs);
 
+	for_each_sg(task->task_sg, sg, task->task_sg_nents, i)
+		kunmap(sg_page(sg));
 	kfree(iov);
 	/*
 	 * Return zeros and GOOD status even if the READ did not return
@@ -353,7 +355,7 @@ static int fd_do_writev(struct se_task *
 
 	for_each_sg(task->task_sg, sg, task->task_sg_nents, i) {
 		iov[i].iov_len = sg->length;
-		iov[i].iov_base = sg_virt(sg);
+		iov[i].iov_base = kmap(sg_page(sg)) + sg->offset;
 	}
 
 	old_fs = get_fs();
@@ -361,6 +363,9 @@ static int fd_do_writev(struct se_task *
 	ret = vfs_writev(fd, &iov[0], task->task_sg_nents, &pos);
 	set_fs(old_fs);
 
+	for_each_sg(task->task_sg, sg, task->task_sg_nents, i)
+		kunmap(sg_page(sg));
+
 	kfree(iov);
 
 	if (ret < 0 || ret != task->task_size) {


