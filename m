Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab1CNLJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 07:09:39 -0400
Received: from nm27-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.232]:35624 "HELO
	nm27-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753496Ab1CNLHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 07:07:22 -0400
X-Yahoo-Newman-Id: 691756.59443.bm@omp1029.mail.sp2.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: CiXo7uIVM1nsn6hkQP.Ri.Z0w8HTT7TKMgQkQJkPn1CoTp4
 Cz1nsRpV7LyAL4pAUxRdJ0wP5NYCw592xfZqkFtuc4vZ2GDBTL1k4sC4Q86R
 G6EPX_p6YbieuTDPsydEwJhZWbNOrpsdlwH72feOE7smIUTq8fgInM137zaj
 gAIdqyD5a284.Iu8OUO9FS4.fBe5Ala2LVTokG_h1vxpLhUgnGzj6R132ael
 J_9m8OFyCbsfprERaO4CsMbN5EfA.Vk1qgBr53OjE3JgyyMYwRYHZ4P43hDm
 7J78IjRF5HqEsq9jJMlBelgN5iomQ702iQtq3ZzYF_B6wnBJysEdzdao2fzW
 uMLziPkQcj87epK.0ZRbmp_X9m_0yzSNDXns_dgF7WzFwqz.Ap2NgBtspcAm
 mHQar.SXbu82JqS6cdjTvrZuWmHMCefnY75oZyLoUpLIjU6W7pU5GdoMwjyn
 wgG5lZQ.GpbhrYyVNpbNBkyz9kg5RpHAIyP7TwYA_yykXuXYPVxznb2hLy8B
 j2iKNJoQqjfbPuPO4538-
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>,
        Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Boaz Harrosh <bharrosh@panasas.com>, Joel Becker <jlbec@evilplan.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 12/21] target: Fix bogus return in transport_add_device_to_core_hba failure path
Date: Mon, 14 Mar 2011 04:06:06 -0700
Message-Id: <1300100775-10012-13-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
References: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes a bogus conditional+return check within the failure path
of transport_add_device_to_core_hba().  This breakage was introduced during
the v4 conversion to remove struct se_cmd passthrough ops for INQUIRY /
READ_CAPCITY during struct se_device creation and registration process.

Reported-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index af56ce2..536de6f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1621,7 +1621,7 @@ struct se_device *transport_add_device_to_core_hba(
 	const char *inquiry_prod,
 	const char *inquiry_rev)
 {
-	int ret = 0, force_pt;
+	int force_pt;
 	struct se_device  *dev;
 
 	dev = kzalloc(sizeof(struct se_device), GFP_KERNEL);
@@ -1738,9 +1738,8 @@ struct se_device *transport_add_device_to_core_hba(
 	}
 	scsi_dump_inquiry(dev);
 
+	return dev;
 out:
-	if (!ret)
-		return dev;
 	kthread_stop(dev->process_thread);
 
 	spin_lock(&hba->device_lock);
-- 
1.7.4.1

