Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933363Ab1I1WtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:49:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54865 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933307Ab1I1Ws6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:48:58 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:47 2011
Message-Id: <20110928220147.818443439@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [213/244] cnic: Fix interrupt logic
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Chan <mchan@broadcom.com>

commit 93736656138e6d2f39f19c1d68f9ef81cfc9dd66 upstream.

We need to keep looping until cnic_get_kcqes() returns 0.  cnic_get_kcqes()
returns a maximum of 64 entries.  If there are more entries in the queue
and we don't loop back, the remaining entries may not be serviced for a
long time.

Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/cnic.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/drivers/net/cnic.c
+++ b/drivers/net/cnic.c
@@ -2778,13 +2778,10 @@ static u32 cnic_service_bnx2_queues(stru
 
 		/* Tell compiler that status_blk fields can change. */
 		barrier();
-		if (status_idx != *cp->kcq1.status_idx_ptr) {
-			status_idx = (u16) *cp->kcq1.status_idx_ptr;
-			/* status block index must be read first */
-			rmb();
-			cp->kwq_con_idx = *cp->kwq_con_idx_ptr;
-		} else
-			break;
+		status_idx = (u16) *cp->kcq1.status_idx_ptr;
+		/* status block index must be read first */
+		rmb();
+		cp->kwq_con_idx = *cp->kwq_con_idx_ptr;
 	}
 
 	CNIC_WR16(dev, cp->kcq1.io_addr, cp->kcq1.sw_prod_idx);
@@ -2908,8 +2905,6 @@ static u32 cnic_service_bnx2x_kcq(struct
 
 		/* Tell compiler that sblk fields can change. */
 		barrier();
-		if (last_status == *info->status_idx_ptr)
-			break;
 
 		last_status = *info->status_idx_ptr;
 		/* status block index must be read before reading the KCQ */


