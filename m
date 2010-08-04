Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab0HDV0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 17:26:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41352 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759089Ab0HDV0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 17:26:11 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/3] tracing/kprobes: unregister_trace_probe needs to be called under mutex
Date: Wed,  4 Aug 2010 18:26:04 -0300
Message-Id: <1280957164-14274-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1280957164-14274-1-git-send-email-acme@infradead.org>
References: <1280957164-14274-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Comment in unregister_trace_probe() says probe_lock will be held when it
gets called. However there is a case where it might called without the
probe_lock being held. Also since we are traversing the probe_list and
deleting an element from the probe_list, probe_lock should be held.

This was first pointed in uprobes traceevent review by Frederic
Weisbecker here.  (http://lkml.org/lkml/2010/5/12/106)

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20100630084548.GA10325@linux.vnet.ibm.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 kernel/trace/trace_kprobe.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 1b79d1c..8b27c98 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -925,14 +925,17 @@ static int create_trace_probe(int argc, char **argv)
 			pr_info("Delete command needs an event name.\n");
 			return -EINVAL;
 		}
+		mutex_lock(&probe_lock);
 		tp = find_probe_event(event, group);
 		if (!tp) {
+			mutex_unlock(&probe_lock);
 			pr_info("Event %s/%s doesn't exist.\n", group, event);
 			return -ENOENT;
 		}
 		/* delete an event */
 		unregister_trace_probe(tp);
 		free_trace_probe(tp);
+		mutex_unlock(&probe_lock);
 		return 0;
 	}
 
-- 
1.6.2.5

