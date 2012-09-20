Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab2ITHLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 03:11:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34187 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab2ITHLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 03:11:16 -0400
Date: Thu, 20 Sep 2012 01:11:34 -0600
From: John Jolly <jjolly@suse.com>
To: linux-kernel@vger.kernel.org
Cc: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>,
        netdev@vger.kernel.org
Subject: [PATCH] rds: Error on offset mismatch if not loopback
Message-ID: <20120920071134.GF14393@linux-tkdk.sfcn.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attempting an rds connection from the IP address of an IPoIB interface
to itself causes a kernel panic due to a BUG_ON() being triggered. Making
the test less strict allows rds-ping to work without crashing the machine.

A local unprivileged user could use this flaw to crash the sytem.
---
 net/rds/ib_send.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
-- 
1.7.7

