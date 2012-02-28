Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab2B1ENU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 23:13:20 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:49902 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab2B1ENT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 23:13:19 -0500
Message-ID: <4F4C544D.1010909@linux.vnet.ibm.com>
Date: Tue, 28 Feb 2012 09:43:01 +0530
From: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: masami.hiramatsu.pt@hitachi.com, ananth@in.ibm.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        acme@infradead.org
CC: jbaron@redhat.com, rostedt@goodmis.org, srikar@linux.vnet.ibm.com
Subject: [PATCH] perf - ensure offset provided during probe addition is not
 greater than function size when no DWARF info
References: <4F4C53C7.2080904@linux.vnet.ibm.com>
In-Reply-To: <4F4C53C7.2080904@linux.vnet.ibm.com>
X-Forwarded-Message-Id: <4F4C53C7.2080904@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022804-4242-0000-0000-000000E40AE7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf probe allows kprobe to be inserted at any offset from a function
start, which results in adding kprobes to unintended location.
(example: perf probe do_fork+10000 is allowed even though size of
do_fork is ~904).

My previous patch https://lkml.org/lkml/2012/2/24/42 addressed the case
where DWARF info was available for the kernel. This patch fixes the
case where perf probe is used on a kernel without debuginfo available.


Signed-off-by: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
---

 tools/perf/util/probe-event.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index f121d5d..9f9b1a2 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1966,6 +1966,12 @@ static int convert_to_probe_trace_events(struct perf_probe_event *pev,
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

