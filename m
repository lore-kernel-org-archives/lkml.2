Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032999Ab2CSU25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 16:28:57 -0400
Received: from mail-yx0-f202.google.com ([209.85.213.202]:55645 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759381Ab2CSU2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 16:28:48 -0400
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Justin Teravest <teravest@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 2/2] trace-cmd: Close the trace file descriptor
Date: Mon, 19 Mar 2012 13:28:43 -0700
Message-Id: <1332188923-13375-2-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332188923-13375-1-git-send-email-vnagarnaik@google.com>
References: <1332188923-13375-1-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trace-cmd opens "trace_raw" file descriptor to splice data continuously
through it to the CPU files. This causes a lot of pages being allocated
for the splice interface in the kernel. After the recorder instance is
destroyed, it doesn't close the file descriptor causing many of the
pages to remain in the cache. This gives an invalid view of memory lying
around in cache.

In any case, it is a good practice for the applications to close all the
descriptors that are opened.

This patch closes the open file descriptor which is used in the splice()
call and updates the check for disk file descriptor when closing it.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 trace-recorder.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/trace-recorder.c b/trace-recorder.c
index 4a01fb9..215affc 100644
--- a/trace-recorder.c
+++ b/trace-recorder.c
@@ -50,7 +50,10 @@ void tracecmd_free_recorder(struct tracecmd_recorder *recorder)
 	if (!recorder)
 		return;
 
-	if (recorder->fd)
+	if (recorder->trace_fd >= 0)
+		close(recorder->trace_fd);
+
+	if (recorder->fd >= 0)
 		close(recorder->fd);
 
 	free(recorder);
-- 
1.7.7.3

