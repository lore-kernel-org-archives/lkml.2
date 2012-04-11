Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257Ab2DKU6C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 16:58:02 -0400
Received: from casper.infradead.org ([85.118.1.10]:45862 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab2DKU57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 16:57:59 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/1] perf kvm: Finding struct machine fails for PERF_RECORD_MMAP
Date: Wed, 11 Apr 2012 17:57:43 -0300
Message-Id: <1334177863-18820-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1334177863-18820-1-git-send-email-acme@infradead.org>
References: <1334177863-18820-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>

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
 1 file changed, 10 insertions(+), 2 deletions(-)

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
-- 
1.7.9.2.358.g22243

