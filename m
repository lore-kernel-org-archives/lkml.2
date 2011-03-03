Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab1CCGXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 01:23:40 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56004 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755845Ab1CCGXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 01:23:39 -0500
Message-ID: <4D6F3461.6060406@cn.fujitsu.com>
Date: Thu, 03 Mar 2011 14:25:37 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] perf cgroup: Fix leak of file reference count
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-03 14:22:19,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-03 14:22:19,
	Serialize complete at 2011-03-03 14:22:19
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In perf_cgroup_connect(), fput_light() is missing in a failure
path.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/perf_event.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 64a018e..4a955fd 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -404,8 +404,10 @@ static inline int perf_cgroup_connect(int fd, struct perf_event *event,
 		return -EBADF;
 
 	css = cgroup_css_from_dir(file, perf_subsys_id);
-	if (IS_ERR(css))
-		return PTR_ERR(css);
+	if (IS_ERR(css)) {
+		ret = PTR_ERR(css);
+		goto out;
+	}
 
 	cgrp = container_of(css, struct perf_cgroup, css);
 	event->cgrp = cgrp;
@@ -422,6 +424,7 @@ static inline int perf_cgroup_connect(int fd, struct perf_event *event,
 		/* must be done before we fput() the file */
 		perf_get_cgroup(event);
 	}
+out:
 	fput_light(file, fput_needed);
 	return ret;
 }
-- 
1.6.3
