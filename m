Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889Ab2BIPMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 10:12:46 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45027 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab2BIPMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 10:12:44 -0500
Date: Thu, 9 Feb 2012 16:12:38 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, mingo@elte.hu
Subject: [PATCH] perf: cleanup initialization of attr->size
Message-ID: <20120209151238.GA10272@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The perf_event_attr size needs to be initialized
in all cases because it captures the ABI version.

This patch moves the initialization of the field
from the perf_event_open() syscall stub to its proper
location in the event_attr_init().

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 92af168..06f2d1a 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -167,7 +167,6 @@ sys_perf_event_open(struct perf_event_attr *attr,
 		      pid_t pid, int cpu, int group_fd,
 		      unsigned long flags)
 {
-	attr->size = sizeof(*attr);
 	return syscall(__NR_perf_event_open, attr, pid, cpu,
 		       group_fd, flags);
 }
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 8131410..c1017b3 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -14,6 +14,8 @@ void event_attr_init(struct perf_event_attr *attr)
 		attr->exclude_host  = 1;
 	if (!perf_guest)
 		attr->exclude_guest = 1;
+	/* to capture ABI version */
+	attr->size = sizeof(*attr);
 }
 
 int mkdir_p(char *path, mode_t mode)
