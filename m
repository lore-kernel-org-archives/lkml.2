Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab2CBJxF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 04:53:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44114 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755830Ab2CBJxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 04:53:02 -0500
Date: Fri, 2 Mar 2012 01:52:15 -0800
From: tip-bot for Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
Message-ID: <tip-1c1bc9223387dacc48eb2b61b0baabe7e9cf47f6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, prashanth@linux.vnet.ibm.com, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        akpm@linux-foundation.org, srikar@linux.vnet.ibm.com,
        tglx@linutronix.de, jbaron@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, prashanth@linux.vnet.ibm.com, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        akpm@linux-foundation.org, srikar@linux.vnet.ibm.com,
        jbaron@redhat.com, tglx@linutronix.de
In-Reply-To: <4F4C544D.1010909@linux.vnet.ibm.com>
References: <4F4C544D.1010909@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe:
  Ensure offset provided is not greater than function length without DWARF info too
Git-Commit-ID: 1c1bc9223387dacc48eb2b61b0baabe7e9cf47f6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 02 Mar 2012 01:52:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1c1bc9223387dacc48eb2b61b0baabe7e9cf47f6
Gitweb:     http://git.kernel.org/tip/1c1bc9223387dacc48eb2b61b0baabe7e9cf47f6
Author:     Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
AuthorDate: Tue, 28 Feb 2012 09:43:01 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 Feb 2012 18:29:46 -0300

perf probe: Ensure offset provided is not greater than function length without DWARF info too

The 'perf probe' command allows kprobe to be inserted at any offset from
a function start, which results in adding kprobes to unintended
location.  (example: perf probe do_fork+10000 is allowed even though
size of do_fork is ~904).

My previous patch https://lkml.org/lkml/2012/2/24/42 addressed the case
where DWARF info was available for the kernel. This patch fixes the
case where perf probe is used on a kernel without debuginfo available.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/4F4C544D.1010909@linux.vnet.ibm.com
Signed-off-by: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 29cb654..e33554a 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1867,6 +1867,12 @@ static int convert_to_probe_trace_events(struct perf_probe_event *pev,
 			   tev->point.symbol);
 		ret = -ENOENT;
 		goto error;
+	} else if (tev->point.offset > sym->end - sym->start) {
+		pr_warning("Offset specified is greater than size of %s\n",
+			   tev->point.symbol);
+		ret = -ENOENT;
+		goto error;
+
 	}
 
 	return 1;
