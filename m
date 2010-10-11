Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab0JKQ7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 12:59:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755486Ab0JKQ7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 12:59:34 -0400
Date: Mon, 11 Oct 2010 18:53:10 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dma: get_user_pages -> get_user_pages_fast
Message-ID: <20101011165310.GA5122@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There doesn't seem to be any advantage to using
get_user_pages, so switch iovlock to get_user_pages_fast
instead.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Lightly tested.  This patch is on top of the bugfix patch I posted
previously.

 drivers/dma/iovlock.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/iovlock.c b/drivers/dma/iovlock.c
index 21ed8f3..c6917e8 100644
--- a/drivers/dma/iovlock.c
+++ b/drivers/dma/iovlock.c
@@ -95,17 +95,11 @@ struct dma_pinned_list *dma_pin_iovec_pages(struct iovec *iov, size_t len)
 		pages += page_list->nr_pages;
 
 		/* pin pages down */
-		down_read(&current->mm->mmap_sem);
-		ret = get_user_pages(
-			current,
-			current->mm,
+		ret = get_user_pages_fast(
 			(unsigned long) iov[i].iov_base,
 			page_list->nr_pages,
 			1,	/* write */
-			0,	/* force */
-			page_list->pages,
-			NULL);
-		up_read(&current->mm->mmap_sem);
+			page_list->pages);
 
 		if (unlikely(ret < 0))
 			goto unpin;
-- 
1.7.3-rc1
