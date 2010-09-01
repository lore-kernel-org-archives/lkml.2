Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab0IALDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 07:03:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:51875 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab0IALDd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 07:03:33 -0400
Subject: Re: ftrace/perf_event leak
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, kvm-devel <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4C7E2D1D.3080603@redhat.com>
References: <4C7E11E5.1040402@redhat.com> <1283331868.2059.808.camel@laptop>
	 <4C7E1C36.6070400@redhat.com> <4C7E1F12.8030304@cn.fujitsu.com>
	 <4C7E2D1D.3080603@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 01 Sep 2010 13:02:57 +0200
Message-ID: <1283338977.2059.938.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-01 at 13:38 +0300, Avi Kivity wrote:
> On 09/01/2010 12:38 PM, Li Zefan wrote:
> >
> > Then try this:
> 
> Tested-by: Avi Kivity <avi@redhat.com>
> 

Thanks, queued as:

---
Subject: perf, trace: Fix module leak
From: Li Zefan <lizf@cn.fujitsu.com>
Date: Wed Sep 01 12:58:43 CEST 2010

Commit 1c024eca (perf, trace: Optimize tracepoints by using
per-tracepoint-per-cpu hlist to track events) caused a module refcount
leak.

Tested-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4C7E1F12.8030304@cn.fujitsu.com>
---
 kernel/trace/trace_event_perf.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/kernel/trace/trace_event_perf.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace_event_perf.c
+++ linux-2.6/kernel/trace/trace_event_perf.c
@@ -91,6 +91,8 @@ int perf_trace_init(struct perf_event *p
 		    tp_event->class && tp_event->class->reg &&
 		    try_module_get(tp_event->mod)) {
 			ret = perf_trace_event_init(tp_event, p_event);
+			if (ret)
+				module_put(tp_event->mod);
 			break;
 		}
 	}
@@ -147,6 +149,7 @@ void perf_trace_destroy(struct perf_even
 		}
 	}
 out:
+	module_put(tp_event->mod);
 	mutex_unlock(&event_mutex);
 }
 

