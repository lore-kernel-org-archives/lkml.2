Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab0F3IvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 04:51:20 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:60893 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab0F3IvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 04:51:18 -0400
Date: Wed, 30 Jun 2010 14:15:48 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [Bugfix] unregister_trace_probe needs to be called under mutex
Message-ID: <20100630084548.GA10325@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comment in unregister_trace_probe() says probe_lock will be held
when it gets called. However there is a case where it might called
without the probe_lock being held. Also since we are traversing the
probe_list and deleting an element from the probe_list, probe_lock
should be held.

This was first pointed in uprobes traceevent review by Frederic
Weisbecker here.  (http://lkml.org/lkml/2010/5/12/106)

This patch is needed for both 2.6.35-rc3 and 2.6.35-rc3-tip

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 4f11a56..67670cd 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -269,14 +269,17 @@ static int create_trace_probe(int argc, char **argv)
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
 
