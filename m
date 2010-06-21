Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab0FUByL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 21:54:11 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:47726 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757356Ab0FUByH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 21:54:07 -0400
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Louis Rilling <louis.rilling@kerlabs.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org, Daniel Lezcano <dlezcano@fr.ibm.com>
References: <20100617212003.GA4182@redhat.com>
	<20100618082033.GD16877@hawkmoon.kerlabs.com>
	<20100618111554.GA3252@redhat.com> <20100618160849.GA7404@redhat.com>
	<20100618173320.GG16877@hawkmoon.kerlabs.com>
	<20100618175541.GA13680@redhat.com>
	<20100618212355.GA29478@redhat.com> <20100619190840.GA3424@redhat.com>
	<m1pqzmqema.fsf_-_@fess.ebiederm.org>
	<m1wrtuozq6.fsf_-_@fess.ebiederm.org>
	<20100620201454.GA6902@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 20 Jun 2010 18:53:52 -0700
In-Reply-To: <20100620201454.GA6902@redhat.com> (Oleg Nesterov's message of "Sun\, 20 Jun 2010 22\:14\:54 +0200")
Message-ID: <m1d3vlw3pr.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: oleg@redhat.com, dlezcano@fr.ibm.com, linux-kernel@vger.kernel.org, containers@lists.osdl.org, xemul@openvz.org, louis.rilling@kerlabs.com, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 6/6] pidns: Support unsharing the pid namespace.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 06/20, Eric W. Biederman wrote:
>>
>> Unsharing of the pid namespace unlike unsharing of other namespaces
>> does not take affect immediately.  Instead it affects the children
>> created with fork and clone.
>
> Cough. It is too late to me to even try to understand the changelog.
>
> Instead I tried to quickly read the patch. Most probably I missed
> somthing, but still I'd like to ask the quiestion.
>
> So. If I understand correctly, the patch is simple:
>
> 	- unshare(CLONE_NEWPID) changes current->proxy->pid_ns,
> 	  but do not change current->pids[] and thus it doesn't
> 	  change task_active_pid_ns().
>
> 	- since copy_process() uses ->proxy->pid_ns for alloc_pid()
> 	  the new children will fall into the new ns.
>
> IOW, the caller becomes the "swapper" for the new namespace.
>
> Correct?

Roughly.  The caller is not in the pid namespace so shows up as pid 0.

> If yes, I'm afraid nobody except you will understand this magic ;)
>
> But what if the task T does unshare(CLONE_NEWPID) and then, say,
> pthread_create() ? Unless I missed something, the new thread won't
> be able to see T ?

Good question.  I need to go back and look at that.

> OK, suppose it does fork() after unshare(), then another fork().
> In this case the second child lives in the same namespace with
> init created by the 1st fork, but it is not descendant ? This means
> in particular that if the new init exits, zap_pid_ns_processes()->
> do_wait() can't work.

do_wait() can't work and I missed that dependency the first time
around.  Having looked at my earlier bug report from Daniel when
I was playing with this patchset earlier it is clear that he was
triggering the proc_mnt race with such a process.

So except for ptrace I don't think the proc_mnt problem is possible
to trigger in the current code.

> I hope I missed something, this all is too subtle for me. And I
> still do not understand 4/6 which adds ns->dead.

ns->dead is just a flag to say no more processes in the pid namespace.
Which means an unshare into the pid namespace after zap_pid_ns_processes
has been called will fail().

Eric



