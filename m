Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab2LYQCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 11:02:10 -0500
Received: from re04.intra2net.com ([82.165.46.26]:49287 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab2LYQCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 11:02:08 -0500
Message-ID: <50D9CDFC.3010101@intra2net.com>
Date: Tue, 25 Dec 2012 17:02:04 +0100
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org
Subject: [perf PATCH] Use pclose() instead of fclose() on pipe stream
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cppcheck message:
[tools/perf/util/sort.c:277]: (error) Mismatching allocation and deallocation: fp

Also fix descriptor leak on error

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
---
 tools/perf/util/sort.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index cfd1c0f..586d2ea 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -274,7 +274,6 @@ static int hist_entry__srcline_snprintf(struct hist_entry *self, char *bf,
 
 	if (getline(&path, &line_len, fp) < 0 || !line_len)
 		goto out_ip;
-	fclose(fp);
 	self->srcline = strdup(path);
 	if (self->srcline == NULL)
 		goto out_ip;
@@ -284,8 +283,10 @@ static int hist_entry__srcline_snprintf(struct hist_entry *self, char *bf,
 		*nl = '\0';
 	path = self->srcline;
 out_path:
+	pclose(fp);
 	return repsep_snprintf(bf, size, "%s", path);
 out_ip:
+	pclose(fp);
 	return repsep_snprintf(bf, size, "%-#*llx", BITS_PER_LONG / 4, self->ip);
 }
 
-- 
1.7.11.7

