Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab2D2Hxv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 03:53:51 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:38924 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab2D2Hxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 03:53:50 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>
References: <1335604790.5995.22.camel@marge.simpson.net>
	<20120428142605.GA20248@redhat.com>
Date: Sun, 29 Apr 2012 00:57:57 -0700
In-Reply-To: <20120428142605.GA20248@redhat.com> (Oleg Nesterov's message of
	"Sat, 28 Apr 2012 16:26:05 +0200")
Message-ID: <m14ns355ru.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19mBL1zNjhzaN09jod3G1i6+uqnEC9OOrQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: marc.info]
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0120]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ******;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: **
Subject: Re: [RFC PATCH] namespaces: fix leak on fork() failure
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 04/28, Mike Galbraith wrote:
>>
>> Greetings,
>
> Hi,
>
> Add CC's. I never understood the proc/namespace interaction in details,
> and it seems to me I forgot everything.
>
>> SIGCHLD delivery during fork() may cause failure,
>
> Or any other reason to fail after copy_namespaces()
>
>> resulting in the aborted
>> child being cloned with CLONE_NEWPID leaking namespaces due to proc being
>> mounted during pid namespace creation, but not unmounted on fork() failure.
>
> Heh. Please look at http://marc.info/?l=linux-kernel&m=127687751003902
> and the whole thread, there are a lot more problems here.

I don't remember seeing a leak in that conversation.

> But this particular one looks simple iirc.
>
>> @@ -216,6 +216,14 @@ void switch_task_namespaces(struct task_struct *p, struct nsproxy *new)
>>  	rcu_assign_pointer(p->nsproxy, new);
>>
>>  	if (ns && atomic_dec_and_test(&ns->count)) {
>> +		/* Handle fork() failure, unmount proc before proceeding */
>> +		if (unlikely(!new && !((p->flags & PF_EXITING)))) {
>> +			struct pid_namespace *pid_ns = ns->pid_ns;
>> +
>> +			if (pid_ns && pid_ns != &init_pid_ns)
>> +				pid_ns_release_proc(pid_ns);
>> +		}
>> +
>>  		/*
>>  		 * wait for others to get what they want from this nsproxy.
>>  		 *
>
> At first glance this looks correct. But the PF_EXITING check doesn't
> look very nice imho. It is needed to detect the case when the caller
> is copy_process()->bad_fork_cleanup_namespaces and p is not current.

Mike's proposed change to switch_task_namespace is most definitely not
correct.  This will potentially get called on unshare and so we don't
limit ourselves to just an exit pid_namespace.  The result is that we
could free the proc mount long before it is safe.

At the same time the leak that Mike detected is most definitely real.

> Perhaps it would be more clean to add the explicit
>
> 	 bad_fork_cleanup_namespaces:
> 	+	if (unlikely(clone_flags & CLONE_NEWPID))
> 	+		pid_ns_release_proc(...);
> 		exit_task_namespaces(p);
> 		
> 		
> code into this error path in copy_process?

For now Oleg your minimal patch looks good. 

Part of me would like to call proc_flush_task instead of
pid_ns_release_proc but we have no assurance task_pid and task_tgid are
valid when we get here so proc_flush_task is out.

There are crazy code paths like daemonize() that also call
swith_task_namespaces and change the pid namespace that are still
potentially broken.

Breaking the loop between the pid namespace and the proc mount would
be good, and I will see about making the time to push those patches.
So we can have something much less magical going on.

Eric
