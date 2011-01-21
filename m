Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab1AUJ1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 04:27:32 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38826 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab1AUJ1b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 04:27:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PnKEKE5ZcvnYTzmrtgYGRRtve/YpHN0i+SVuse6O817j665zbbGtWGQLQlbPpQg9u8
         lpbsn6zs5OdL8b7MzTg6YI+/f/+gKEPYpCciNSPaEBICgtopjWV9L5DzaQpGU69ljOuP
         4WVGbTfj+REJgIgwzNETTdv3tx2dZNRQS8doY=
MIME-Version: 1.0
In-Reply-To: <1295544654.19789.19.camel@fedora>
References: <AANLkTinxxOsXNatAiP0t8Vv0xFZcdSpoWWrG49g6JjqF@mail.gmail.com>
	<1295544654.19789.19.camel@fedora>
Date: Fri, 21 Jan 2011 17:27:29 +0800
Message-ID: <AANLkTin6g8SGnuG6j6JVCdBvOeiBj8Quwr2T9K+3jUwq@mail.gmail.com>
Subject: Re: [BUG?] tracing/function_graph: set_graph_function was broken from 2.6.36-rc2
From: wu zhangjin <wuzhangjin@gmail.com>
To: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        zhiping zhong <xzhong86@163.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 1:30 AM, Steven Rostedt <srostedt@redhat.com> wrote:
> On Thu, 2011-01-20 at 02:55 +0800, wu zhangjin wrote:
>> Hi, Steve
>>
>> Zhiping Zhong reported a problem about set_graph_function: whenever
>> users configure the entries through the tracing/set_graph_function
>> interface, the tracing result always include the other functions which
>> are not configured through the interfaces, and most of the tracing
>> result we can see are the irq related functions, which means
>> set_graph_function doesn't work as expects.
>
> It does, but you need to disable irq tracing:
>
> echo 0 > /debug/tracing/options/funcgraph-irqs
>
> Perhaps I'll make this the default :-/
>

Yeah, only If we put 0 to /debug/tracing/options/funcgraph-irqs,
otherwise, every function will be traced whenever we set the entries
through the tracing/set_graph_function interface, this may be not that
we expected ;-) set_graph_function interface should work as-is
whenever /debug/tracing/options/funcgraph-irqs is set, the cause may
be the following "if" statement:

>> trace_graph_entry():
>>
>>         [snip]
>>         /* trace it when it is-nested-in or is a function enabled. */
>>         if (!(trace->depth || ftrace_graph_addr(trace->func)) ||
>>               ftrace_graph_ignore_irqs())
>>                 return 0;
>>         [snip]
>>

By default, ftrace_graph_ignore_irqs() is false, then, if we don't put
0 to /debug/tracing/options/funcgraph-irqs, it will not return even if
we have specified some entries through the tracing/set_graph_function
interface, as a result, every function will be traced and it doesn't
work as we expected, the expected result is only the specified
functions are reserved in the tracing result.

>> A quick fix looks like this:
>>
>>         /* trace it when it is-nested-in or is a function enabled. */
>> -       if (!(trace->depth || ftrace_graph_addr(trace->func)) ||
>> -             ftrace_graph_ignore_irqs())
>> +       if (!(trace->depth || ftrace_graph_addr(trace->func) ||
>> +             !ftrace_graph_ignore_irqs()))
>>                 return 0;
>>
>> And as the git log shows, the ftrace_graph_ignore_irqs() function was
>> added from the following commit:
>>
>>           tracing: Do not trace in irq when funcgraph-irq option is zero

Regards,
Wu Zhangjin
