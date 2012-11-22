Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633Ab2KVWjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:39:22 -0500
Received: from mail.kernel.org ([198.145.19.201]:49005 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555Ab2KVSdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>, Yehuda Sadeh <yehuda@inktank.com>,
        Alex Elder <elder@inktank.com>
Subject: [ 144/171] libceph: protect ceph_con_open() with mutex
Date: Wed, 21 Nov 2012 16:41:30 -0800
Message-Id: <20121122004047.797793478@linuxfoundation.org>
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

(cherry picked from commit 5469155f2bc83bb2c88b0a0370c3d54d87eed06e)

Take the con mutex while we are initiating a ceph open.  This is necessary
because the may have previously been in use and then closed, which could
result in a racing workqueue running con_work().

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Yehuda Sadeh <yehuda@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -537,6 +537,7 @@ void ceph_con_open(struct ceph_connectio
 		   __u8 entity_type, __u64 entity_num,
 		   struct ceph_entity_addr *addr)
 {
+	mutex_lock(&con->mutex);
 	dout("con_open %p %s\n", con, ceph_pr_addr(&addr->in_addr));
 	set_bit(OPENING, &con->state);
 	WARN_ON(!test_and_clear_bit(CLOSED, &con->state));
@@ -546,6 +547,7 @@ void ceph_con_open(struct ceph_connectio
 
 	memcpy(&con->peer_addr, addr, sizeof(*addr));
 	con->delay = 0;      /* reset backoff memory */
+	mutex_unlock(&con->mutex);
 	queue_con(con);
 }
 EXPORT_SYMBOL(ceph_con_open);


