Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab0IAJlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 05:41:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:39381 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab0IAJls convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 05:41:48 -0400
Subject: Re: ftrace/perf_event leak
From: Peter Zijlstra <peterz@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, kvm-devel <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4C7E1F12.8030304@cn.fujitsu.com>
References: <4C7E11E5.1040402@redhat.com> <1283331868.2059.808.camel@laptop>
	 <4C7E1C36.6070400@redhat.com>  <4C7E1F12.8030304@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 01 Sep 2010 11:41:35 +0200
Message-ID: <1283334095.2059.849.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-01 at 17:38 +0800, Li Zefan wrote:

> ---
> diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
> index 8a2b73f..9d1d1f2 100644
> --- a/kernel/trace/trace_event_perf.c
> +++ b/kernel/trace/trace_event_perf.c
> @@ -161,6 +161,7 @@ void perf_trace_destroy(struct perf_event *p_event)
>  		}
>  	}
>  out:
> +	module_put(tp_event->mod);
>  	mutex_unlock(&event_mutex);
>  }

Ah, indeed, we so that try_module_get() for each reference to the
tracepoint, I guess we also should do the below, in case the
registration fails.

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
