Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab1K1KjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 05:39:08 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:34052 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab1K1KjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 05:39:06 -0500
Message-ID: <4ED364B6.8090108@parallels.com>
Date: Mon, 28 Nov 2011 14:38:46 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
CC: Pedro Alves <pedro@codesourcery.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [RFC][PATCH 0/3] fork: Add the ability to create tasks with given
 pids
References: <4EC4F2FB.408@parallels.com> <201111221204.39235.pedro@codesourcery.com> <20111122153326.GD322@google.com> <201111231620.45440.pedro@codesourcery.com> <20111123162417.GE25780@google.com> <4ECD3946.1030503@parallels.com> <4ECD542C.7010705@parallels.com> <20111124173121.GA23260@redhat.com> <4ECF6AA0.80006@parallels.com> <20111127184725.GA4266@google.com>
In-Reply-To: <20111127184725.GA4266@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2011 10:47 PM, Tejun Heo wrote:
> Hello, Pavel.
> 
> On Fri, Nov 25, 2011 at 02:14:56PM +0400, Pavel Emelyanov wrote:
>> OK, here's another proposal that seem to suit all of us:
>>
>> 1. me wants to clone tasks with pids set
>> 2. Pedro wants to fork task with not changing pids and w/o root perms
>> 3. Oleg and Tejun want to have little intrusion into fork() path
>>
>> The proposal is to implement the PR_RESERVE_PID prctl which allocates and puts a
>> pid on the current. The subsequent fork() uses this pid, this pid survives and keeps
>> its bit in the pidmap after detach. The 2nd fork() after the 1st task death thus
>> can reuse the same pid again. This basic thing doesn't require root perms at all
>> and safe against pid reuse problems. When requesting for pid reservation task may
>> specify a pid number it wants to have, but this requires root perms (CAP_SYS_ADMIN).
>>
>> Pedro, I suppose this will work for your checkpoint feature in gdb, am I right?
>>
>> Few comments about intrusion:
>>
>>  * the common path - if (pid != &init_struct_pid) - on fork is just modified
>>  * we have -1 argument to copy_process
>>  * one more field on struct pid is OK, since it size doesn't change (32 bit level is
>>    anyway not required, it's OK to reduce on down to 16 bits)
>>  * no clone flags extension
>>  * no new locking - the reserved pid manipulations happen under tasklist_lock and
>>    existing common paths do not require more of it
>>  * yes, we have +1 member on task_struct :(
>>
>> Current API problems:
>>
>>  * Only one fork() with pid at a time. Next call to PR_RESERVE_PID will kill the
>>    previous reservation (don't know how to fix)
>>  * No way to fork() an init of a pid sub-namespace with desired pid in current
>>    (can be fixed for a flag for PR_RESERVE_PID saying that we need a pid for a
>>     namespace of a next level)
>>  * No way to grab existing pid for reserve (can be fixed, if someone wants this)
>>
>> Oleg, Tejun, do you agree with such an approach?
> 
> Hmmm... Any attempt to reserve PIDs without full control over the
> namespace is futile.  It can never be complete / reliable. 

Why? What's the _real_ problem with the 

pid = prctl(PR_RESERVE_PID, 0); /* let the kernel _generate_ a pid for us */
while (1) {
	real_pid = fork();
	BUG_ON(pid != real_pid);
	if (real_pid == 0)
		return do_child();

	wait();
}

model? Let's temporarily forget about the single reserved pid implementation
limitation and concentrate on the approach itself.

> Let's just
> forget about it.  If anyone, including gdb, wants to have fun with CR,
> let them manage namespace too; otherwise, it's never gonna be
> reliable.
> 
> If you take the above out, setting last_pid is as simple as it gets
> and good enough.  It's essentially few tens of lines of code to add
> userland interface for setting one pid_t value.  Let's restrict
> manipulation to root for now and see whether finer grained CAP_* makes
> sense as we go along.

That's OK for me, I'll send the patches soon, but I'd like to hear for some sane 
explanation of the above.

> Thanks.
> 

