Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab2DVO3C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 10:29:02 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:39312 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab2DVO3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 10:29:01 -0400
Message-ID: <4F9415A8.20708@gmail.com>
Date: Sun, 22 Apr 2012 16:28:56 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Subject: Re: [PATCH 12/16] rtmutex: turn the plist into an rb-tree.
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>  <1333696481-3433-13-git-send-email-juri.lelli@gmail.com> <1334178715.23924.308.camel@gandalf.stny.rr.com>
In-Reply-To: <1334178715.23924.308.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 11:11 PM, Steven Rostedt wrote:
> On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
>> From: Peter Zijlstra<peterz@infradead.org>
>>
>> Turn the pi-chains from plist to rb-tree, in the rt_mutex code,
>> and provide a proper comparison function for -deadline and
>> -priority tasks.
>
> I have to ask. Why not just add a rbtree with a plist? That is, add all
> deadline tasks to the rbtree and all others to the plist. As plist has a
> O(1) operation, and rbtree does not. We are making all RT tasks suffer
> the overhead of the rbtree.
>

I basically got this patch from the v3 patchset and, since it applied
perfectly and came from Peter, I assumed it was the right way to go ;-).

> As deadline tasks always win, the two may stay agnostic from each other.
> Check first the rbtree, if it is empty, then check the plist.
>
> This will become more predominant with the -rt tree as it converts most
> the locks in the kernel to pi mutexes.
>

I see your point, but I'm not yet convinced that in the end the plist +
rbtree implementation would win. AFAIK, the only O(1) plist operation is
removal, beeing addition O(K) [K RT priorities]. Now, we have O(logn)
[n elements] operations for rbtrees and we speed-up search with the
leftmost pointer.
So, are we sure that add complexity (and related checks) is needed here?
I'm not against your point, I'm only asking :-).

Thanks a lot,

- Juri
  
>>
>> This is done mainly because:
>>   - classical prio field of the plist is just an int, which might
>>     not be enough for representing a deadline;
>>   - manipulating such a list would become O(nr_deadline_tasks),
>>     which might be to much, as the number of -deadline task increases.
>>
>> Therefore, an rb-tree is used, and tasks are queued in it according
>> to the following logic:
>>   - among two -priority (i.e., SCHED_BATCH/OTHER/RR/FIFO) tasks, the
>>     one with the higher (lower, actually!) prio wins;
>>   - among a -priority and a -deadline task, the latter always wins;
>>   - among two -deadline tasks, the one with the earliest deadline
>>     wins.
>>
>> Queueing and dequeueing functions are changed accordingly, for both
>> the list of a task's pi-waiters and the list of tasks blocked on
>> a pi-lock.
>>
>> Signed-off-by: Peter Zijlstra<peterz@infradead.org>
>> Signed-off-by: Dario Faggioli<raistlin@linux.it>
>> Signed-off-by: Juri Lelli<juri.lelli@gmail.com>
>
>
