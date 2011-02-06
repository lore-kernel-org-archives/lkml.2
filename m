Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab1BFXrp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:47:45 -0500
Received: from 1wt.eu ([62.212.114.60]:60339 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622Ab1BFXrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:47:43 -0500
Message-Id: <20110206232252.913509649@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 07 Feb 2011 00:23:01 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Dan Carpenter <error27@gmail.com>, Roland Dreier <rolandd@cisco.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [PATCH 09/23] IB/uverbs: Handle large number of entries in poll CQ
In-Reply-To: <4beed4da27f06efb2c13d6ed48850634@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.58-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Carpenter <error27@gmail.com>

commit 7182afea8d1afd432a17c18162cc3fd441d0da93 upstream.

In ib_uverbs_poll_cq() code there is a potential integer overflow if
userspace passes in a large cmd.ne.  The calls to kmalloc() would
allocate smaller buffers than intended, leading to memory corruption.
There iss also an information leak if resp wasn't all used.
Unprivileged userspace may call this function, although only if an
RDMA device that uses this function is present.

Fix this by copying CQ entries one at a time, which avoids the
allocation entirely, and also by moving this copying into a function
that makes sure to initialize all memory copied to userspace.

Special thanks to Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
for his help and advice.

Signed-off-by: Dan Carpenter <error27@gmail.com>

[ Monkey around with things a bit to avoid bad code generation by gcc
  when designated initializers are used.  - Roland ]

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>

---
 drivers/infiniband/core/uverbs_cmd.c |  101 +++++++++++++++++++----------------
 1 file changed, 57 insertions(+), 44 deletions(-)

Index: longterm-2.6.27/drivers/infiniband/core/uverbs_cmd.c
===================================================================
--- longterm-2.6.27.orig/drivers/infiniband/core/uverbs_cmd.c	2011-01-29 11:19:14.689065716 +0100
+++ longterm-2.6.27/drivers/infiniband/core/uverbs_cmd.c	2011-01-29 11:27:14.060064011 +0100
@@ -875,68 +875,81 @@
 	return ret ? ret : in_len;
 }
 
+static int copy_wc_to_user(void __user *dest, struct ib_wc *wc)
+{
+	struct ib_uverbs_wc tmp;
+
+	tmp.wr_id		= wc->wr_id;
+	tmp.status		= wc->status;
+	tmp.opcode		= wc->opcode;
+	tmp.vendor_err		= wc->vendor_err;
+	tmp.byte_len		= wc->byte_len;
+	tmp.ex.imm_data		= (__u32 __force) wc->ex.imm_data;
+	tmp.qp_num		= wc->qp->qp_num;
+	tmp.src_qp		= wc->src_qp;
+	tmp.wc_flags		= wc->wc_flags;
+	tmp.pkey_index		= wc->pkey_index;
+	tmp.slid		= wc->slid;
+	tmp.sl			= wc->sl;
+	tmp.dlid_path_bits	= wc->dlid_path_bits;
+	tmp.port_num		= wc->port_num;
+	tmp.reserved		= 0;
+
+	if (copy_to_user(dest, &tmp, sizeof tmp))
+		return -EFAULT;
+
+	return 0;
+}
+
 ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
 			  const char __user *buf, int in_len,
 			  int out_len)
 {
 	struct ib_uverbs_poll_cq       cmd;
-	struct ib_uverbs_poll_cq_resp *resp;
+	struct ib_uverbs_poll_cq_resp  resp;
+	u8 __user                     *header_ptr;
+	u8 __user                     *data_ptr;
 	struct ib_cq                  *cq;
-	struct ib_wc                  *wc;
-	int                            ret = 0;
-	int                            i;
-	int                            rsize;
+	struct ib_wc                   wc;
+	int                            ret;
 
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	wc = kmalloc(cmd.ne * sizeof *wc, GFP_KERNEL);
-	if (!wc)
-		return -ENOMEM;
-
-	rsize = sizeof *resp + cmd.ne * sizeof(struct ib_uverbs_wc);
-	resp = kmalloc(rsize, GFP_KERNEL);
-	if (!resp) {
-		ret = -ENOMEM;
-		goto out_wc;
-	}
-
 	cq = idr_read_cq(cmd.cq_handle, file->ucontext, 0);
-	if (!cq) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (!cq)
+		return -EINVAL;
 
-	resp->count = ib_poll_cq(cq, cmd.ne, wc);
+	/* we copy a struct ib_uverbs_poll_cq_resp to user space */
+	header_ptr = (void __user *)(unsigned long) cmd.response;
+	data_ptr = header_ptr + sizeof resp;
 
-	put_cq_read(cq);
+	memset(&resp, 0, sizeof resp);
+	while (resp.count < cmd.ne) {
+		ret = ib_poll_cq(cq, 1, &wc);
+		if (ret < 0)
+			goto out_put;
+		if (!ret)
+			break;
+
+		ret = copy_wc_to_user(data_ptr, &wc);
+		if (ret)
+			goto out_put;
 
-	for (i = 0; i < resp->count; i++) {
-		resp->wc[i].wr_id 	   = wc[i].wr_id;
-		resp->wc[i].status 	   = wc[i].status;
-		resp->wc[i].opcode 	   = wc[i].opcode;
-		resp->wc[i].vendor_err 	   = wc[i].vendor_err;
-		resp->wc[i].byte_len 	   = wc[i].byte_len;
-		resp->wc[i].ex.imm_data    = (__u32 __force) wc[i].ex.imm_data;
-		resp->wc[i].qp_num 	   = wc[i].qp->qp_num;
-		resp->wc[i].src_qp 	   = wc[i].src_qp;
-		resp->wc[i].wc_flags 	   = wc[i].wc_flags;
-		resp->wc[i].pkey_index 	   = wc[i].pkey_index;
-		resp->wc[i].slid 	   = wc[i].slid;
-		resp->wc[i].sl 		   = wc[i].sl;
-		resp->wc[i].dlid_path_bits = wc[i].dlid_path_bits;
-		resp->wc[i].port_num 	   = wc[i].port_num;
+		data_ptr += sizeof(struct ib_uverbs_wc);
+		++resp.count;
 	}
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response, resp, rsize))
+	if (copy_to_user(header_ptr, &resp, sizeof resp)) {
 		ret = -EFAULT;
+		goto out_put;
+	}
 
-out:
-	kfree(resp);
+	ret = in_len;
 
-out_wc:
-	kfree(wc);
-	return ret ? ret : in_len;
+out_put:
+	put_cq_read(cq);
+	return ret;
 }
 
 ssize_t ib_uverbs_req_notify_cq(struct ib_uverbs_file *file,


