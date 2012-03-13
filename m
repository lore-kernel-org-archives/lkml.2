Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765Ab2CMARl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:17:41 -0400
Received: from mail.windriver.com ([147.11.1.11]:46633 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757642Ab2CMARi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:17:38 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 007/196] perf: Better fit max unprivileged mlock pages for tools needs
Date: Mon, 12 Mar 2012 20:12:15 -0400
Message-Id: <1331597724-31358-8-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 880f57318450dbead6a03f9e31a1468924d6dd88 upstream.

The maximum kilobytes of locked memory that an unprivileged user
can reserve is of 512 kB = 128 pages by default, scaled to the
number of onlined CPUs, which fits well with the tools that use
128 data pages by default.

However tools actually use 129 pages, because they need one more
for the user control page. Thus the default mlock threshold is
not sufficient for the default tools needs and we always end up
to evaluate the constant mlock rlimit policy, which doesn't have
this scaling with the number of online CPUs.

Hence, on systems that have more than 16 CPUs, we overlap the
rlimit threshold and fail to mmap:

	$ perf record ls
	Error: failed to mmap with 1 (Operation not permitted)

Just increase the max unprivileged mlock threshold by one page
so that it supports well perf tools even after 16 CPUs.

Reported-by: Han Pingtian <phan@redhat.com>
Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <1300904979-5508-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/perf_event.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 2357b19..b203546 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -57,7 +57,8 @@ static atomic_t nr_task_events __read_mostly;
  */
 int sysctl_perf_event_paranoid __read_mostly = 1;
 
-int sysctl_perf_event_mlock __read_mostly = 512; /* 'free' kb per user */
+/* Minimum for 128 pages + 1 for the user control page */
+int sysctl_perf_event_mlock __read_mostly = 516; /* 'free' kb per user */
 
 /*
  * max perf event sample rate
-- 
1.7.9.3

