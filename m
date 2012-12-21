Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab2LUSnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 13:43:17 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:36269 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab2LUSnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 13:43:06 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, Serge Hallyn <serge@hallyn.com>,
        Gao feng <gaofeng@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <8739097bkk.fsf@xmission.com>
	<1353083750-3621-1-git-send-email-ebiederm@xmission.com>
	<1353083750-3621-7-git-send-email-ebiederm@xmission.com>
	<20121219184757.GB22991@redhat.com> <87bodourqt.fsf@xmission.com>
	<20121221141133.GA13805@redhat.com>
	<20121221150238.GA16003@redhat.com>
	<20121221153152.GA17250@redhat.com>
Date: Fri, 21 Dec 2012 10:42:57 -0800
In-Reply-To: <20121221153152.GA17250@redhat.com> (Oleg Nesterov's message of
	"Fri, 21 Dec 2012 16:31:52 +0100")
Message-ID: <8738yzl00e.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19QuVDdcnLt0Jdt09tbFefJjMhhlh89m84=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.5 XMGappySubj_01 Very gappy subject
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0006]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 07/11] pidns: Wait in zap_pid_ns_processes until pid_ns->nr_hashed == 1
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 12/21, Oleg Nesterov wrote:
>>
>> Once again, the parent namespace injects the task T after ns->reaper
>> sees nr_hashed == 1 and returns. Suppose that reaper's parent does
>> do_wait() and free_pidmap() clears the bit == 1.
>>
>> Now, what if T doesn't exit but forks? We must not re-create the
>> task with pid_nr == 1 in the dead namespace. Normally this can't
>> happen, RESERVED_PIDS logic in alloc_pidmap() saves us. But it
>> seems that we need
>>
>> 	- .extra1 = &zero,
>> 	+ .extra1 = &one,
>>
>> in pid_ns_ctl_table.
>
> Oh, and another problem, or I am totally confused.
>
> T forks and creates the child C1. C1 creates C2. What if C1 exits?
> It will try to reparent C2 to the dead/freed ns->child_reaper.
>
> In short. We shouldn't allow alloc_pid() if ns->child_reaper is dying,
> I think. nr_hashed == -1 doesn't really work.

Certainly nr_hashed == -1 is insufficient.

Injecting a processes when nr_hashed == 1 seems to be the magic poison.

I wonder if we could just say.
	if (ns->nr_hashed == -1)
        	goto out_unlock;
	if ((ns->nr_hashed >= 1) && (ns->child_reaper->flags & PF_EXITING))
		goto out_unlock;

I don't know if the locking is sufficient at that point.

Eric
