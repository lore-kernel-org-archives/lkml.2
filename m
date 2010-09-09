Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab0IITpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:45:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:40598 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108Ab0IITpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:45:34 -0400
Date: Thu, 9 Sep 2010 19:45:07 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, lizf@cn.fujitsu.com, tglx@linutronix.de,
        avi@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        lizf@cn.fujitsu.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        avi@redhat.com, mingo@elte.hu
In-Reply-To: <4C7E1F12.8030304@cn.fujitsu.com>
References: <4C7E1F12.8030304@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, trace: Fix module leak
Message-ID: <tip-9cb627d5f38830ca19aa0dca52d1d3a633018bf7@git.kernel.org>
Git-Commit-ID: 9cb627d5f38830ca19aa0dca52d1d3a633018bf7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 19:45:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9cb627d5f38830ca19aa0dca52d1d3a633018bf7
Gitweb:     http://git.kernel.org/tip/9cb627d5f38830ca19aa0dca52d1d3a633018bf7
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed, 1 Sep 2010 12:58:43 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Sep 2010 20:38:51 +0200

perf, trace: Fix module leak

Commit 1c024eca (perf, trace: Optimize tracepoints by using
per-tracepoint-per-cpu hlist to track events) caused a module
refcount leak.

Reported-And-Tested-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4C7E1F12.8030304@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_event_perf.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 000e6e8..31cc4cb 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -91,6 +91,8 @@ int perf_trace_init(struct perf_event *p_event)
 		    tp_event->class && tp_event->class->reg &&
 		    try_module_get(tp_event->mod)) {
 			ret = perf_trace_event_init(tp_event, p_event);
+			if (ret)
+				module_put(tp_event->mod);
 			break;
 		}
 	}
@@ -146,6 +148,7 @@ void perf_trace_destroy(struct perf_event *p_event)
 		}
 	}
 out:
+	module_put(tp_event->mod);
 	mutex_unlock(&event_mutex);
 }
 
