Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab2JVSM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 14:12:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755986Ab2JVSM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 14:12:56 -0400
Date: Mon, 22 Oct 2012 14:12:54 -0400
From: Jay Fenlason <fenlason@redhat.com>
To: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH] prevent CVE-2012-2372 rds-ping causes kernel panic
Message-ID: <20121022181253.GA13736@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you use rds-ping of the local IP address of some Infiniband HCAs
(QLogic, possibly others) the machine will panic with a BUG_ON due to
an overly restrictive check.  Loosen the restriction a bit

This should have gotten sent a while ago (it was first noticed in
 https://bugzilla.redhat.com/show_bug.cgi?id=803936
and patched in kernel-2.6.32-275.el6) but I got confused about its
embargo status and lost it.

Signed-off-by: Jay Fenlason <fenlason@redhat.com>

diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
index e590949..7920c85 100644
--- a/net/rds/ib_send.c
+++ b/net/rds/ib_send.c
@@ -544,7 +544,7 @@ int rds_ib_xmit(struct rds_connection *conn, struct rds_message *rm,
 	int flow_controlled = 0;
 	int nr_sig = 0;
 
-	BUG_ON(off % RDS_FRAG_SIZE);
+	BUG_ON(!conn->c_loopback && off % RDS_FRAG_SIZE);
 	BUG_ON(hdr_off != 0 && hdr_off != sizeof(struct rds_header));
 
 	/* Do not send cong updates to IB loopback */
