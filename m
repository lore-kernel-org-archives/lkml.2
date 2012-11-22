Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab2KVSie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:38:34 -0500
Received: from mail.kernel.org ([198.145.19.201]:49345 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448Ab2KVSi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:38:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>, Alex Elder <elder@inktank.com>
Subject: [ 086/171] libceph: flush msgr queue during mon_client shutdown
Date: Wed, 21 Nov 2012 16:40:32 -0800
Message-Id: <20121122004042.000513393@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

(cherry picked from commit f3dea7edd3d449fe7a6d402c1ce56a294b985261)
(cherry picked from commit 642c0dbde32f34baa7886e988a067089992adc8f)

We need to flush the msgr workqueue during mon_client shutdown to
ensure that any work affecting our embedded ceph_connection is
finished so that we can be safely destroyed.

Previously, we were flushing the work queue after osd_client
shutdown and before mon_client shutdown to ensure that any osd
connection refs to authorizers are flushed.  Remove the redundant
flush, and document in the comment that the mon_client flush is
needed to cover that case as well.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/ceph_common.c |    7 -------
 net/ceph/mon_client.c  |    8 ++++++++
 2 files changed, 8 insertions(+), 7 deletions(-)

--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -504,13 +504,6 @@ void ceph_destroy_client(struct ceph_cli
 	/* unmount */
 	ceph_osdc_stop(&client->osdc);
 
-	/*
-	 * make sure osd connections close out before destroying the
-	 * auth module, which is needed to free those connections'
-	 * ceph_authorizers.
-	 */
-	ceph_msgr_flush();
-
 	ceph_monc_stop(&client->monc);
 
 	ceph_debugfs_client_cleanup(client);
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -847,6 +847,14 @@ void ceph_monc_stop(struct ceph_mon_clie
 
 	mutex_unlock(&monc->mutex);
 
+	/*
+	 * flush msgr queue before we destroy ourselves to ensure that:
+	 *  - any work that references our embedded con is finished.
+	 *  - any osd_client or other work that may reference an authorizer
+	 *    finishes before we shut down the auth subsystem.
+	 */
+	ceph_msgr_flush();
+
 	ceph_auth_destroy(monc->auth);
 
 	ceph_msg_put(monc->m_auth);


