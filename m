Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab1AQSOB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 13:14:01 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54295 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab1AQSOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 13:14:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:user-agent:mime-version
         :content-type;
        b=ISRJlU3liygGc2Tlje4qodRdxwIibIKfLYkOypwWrKAJlOe6cGh/aY815cIn0zOnZA
         R7zg5O61el1lPLTylZjsgvb/JRm3heFW0185byLcZezITGqFVqpPUx2NXCjhn1tB/wp7
         Lbe19MBmuoN0fT+zs3m9UdEiPkmNTGFNDJawk=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] perf-tools: minor cleanup in parse_single_tracepoint_event() when parsing id
Date: Mon, 17 Jan 2011 19:13:56 +0100
Message-ID: <m3zkqzv1nf.fsf@gmail.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Franck Bui-Huu <fbuihuu@gmail.com>

And trust the kernel to return a valid number as the previous code
already assume.

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
---
 tools/perf/util/parse-events.c |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index a58407e..777ce03 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -414,25 +414,19 @@ parse_single_tracepoint_event(char *sys_name,
 			      const char **strp)
 {
 	char evt_path[MAXPATHLEN];
-	char id_buf[4];
 	u64 id;
-	int fd;
+	FILE *fp;
 	size_t len;
 
 	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", debugfs_path,
 		 sys_name, evt_name);
 
-	fd = open(evt_path, O_RDONLY);
-	if (fd < 0)
-		return EVT_FAILED;
-
-	if (read(fd, id_buf, sizeof(id_buf)) < 0) {
-		close(fd);
+	fp = fopen(evt_path, "r");
+	if (!fp)
 		return EVT_FAILED;
-	}
+	fscanf(fp, "%Lu", &id);
+	fclose(fp);
 
-	close(fd);
-	id = atoll(id_buf);
 	attr->config = id;
 	attr->type = PERF_TYPE_TRACEPOINT;
 
-- 
1.7.3.2
