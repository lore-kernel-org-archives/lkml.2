Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab1GUQEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 12:04:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab1GUQEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 12:04:10 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 01/10] dlm: show addresses in configfs
Date: Thu, 21 Jul 2011 11:03:58 -0500
Message-Id: <1311264247-28129-2-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masatake YAMATO <yamato@redhat.com>

Display all addresses the dlm is using for the local node
from the configfs file config/dlm/<cluster>/comms/<comm>/addr_list
Also make the addr file write only.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/config.c |   59 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 9b026ea..ad3b5a8 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -28,7 +28,8 @@
  * /config/dlm/<cluster>/spaces/<space>/nodes/<node>/weight
  * /config/dlm/<cluster>/comms/<comm>/nodeid
  * /config/dlm/<cluster>/comms/<comm>/local
- * /config/dlm/<cluster>/comms/<comm>/addr
+ * /config/dlm/<cluster>/comms/<comm>/addr      (write only)
+ * /config/dlm/<cluster>/comms/<comm>/addr_list (read only)
  * The <cluster> level is useless, but I haven't figured out how to avoid it.
  */
 
@@ -80,6 +81,7 @@ static ssize_t comm_local_write(struct dlm_comm *cm, const char *buf,
 				size_t len);
 static ssize_t comm_addr_write(struct dlm_comm *cm, const char *buf,
 				size_t len);
+static ssize_t comm_addr_list_read(struct dlm_comm *cm, char *buf);
 static ssize_t node_nodeid_read(struct dlm_node *nd, char *buf);
 static ssize_t node_nodeid_write(struct dlm_node *nd, const char *buf,
 				size_t len);
@@ -190,6 +192,7 @@ enum {
 	COMM_ATTR_NODEID = 0,
 	COMM_ATTR_LOCAL,
 	COMM_ATTR_ADDR,
+	COMM_ATTR_ADDR_LIST,
 };
 
 struct comm_attribute {
@@ -217,14 +220,22 @@ static struct comm_attribute comm_attr_local = {
 static struct comm_attribute comm_attr_addr = {
 	.attr   = { .ca_owner = THIS_MODULE,
                     .ca_name = "addr",
-                    .ca_mode = S_IRUGO | S_IWUSR },
+                    .ca_mode = S_IWUSR },
 	.store  = comm_addr_write,
 };
 
+static struct comm_attribute comm_attr_addr_list = {
+	.attr   = { .ca_owner = THIS_MODULE,
+                    .ca_name = "addr_list",
+                    .ca_mode = S_IRUGO },
+	.show   = comm_addr_list_read,
+};
+
 static struct configfs_attribute *comm_attrs[] = {
 	[COMM_ATTR_NODEID] = &comm_attr_nodeid.attr,
 	[COMM_ATTR_LOCAL] = &comm_attr_local.attr,
 	[COMM_ATTR_ADDR] = &comm_attr_addr.attr,
+	[COMM_ATTR_ADDR_LIST] = &comm_attr_addr_list.attr,
 	NULL,
 };
 
@@ -720,6 +731,50 @@ static ssize_t comm_addr_write(struct dlm_comm *cm, const char *buf, size_t len)
 	return len;
 }
 
+static ssize_t comm_addr_list_read(struct dlm_comm *cm, char *buf)
+{
+	ssize_t s;
+	ssize_t allowance;
+	int i;
+	struct sockaddr_storage *addr;
+	struct sockaddr_in *addr_in;
+	struct sockaddr_in6 *addr_in6;
+	
+	/* Taken from ip6_addr_string() defined in lib/vsprintf.c */
+	char buf0[sizeof("AF_INET6	xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:255.255.255.255\n")];
+	
+
+	/* Derived from SIMPLE_ATTR_SIZE of fs/configfs/file.c */
+	allowance = 4096;
+	buf[0] = '\0';
+
+	for (i = 0; i < cm->addr_count; i++) {
+		addr = cm->addr[i];
+
+		switch(addr->ss_family) {
+		case AF_INET:
+			addr_in = (struct sockaddr_in *)addr;
+			s = sprintf(buf0, "AF_INET	%pI4\n", &addr_in->sin_addr.s_addr);
+			break;
+		case AF_INET6:
+			addr_in6 = (struct sockaddr_in6 *)addr;
+			s = sprintf(buf0, "AF_INET6	%pI6\n", &addr_in6->sin6_addr);
+			break;
+		default:
+			s = sprintf(buf0, "%s\n", "<UNKNOWN>");
+			break;
+		}
+		allowance -= s;
+		if (allowance >= 0)
+			strcat(buf, buf0);
+		else {
+			allowance += s;
+			break;
+		}
+	}
+	return 4096 - allowance;
+}
+
 static ssize_t show_node(struct config_item *i, struct configfs_attribute *a,
 			 char *buf)
 {
-- 
1.7.6

