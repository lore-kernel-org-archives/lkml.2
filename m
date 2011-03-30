Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965164Ab1C3V3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:29:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:56389 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933624Ab1C3VJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411278573"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: sean.hefty@intel.com, dledford@redhat.com, roland@purestorage.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [196/275] IB/cm: Bump reference count on cm_id before invoking callback
Message-Id: <20110330210720.182FB3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/infiniband/core/cm.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/drivers/infiniband/core/cm.c
===================================================================
--- linux-2.6.35.y.orig/drivers/infiniband/core/cm.c	2011-03-29 22:50:42.296176166 -0700
+++ linux-2.6.35.y/drivers/infiniband/core/cm.c	2011-03-29 23:03:02.367239599 -0700
@@ -2987,6 +2987,7 @@
 		goto out; /* No match. */
 	}
 	atomic_inc(&cur_cm_id_priv->refcount);
+	atomic_inc(&cm_id_priv->refcount);
 	spin_unlock_irq(&cm.lock);
 
 	cm_id_priv->id.cm_handler = cur_cm_id_priv->id.cm_handler;
