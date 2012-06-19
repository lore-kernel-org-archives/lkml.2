Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab2FSUOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 16:14:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826Ab2FSUOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 16:14:23 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Wanpeng Li <liwp.linux@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH V2] writeback: fix hung_task alarm when sync block
References: <1339562553-10035-1-git-send-email-liwp.linux@gmail.com>
	<x49txyf8exl.fsf@segfault.boston.devel.redhat.com>
	<20120613144840.GA3055@localhost>
	<x49lijr8bur.fsf@segfault.boston.devel.redhat.com>
	<20120614133600.GB14883@localhost>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 19 Jun 2012 16:14:16 -0400
In-Reply-To: <20120614133600.GB14883@localhost> (Fengguang Wu's message of
	"Thu, 14 Jun 2012 21:36:00 +0800")
Message-ID: <x491ulbjbzb.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu <fengguang.wu@intel.com> writes:

> Good idea! Yes we can do some estimation and adaptively extend the
> hang timeout for the current writeback_inodes_sb_nr()/sync_inodes_sb()
> call.
>
> Note that it's not going to reliably get rid of false warnings due to
> estimation errors, which could be pretty large and unavoidable on
> change of workload. But still, it would be a net improvement and
> perhaps enough to get rid of most false warnings, while still being
> able to catch livelock or other kind of task hang.

Hi, Fengguang,

I didn't see a patch from you for this, so I went ahead and threw
something together.  Let me know what you think of it.  I wasn't sure
how to estimate the total I/O that will be issued for syncing out an
entire superblock, though, so I didn't do that part.

Cheers,
Jeff

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 8d2fb8c..346f3de 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1291,6 +1291,37 @@ static void wait_sb_inodes(struct super_block *sb)
 }
 
 /**
+ * wb_wait_for_completion_nohang -	wait for the given work item to
+ * complete, attempting to not falsely trigger the hangcheck timer.
+ * @work: the wb_writeback_work we're waiting on
+ *
+ * Wait for the completion of the given work item.  If the hang check
+ * timer is activated, then estimate the amount of time we should spend
+ * waiting for I/O, and wake up often enough to not trigger the timer.
+ * Once we've exceeded the estimated I/O time, wait without a timeout so
+ * that the hangcheck timer will then fire.
+ */
+void wb_wait_for_completion_nohang(struct wb_writeback_work *work)
+{
+	unsigned long hang_check = sysctl_hung_task_timeout_secs;
+	bool completed = false;
+
+	if (hang_check) {
+		/* loop until the time remaining is less than the timer */
+		unsigned long est_io_time_s = work->nr_pages /
+					work->sb->s_bdi->avg_write_bandwidth;
+		while (!completed && est_io_time_s > hang_check) {
+			completed = !!wait_for_completion_timeout(work->done,
+							hang_check * (HZ/2));
+			est_io_time_s -= hang_check / 2;
+		}
+	}
+
+	if (!completed)
+		wait_for_completion(work->done);
+}
+
+/**
  * writeback_inodes_sb_nr -	writeback dirty inodes from given super_block
  * @sb: the superblock
  * @nr: the number of pages to write
@@ -1316,7 +1347,7 @@ void writeback_inodes_sb_nr(struct super_block *sb,
 
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 	bdi_queue_work(sb->s_bdi, &work);
-	wait_for_completion(&done);
+	wb_wait_for_completion_nohang(&work);
 }
 EXPORT_SYMBOL(writeback_inodes_sb_nr);
 
