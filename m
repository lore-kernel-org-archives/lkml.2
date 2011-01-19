Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab1ASS6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 13:58:18 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40194 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab1ASS6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 13:58:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=bBdFFT1cdOYrfv4+uTZeCFlQfQjNQ5+AZvjjLn8nvwFDK6kO3r2O+ystP8dbJz7QcD
         rS2rcFKdxdrHBTv0vq/zTZ8aexwmweXvuX5nplZSnxLXEO2WckEJmzUXoVY+geKWNhdZ
         f1EGvKlsJpS0eEaCOSqtcmp/wbwt7Yu2BGH7I=
MIME-Version: 1.0
Date: Thu, 20 Jan 2011 02:55:39 +0800
Message-ID: <AANLkTinxxOsXNatAiP0t8Vv0xFZcdSpoWWrG49g6JjqF@mail.gmail.com>
Subject: [BUG?] tracing/function_graph: set_graph_function was broken from 2.6.36-rc2
From: wu zhangjin <wuzhangjin@gmail.com>
To: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        zhiping zhong <xzhong86@163.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Steve

Zhiping Zhong reported a problem about set_graph_function: whenever
users configure the entries through the tracing/set_graph_function
interface, the tracing result always include the other functions which
are not configured through the interfaces, and most of the tracing
result we can see are the irq related functions, which means
set_graph_function doesn't work as expects.

I have done some investigation, in the *ftrace_graph_entry ->
trace_graph_entry() function, there is checking like this:

        [snip]
        /* trace it when it is-nested-in or is a function enabled. */
        if (!(trace->depth || ftrace_graph_addr(trace->func)) ||
              ftrace_graph_ignore_irqs())
                return 0;
        [snip]

and:

static inline int ftrace_graph_ignore_irqs(void)
{
        if (!ftrace_graph_skip_irqs)
                return 0;

        return in_irq();
}

and:

/* When set, irq functions will be ignored */
static int ftrace_graph_skip_irqs;

As we can see above, ftrace_graph_skip_irqs is initialized as 0, then,
ftrace_graph_ignore_irqs() will return 0 by default, as a result, the
checking in trace_graph_entry() will always be false, then every
function will be traced whenever the set_graph_function is configured,
so, this may be the cause.

A quick fix looks like this:

        /* trace it when it is-nested-in or is a function enabled. */
-       if (!(trace->depth || ftrace_graph_addr(trace->func)) ||
-             ftrace_graph_ignore_irqs())
+       if (!(trace->depth || ftrace_graph_addr(trace->func) ||
+             !ftrace_graph_ignore_irqs()))
                return 0;

And as the git log shows, the ftrace_graph_ignore_irqs() function was
added from the following commit:

          tracing: Do not trace in irq when funcgraph-irq option is zero

Regards,
Wu Zhangjin
