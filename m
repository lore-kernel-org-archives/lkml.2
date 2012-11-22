Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373Ab2KVWnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:43:25 -0500
Received: from mail.kernel.org ([198.145.19.201]:49006 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514Ab2KVSdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Guanjun He <gjhe@suse.com>, Sage Weil <sage@inktank.com>
Subject: [ 139/171] libceph: prevent the race of incoming work during teardown
Date: Wed, 21 Nov 2012 16:41:25 -0800
Message-Id: <20121122004047.302762258@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guanjun He <gjhe@suse.com>

(cherry picked from commit a2a3258417eb6a1799cf893350771428875a8287)

Add an atomic variable 'stopping' as flag in struct ceph_messenger,
set this flag to 1 in function ceph_destroy_client(), and add the condition code
in function ceph_data_ready() to test the flag value, if true(1), just return.

Signed-off-by: Guanjun He <gjhe@suse.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/ceph/messenger.h |    1 +
 net/ceph/ceph_common.c         |    2 ++
 net/ceph/messenger.c           |    5 +++++
 3 files changed, 8 insertions(+)

--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -50,6 +50,7 @@ struct ceph_messenger {
 	struct ceph_entity_inst inst;    /* my name+address */
 	struct ceph_entity_addr my_enc_addr;
 
+	atomic_t stopping;
 	bool nocrc;
 
 	/*
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -495,6 +495,8 @@ void ceph_destroy_client(struct ceph_cli
 {
 	dout("destroy_client %p\n", client);
 
+	atomic_set(&client->msgr.stopping, 1);
+
 	/* unmount */
 	ceph_osdc_stop(&client->osdc);
 
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -254,6 +254,9 @@ static void con_sock_state_closed(struct
 static void ceph_sock_data_ready(struct sock *sk, int count_unused)
 {
 	struct ceph_connection *con = sk->sk_user_data;
+	if (atomic_read(&con->msgr->stopping)) {
+		return;
+	}
 
 	if (sk->sk_state != TCP_CLOSE_WAIT) {
 		dout("%s on %p state = %lu, queueing work\n", __func__,
@@ -2413,6 +2416,8 @@ void ceph_messenger_init(struct ceph_mes
 	encode_my_addr(msgr);
 	msgr->nocrc = nocrc;
 
+	atomic_set(&msgr->stopping, 0);
+
 	dout("%s %p\n", __func__, msgr);
 }
 EXPORT_SYMBOL(ceph_messenger_init);


