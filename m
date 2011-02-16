Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740Ab1BPArc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:47:32 -0500
Received: from kroah.org ([198.145.64.141]:45143 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932684Ab1BPArX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:47:23 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:20:59 2011
Message-Id: <20110216002059.742032464@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:19:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jay Cliburn <jcliburn@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [patch 007/176] atl1: fix oops when changing tx/rx ring params
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: J. K. Cliburn <jcliburn@gmail.com>

commit 2f32c867219734b06abc980d4812f67b6d6fe517 upstream.

Commit 3f5a2a713aad28480d86b0add00c68484b54febc zeroes out the statistics
message block (SMB) and coalescing message block (CMB) when adapter ring
resources are freed.  This is desirable behavior, but, as a side effect,
the commit leads to an oops when atl1_set_ringparam() attempts to alter
the number of rx or tx elements in the ring buffer (by using ethtool
-G, for example).  We don't want SMB or CMB to change during this
operation.

Modify atl1_set_ringparam() to preserve SMB and CMB when changing ring
parameters.

Signed-off-by: Jay Cliburn <jcliburn@gmail.com>
Reported-by: Tõnu Raitviir <jussuf@linux.ee>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/atlx/atl1.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -3503,6 +3503,8 @@ static int atl1_set_ringparam(struct net
 	struct atl1_rfd_ring rfd_old, rfd_new;
 	struct atl1_rrd_ring rrd_old, rrd_new;
 	struct atl1_ring_header rhdr_old, rhdr_new;
+	struct atl1_smb smb;
+	struct atl1_cmb cmb;
 	int err;
 
 	tpd_old = adapter->tpd_ring;
@@ -3543,11 +3545,19 @@ static int atl1_set_ringparam(struct net
 		adapter->rrd_ring = rrd_old;
 		adapter->tpd_ring = tpd_old;
 		adapter->ring_header = rhdr_old;
+		/*
+		 * Save SMB and CMB, since atl1_free_ring_resources
+		 * will clear them.
+		 */
+		smb = adapter->smb;
+		cmb = adapter->cmb;
 		atl1_free_ring_resources(adapter);
 		adapter->rfd_ring = rfd_new;
 		adapter->rrd_ring = rrd_new;
 		adapter->tpd_ring = tpd_new;
 		adapter->ring_header = rhdr_new;
+		adapter->smb = smb;
+		adapter->cmb = cmb;
 
 		err = atl1_up(adapter);
 		if (err)


