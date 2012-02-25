Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab2BYMNz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 07:13:55 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:47713 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab2BYMNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 07:13:53 -0500
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
Date: Sat, 25 Feb 2012 04:13:44 -0800
In-Reply-To: <alpine.DEB.2.00.1202241131400.3726@router.home> (Christoph
	Lameter's message of "Fri, 24 Feb 2012 11:32:59 -0600 (CST)")
Message-ID: <87sjhzun47.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18hsx1c9uGO4PEvPxO0y2ZsFFQCgODybfM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Christoph Lameter <cl@linux.com>
X-Spam-Relay-Country: **
Subject: Re: [RFC][PATCH] fix move/migrate_pages() race on task struct
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <cl@linux.com> writes:

> On Fri, 24 Feb 2012, Dave Hansen wrote:
>
>> > Is that all safe? If not then we need to take a refcount on the task
>> > struct after all.
>>
>> Urg, no we can't sleep under an rcu_read_lock().
>
> Ok so take a count and drop it before entering the main migration
> function?

For correct operation of kernel code a count sounds fine.

If you are going to allow sleeping how do you ensure that an exec that
happens between the taking of the reference count and checking the
permissions does not mess things up.

At the very least the patch description needs an explanation of what
the thinking will be in that case.

At the moment I suspect the permissions checks are not safe unless
performed under both rcu_read_lock and task_lock to ensure that
the task<->mm association does not change on us while we are
working.  Even with that the cred can change under us but at least
we know the cred will be valid until rcu_read_unlock happens.

This entire thinhg of modifying another process is a pain.

Perhaps you can play with task->self_exec_id to detect an exec and fail
the system call if there was an exec in between when we find the task
and when we drop the task reference.

Eric

