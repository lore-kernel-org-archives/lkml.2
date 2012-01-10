Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933750Ab2AJW7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 17:59:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52190 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933712Ab2AJW64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 17:58:56 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:46:19 2012
Message-Id: <20120110214619.252095189@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:45:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ramkrishna Vepa <ram.vepa@qlogic.com>,
        Mike Marciniszyn <mike.marciniszyn@qlogic.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [12/40] IB/qib: Fix a possible data corruption when receiving
 packets
In-Reply-To: <20120110214630.GA14384@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ram Vepa <ram.vepa@qlogic.com>

commit eddfb675256f49d14e8c5763098afe3eb2c93701 upstream.

Prevent a receive data corruption by ensuring that the write to update
the rcvhdrheadn register to generate an interrupt is at the very end
of the receive processing.

Signed-off-by: Ramkrishna Vepa <ram.vepa@qlogic.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@qlogic.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/infiniband/hw/qib/qib_iba6120.c |    4 +++-
 drivers/infiniband/hw/qib/qib_iba7220.c |    4 +++-
 drivers/infiniband/hw/qib/qib_iba7322.c |    6 ++++--
 3 files changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/infiniband/hw/qib/qib_iba6120.c
+++ b/drivers/infiniband/hw/qib/qib_iba6120.c
@@ -2076,9 +2076,11 @@ static void qib_6120_config_ctxts(struct
 static void qib_update_6120_usrhead(struct qib_ctxtdata *rcd, u64 hd,
 				    u32 updegr, u32 egrhd, u32 npkts)
 {
-	qib_write_ureg(rcd->dd, ur_rcvhdrhead, hd, rcd->ctxt);
 	if (updegr)
 		qib_write_ureg(rcd->dd, ur_rcvegrindexhead, egrhd, rcd->ctxt);
+	mmiowb();
+	qib_write_ureg(rcd->dd, ur_rcvhdrhead, hd, rcd->ctxt);
+	mmiowb();
 }
 
 static u32 qib_6120_hdrqempty(struct qib_ctxtdata *rcd)
--- a/drivers/infiniband/hw/qib/qib_iba7220.c
+++ b/drivers/infiniband/hw/qib/qib_iba7220.c
@@ -2704,9 +2704,11 @@ static int qib_7220_set_loopback(struct
 static void qib_update_7220_usrhead(struct qib_ctxtdata *rcd, u64 hd,
 				    u32 updegr, u32 egrhd, u32 npkts)
 {
-	qib_write_ureg(rcd->dd, ur_rcvhdrhead, hd, rcd->ctxt);
 	if (updegr)
 		qib_write_ureg(rcd->dd, ur_rcvegrindexhead, egrhd, rcd->ctxt);
+	mmiowb();
+	qib_write_ureg(rcd->dd, ur_rcvhdrhead, hd, rcd->ctxt);
+	mmiowb();
 }
 
 static u32 qib_7220_hdrqempty(struct qib_ctxtdata *rcd)
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -4060,10 +4060,12 @@ static void qib_update_7322_usrhead(stru
 	 */
 	if (hd >> IBA7322_HDRHEAD_PKTINT_SHIFT)
 		adjust_rcv_timeout(rcd, npkts);
-	qib_write_ureg(rcd->dd, ur_rcvhdrhead, hd, rcd->ctxt);
-	qib_write_ureg(rcd->dd, ur_rcvhdrhead, hd, rcd->ctxt);
 	if (updegr)
 		qib_write_ureg(rcd->dd, ur_rcvegrindexhead, egrhd, rcd->ctxt);
+	mmiowb();
+	qib_write_ureg(rcd->dd, ur_rcvhdrhead, hd, rcd->ctxt);
+	qib_write_ureg(rcd->dd, ur_rcvhdrhead, hd, rcd->ctxt);
+	mmiowb();
 }
 
 static u32 qib_7322_hdrqempty(struct qib_ctxtdata *rcd)


