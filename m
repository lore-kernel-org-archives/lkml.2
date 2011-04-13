Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048Ab1DMQOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:14:55 -0400
Received: from kroah.org ([198.145.64.141]:53119 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933008Ab1DMQNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:13:43 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 09:10:50 2011
Message-Id: <20110413161050.106639498@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 09:10:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andy Grover <andy.grover@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [71/71] net: fix rds_iovec page count overflow
In-Reply-To: <20110413161106.GA20405@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/rds/rdma.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -497,6 +497,14 @@ static struct rds_rdma_op *rds_rdma_prep
 
 		max_pages = max(nr, max_pages);
 		nr_pages += nr;
+
+		/*
+		 * nr_pages for one entry is limited to (UINT_MAX>>PAGE_SHIFT)+1,
+		 * so tot_pages cannot overflow without first going negative.
+		 */
+		if ((int)nr_pages < 0)
+			ret = -EINVAL;
+			goto out;
 	}
 
 	pages = kcalloc(max_pages, sizeof(struct page *), GFP_KERNEL);


