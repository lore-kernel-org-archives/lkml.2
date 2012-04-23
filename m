Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab2DWNhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 09:37:14 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45287 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab2DWNhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 09:37:12 -0400
Message-ID: <4F955B02.7040304@gmail.com>
Date: Mon, 23 Apr 2012 15:37:06 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org,
        cfriesen@nortel.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Subject: Re: [PATCH 05/16] sched: SCHED_DEADLINE policy implementation.
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>   <1333696481-3433-6-git-send-email-juri.lelli@gmail.com>  <1335180743.28150.119.camel@twins> <4F954757.3020003@gmail.com> <1335183740.28150.135.camel@twins>
In-Reply-To: <1335183740.28150.135.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 02:22 PM, Peter Zijlstra wrote:
> On Mon, 2012-04-23 at 14:13 +0200, Juri Lelli wrote:
>> On 04/23/2012 01:32 PM, Peter Zijlstra wrote:
>>> On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
>>>> +       /*
>>>> +        * We Keep moving the deadline away until we get some
>>>> +        * available runtime for the entity. This ensures correct
>>>> +        * handling of situations where the runtime overrun is
>>>> +        * arbitrary large.
>>>> +        */
>>>> +       while (dl_se->runtime<= 0) {
>>>> +               dl_se->deadline += dl_se->dl_deadline;
>>>> +               dl_se->runtime += dl_se->dl_runtime;
>>>> +       }
>>>
>>> Does gcc 'optimize' that into a division? If so, it might need special
>>> glue to make it not do that.
>>
>> I got two adds and a jle, no div here..
>
> Gcc is known to change such loops to something like:
>
>   if (runtime<= 0) {
>     tmp = 1 - runtime / dl_runtime;
>     deadline += tmp * dl_deadline;
>     runtime += tmp * dl_runtime;
>   }
>
>

This is what I got for that snippet:

ffffffff81062826 <enqueue_task_dl>:
[...]
ffffffff81062885:       49 03 44 24 20          add    0x20(%r12),%rax
ffffffff8106288a:       49 8b 54 24 28          mov    0x28(%r12),%rdx
ffffffff8106288f:       49 01 54 24 38          add    %rdx,0x38(%r12)
ffffffff81062894:       49 89 44 24 30          mov    %rax,0x30(%r12)
ffffffff81062899:       49 8b 44 24 30          mov    0x30(%r12),%rax
ffffffff8106289e:       48 85 c0                test   %rax,%rax
ffffffff810628a1:       7e e2                   jle    ffffffff81062885 <enqueue_task_dl+0x5f>

So it seems we are fine in this case, right?
It is anyway better to enforce this Gcc behaviour, just to be
on the safe side?

Thanks,

- Juri
