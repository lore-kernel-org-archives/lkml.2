Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933887Ab2E0BdC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:33:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38960 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933879Ab2E0BPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:15:24 -0400
Message-Id: <20120527002511.461740306@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:25:27 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Yishai Hadas <yishaih@mellanox.com>,
        Christoph Lameter <cl@linux.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [ 21/91] IB/core: Fix mismatch between locked and pinned pages
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/umem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -269,7 +269,7 @@ void ib_umem_release(struct ib_umem *ume
 	} else
 		down_write(&mm->mmap_sem);
 
-	current->mm->locked_vm -= diff;
+	current->mm->pinned_vm -= diff;
 	up_write(&mm->mmap_sem);
 	mmput(mm);
 	kfree(umem);


