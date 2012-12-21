Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab2LUBT0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 20:19:26 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:52804 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab2LUBTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 20:19:19 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, Serge Hallyn <serge@hallyn.com>,
        Gao feng <gaofeng@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <8739097bkk.fsf@xmission.com>
	<1353083750-3621-1-git-send-email-ebiederm@xmission.com>
	<1353083750-3621-7-git-send-email-ebiederm@xmission.com>
	<20121219184757.GB22991@redhat.com>
Date: Thu, 20 Dec 2012 17:19:06 -0800
In-Reply-To: <20121219184757.GB22991@redhat.com> (Oleg Nesterov's message of
	"Wed, 19 Dec 2012 19:47:57 +0100")
Message-ID: <87bodourqt.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/b2LeZWmoVamm55dk5SaVY+FfUIDceKKU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.5 XMGappySubj_01 Very gappy subject
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0048]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 07/11] pidns: Wait in zap_pid_ns_processes until pid_ns->nr_hashed == 1
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 11/16, Eric W. Biederman wrote:
>>
>> @@ -216,22 +216,15 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
>>
>>  	/*
>>  	 * sys_wait4() above can't reap the TASK_DEAD children.
>> -	 * Make sure they all go away, see __unhash_process().
>> +	 * Make sure they all go away, see free_pid().
>>  	 */
>>  	for (;;) {
>> -		bool need_wait = false;
>> -
>> -		read_lock(&tasklist_lock);
>> -		if (!list_empty(&current->children)) {
>> -			__set_current_state(TASK_UNINTERRUPTIBLE);
>> -			need_wait = true;
>> -		}
>> -		read_unlock(&tasklist_lock);
>> -
>> -		if (!need_wait)
>> +		set_current_state(TASK_UNINTERRUPTIBLE);
>> +		if (pid_ns->nr_hashed == 1)
>>  			break;
>>  		schedule();
>>  	}
>
> I agree, the patch itself looks fine.
>
> But, with all other changes I do not understand this part at all.
>
> A task from the parent namespace can do setns + fork at any time
> (until nr_hashed >= 0). So ->nr_hashed can be incremented again
> after zap_pid_ns_processes() returns.

I want to talk about how alloc_pid and free_pid prevent nr_hashed
from increasing once the last processes has exited the pid namespace
but that doesn't apply here.

> Or, we can sleep in TASK_UNINTERRUPTIBLE "forever" if this happens
> after kill-them-all.

Sleeping forever should be prevented by this chunk in free_pid:

		switch(--ns->nr_hashed) {
		case 1:
			/* When all that is left in the pid namespace
			 * is the reaper wake up the reaper.  The reaper
			 * may be sleeping in zap_pid_ns_processes().
			 */
			wake_up_process(ns->child_reaper);


I admit it continues to be true that if an injected process or a
debugged process does not exit we can block waiting for all of the
processes to be reaped indefinitely.

> Could you explain why do we need to wait at all? I can be easily
> wrong, but at first glance the original reason for this wait has
> gone away?

It is very nice to know that when you do waitpid for the init process of
a pid namespace that there are no other processes in the pid namespace.

Leaving the wait here has the nice effect that it doesn't penalize
anything but pid namespace code paths.

Eric
