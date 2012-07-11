Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab2GKPJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:09:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:33329 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629Ab2GKPJx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:09:53 -0400
Message-ID: <1342019376.3462.166.camel@twins>
Subject: Re: [PATCH] trace: add ability to set a target task for events (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arun Sharma <asharma@fb.com>
Date: Wed, 11 Jul 2012 17:09:36 +0200
In-Reply-To: <1342016098-213063-1-git-send-email-avagin@openvz.org>
References: <1342016098-213063-1-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-11 at 18:14 +0400, Andrew Vagin wrote:
> @@ -5226,6 +5227,29 @@ void perf_tp_event(u64 addr, u64 count, void *record, int entry_size,
>                         perf_swevent_event(event, count, &data, regs);
>         }
>  
> +       /*
> +        * If we got specified a target task, also iterate its context and
> +        * deliver this event there too.
> +        */
> +       if (task && task != current) {
> +               struct perf_event_context *ctx;
> +               struct trace_entry *entry = record;
> +
> +               rcu_read_lock();
> +               ctx = rcu_dereference(task->perf_event_ctxp[perf_sw_context]);
> +               if (!ctx)
> +                       goto unlock;
> +
> +               list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {

I added:
			if (event->attr.type != PERF_TYPE_TRACEPOINT)
				continue;

> +                       if (entry->type != event->attr.config)
> +                               continue;
> +                       if (perf_tp_event_match(event, &data, regs))
> +                               perf_swevent_event(event, count, &data, regs);
> +               }
> +unlock:
> +               rcu_read_unlock();
> +       }
> +
>         perf_swevent_put_recursion_context(rctx);
>  } 

Otherwise I've applied the patch.. Thanks!
