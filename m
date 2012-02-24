Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab2BXDLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 22:11:51 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:38527 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab2BXDLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 22:11:49 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Christoph Lameter <cl@linux.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
References: <20120223180740.C4EC4156@kernel>
	<alpine.DEB.2.00.1202231240590.9878@router.home>
	<4F468F09.5050200@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1202231334290.10914@router.home>
	<4F469BC7.50705@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1202231536240.13554@router.home>
Date: Thu, 23 Feb 2012 19:14:50 -0800
In-Reply-To: <alpine.DEB.2.00.1202231536240.13554@router.home> (Christoph
	Lameter's message of "Thu, 23 Feb 2012 15:41:50 -0600 (CST)")
Message-ID: <m1ehtkapn9.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+Tk7xCtB7pBcuurhanPN7xpW5H0ubW6Aw=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Christoph Lameter <cl@linux.com>
X-Spam-Relay-Country: **
Subject: Re: [RFC][PATCH] fix move/migrate_pages() race on task struct
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <cl@linux.com> writes:

> On Thu, 23 Feb 2012, Dave Hansen wrote:
>
>> > We may at this point be getting a reference to a task struct from another
>> > process not only from the current process (where the above procedure is
>> > valid). You rightly pointed out that the slab rcu free mechanism allows a
>> > free and a reallocation within the RCU period.
>>
>> I didn't _mean_ to point that out, but I think I realize what you're
>> talking about.  What we have before this patch is this:
>>
>>         rcu_read_lock();
>>         task = pid ? find_task_by_vpid(pid) : current;
>
> We take a refcount here on the mm ... See the code. We could simply take a
> refcount on the task as well if this is considered safe enough. If we have
> a refcount on the task then we do not need the refcount on the mm. Thats
> was your approach...
>
>>         rcu_read_unlock();
>
>> > Is that a real difference or are you just playing with words?
>>
>> I think we're talking about two different things:
>> 1. does RCU protect the pid->task lookup sufficiently?
>
> I dont know

Yes.  See below.

>> 2. Can the task simply go away in the move/migrate_pages() calls?
>
> The task may go away but we need the mm to stay for migration.
> That is why a refcount is taken on the mm.
>
> The bug in migrate_pages() is that we do a rcu_unlock and a rcu_lock. If
> we drop those then we should be safe if the use of a task pointer within a
> rcu section is safe without taking a refcount.

Yes the user of a task_struct pointer found via a userspace pid is valid
for the life of an rcu critical section, and the bug is indeed that we
drop the rcu_lock and somehow expect the task to remain valid.

The guarantee comes from release_task.  In release_task we call
__exit_signal which calls __unhash_process, and then we call
delayed_put_task to guarantee that the task lives until the end
of the rcu interval.



In migrate_pages we have a lot of task accesses outside of the
rcu critical section, and without a reference count on task.

I tell you the truth trying to figure out what that code needs to be
correct if task != current makes my head hurt.

I think we need to grab a reference on task_struct, to stop the task
from going away, and in addition we need to hold task_lock.  To keep
task->mm from changing (see exec_mmap).  But we can't do that and sleep
so I think the entire function needs to be rewritten, and the need for
task deep in the migrate_pages path needs to be removed as even with the
reference count held we can race with someone calling exec.

The only easy fix I see is to add:
if (pid)
	return -EINVAL;

Then we are working with current and only current change it's mm making
things much, much, much simpler.

Eric
