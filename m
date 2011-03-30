Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933636Ab1C3VJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:09:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:48428 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933621Ab1C3VJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727133691"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: sean.hefty@intel.com, dledford@redhat.com, roland@purestorage.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [195/275] RDMA/cma: Fix crash in request handlers
Message-Id: <20110330210719.0BA373E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Sean Hefty <sean.hefty@intel.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/infiniband/core/cma.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

Index: linux-2.6.35.y/drivers/infiniband/core/cma.c
===================================================================
--- linux-2.6.35.y.orig/drivers/infiniband/core/cma.c	2011-03-29 22:50:42.822162706 -0700
+++ linux-2.6.35.y/drivers/infiniband/core/cma.c	2011-03-29 23:03:02.347240110 -0700
@@ -1136,6 +1136,11 @@
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
@@ -1148,8 +1153,10 @@
 			ib_send_cm_mra(cm_id, CMA_CM_MRA_SETTING, NULL, 0);
 		mutex_unlock(&lock);
 		mutex_unlock(&conn_id->handler_mutex);
+		cma_deref_id(conn_id);
 		goto out;
 	}
+	cma_deref_id(conn_id);
 
 	/* Destroy the CM ID by returning a non-zero value. */
 	conn_id->cm_id.ib = NULL;
@@ -1351,17 +1358,25 @@
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
