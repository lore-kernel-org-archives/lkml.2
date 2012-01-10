Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934174Ab2AJXCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:02:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52585 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934018Ab2AJXCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 18:02:03 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:56:02 2012
Message-Id: <20120110215602.841839783@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:55:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eli Cohen <eli@mellanox.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [15/49] IB/uverbs: Protect QP multicast list
In-Reply-To: <20120110215609.GA22505@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eli Cohen <eli@dev.mellanox.co.il>

commit e214a0fe2b382fa302c036ecd6e6ffe99e3b9875 upstream.

Userspace verbs multicast attach/detach operations on a QP are done
while holding the rwsem of the QP for reading.  That's not sufficient
since a reader lock allows more than one reader to acquire the
lock.  However, multicast attach/detach does list manipulation that
can corrupt the list if multiple threads run in parallel.

Fix this by acquiring the rwsem as a writer to serialize attach/detach
operations.  Add idr_write_qp() and put_qp_write() to encapsulate
this.

This fixes oops seen when running applications that perform multicast
joins/leaves.

Reported by: Mike Dubman <miked@mellanox.com>
Signed-off-by: Eli Cohen <eli@mellanox.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/infiniband/core/uverbs_cmd.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -241,11 +241,24 @@ static struct ib_qp *idr_read_qp(int qp_
 	return idr_read_obj(&ib_uverbs_qp_idr, qp_handle, context, 0);
 }
 
+static struct ib_qp *idr_write_qp(int qp_handle, struct ib_ucontext *context)
+{
+	struct ib_uobject *uobj;
+
+	uobj = idr_write_uobj(&ib_uverbs_qp_idr, qp_handle, context);
+	return uobj ? uobj->object : NULL;
+}
+
 static void put_qp_read(struct ib_qp *qp)
 {
 	put_uobj_read(qp->uobject);
 }
 
+static void put_qp_write(struct ib_qp *qp)
+{
+	put_uobj_write(qp->uobject);
+}
+
 static struct ib_srq *idr_read_srq(int srq_handle, struct ib_ucontext *context)
 {
 	return idr_read_obj(&ib_uverbs_srq_idr, srq_handle, context, 0);
@@ -2375,7 +2388,7 @@ ssize_t ib_uverbs_attach_mcast(struct ib
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
+	qp = idr_write_qp(cmd.qp_handle, file->ucontext);
 	if (!qp)
 		return -EINVAL;
 
@@ -2404,7 +2417,7 @@ ssize_t ib_uverbs_attach_mcast(struct ib
 		kfree(mcast);
 
 out_put:
-	put_qp_read(qp);
+	put_qp_write(qp);
 
 	return ret ? ret : in_len;
 }
@@ -2422,7 +2435,7 @@ ssize_t ib_uverbs_detach_mcast(struct ib
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
+	qp = idr_write_qp(cmd.qp_handle, file->ucontext);
 	if (!qp)
 		return -EINVAL;
 
@@ -2441,7 +2454,7 @@ ssize_t ib_uverbs_detach_mcast(struct ib
 		}
 
 out_put:
-	put_qp_read(qp);
+	put_qp_write(qp);
 
 	return ret ? ret : in_len;
 }


