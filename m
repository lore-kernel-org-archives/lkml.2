Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705Ab1DYUqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:46:24 -0400
Received: from 1wt.eu ([62.212.114.60]:34311 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932257Ab1DYUYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:46 -0400
Message-Id: <20110425200236.818872291@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:00 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Sean Hefty <sean.hefty@intel.com>, Doug Ledford <dledford@redhat.com>,
        Roland Dreier <roland@purestorage.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 088/173] IB/cm: Bump reference count on cm_id before invoking callback
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sean Hefty <sean.hefty@intel.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/infiniband/core/cm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -2986,6 +2986,7 @@ static int cm_sidr_req_handler(struct cm
 		goto out; /* No match. */
 	}
 	atomic_inc(&cur_cm_id_priv->refcount);
+	atomic_inc(&cm_id_priv->refcount);
 	spin_unlock_irq(&cm.lock);
 
 	cm_id_priv->id.cm_handler = cur_cm_id_priv->id.cm_handler;


