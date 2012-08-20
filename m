Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab2HTHoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 03:44:08 -0400
Received: from mail.windriver.com ([147.11.1.11]:62201 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab2HTHoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 03:44:06 -0400
From: Ying Xue <ying.xue@windriver.com>
To: <michaelc@cs.wisc.edu>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] iscsi: Don't disable BH on BH context
Date: Mon, 20 Aug 2012 15:47:56 +0800
Message-ID: <1345448876-30492-1-git-send-email-ying.xue@windriver.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we have already in BH context when iscsi_sw_tcp_write_space()
is called, it's unnecessary to disable BH.

Signed-off-by: Ying Xue <ying.xue@windriver.com>
---
 drivers/scsi/iscsi_tcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 9220861..d763857 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -194,7 +194,7 @@ static void iscsi_sw_tcp_write_space(struct sock *sk)
 	struct iscsi_sw_tcp_conn *tcp_sw_conn;
 	void (*old_write_space)(struct sock *);
 
-	read_lock_bh(&sk->sk_callback_lock);
+	read_lock(&sk->sk_callback_lock);
 	conn = sk->sk_user_data;
 	if (!conn) {
 		read_unlock_bh(&sk->sk_callback_lock);
@@ -204,7 +204,7 @@ static void iscsi_sw_tcp_write_space(struct sock *sk)
 	tcp_conn = conn->dd_data;
 	tcp_sw_conn = tcp_conn->dd_data;
 	old_write_space = tcp_sw_conn->old_write_space;
-	read_unlock_bh(&sk->sk_callback_lock);
+	read_unlock(&sk->sk_callback_lock);
 
 	old_write_space(sk);
 
-- 
1.7.11

