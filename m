Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933616Ab1FWRhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:37:42 -0400
Received: from mail.windriver.com ([147.11.1.11]:35110 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933556Ab1FWRhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:39 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Sean Hefty <sean.hefty@intel.com>,
        Roland Dreier <roland@purestorage.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 177/247] RDMA/cma: Fix crash in request handlers
Date: Thu, 23 Jun 2011 13:34:05 -0400
Message-Id: <1308850515-15242-118-git-send-email-paul.gortmaker@windriver.com>
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

commit 25ae21a10112875763c18b385624df713a288a05 upstream.

Doug Ledford and Red Hat reported a crash when running the rdma_cm on
a real-time OS.  The crash has the following call trace:

    cm_process_work
       cma_req_handler
          cma_disable_callback
          rdma_create_id
             kzalloc
             init_completion
          cma_get_net_info
          cma_save_net_info
          cma_any_addr
             cma_zero_addr
          rdma_translate_ip
             rdma_copy_addr
          cma_acquire_dev
             rdma_addr_get_sgid
             ib_find_cached_gid
             cma_attach_to_dev
          ucma_event_handler
             kzalloc
             ib_copy_ah_attr_to_user
          cma_comp

[ preempted ]

    cma_write
        copy_from_user
        ucma_destroy_id
           copy_from_user
           _ucma_find_context
           ucma_put_ctx
           ucma_free_ctx
              rdma_destroy_id
                 cma_exch
                 cma_cancel_operation
                 rdma_node_get_transport

        rt_mutex_slowunlock
        bad_area_nosemaphore
        oops_enter

They were able to reproduce the crash multiple times with the
following details:

    Crash seems to always happen on the:
            mutex_unlock(&conn_id->handler_mutex);
    as conn_id looks to have been freed during this code path.

An examination of the code shows that a race exists in the request
handlers.  When a new connection request is received, the rdma_cm
allocates a new connection identifier.  This identifier has a single
reference count on it.  If a user calls rdma_destroy_id() from another
thread after receiving a callback, rdma_destroy_id will proceed to
destroy the id and free the associated memory.  However, the request
handlers may still be in the process of running.  When control returns
to the request handlers, they can attempt to access the newly created
identifiers.

Fix this by holding a reference on the newly created rdma_cm_id until
the request handler is through accessing it.

Signed-off-by: Sean Hefty <sean.hefty@intel.com>
Acked-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/infiniband/core/cma.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 6d77706..42f8e8a 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1137,6 +1137,11 @@ static int cma_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *ib_event)
 	cm_id->context = conn_id;
 	cm_id->cm_handler = cma_ib_handler;
 
+	/*
+	 * Protect against the user destroying conn_id from another thread
+	 * until we're done accessing it.
+	 */
+	atomic_inc(&conn_id->refcount);
 	ret = conn_id->id.event_handler(&conn_id->id, &event);
 	if (!ret) {
 		/*
@@ -1149,8 +1154,10 @@ static int cma_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *ib_event)
 			ib_send_cm_mra(cm_id, CMA_CM_MRA_SETTING, NULL, 0);
 		mutex_unlock(&lock);
 		mutex_unlock(&conn_id->handler_mutex);
+		cma_deref_id(conn_id);
 		goto out;
 	}
+	cma_deref_id(conn_id);
 
 	/* Destroy the CM ID by returning a non-zero value. */
 	conn_id->cm_id.ib = NULL;
@@ -1352,17 +1359,25 @@ static int iw_conn_req_handler(struct iw_cm_id *cm_id,
 	event.param.conn.private_data_len = iw_event->private_data_len;
 	event.param.conn.initiator_depth = attr.max_qp_init_rd_atom;
 	event.param.conn.responder_resources = attr.max_qp_rd_atom;
+
+	/*
+	 * Protect against the user destroying conn_id from another thread
+	 * until we're done accessing it.
+	 */
+	atomic_inc(&conn_id->refcount);
 	ret = conn_id->id.event_handler(&conn_id->id, &event);
 	if (ret) {
 		/* User wants to destroy the CM ID */
 		conn_id->cm_id.iw = NULL;
 		cma_exch(conn_id, CMA_DESTROYING);
 		mutex_unlock(&conn_id->handler_mutex);
+		cma_deref_id(conn_id);
 		rdma_destroy_id(&conn_id->id);
 		goto out;
 	}
 
 	mutex_unlock(&conn_id->handler_mutex);
+	cma_deref_id(conn_id);
 
 out:
 	if (dev)
-- 
1.7.4.4

