Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab1ATRbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 12:31:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953Ab1ATRbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 12:31:09 -0500
Subject: Re: [BUG?] tracing/function_graph: set_graph_function was broken
 from 2.6.36-rc2
From: Steven Rostedt <srostedt@redhat.com>
To: wu zhangjin <wuzhangjin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        zhiping zhong <xzhong86@163.com>
In-Reply-To: <AANLkTinxxOsXNatAiP0t8Vv0xFZcdSpoWWrG49g6JjqF@mail.gmail.com>
References: <AANLkTinxxOsXNatAiP0t8Vv0xFZcdSpoWWrG49g6JjqF@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Thu, 20 Jan 2011 12:30:54 -0500
Message-ID: <1295544654.19789.19.camel@fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 02:55 +0800, wu zhangjin wrote:
> Hi, Steve
> 
> Zhiping Zhong reported a problem about set_graph_function: whenever
> users configure the entries through the tracing/set_graph_function
> interface, the tracing result always include the other functions which
> are not configured through the interfaces, and most of the tracing
> result we can see are the irq related functions, which means
> set_graph_function doesn't work as expects.

It does, but you need to disable irq tracing:

echo 0 > /debug/tracing/options/funcgraph-irqs

Perhaps I'll make this the default :-/

-- Steve

> 
> I have done some investigation, in the *ftrace_graph_entry ->
> trace_graph_entry() function, there is checking like this:
> 
>         [snip]
>         /* trace it when it is-nested-in or is a function enabled. */
>         if (!(trace->depth || ftrace_graph_addr(trace->func)) ||
>               ftrace_graph_ignore_irqs())
>                 return 0;
>         [snip]
> 
> and:
> 
> static inline int ftrace_graph_ignore_irqs(void)
> {
>         if (!ftrace_graph_skip_irqs)
>                 return 0;
> 
>         return in_irq();
> }
> 
> and:
> 
> /* When set, irq functions will be ignored */
> static int ftrace_graph_skip_irqs;
> 
> As we can see above, ftrace_graph_skip_irqs is initialized as 0, then,
> ftrace_graph_ignore_irqs() will return 0 by default, as a result, the
> checking in trace_graph_entry() will always be false, then every
> function will be traced whenever the set_graph_function is configured,
> so, this may be the cause.
> 
> A quick fix looks like this:
> 
>         /* trace it when it is-nested-in or is a function enabled. */
> -       if (!(trace->depth || ftrace_graph_addr(trace->func)) ||
> -             ftrace_graph_ignore_irqs())
> +       if (!(trace->depth || ftrace_graph_addr(trace->func) ||
> +             !ftrace_graph_ignore_irqs()))
>                 return 0;
> 
> And as the git log shows, the ftrace_graph_ignore_irqs() function was
> added from the following commit:
> 
>           tracing: Do not trace in irq when funcgraph-irq option is zero
> 
> Regards,
> Wu Zhangjin


