Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab1FUAUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 20:20:54 -0400
Received: from smtp-out.google.com ([216.239.44.51]:3065 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004Ab1FUAUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 20:20:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=Zr6nMZbmLCK6QeEDWLkum8iBKpiCDENbXA968DJWk4k6j+zuZs872y+WsGUUh4oSj
	1Wi/zuKW/L4U5cYz0081w==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH] trace-cmd: Add check for truncated files
Date: Mon, 20 Jun 2011 17:19:38 -0700
Message-Id: <1308615578-556-1-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the trace data file that is being read is truncated, mmap'ing its
non-existent page does not give any error. When the page is read, the
process dies with a SIGBUS.

This patch adds a file size check while initializing the trace data and
makes sure that the file size matches the expected size; otherwise an
error is returned.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 trace-input.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/trace-input.c b/trace-input.c
index f537ef5..723d47f 100644
--- a/trace-input.c
+++ b/trace-input.c
@@ -92,6 +92,7 @@ struct tracecmd_input {
 	size_t			header_files_start;
 	size_t			ftrace_files_start;
 	size_t			event_files_start;
+	size_t			total_file_size;
 };
 
 __thread struct tracecmd_input *tracecmd_curr_thread_handle;
@@ -2085,6 +2086,15 @@ int tracecmd_init_data(struct tracecmd_input *handle)
 		handle->cpu_data[cpu].file_offset = offset;
 		handle->cpu_data[cpu].file_size = size;
 
+		if (offset + size > handle->total_file_size) {
+			/* this happens if the file got truncated */
+			printf("File possibly truncated. "
+				"Need at least %llu, but file size is %lu.\n",
+				offset + size, handle->total_file_size);
+			errno = EINVAL;
+			return -1;
+		}
+
 		if (init_cpu(handle, cpu))
 			return -1;
 	}
@@ -2189,6 +2199,12 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd)
 	handle->header_files_start =
 		lseek64(handle->fd, 0, SEEK_CUR);
 
+	handle->total_file_size =
+		lseek64(handle->fd, 0, SEEK_END);
+
+	handle->header_files_start =
+		lseek64(handle->fd, handle->header_files_start, SEEK_SET);
+
 	return handle;
 
  failed_read:
-- 
1.7.3.1

