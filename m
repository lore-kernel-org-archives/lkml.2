Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933087Ab2KZRH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:07:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47569 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933053Ab2KZRHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:07:20 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Guanjun He <gjhe@suse.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 120/270] libceph: prevent the race of incoming work during teardown
Date: Mon, 26 Nov 2012 14:56:50 -0200
Message-Id: <1353949160-26803-121-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guanjun He <gjhe@suse.com>

commit a2a3258417eb6a1799cf893350771428875a8287 upstream.

Add an atomic variable 'stopping' as flag in struct ceph_messenger,
set this flag to 1 in function ceph_destroy_client(), and add the condition code
in function ceph_data_ready() to test the flag value, if true(1), just return.

Signed-off-by: Guanjun He <gjhe@suse.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 include/linux/ceph/messenger.h |    1 +
 net/ceph/ceph_common.c         |    2 ++
 net/ceph/messenger.c           |    5 +++++
 3 files changed, 8 insertions(+)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index ec22abd..de39cda 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -50,6 +50,7 @@ struct ceph_messenger {
 	struct ceph_entity_inst inst;    /* my name+address */
 	struct ceph_entity_addr my_enc_addr;
 
+	atomic_t stopping;
 	bool nocrc;
 
 	/*
diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index 58b09ef..3b45e01 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -495,6 +495,8 @@ void ceph_destroy_client(struct ceph_client *client)
 {
 	dout("destroy_client %p\n", client);
 
+	atomic_set(&client->msgr.stopping, 1);
+
 	/* unmount */
 	ceph_osdc_stop(&client->osdc);
 
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 16814d1..63e1252 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -254,6 +254,9 @@ static void con_sock_state_closed(struct ceph_connection *con)
 static void ceph_sock_data_ready(struct sock *sk, int count_unused)
 {
 	struct ceph_connection *con = sk->sk_user_data;
+	if (atomic_read(&con->msgr->stopping)) {
+		return;
+	}
 
 	if (sk->sk_state != TCP_CLOSE_WAIT) {
 		dout("%s on %p state = %lu, queueing work\n", __func__,
@@ -2413,6 +2416,8 @@ void ceph_messenger_init(struct ceph_messenger *msgr,
 	encode_my_addr(msgr);
 	msgr->nocrc = nocrc;
 
+	atomic_set(&msgr->stopping, 0);
+
 	dout("%s %p\n", __func__, msgr);
 }
 EXPORT_SYMBOL(ceph_messenger_init);
-- 
1.7.9.5

