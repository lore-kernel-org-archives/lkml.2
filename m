Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab1A0S2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 13:28:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:49029 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805Ab1A0S2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 13:28:35 -0500
Date: Thu, 27 Jan 2011 18:28:04 GMT
From: tip-bot for Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, eric.dumazet@gmail.com,
        a.p.zijlstra@chello.nl, davem@davemloft.net, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        a.p.zijlstra@chello.nl, davem@davemloft.net, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1295980851.3588.351.camel@edumazet-laptop>
References: <1295980851.3588.351.camel@edumazet-laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix alloc_callchain_buffers()
Message-ID: <tip-88d4f0db7fa8785859c1d637f9aac210932b6216@git.kernel.org>
Git-Commit-ID: 88d4f0db7fa8785859c1d637f9aac210932b6216
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 27 Jan 2011 18:28:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  88d4f0db7fa8785859c1d637f9aac210932b6216
Gitweb:     http://git.kernel.org/tip/88d4f0db7fa8785859c1d637f9aac210932b6216
Author:     Eric Dumazet <eric.dumazet@gmail.com>
AuthorDate: Tue, 25 Jan 2011 19:40:51 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 27 Jan 2011 19:21:50 +0100

perf: Fix alloc_callchain_buffers()

Commit 927c7a9e92c4 ("perf: Fix race in callchains") introduced
a mismatch in the sizing of struct callchain_cpus_entries.

nr_cpu_ids must be used instead of num_possible_cpus(), or we
might get out of bound memory accesses on some machines.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Miller <davem@davemloft.net>
Cc: Stephane Eranian <eranian@google.com>
CC: stable@kernel.org
LKML-Reference: <1295980851.3588.351.camel@edumazet-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 126a302..852ae8c 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1999,8 +1999,7 @@ static int alloc_callchain_buffers(void)
 	 * accessed from NMI. Use a temporary manual per cpu allocation
 	 * until that gets sorted out.
 	 */
-	size = sizeof(*entries) + sizeof(struct perf_callchain_entry *) *
-		num_possible_cpus();
+	size = offsetof(struct callchain_cpus_entries, cpu_entries[nr_cpu_ids]);
 
 	entries = kzalloc(size, GFP_KERNEL);
 	if (!entries)
