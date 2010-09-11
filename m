Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab0IKBYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 21:24:48 -0400
Received: from smtp-out.google.com ([216.239.44.51]:59424 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab0IKBYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 21:24:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=SWECwmDFDcpDuybSx9O/DLXmFb59V/stnb3ANHeX+y9mPmAO5JPHqCX1RZO3Qk2W7
	bWgp6xcGpvG/Bkve3fMVQ==
From: David Sharp <dhsharp@google.com>
To: rostedt@goodmis.org
Cc: mrubin@google.com, linux-kernel@vger.kernel.org,
        David Sharp <dhsharp@google.com>
Subject: [PATCH] trace-cmd: Use lseek64 and off64_t in tracecmd_append_cpu_data().
Date: Fri, 10 Sep 2010 18:24:18 -0700
Message-Id: <1284168258-24287-1-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lseek64 returns 64-bit, but was being truncated to int. Large offsets would
cause the subsequent error checking to fail spuriously, leaving behind a bad
trace.dat and a collection of trace.dat.cpuX files.
---
 trace-output.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/trace-output.c b/trace-output.c
index 89b3954..0730a1e 100644
--- a/trace-output.c
+++ b/trace-output.c
@@ -705,9 +705,9 @@ out_free:
 int tracecmd_append_cpu_data(struct tracecmd_output *handle,
 			     int cpus, char * const *cpu_data_files)
 {
-	unsigned long long *offsets = NULL;
+	off64_t *offsets = NULL;
 	unsigned long long *sizes = NULL;
-	unsigned long long offset;
+	off64_t offset;
 	unsigned long long endian8;
 	off64_t check_size;
 	char *file;
@@ -733,7 +733,7 @@ int tracecmd_append_cpu_data(struct tracecmd_output *handle,
 	if (!sizes)
 		goto out_free;
 
-	offset = lseek(handle->fd, 0, SEEK_CUR);
+	offset = lseek64(handle->fd, 0, SEEK_CUR);
 
 	/* hold any extra data for data */
 	offset += cpus * (16);
@@ -761,8 +761,8 @@ int tracecmd_append_cpu_data(struct tracecmd_output *handle,
 
 	for (i = 0; i < cpus; i++) {
 		fprintf(stderr, "offset=%llx\n", offsets[i]);
-		ret = lseek64(handle->fd, offsets[i], SEEK_SET);
-		if (ret < 0) {
+		offset = lseek64(handle->fd, offsets[i], SEEK_SET);
+		if (offset == (off64_t)-1) {
 			warning("could not seek to %lld\n", offsets[i]);
 			goto out_free;
 		}
-- 
1.7.1

