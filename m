Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab0KZSkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 13:40:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:43554 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755391Ab0KZSkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 13:40:24 -0500
Message-ID: <4CEFFEFA.3050002@kernel.org>
Date: Fri, 26 Nov 2010 19:39:54 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 06/14] signal: use GROUP_STOP_PENDING to avoid stopping
 multiple times for a single group stop
References: <1290768569-16224-1-git-send-email-tj@kernel.org> <1290768569-16224-7-git-send-email-tj@kernel.org> <20101126175945.GE28177@redhat.com>
In-Reply-To: <20101126175945.GE28177@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 18:40:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On 11/26/2010 06:59 PM, Oleg Nesterov wrote:
> I am stucked at this point ;)

:-)

> On 11/26, Tejun Heo wrote:
>> Currently task->signal->group_stop_count is used to decide whether to
>> stop for group stop.  However, if there is a task in the group which
>> is taking a long time to stop, other tasks which are continued by
>> ptrace would repeatedly stop for the same group stop until the group
>> stop is complete.
> 
> Yes. but the tracee won't abuse ->group_stop_count, this was fixed
> by the previous patch.

Yes.

> But, otoh, what if debugger resumes the tracee when the group stop
> was completed by other sub-threads ?

Well, then the tracee continues.  What this patch does is making each
task in a group to stop once for a single group stop instance.  If
ptracer decides to resume the tracee (w/o sending SIGCONT, that is),
then it can do so and the tracee won't stop for the same group stop
again.

> The tracee will run with GROUP_STOP_PENDING set. ->group_stop_count
> is zero. If this tracee recieves a signal (or spurious TIF_SIGPENDING),
> suddenly it will notice GROUP_STOP_PENDING and report the stop to
> debugger.

Yeah, of course.  That's the tracee participating in the group stop.
Oh, the tracee _should_ always have TIF_SIGPENDING set or be
guaranteed to run get_signal_to_deliver().  I think there are traced
points where that is not true.  We probably need to set TIF_SIGPENDING
together with GROUP_STOP_PENDING.

> This looks a bit strange. OK, perhaps it makes sense to report the
> stop to "ack" the group stop which wasn't acked in ptrace_stop().
> Or, if it was untraced after resume, it makes sense to "silently"
> stop as well.
> 
> But, in this case it shouldn't wait until signal_pending() is true?

Yeap, thanks a lot for catching that one.  :-)

>> @@ -1742,8 +1745,8 @@ static int do_signal_stop(int signr)
>>  	struct signal_struct *sig = current->signal;
>>  	int notify = 0;
>>
>> -	if (!sig->group_stop_count) {
>> -		unsigned int gstop = GROUP_STOP_CONSUME;
>> +	if (!(current->group_stop & GROUP_STOP_PENDING)) {
>> +		unsigned int gstop = GROUP_STOP_PENDING | GROUP_STOP_CONSUME;
>>  		struct task_struct *t;
> 
> Hmm. This means, the ptraced task can initiate the group stop
> while it is already in progress...
>
> Debugger can constantly resume a tracee while the group stop
> is not finished. Finally this tracee can dequeue SIGSTOP without
> GROUP_STOP_PENDING.
> 
> At first glance, nothing bad can happen, but I am not sure.
> We can have other ptraced threads which were resumed after
> ptrace_stop()/do_signal_stop().

Hmmm.... right.  I think it is better to test for GROUP_STOP_PENDING
there.  That happens on delivery of a new stop signal, so
semantic-wise, it's correct.  Given the statelessness of group stop
across STOP/CONT attempts, I think it should be okay.  I'll think
about it more.

>> This will change with future patches.
> 
> Yes. I tried to study this series patch-by-patch. I think I should
> read the whole series to really understand the intermediate changes.
> I'll try to return on Monday.
> 
> Cough. I didn't expect I forgot this code that much ;)

Heh, I thought adding transparent/nestable ptrace attach would take me
several days; instead, understanding the code and producing this
patchset took me two weeks filled with swearing.  This is a truly
hairy piece of code.  :-)

Thanks a lot for reviewing.

-- 
tejun
