Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933646Ab1FWRhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:37:47 -0400
Received: from mail.windriver.com ([147.11.1.11]:35148 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933619Ab1FWRhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:43 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Sean Hefty <sean.hefty@intel.com>,
        Roland Dreier <roland@purestorage.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 178/247] IB/cm: Bump reference count on cm_id before invoking callback
Date: Thu, 23 Jun 2011 13:34:06 -0400
Message-Id: <1308850515-15242-119-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sean Hefty <sean.hefty@intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 29963437a48475036353b95ab142bf199adb909e upstream.

When processing a SIDR REQ, the ib_cm allocates a new cm_id.  The
refcount of the cm_id is initialized to 1.  However, cm_process_work
will decrement the refcount after invoking all callbacks.  The result
is that the cm_id will end up with refcount set to 0 by the end of the
sidr req handler.

If a user tries to destroy the cm_id, the destruction will proceed,
under the incorrect assumption that no other threads are referencing
the cm_id.  This can lead to a crash when the cm callback thread tries
to access the cm_id.

This problem was noticed as part of a larger investigation with kernel
crashes in the rdma_cm when running on a real time OS.

Signed-off-by: Sean Hefty <sean.hefty@intel.com>
Acked-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/infiniband/core/cm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index ad63b79..2422945 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -2987,6 +2987,7 @@ static int cm_sidr_req_handler(struct cm_work *work)
 		goto out; /* No match. */
 	}
 	atomic_inc(&cur_cm_id_priv->refcount);
+	atomic_inc(&cm_id_priv->refcount);
 	spin_unlock_irq(&cm.lock);
 
 	cm_id_priv->id.cm_handler = cur_cm_id_priv->id.cm_handler;
-- 
1.7.4.4

