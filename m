Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759953Ab0HEIB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 04:01:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:46077 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759674Ab0HEIBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 04:01:54 -0400
Date: Thu, 5 Aug 2010 08:01:24 GMT
From: tip-bot for Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100630084548.GA10325@linux.vnet.ibm.com>
References: <20100630084548.GA10325@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/kprobes: unregister_trace_probe needs to be called under mutex
Message-ID: <tip-9da79ab83ee33ddc1fdd0858fd3d70925a1bde99@git.kernel.org>
Git-Commit-ID: 9da79ab83ee33ddc1fdd0858fd3d70925a1bde99
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 05 Aug 2010 08:01:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9da79ab83ee33ddc1fdd0858fd3d70925a1bde99
Gitweb:     http://git.kernel.org/tip/9da79ab83ee33ddc1fdd0858fd3d70925a1bde99
Author:     Srikar Dronamraju <srikar@linux.vnet.ibm.com>
AuthorDate: Wed, 30 Jun 2010 14:15:48 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 4 Aug 2010 12:41:23 -0300

tracing/kprobes: unregister_trace_probe needs to be called under mutex

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
 
