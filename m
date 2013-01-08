Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab3AHL13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 06:27:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756114Ab3AHL12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 06:27:28 -0500
From: Tomas Hozza <thozza@redhat.com>
To: gregkh@linuxfoundation.org
Cc: kys@microsoft.com, jasowang@redhat.com, haiyangz@microsoft.com,
        linux-kernel@vger.kernel.org, habdi@microsoft.com,
        Tomas Hozza <thozza@redhat.com>
Subject: [PATCH 2/2] tools: hv: Use CLOEXEC when opening kvp_pool files
Date: Tue,  8 Jan 2013 12:26:43 +0100
Message-Id: <1357644403-11140-2-git-send-email-thozza@redhat.com>
In-Reply-To: <1357644403-11140-1-git-send-email-thozza@redhat.com>
References: <1357644403-11140-1-git-send-email-thozza@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use CLOEXEC flag when opening kvp_pool_x files to prevent file
descriptor leakage. Not using it was causing a problem when
SELinux was enabled.

Signed-off-by: Tomas Hozza <thozza@redhat.com>
---
 tools/hv/hv_kvp_daemon.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 6b56b75..31f839cc 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -151,7 +151,7 @@ static void kvp_update_file(int pool)
 	 */
 	kvp_acquire_lock(pool);
 
-	filep = fopen(kvp_file_info[pool].fname, "w");
+	filep = fopen(kvp_file_info[pool].fname, "we");
 	if (!filep) {
 		kvp_release_lock(pool);
 		syslog(LOG_ERR, "Failed to open file, pool: %d", pool);
@@ -182,7 +182,7 @@ static void kvp_update_mem_state(int pool)
 
 	kvp_acquire_lock(pool);
 
-	filep = fopen(kvp_file_info[pool].fname, "r");
+	filep = fopen(kvp_file_info[pool].fname, "re");
 	if (!filep) {
 		kvp_release_lock(pool);
 		syslog(LOG_ERR, "Failed to open file, pool: %d", pool);
@@ -246,13 +246,13 @@ static int kvp_file_init(void)
 		records_read = 0;
 		num_blocks = 1;
 		sprintf(fname, "/var/opt/hyperv/.kvp_pool_%d", i);
-		fd = open(fname, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR | S_IROTH);
+		fd = open(fname, O_RDWR | O_CREAT | O_CLOEXEC, S_IRUSR | S_IWUSR | S_IROTH);
 
 		if (fd == -1)
 			return 1;
 
 
-		filep = fopen(fname, "r");
+		filep = fopen(fname, "re");
 		if (!filep)
 			return 1;
 
-- 
1.7.11.7

