Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000Ab2IEQpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 12:45:38 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:41394
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754235Ab2IEQoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 12:44:46 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        ben@decadent.org.uk, thozza@redhat.com, dcbw@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, stable@vger.kernel.org
Subject: [PATCH 2/4] tools: hv: Fix exit() error code
Date: Wed,  5 Sep 2012 10:02:31 -0700
Message-Id: <1346864553-30059-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1346864553-30059-1-git-send-email-kys@microsoft.com>
References: <1346864519-30020-1-git-send-email-kys@microsoft.com>
 <1346864553-30059-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux native exit codes are 8-bit unsigned values.  exit(-1) results
in an exit code of 255, which is usually reserved for shells reporting
'command not found'.  Use the portable value EXIT_FAILURE.  (Not that
this matters much for a daemon.)

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: stable@vger.kernel.org
---
 tools/hv/hv_kvp_daemon.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 4514fb4..01b3ca5 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -122,7 +122,7 @@ static void kvp_acquire_lock(int pool)
 
 	if (fcntl(kvp_file_info[pool].fd, F_SETLKW, &fl) == -1) {
 		syslog(LOG_ERR, "Failed to acquire the lock pool: %d", pool);
-		exit(-1);
+		exit(EXIT_FAILURE);
 	}
 }
 
@@ -134,7 +134,7 @@ static void kvp_release_lock(int pool)
 	if (fcntl(kvp_file_info[pool].fd, F_SETLK, &fl) == -1) {
 		perror("fcntl");
 		syslog(LOG_ERR, "Failed to release the lock pool: %d", pool);
-		exit(-1);
+		exit(EXIT_FAILURE);
 	}
 }
 
@@ -153,7 +153,7 @@ static void kvp_update_file(int pool)
 	if (!filep) {
 		kvp_release_lock(pool);
 		syslog(LOG_ERR, "Failed to open file, pool: %d", pool);
-		exit(-1);
+		exit(EXIT_FAILURE);
 	}
 
 	bytes_written = fwrite(kvp_file_info[pool].records,
@@ -179,7 +179,7 @@ static void kvp_update_mem_state(int pool)
 	if (!filep) {
 		kvp_release_lock(pool);
 		syslog(LOG_ERR, "Failed to open file, pool: %d", pool);
-		exit(-1);
+		exit(EXIT_FAILURE);
 	}
 	while (!feof(filep)) {
 		readp = &record[records_read];
@@ -196,7 +196,7 @@ static void kvp_update_mem_state(int pool)
 
 			if (record == NULL) {
 				syslog(LOG_ERR, "malloc failed");
-				exit(-1);
+				exit(EXIT_FAILURE);
 			}
 			continue;
 		}
@@ -225,7 +225,7 @@ static int kvp_file_init(void)
 	if (access("/var/opt/hyperv", F_OK)) {
 		if (mkdir("/var/opt/hyperv", S_IRUSR | S_IWUSR | S_IROTH)) {
 			syslog(LOG_ERR, " Failed to create /var/opt/hyperv");
-			exit(-1);
+			exit(EXIT_FAILURE);
 		}
 	}
 
@@ -1358,13 +1358,13 @@ int main(void)
 
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
@@ -1376,7 +1376,7 @@ int main(void)
 	if (error < 0) {
 		syslog(LOG_ERR, "bind failed; error:%d", error);
 		close(fd);
-		exit(-1);
+		exit(EXIT_FAILURE);
 	}
 	sock_opt = addr.nl_groups;
 	setsockopt(fd, 270, 1, &sock_opt, sizeof(sock_opt));
@@ -1396,7 +1396,7 @@ int main(void)
 	if (len < 0) {
 		syslog(LOG_ERR, "netlink_send failed; error:%d", len);
 		close(fd);
-		exit(-1);
+		exit(EXIT_FAILURE);
 	}
 
 	pfd.fd = fd;
@@ -1608,7 +1608,7 @@ kvp_done:
 		len = netlink_send(fd, incoming_cn_msg);
 		if (len < 0) {
 			syslog(LOG_ERR, "net_link send failed; error:%d", len);
-			exit(-1);
+			exit(EXIT_FAILURE);
 		}
 	}
 
-- 
1.7.4.1

