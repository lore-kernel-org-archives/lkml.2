Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946526Ab2JDVpY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:45:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44933 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934200Ab2JDVYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:24:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [ 23/52] tools/hv: Fix exit() error code
Date: Thu,  4 Oct 2012 14:21:14 -0700
Message-Id: <20121004210638.241595084@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210635.372689554@linuxfoundation.org>
References: <20121004210635.372689554@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 6bb22fea25624ab593eee376fa5fb82d1b13f45a upstream.

Linux native exit codes are 8-bit unsigned values.  exit(-1) results
in an exit code of 255, which is usually reserved for shells reporting
'command not found'.  Use the portable value EXIT_FAILURE.  (Not that
this matters much for a daemon.)

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/hv/hv_kvp_daemon.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -106,7 +106,7 @@ static void kvp_acquire_lock(int pool)
 
 	if (fcntl(kvp_file_info[pool].fd, F_SETLKW, &fl) == -1) {
 		syslog(LOG_ERR, "Failed to acquire the lock pool: %d", pool);
-		exit(-1);
+		exit(EXIT_FAILURE);
 	}
 }
 
@@ -118,7 +118,7 @@ static void kvp_release_lock(int pool)
 	if (fcntl(kvp_file_info[pool].fd, F_SETLK, &fl) == -1) {
 		perror("fcntl");
 		syslog(LOG_ERR, "Failed to release the lock pool: %d", pool);
-		exit(-1);
+		exit(EXIT_FAILURE);
 	}
 }
 
@@ -137,7 +137,7 @@ static void kvp_update_file(int pool)
 	if (!filep) {
 		kvp_release_lock(pool);
 		syslog(LOG_ERR, "Failed to open file, pool: %d", pool);
-		exit(-1);
+		exit(EXIT_FAILURE);
 	}
 
 	bytes_written = fwrite(kvp_file_info[pool].records,
@@ -163,7 +163,7 @@ static void kvp_update_mem_state(int poo
 	if (!filep) {
 		kvp_release_lock(pool);
 		syslog(LOG_ERR, "Failed to open file, pool: %d", pool);
-		exit(-1);
+		exit(EXIT_FAILURE);
 	}
 	while (!feof(filep)) {
 		readp = &record[records_read];
@@ -180,7 +180,7 @@ static void kvp_update_mem_state(int poo
 
 			if (record == NULL) {
 				syslog(LOG_ERR, "malloc failed");
-				exit(-1);
+				exit(EXIT_FAILURE);
 			}
 			continue;
 		}
@@ -209,7 +209,7 @@ static int kvp_file_init(void)
 	if (access("/var/opt/hyperv", F_OK)) {
 		if (mkdir("/var/opt/hyperv", S_IRUSR | S_IWUSR | S_IROTH)) {
 			syslog(LOG_ERR, " Failed to create /var/opt/hyperv");
-			exit(-1);
+			exit(EXIT_FAILURE);
 		}
 	}
 
@@ -658,13 +658,13 @@ int main(void)
 
 	if (kvp_file_init()) {
 		syslog(LOG_ERR, "Failed to initialize the pools");
-		exit(-1);
+		exit(EXIT_FAILURE);
 	}
 
 	fd = socket(AF_NETLINK, SOCK_DGRAM, NETLINK_CONNECTOR);
 	if (fd < 0) {
 		syslog(LOG_ERR, "netlink socket creation failed; error:%d", fd);
-		exit(-1);
+		exit(EXIT_FAILURE);
 	}
 	addr.nl_family = AF_NETLINK;
 	addr.nl_pad = 0;
@@ -676,7 +676,7 @@ int main(void)
 	if (error < 0) {
 		syslog(LOG_ERR, "bind failed; error:%d", error);
 		close(fd);
-		exit(-1);
+		exit(EXIT_FAILURE);
 	}
 	sock_opt = addr.nl_groups;
 	setsockopt(fd, 270, 1, &sock_opt, sizeof(sock_opt));
@@ -696,7 +696,7 @@ int main(void)
 	if (len < 0) {
 		syslog(LOG_ERR, "netlink_send failed; error:%d", len);
 		close(fd);
-		exit(-1);
+		exit(EXIT_FAILURE);
 	}
 
 	pfd.fd = fd;
@@ -864,7 +864,7 @@ kvp_done:
 		len = netlink_send(fd, incoming_cn_msg);
 		if (len < 0) {
 			syslog(LOG_ERR, "net_link send failed; error:%d", len);
-			exit(-1);
+			exit(EXIT_FAILURE);
 		}
 	}
 


