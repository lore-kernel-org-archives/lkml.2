Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab2DIIWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 04:22:48 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:39392 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977Ab2DIIWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 04:22:47 -0400
From: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Subject: [BUG PATCH] perf: kvm - finding struct machine fails for
 PERF_RECORD_MMAP
To: mingo@redhat.com, acme@ghostprotocols.net, dsahern@gmail.com
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, fweisbec@gmail.com,
        eranian@google.com, linux-kernel@vger.kernel.org,
        nikunj@linux.vnet.ibm.com
Date: Mon, 09 Apr 2012 13:52:23 +0530
Message-ID: <20120409081835.10576.22018.stgit@abhimanyu.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12040908-5564-0000-0000-0000022166FD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>

Running 'perf kvm --host --guest --guestmount /tmp/guestmount record -a -g -- sleep 2'

Was resulting in a segfault. For event type PERF_RECORD_MMAP,
event->ip.pid is being used in perf_session__find_machine_for_cpumode,
which is not correct.

event->ip.pid happens to be 0 in this case and results in returning a
NULL machine object. Finally, access to self->pid in
machine__mmap_name, results in a segfault later.

For PERF_RECORD_MMAP type, pass event->mmap.pid.

Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
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

