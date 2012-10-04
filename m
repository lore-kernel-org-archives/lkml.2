Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933830Ab2JDVVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:21:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44933 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933792Ab2JDVVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:21:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [ 27/58] tools/hv: Check for read/write errors
Date: Thu,  4 Oct 2012 14:19:34 -0700
Message-Id: <20121004210638.848007423@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210635.449598766@linuxfoundation.org>
References: <20121004210635.449598766@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 436473bc2173499ae274d0f50111d1e355006caf upstream.

hv_kvp_daemon currently does not check whether fread() or fwrite()
succeed.  Add the necessary checks.  Also, remove the incorrect use of
feof() before fread().

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/hv/hv_kvp_daemon.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -144,7 +144,12 @@ static void kvp_update_file(int pool)
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
 
@@ -165,12 +170,17 @@ static void kvp_update_mem_state(int poo
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
@@ -233,12 +243,18 @@ static int kvp_file_init(void)
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


