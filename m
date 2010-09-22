Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab0IVUaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 16:30:23 -0400
Received: from smtp103.sbc.mail.gq1.yahoo.com ([67.195.15.62]:26300 "HELO
	smtp103.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755133Ab0IVUaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 16:30:20 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: u_.osB8VM1meurLOlzK0VIDt5suOE_wkFnTPBWIdkNivjE5
 zFk5YnAYidXiN32oQDq1XF8Sm5NfWUlaliR_Bx3qvjWtfPNB3HK9m3ScUqKE
 jGnLE2VgY20x1nfKDo67BJr4cO_ueYBUmKFdbDU0EtIxr3A.Vkw0oyKlCIAy
 y5jJTEQbHUZ4uvwwNUqF.cSd.m73UFY79uJ3iaYtf64T05Puht8sdZLWlig1
 _TDeiOKjvL0i7dsv4rtjdi0lVwis0ZG1IdFzPiwFKsW2hp15g2j3Z49_.wmF
 _3nz0G3KD0YzqP6nEJ6TmzMZVXzcJwLuvG5rVMsLL6nzVr1qqZmRDIUjE
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Bernard Metzler <BMT@zurich.ibm.com>
Cc: David Miller <davem@davemloft.net>, Matthew Wilcox <willy@linux.intel.com>,
        Andi Keen <ak@linux.intel.com>, Roland Dreier <rdreier@cisco.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 1/2] siw: Fix ib_register_device() for > v2.6.34 kernels
Date: Wed, 22 Sep 2010 13:30:17 -0700
Message-Id: <1285187417-10928-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a LINUX_VERSION_CODE > v2.6.34 check inside of siw_main.c:siw_register_device()
around the use of ib_register_device().  In post v2.6.34 kernels this function accepts a second
parameter used a sysfs port callback described here:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9a6edb60ec10d86b1025a0cdad68fd89f1ddaf02

This patch currently sets this second parameter to NULL.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 softiwarp/siw_main.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/softiwarp/siw_main.c b/softiwarp/siw_main.c
index cacedea..c97adee 100644
--- a/softiwarp/siw_main.c
+++ b/softiwarp/siw_main.c
@@ -233,8 +233,11 @@ int siw_register_device(struct siw_dev *dev)
 	ibdev->iwcm->add_ref = siw_qp_get_ref;
 	ibdev->iwcm->rem_ref = siw_qp_put_ref;
 	ibdev->iwcm->get_qp = siw_get_ofaqp;
-
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 34)
+	rv = ib_register_device(ibdev, NULL);
+#else
 	rv = ib_register_device(ibdev);
+#endif
 	if (rv) {
 		dprint(DBG_DM|DBG_ON, "(dev=%s): "
 			"ib_register_device failed: rv=%d\n", ibdev->name, rv);
-- 
1.5.6.5

