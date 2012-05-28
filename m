Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab2E1DuP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:50:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51974 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753743Ab2E1D3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:20 -0400
Message-Id: <20120528031206.342607017@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:27 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Yishai Hadas <yishaih@mellanox.com>,
        Christoph Lameter <cl@linux.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [ 025/117] IB/core: Fix mismatch between locked and pinned pages
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yishai Hadas <yishaih@mellanox.com>

commit c4870eb874ac16dccef40e1bc7a002c7e9156adc upstream.

Commit bc3e53f682d9 ("mm: distinguish between mlocked and pinned
pages") introduced a separate counter for pinned pages and used it in
the IB stack.  However, in ib_umem_get() the pinned counter is
incremented, but ib_umem_release() wrongly decrements the locked
counter.  Fix this.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/infiniband/core/umem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 71f0c0f..a841123 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -269,7 +269,7 @@ void ib_umem_release(struct ib_umem *umem)
 	} else
 		down_write(&mm->mmap_sem);
 
-	current->mm->locked_vm -= diff;
+	current->mm->pinned_vm -= diff;
 	up_write(&mm->mmap_sem);
 	mmput(mm);
 	kfree(umem);


