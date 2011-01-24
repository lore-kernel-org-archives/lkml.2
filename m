Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab1AXNbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 08:31:14 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38615 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab1AXNbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 08:31:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=xiUa8OcgiEDJvSjkorzhf/kQaveZQW73tzRE7mpe+DAQ9EK1UaC07CcSEJPDej3XW7
         yd4xeFHMfpUzrtkjg9UfUrzbkrXnSY742vsx7OIiEnGbaY1L2IsHZR98i14GuxbJoawF
         h7At5m8h6dEko9e2ta6GU5hlC4J2XEUb9lZ5g=
Date: Mon, 24 Jan 2011 14:31:05 +0100
From: Tejun Heo <tj@kernel.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] scsi: remove bogus use of struct execute_work in sg
Message-ID: <20110124133105.GC11404@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

execute_work usage in sg is bogus.  execute_in_process_context() is
never used and ew is used purely as wrapper around work_struct which
is superflous.  Use work_struct directly.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
---
This hasn't changed from the previous posting.

  http://thread.gmane.org/gmane.linux.scsi/62923

Thanks.

 drivers/scsi/sg.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: work/drivers/scsi/sg.c
===================================================================
--- work.orig/drivers/scsi/sg.c
+++ work/drivers/scsi/sg.c
@@ -139,7 +139,7 @@ typedef struct sg_request {	/* SG_MAX_QU
 	volatile char done;	/* 0->before bh, 1->before read, 2->read */
 	struct request *rq;
 	struct bio *bio;
-	struct execute_work ew;
+	struct work_struct work;
 } Sg_request;
 
 typedef struct sg_fd {		/* holds the state of a file descriptor */
@@ -162,7 +162,7 @@ typedef struct sg_fd {		/* holds the sta
 	char keep_orphan;	/* 0 -> drop orphan (def), 1 -> keep for read() */
 	char mmap_called;	/* 0 -> mmap() never called on this fd */
 	struct kref f_ref;
-	struct execute_work ew;
+	struct work_struct work;
 } Sg_fd;
 
 typedef struct sg_device { /* holds the state of each scsi generic device */
@@ -1248,7 +1248,7 @@ sg_mmap(struct file *filp, struct vm_are
 
 static void sg_rq_end_io_usercontext(struct work_struct *work)
 {
-	struct sg_request *srp = container_of(work, struct sg_request, ew.work);
+	struct sg_request *srp = container_of(work, struct sg_request, work);
 	struct sg_fd *sfp = srp->parentfp;
 
 	sg_finish_rem_req(srp);
@@ -1335,8 +1335,8 @@ static void sg_rq_end_io(struct request
 		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
 		kref_put(&sfp->f_ref, sg_remove_sfp);
 	} else {
-		INIT_WORK(&srp->ew.work, sg_rq_end_io_usercontext);
-		schedule_work(&srp->ew.work);
+		INIT_WORK(&srp->work, sg_rq_end_io_usercontext);
+		schedule_work(&srp->work);
 	}
 }
 
@@ -2089,7 +2089,7 @@ sg_add_sfp(Sg_device * sdp, int dev)
 
 static void sg_remove_sfp_usercontext(struct work_struct *work)
 {
-	struct sg_fd *sfp = container_of(work, struct sg_fd, ew.work);
+	struct sg_fd *sfp = container_of(work, struct sg_fd, work);
 	struct sg_device *sdp = sfp->parentdp;
 
 	/* Cleanup any responses which were never read(). */
@@ -2126,8 +2126,8 @@ static void sg_remove_sfp(struct kref *k
 	write_unlock_irqrestore(&sg_index_lock, iflags);
 	wake_up_interruptible(&sdp->o_excl_wait);
 
-	INIT_WORK(&sfp->ew.work, sg_remove_sfp_usercontext);
-	schedule_work(&sfp->ew.work);
+	INIT_WORK(&sfp->work, sg_remove_sfp_usercontext);
+	schedule_work(&sfp->work);
 }
 
 static int
