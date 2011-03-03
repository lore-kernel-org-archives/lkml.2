Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab1CCI3D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 03:29:03 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49436 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751649Ab1CCI3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 03:29:01 -0500
Message-ID: <4D6F51C9.3020800@cn.fujitsu.com>
Date: Thu, 03 Mar 2011 16:31:05 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [BUG] lock issue in perf cgroup with jump label enabled
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-03 16:27:44,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-03 16:27:45,
	Serialize complete at 2011-03-03 16:27:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_JUMP_LABEL enabled:

# mount -t cgroup -o perf_event xxx /mnt
# mkdir /mnt/test
# ./perf stat -B -a -e cycles:u -G test -- sleep 1

lockdep warning will be triggered immediately, and the machine
will become unresponsive.

I guess this is the culprit?

In the "perf cgroup support" patch:

@@ -419,6 +781,17 @@ list_add_event(struct perf_event *event, struct perf_event_con
                list_add_tail(&event->group_entry, list);
        }
 
+       if (is_cgroup_event(event)) {
+               ctx->nr_cgroups++;
+               /*
+                * one more event:
+                * - that has cgroup constraint on event->cpu
+                * - that may need work on context switch
+                */
+               atomic_inc(&per_cpu(perf_cgroup_events, event->cpu));
+               jump_label_inc(&perf_sched_events);
+       }

list_add_event() is called with spin lock ctl->lock held,  while
jump_label_inc() will acquire jump_label_mutex..
