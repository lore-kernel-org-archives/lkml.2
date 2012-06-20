Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475Ab2FTKtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:49:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34490 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab2FTKtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:49:21 -0400
Date: Wed, 20 Jun 2012 03:49:06 -0700
From: tip-bot for Salman Qazi <sqazi@google.com>
Message-ID: <tip-9c5da09d266ca9b32eb16cf940f8161d949c2fe5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, sqazi@google.com, tj@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, sqazi@google.com, tj@kernel.org,
        tglx@linutronix.de
In-Reply-To: <20120614223108.1025.2503.stgit@dungbeetle.mtv.corp.google.com>
References: <20120614223108.1025.2503.stgit@dungbeetle.mtv.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Use css_tryget()
  to avoid propping up css refcount
Git-Commit-ID: 9c5da09d266ca9b32eb16cf940f8161d949c2fe5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 20 Jun 2012 03:49:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9c5da09d266ca9b32eb16cf940f8161d949c2fe5
Gitweb:     http://git.kernel.org/tip/9c5da09d266ca9b32eb16cf940f8161d949c2fe5
Author:     Salman Qazi <sqazi@google.com>
AuthorDate: Thu, 14 Jun 2012 15:31:09 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 18 Jun 2012 11:45:57 +0200

perf: Use css_tryget() to avoid propping up css refcount

An rmdir pushes css's ref count to zero.  However, if the associated
directory is open at the time, the dentry ref count is non-zero.  If
the fd for this directory is then passed into perf_event_open, it
does a css_get().  This bounces the ref count back up from zero.  This
is a problem by itself.  But what makes it turn into a crash is the
fact that we end up doing an extra dput, since we perform a dput
when css_put sees the ref count go down to zero.

css_tryget() does not fall into that trap. So, we use that instead.

Reproduction test-case for the bug:

 #include <unistd.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <linux/unistd.h>
 #include <linux/perf_event.h>
 #include <string.h>
 #include <errno.h>
 #include <stdio.h>

 #define PERF_FLAG_PID_CGROUP    (1U << 2)

 int perf_event_open(struct perf_event_attr *hw_event_uptr,
                     pid_t pid, int cpu, int group_fd, unsigned long flags) {
         return syscall(__NR_perf_event_open,hw_event_uptr, pid, cpu,
                 group_fd, flags);
 }

 /*
  * Directly poke at the perf_event bug, since it's proving hard to repro
  * depending on where in the kernel tree.  what moved?
  */
 int main(int argc, char **argv)
 {
        int fd;
        struct perf_event_attr attr;
        memset(&attr, 0, sizeof(attr));
        attr.exclude_kernel = 1;
        attr.size = sizeof(attr);
        mkdir("/dev/cgroup/perf_event/blah", 0777);
        fd = open("/dev/cgroup/perf_event/blah", O_RDONLY);
        perror("open");
        rmdir("/dev/cgroup/perf_event/blah");
        sleep(2);
        perf_event_open(&attr, fd, 0, -1,  PERF_FLAG_PID_CGROUP);
        perror("perf_event_open");
        close(fd);
        return 0;
 }

Signed-off-by: Salman Qazi <sqazi@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/20120614223108.1025.2503.stgit@dungbeetle.mtv.corp.google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index f85c015..d7d71d6 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -253,9 +253,9 @@ perf_cgroup_match(struct perf_event *event)
 	return !event->cgrp || event->cgrp == cpuctx->cgrp;
 }
 
-static inline void perf_get_cgroup(struct perf_event *event)
+static inline bool perf_tryget_cgroup(struct perf_event *event)
 {
-	css_get(&event->cgrp->css);
+	return css_tryget(&event->cgrp->css);
 }
 
 static inline void perf_put_cgroup(struct perf_event *event)
@@ -484,7 +484,11 @@ static inline int perf_cgroup_connect(int fd, struct perf_event *event,
 	event->cgrp = cgrp;
 
 	/* must be done before we fput() the file */
-	perf_get_cgroup(event);
+	if (!perf_tryget_cgroup(event)) {
+		event->cgrp = NULL;
+		ret = -ENOENT;
+		goto out;
+	}
 
 	/*
 	 * all events in a group must monitor
