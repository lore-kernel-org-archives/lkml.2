Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933937Ab1FWRly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:41:54 -0400
Received: from mail.windriver.com ([147.11.1.11]:35793 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933869Ab1FWRjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:39:02 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Grover <andy.grover@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 246/247] net: fix rds_iovec page count overflow
Date: Thu, 23 Jun 2011 13:35:14 -0400
Message-Id: <1308850515-15242-187-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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

[PG: In 34, var names are slightly different, 1b1f6's tot_pages is
 34's nr_pages, and 1b1f6's nr_pages is 34's nr; so map accordingly.]

Reported-by: Thomas Pollet <thomas.pollet@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andy Grover <andy.grover@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/rds/rdma.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index cf0dfa7..3481931 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -498,6 +498,15 @@ static struct rds_rdma_op *rds_rdma_prepare(struct rds_sock *rs,
 
 		max_pages = max(nr, max_pages);
 		nr_pages += nr;
+
+		/*
+		 * nr for one entry is limited to (UINT_MAX>>PAGE_SHIFT)+1,
+		 * so nr_pages cannot overflow without first going negative.
+		 */
+		if ((int)nr_pages < 0) {
+			ret = -EINVAL;
+			goto out;
+		}
 	}
 
 	pages = kcalloc(max_pages, sizeof(struct page *), GFP_KERNEL);
-- 
1.7.4.4

