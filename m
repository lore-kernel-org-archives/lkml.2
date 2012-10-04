Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933613Ab2JDVTr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:19:47 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:49290 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933595Ab2JDVTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:19:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dean Luick <dean.luick@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [ 53/56] IB/qib: Fix local access validation for user MRs
Date: Thu,  4 Oct 2012 14:16:14 -0700
Message-Id: <20121004211158.144882730@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004211152.101901246@linuxfoundation.org>
References: <20121004211152.101901246@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

commit c00aaa1a0221a22153071fcb2f320e2ebaecc2fd upstream.

Commit 8aac4cc3a9d7 ("IB/qib: RCU locking for MR validation") introduced
a bug that broke user post sends.  The proper validation of the MR
was lost in the patch.

This patch corrects that validation.

Reviewed-by: Dean Luick <dean.luick@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/qib/qib_keys.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/hw/qib/qib_keys.c
+++ b/drivers/infiniband/hw/qib/qib_keys.c
@@ -186,8 +186,9 @@ int qib_lkey_ok(struct qib_lkey_table *r
 		goto bail;
 
 	off = sge->addr - mr->user_base;
-	if (unlikely(sge->addr < mr->iova || off + sge->length > mr->length ||
-		     (mr->access_flags & acc) == 0))
+	if (unlikely(sge->addr < mr->user_base ||
+		     off + sge->length > mr->length ||
+		     (mr->access_flags & acc) != acc))
 		goto bail;
 	if (unlikely(!atomic_inc_not_zero(&mr->refcount)))
 		goto bail;


