Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759582Ab2IEVTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 17:19:53 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:35279
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759538Ab2IEVTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 17:19:49 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        ben@decadent.org.uk, thozza@redhat.com, dcbw@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, stable@vger.kernel.org
Subject: [PATCH 3/3] tools/hv: Check for read/write errors
Date: Wed,  5 Sep 2012 14:37:37 -0700
Message-Id: <1346881057-31479-3-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1346881057-31479-1-git-send-email-kys@microsoft.com>
References: <1346881020-31440-1-git-send-email-kys@microsoft.com>
 <1346881057-31479-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

hv_kvp_daemon currently does not check whether fread() or fwrite()
succeed.  Add the necessary checks.  Also, remove the incorrect use of
feof() before fread().

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: stable@vger.kernel.org
---
 tools/hv/hv_kvp_daemon.c |   22 +++++++++++++++++++---
 1 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 01b3ca5..3922abc 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -160,7 +160,12 @@ static void kvp_update_file(int pool)
 				sizeof(struct kvp_record),
 				kvp_file_info[pool].num_records, filep);
 
-	fclose(filep);
+	if (ferror(filep) || fclose(filep)) {
+		kvp_release_lock(pool);
+		syslog(LOG_ERR, "Failed to write file, pool: %d", pool);
+		exit(EXIT_FAILURE);
+	}
+
 	kvp_release_lock(pool);
 }
 
@@ -181,12 +186,17 @@ static void kvp_update_mem_state(int pool)
 		syslog(LOG_ERR, "Failed to open file, pool: %d", pool);
 		exit(EXIT_FAILURE);
 	}
-	while (!feof(filep)) {
+	for (;;) {
 		readp = &record[records_read];
 		records_read += fread(readp, sizeof(struct kvp_record),
 					ENTRIES_PER_BLOCK * num_blocks,
 					filep);
 
+		if (ferror(filep)) {
+			syslog(LOG_ERR, "Failed to read file, pool: %d", pool);
+			exit(EXIT_FAILURE);
+		}
+
 		if (!feof(filep)) {
 			/*
 			 * We have more data to read.
@@ -249,12 +259,18 @@ static int kvp_file_init(void)
 			fclose(filep);
 			return 1;
 		}
-		while (!feof(filep)) {
+		for (;;) {
 			readp = &record[records_read];
 			records_read += fread(readp, sizeof(struct kvp_record),
 					ENTRIES_PER_BLOCK,
 					filep);
 
+			if (ferror(filep)) {
+				syslog(LOG_ERR, "Failed to read file, pool: %d",
+				       i);
+				exit(EXIT_FAILURE);
+			}
+
 			if (!feof(filep)) {
 				/*
 				 * We have more data to read.
-- 
1.7.4.1

