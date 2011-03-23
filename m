Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933369Ab1CWVTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 17:19:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:35827 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932133Ab1CWVTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 17:19:31 -0400
Date: Wed, 23 Mar 2011 21:19:09 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        fweisbec@gmail.com, phan@redhat.com, stable@kernel.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        fweisbec@gmail.com, phan@redhat.com, stable@kernel.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1300904979-5508-1-git-send-email-fweisbec@gmail.com>
References: <1300904979-5508-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Better fit max unprivileged mlock pages for tools needs
Message-ID: <tip-880f57318450dbead6a03f9e31a1468924d6dd88@git.kernel.org>
Git-Commit-ID: 880f57318450dbead6a03f9e31a1468924d6dd88
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Mar 2011 21:19:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  880f57318450dbead6a03f9e31a1468924d6dd88
Gitweb:     http://git.kernel.org/tip/880f57318450dbead6a03f9e31a1468924d6dd88
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Wed, 23 Mar 2011 19:29:39 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 23 Mar 2011 20:57:04 +0100

perf: Better fit max unprivileged mlock pages for tools needs

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
Cc: Stable <stable@kernel.org>
LKML-Reference: <1300904979-5508-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 0c71422..c75925c 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -145,7 +145,8 @@ static struct srcu_struct pmus_srcu;
  */
 int sysctl_perf_event_paranoid __read_mostly = 1;
 
-int sysctl_perf_event_mlock __read_mostly = 512; /* 'free' kb per user */
+/* Minimum for 128 pages + 1 for the user control page */
+int sysctl_perf_event_mlock __read_mostly = 516; /* 'free' kb per user */
 
 /*
  * max perf event sample rate
