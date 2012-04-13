Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab2DMSNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:13:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51598 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab2DMSNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:13:40 -0400
Date: Fri, 13 Apr 2012 11:13:18 -0700
From: "tip-bot for Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Message-ID: <tip-7fb0a5ee8889488f7568ffddffeb66ddeb50917e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, nikunj@linux.vnet.ibm.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, nikunj@linux.vnet.ibm.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <20120409081835.10576.22018.stgit@abhimanyu.in.ibm.com>
References: <20120409081835.10576.22018.stgit@abhimanyu.in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf kvm:
  Finding struct machine fails for PERF_RECORD_MMAP
Git-Commit-ID: 7fb0a5ee8889488f7568ffddffeb66ddeb50917e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 13 Apr 2012 11:13:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7fb0a5ee8889488f7568ffddffeb66ddeb50917e
Gitweb:     http://git.kernel.org/tip/7fb0a5ee8889488f7568ffddffeb66ddeb50917e
Author:     Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
AuthorDate: Mon, 9 Apr 2012 13:52:23 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 11 Apr 2012 11:45:12 -0300

perf kvm: Finding struct machine fails for PERF_RECORD_MMAP

Running 'perf kvm --host --guest --guestmount /tmp/guestmount record -a -g -- sleep 2'

Was resulting in a segfault. For event type PERF_RECORD_MMAP,
event->ip.pid is being used in perf_session__find_machine_for_cpumode,
which is not correct.

The event->ip.pid field happens to be 0 in this case and results in
returning a NULL machine object. Finally, access to self->pid in
machine__mmap_name, results in a segfault later.

For PERF_RECORD_MMAP type, pass event->mmap.pid.

Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Tested-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20120409081835.10576.22018.stgit@abhimanyu.in.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 9412e3b..00923cd 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -826,8 +826,16 @@ static struct machine *
 {
 	const u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
-	if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL && perf_guest)
-		return perf_session__find_machine(session, event->ip.pid);
+	if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL && perf_guest) {
+		u32 pid;
+
+		if (event->header.type == PERF_RECORD_MMAP)
+			pid = event->mmap.pid;
+		else
+			pid = event->ip.pid;
+
+		return perf_session__find_machine(session, pid);
+	}
 
 	return perf_session__find_host_machine(session);
 }
