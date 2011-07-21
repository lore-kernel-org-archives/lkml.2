Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066Ab1GUQGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 12:06:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758Ab1GUQEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 12:04:11 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 03/10] dlm: dump address of unknown node
Date: Thu, 21 Jul 2011 11:04:00 -0500
Message-Id: <1311264247-28129-4-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masatake YAMATO <yamato@redhat.com>

When the dlm fails to make a network connection to another
node, include the address of the node in the error message.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lowcomms.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 5e2c71f..990626e 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -512,12 +512,10 @@ static void process_sctp_notification(struct connection *con,
 			}
 			make_sockaddr(&prim.ssp_addr, 0, &addr_len);
 			if (dlm_addr_to_nodeid(&prim.ssp_addr, &nodeid)) {
-				int i;
 				unsigned char *b=(unsigned char *)&prim.ssp_addr;
 				log_print("reject connect from unknown addr");
-				for (i=0; i<sizeof(struct sockaddr_storage);i++)
-					printk("%02x ", b[i]);
-				printk("\n");
+				print_hex_dump_bytes("ss: ", DUMP_PREFIX_NONE, 
+						     b, sizeof(struct sockaddr_storage));
 				sctp_send_shutdown(prim.ssp_assoc_id);
 				return;
 			}
@@ -748,7 +746,10 @@ static int tcp_accept_from_sock(struct connection *con)
 	/* Get the new node's NODEID */
 	make_sockaddr(&peeraddr, 0, &len);
 	if (dlm_addr_to_nodeid(&peeraddr, &nodeid)) {
+		unsigned char *b=(unsigned char *)&peeraddr;
 		log_print("connect from non cluster node");
+		print_hex_dump_bytes("ss: ", DUMP_PREFIX_NONE, 
+				     b, sizeof(struct sockaddr_storage));
 		sock_release(newsock);
 		mutex_unlock(&con->sock_mutex);
 		return -1;
-- 
1.7.6

