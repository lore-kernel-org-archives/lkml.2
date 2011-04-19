Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab1DSUm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:42:58 -0400
Received: from kroah.org ([198.145.64.141]:59017 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755100Ab1DSUmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:42:55 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:41:19 2011
Message-Id: <20110419204119.717155529@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:31:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andy Grover <andy.grover@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Bader <stefan.bader@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Brad Figg <brad.figg@canonical.com>
Subject: [28/28] net: fix rds_iovec page count overflow
In-Reply-To: <20110419204122.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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
[v2: nr is unsigned in the old code]
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Acked-by: Tim Gardner <tim.gardner@canonical.com>
Acked-by: Brad Figg <brad.figg@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/rds/rdma.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -473,6 +473,17 @@ static struct rds_rdma_op *rds_rdma_prep
 
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


