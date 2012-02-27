Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab2B0UPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 15:15:12 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59550 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab2B0UPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 15:15:10 -0500
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
	<m1ehtkapn9.fsf@fess.ebiederm.org>
	<alpine.DEB.2.00.1202240859340.2621@router.home>
	<4F47BF56.6010602@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1202241053220.3726@router.home>
	<alpine.DEB.2.00.1202241105280.3726@router.home>
	<4F47C800.4090903@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1202241131400.3726@router.home>
	<87sjhzun47.fsf@xmission.com>
	<alpine.DEB.2.00.1202271238450.32410@router.home>
Date: Mon, 27 Feb 2012 12:15:00 -0800
In-Reply-To: <alpine.DEB.2.00.1202271238450.32410@router.home> (Christoph
	Lameter's message of "Mon, 27 Feb 2012 13:01:52 -0600 (CST)")
Message-ID: <87d390janv.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/g/AqkUAy3/j2Xi2CVkP8LJtfKQP2AcSU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
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

> On Sat, 25 Feb 2012, Eric W. Biederman wrote:
>
>> > Ok so take a count and drop it before entering the main migration
>> > function?
>>
>> For correct operation of kernel code a count sounds fine.
>>
>> If you are going to allow sleeping how do you ensure that an exec that
>> happens between the taking of the reference count and checking the
>> permissions does not mess things up.
>
> Ok in that case there is a race between which of the two address space
> structures (mm structs) are used. But that is up to the user to resolve if
> he wants to.
>
>> At the moment I suspect the permissions checks are not safe unless
>> performed under both rcu_read_lock and task_lock to ensure that
>> the task<->mm association does not change on us while we are
>> working.  Even with that the cred can change under us but at least
>> we know the cred will be valid until rcu_read_unlock happens.
>
> The permissions check only refer to the task struct.
>
>> This entire thinhg of modifying another process is a pain.
>>
>> Perhaps you can play with task->self_exec_id to detect an exec and fail
>> the system call if there was an exec in between when we find the task
>> and when we drop the task reference.
>
> I am not sure why there would be an issue. We have to operate on one mm
> the pid refers to. If it changes then we may either operate on the old
> one or the new one.
>
> We can move the determination of the mm to the last point possible to show
> that it is not used earlier?

If we are just changing the numa node on which the pages reside it isn't
too bad of a problem.  Somehow from the names I thought we were moving
pages from one task to another.

The problem that I see is that we may race with a suid exec in which
case the permissions checks might pass for the pre-exec state and then
we get the post exec mm that we don't actually have permissions for,
but we manipulate it anyway.

Another possibility is that half the permission checks could be
performed on the pre-exec state and another half the permission checks
on the post-exec state, and we happen to pass as a fluke in a situation
where neither the pre nor the post exec state would be allowed (for
different reasons) but looking at the inconsistent allowed us to pass.

So we really need to do something silly like get task and
task->self_exec_id.  Then perform the permission checks and get the mm.
Then if just before we perform the operation task->self_exec_id is
different restart the system call, or fail with something like -EAGAIN.

Eric
