Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab0HCQDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 12:03:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:42697 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932341Ab0HCQDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 12:03:12 -0400
Message-ID: <4C583DAD.4080507@kernel.org>
Date: Tue, 03 Aug 2010 18:02:53 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Jens Axboe <jaxboe@fusionio.com>, Jan Harkes <jaharkes@cs.cmu.edu>,
        coda@cs.cmu.edu
CC: stable@kernel.org, Vladislav Bolkhovitin <vst@vlnb.net>,
        Bryan Mesich <bryan.mesich@ndsu.edu>, scst-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, Neil Brown <neilb@suse.de>
Subject: [PATCH] coda: rename REQ_* to CODA_REQ_*
References: <20100628010346.GA2376@atlantis.cc.ndsu.nodak.edu>	<4C28EFD6.2070203@vlnb.net>	<20100714190325.GA25148@atlantis.cc.ndsu.nodak.edu>	<4C3EF3AD.5070509@vlnb.net>	<20100723191844.GB31152@atlantis.cc.ndsu.nodak.edu>	<4C4D7DF5.9060909@vlnb.net>	<20100727220110.GF31152@atlantis.cc.ndsu.nodak.edu>	<4C5073F3.1060406@vlnb.net>	<4C52A98A.7060507@kernel.org> <20100802104227.79340b49@notabene> <4C56D397.8010305@kernel.org> <4C5724E8.9010204@kernel.dk> <4C57E722.5060809@kernel.org> <4C57FA57.2000601@kernel.dk> <4C57FBAD.1080809@fusionio.com> <4C583B3B.3060301@kernel.org>
In-Reply-To: <4C583B3B.3060301@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 03 Aug 2010 16:02:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

REQ_* constants are used for block layer requests causing inconsistent
duplicate definitions of REQ_WRITE.  Rename REQ_* used by coda to
CODA_REQ_*.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
So, something like this.  Build tested only.

Thanks.

 fs/coda/psdev.c            |   14 +++++++-------
 fs/coda/upcall.c           |   12 ++++++------
 include/linux/coda_psdev.h |    8 ++++----
 3 files changed, 17 insertions(+), 17 deletions(-)

Index: work/fs/coda/psdev.c
===================================================================
--- work.orig/fs/coda/psdev.c
+++ work/fs/coda/psdev.c
@@ -177,7 +177,7 @@ static ssize_t coda_psdev_write(struct f
 		nbytes = req->uc_outSize; /* don't have more space! */
 	}
         if (copy_from_user(req->uc_data, buf, nbytes)) {
-		req->uc_flags |= REQ_ABORT;
+		req->uc_flags |= CODA_REQ_ABORT;
 		wake_up(&req->uc_sleep);
 		retval = -EFAULT;
 		goto out;
@@ -185,7 +185,7 @@ static ssize_t coda_psdev_write(struct f

 	/* adjust outsize. is this useful ?? */
         req->uc_outSize = nbytes;	
-        req->uc_flags |= REQ_WRITE;
+        req->uc_flags |= CODA_REQ_WRITE;
 	count = nbytes;

 	/* Convert filedescriptor into a file handle */
@@ -254,8 +254,8 @@ static ssize_t coda_psdev_read(struct fi
 	        retval = -EFAULT;

 	/* If request was not a signal, enqueue and don't free */
-	if (!(req->uc_flags & REQ_ASYNC)) {
-		req->uc_flags |= REQ_READ;
+	if (!(req->uc_flags & CODA_REQ_ASYNC)) {
+		req->uc_flags |= CODA_REQ_READ;
 		list_add_tail(&(req->uc_chain), &vcp->vc_processing);
 		goto out;
 	}
@@ -315,19 +315,19 @@ static int coda_psdev_release(struct ino
 		list_del(&req->uc_chain);

 		/* Async requests need to be freed here */
-		if (req->uc_flags & REQ_ASYNC) {
+		if (req->uc_flags & CODA_REQ_ASYNC) {
 			CODA_FREE(req->uc_data, sizeof(struct coda_in_hdr));
 			kfree(req);
 			continue;
 		}
-		req->uc_flags |= REQ_ABORT;
+		req->uc_flags |= CODA_REQ_ABORT;
 		wake_up(&req->uc_sleep);
 	}

 	list_for_each_entry_safe(req, tmp, &vcp->vc_processing, uc_chain) {
 		list_del(&req->uc_chain);

-		req->uc_flags |= REQ_ABORT;
+		req->uc_flags |= CODA_REQ_ABORT;
 		wake_up(&req->uc_sleep);
 	}

Index: work/fs/coda/upcall.c
===================================================================
--- work.orig/fs/coda/upcall.c
+++ work/fs/coda/upcall.c
@@ -604,7 +604,7 @@ static void coda_unblock_signals(sigset_
 			       (((r)->uc_opcode != CODA_CLOSE && \
 				 (r)->uc_opcode != CODA_STORE && \
 				 (r)->uc_opcode != CODA_RELEASE) || \
-				(r)->uc_flags & REQ_READ))
+				(r)->uc_flags & CODA_REQ_READ))

 static inline void coda_waitfor_upcall(struct upc_req *req)
 {
@@ -624,7 +624,7 @@ static inline void coda_waitfor_upcall(s
 			set_current_state(TASK_UNINTERRUPTIBLE);

 		/* got a reply */
-		if (req->uc_flags & (REQ_WRITE | REQ_ABORT))
+		if (req->uc_flags & (CODA_REQ_WRITE | CODA_REQ_ABORT))
 			break;

 		if (blocked && time_after(jiffies, timeout) &&
@@ -708,7 +708,7 @@ static int coda_upcall(struct venus_comm
 	coda_waitfor_upcall(req);

 	/* Op went through, interrupt or not... */
-	if (req->uc_flags & REQ_WRITE) {
+	if (req->uc_flags & CODA_REQ_WRITE) {
 		out = (union outputArgs *)req->uc_data;
 		/* here we map positive Venus errors to kernel errors */
 		error = -out->oh.result;
@@ -717,13 +717,13 @@ static int coda_upcall(struct venus_comm
 	}

 	error = -EINTR;
-	if ((req->uc_flags & REQ_ABORT) || !signal_pending(current)) {
+	if ((req->uc_flags & CODA_REQ_ABORT) || !signal_pending(current)) {
 		printk(KERN_WARNING "coda: Unexpected interruption.\n");
 		goto exit;
 	}

 	/* Interrupted before venus read it. */
-	if (!(req->uc_flags & REQ_READ))
+	if (!(req->uc_flags & CODA_REQ_READ))
 		goto exit;

 	/* Venus saw the upcall, make sure we can send interrupt signal */
@@ -747,7 +747,7 @@ static int coda_upcall(struct venus_comm
 	sig_inputArgs->ih.opcode = CODA_SIGNAL;
 	sig_inputArgs->ih.unique = req->uc_unique;

-	sig_req->uc_flags = REQ_ASYNC;
+	sig_req->uc_flags = CODA_REQ_ASYNC;
 	sig_req->uc_opcode = sig_inputArgs->ih.opcode;
 	sig_req->uc_unique = sig_inputArgs->ih.unique;
 	sig_req->uc_inSize = sizeof(struct coda_in_hdr);
Index: work/include/linux/coda_psdev.h
===================================================================
--- work.orig/include/linux/coda_psdev.h
+++ work/include/linux/coda_psdev.h
@@ -86,9 +86,9 @@ struct upc_req {
 	wait_queue_head_t   uc_sleep;   /* process' wait queue */
 };

-#define REQ_ASYNC  0x1
-#define REQ_READ   0x2
-#define REQ_WRITE  0x4
-#define REQ_ABORT  0x8
+#define CODA_REQ_ASYNC		0x1
+#define CODA_REQ_READ		0x2
+#define CODA_REQ_WRITE		0x4
+#define CODA_REQ_ABORT		0x8

 #endif
