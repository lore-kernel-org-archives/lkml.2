Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754Ab1DZV2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:28:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:1206 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932306Ab1DZVOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="914748566"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: torvalds@linux-foundation.org, andy.grover@oracle.com, davem@davemloft.net,
        ak@linux.intel.com, stefan.bader@canonical.com,
        tim.gardner@canonical.com, brad.figg@canonical.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [51/106] net: fix rds_iovec page count overflow
Message-Id: <20110426211331.684743E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Linus Torvalds <torvalds@linux-foundation.org>

commit 1b1f693d7ad6d193862dcb1118540a030c5e761f upstream.

As reported by Thomas Pollet, the rdma page counting can overflow.  We
get the rdma sizes in 64-bit unsigned entities, but then limit it to
UINT_MAX bytes and shift them down to pages (so with a possible "+1" for
an unaligned address).

So each individual page count fits comfortably in an 'unsigned int' (not
even close to overflowing into signed), but as they are added up, they
might end up resulting in a signed return value. Which would be wrong.

Catch the case of tot_pages turning negative, and return the appropriate
error code.

Reported-by: Thomas Pollet <thomas.pollet@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andy Grover <andy.grover@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
[v2: nr is unsigned in the old code]
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Acked-by: Tim Gardner <tim.gardner@canonical.com>
Acked-by: Brad Figg <brad.figg@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/rds/rdma.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: linux-2.6.35.y/net/rds/rdma.c
===================================================================
--- linux-2.6.35.y.orig/net/rds/rdma.c
+++ linux-2.6.35.y/net/rds/rdma.c
@@ -500,6 +500,17 @@ static struct rds_rdma_op *rds_rdma_prep
 
 		max_pages = max(nr, max_pages);
 		nr_pages += nr;
+
+		/*
+		 * nr for one entry in limited to (UINT_MAX>>PAGE_SHIFT)+1
+		 * so nr_pages cannot overflow without becoming bigger than
+		 * INT_MAX first. If nr cannot overflow then max_pages should
+		 * be ok.
+		 */
+		if (nr_pages > INT_MAX) {
+			ret = -EINVAL;
+			goto out;
+		}
 	}
 
 	pages = kcalloc(max_pages, sizeof(struct page *), GFP_KERNEL);
