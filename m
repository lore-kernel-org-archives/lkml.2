Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533Ab1CDLvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 06:51:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:41871 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131Ab1CDLvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 06:51:23 -0500
Date: Fri, 4 Mar 2011 11:50:57 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, lizf@cn.fujitsu.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4D6F3461.6060406@cn.fujitsu.com>
References: <4D6F3461.6060406@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf cgroup: Fix leak of file reference count
Message-ID: <tip-3db272c0494900fcb905a201180a78cae3addd6e@git.kernel.org>
Git-Commit-ID: 3db272c0494900fcb905a201180a78cae3addd6e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 04 Mar 2011 11:50:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3db272c0494900fcb905a201180a78cae3addd6e
Gitweb:     http://git.kernel.org/tip/3db272c0494900fcb905a201180a78cae3addd6e
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 3 Mar 2011 14:25:37 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Mar 2011 11:32:50 +0100

perf cgroup: Fix leak of file reference count

In perf_cgroup_connect(), fput_light() is missing in a failure path.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4D6F3461.6060406@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 821ce82..7c999e8 100644
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
