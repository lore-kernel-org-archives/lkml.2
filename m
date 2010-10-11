Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab0JKJvD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 05:51:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265Ab0JKJvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 05:51:02 -0400
Date: Mon, 11 Oct 2010 11:44:17 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Dan Williams <dan.j.williams@intel.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: stable@kernel.org
Subject: [PATCH] dma: fix error handling on out of memory
Message-ID: <20101011094416.GA3771@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_user_pages might return less pages than requested. If this happens
for the first iovec in dma_pin_iovec_pages, then nr_iovecs is 0 and so
dma_unpin_iovec_pages will not unpin any pages, leaking pinned memory.
A similar off by one would trigger for any of the following entries.

Fix by updating nr_iovecs and nr_pages in this case.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Error handling in dma_pin_iovec_pages still looks wrong to me.  Am I
missing something?  The following patch against 2.6.36-rc7 was under
some very light testing by me.

Thanks,

 drivers/dma/iovlock.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/iovlock.c b/drivers/dma/iovlock.c
index bb48a57..21ed8f3 100644
--- a/drivers/dma/iovlock.c
+++ b/drivers/dma/iovlock.c
@@ -107,10 +107,16 @@ struct dma_pinned_list *dma_pin_iovec_pages(struct iovec *iov, size_t len)
 			NULL);
 		up_read(&current->mm->mmap_sem);
 
-		if (ret != page_list->nr_pages)
+		if (unlikely(ret < 0))
 			goto unpin;
 
 		local_list->nr_iovecs = i + 1;
+
+		if (unlikely(ret != page_list->nr_pages)) {
+			page_list->nr_pages = ret;
+			goto unpin;
+		}
+
 	}
 
 	return local_list;
-- 
MST
