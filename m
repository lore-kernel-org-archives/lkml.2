Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab2LVUQe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 15:16:34 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:41424 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab2LVUQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 15:16:29 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rob Landley <rob@landley.net>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <1356205160.5255.0@driftwood>
Date: Sat, 22 Dec 2012 12:16:22 -0800
In-Reply-To: <1356205160.5255.0@driftwood> (Rob Landley's message of "Sat, 22
	Dec 2012 13:39:20 -0600")
Message-ID: <874njddeqx.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+6qXtjeXGP+jX18fay1owFvoSc8gqWP2s=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Rob Landley <rob@landley.net>
X-Spam-Relay-Country: 
Subject: Re: [PATCH review 1/3] pidns: Outlaw thread creation after unshare(CLONE_NEWPID)
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley <rob@landley.net> writes:

> On 12/21/2012 10:57:34 PM, Eric W. Biederman wrote:
>> 
>> The sequence:
>> unshare(CLONE_NEWPID)
>> clone(CLONE_THREAD|CLONE_SIGHAND|CLONE_VM)
>> 
>> Creates a new process in the new pid namespace without setting
>> pid_ns->child_reaper.  After forking this results in a NULL
>> pointer dereference.
>> 
>> Avoid this and other nonsense scenarios that can show up after
>> creating a new pid namespace with unshare by adding a new
>> check in copy_prodcess.
>> 
>> Pointed-out-by:  Oleg Nesterov <oleg@redhat.com>
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> ---
>>  kernel/fork.c |    8 ++++++++
>>  1 files changed, 8 insertions(+), 0 deletions(-)
>> 
>> diff --git a/kernel/fork.c b/kernel/fork.c
>> index a31b823..65ca6d2 100644
>> --- a/kernel/fork.c
>> +++ b/kernel/fork.c
>> @@ -1166,6 +1166,14 @@ static struct task_struct  
>> *copy_process(unsigned long clone_flags,
>>  				current->signal->flags &  
>> SIGNAL_UNKILLABLE)
>>  		return ERR_PTR(-EINVAL);
>> 
>> +	/*
>> +	 * If the new process will be in a different pid namespace
>> +	 * don't allow the creation of threads.
>> +	 */
>> +	if ((clone_flags & (CLONE_VM|CLONE_NEWPID)) &&
>> +	    (task_active_pid_ns(current) != current->nsproxy->pid_ns))
>> +		return ERR_PTR(-EINVAL);
>> +
>
> Since the first bit will trigger if clone_flags has just CLONE_VM  
> without CLONE_NEWPID, or vice versa, I'm guessing this is a fast path  
> optimization? (Otherwise you meant (clone_flags &  
> (CLONE_VM|CLONE_NEWPID)) == CLONE_VM|CLONE_NEWPID ?)
>
> (Just trying to wrap my head around it...)

Actually I mean (clone_flags & (CLONE_THREAD | CLONE_SIGHAND | CLONE_VM | CLONE_NEWPID))
CLONE_THREAD and CLONE_SIGHAND imply CLONE_VM... and that is enfored above.

I don't mean all of those flags must be in place.

CLONE_NEWPID is an optimization in that the test is also in copy_pid_ns
but there is no point in going to all of the work to get there if we are
going to be testing for this scenario anyway.

I definitely don't mean (clone_flags & (CLONE_VM|CLONE_NEWPID)) ==
(CLONE_VM|CLONE_NEWPID)).  The task_active_pid_ns(current) !=
current->nsproxy->pid_ns case is what tests to see if the pid namespace
has already been unshared.

The sequence "unshare(CLONE_NEWPID); unshare(CLONE_NEWPID);" is nonsense
and that is what CLONE_NEWPID is about in that test.

Similary the sequence "unshare(CLONE_NEWPID); clone(CLONE_THREAD);" is
nonsense and what the CLONE_VM is the test is for.  There are also a
number of other nonsense thread like states that CLONE_VM also catches
and prevents.

Eric

