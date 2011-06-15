Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab1FOTIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:08:37 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:43271 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab1FOTIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:08:35 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Greg Kurz <gkurz@fr.ibm.com>, akpm@linux-foundation.org,
        containers@lists.osdl.org, linux-kernel@vger.kernel.org,
        serge@hallyn.com, daniel.lezcano@free.fr, xemul@openvz.org
References: <20110615145527.4016.70157.stgit@bahia.local>
	<20110615184625.GA15573@redhat.com>
Date: Wed, 15 Jun 2011 12:08:23 -0700
In-Reply-To: <20110615184625.GA15573@redhat.com> (Oleg Nesterov's message of
	"Wed, 15 Jun 2011 20:46:25 +0200")
Message-ID: <m162o6lxp4.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/Ve5f0JnfMVYuVc1cpAUuU1k8WfxdtLlM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] Introduce ActivePid: in /proc/self/status (v2, was Vpid:)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 06/15, Greg Kurz wrote:
>>
>> @@ -176,6 +177,17 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
>>  		if (tracer)
>>  			tpid = task_pid_nr_ns(tracer, ns);
>>  	}
>> +	actpid = 0;
>> +	sighand = rcu_dereference(p->sighand);
>> +	if (sighand) {
>> +		struct pid_namespace *pid_ns;
>> +		unsigned long flags;
>> +		spin_lock_irqsave(&sighand->siglock, flags);
>
> Well. This is not exactly right. We have lock_task_sighand() for this.
>
> But. Why do you need ->siglock? Why rcu_read_lock() is not enough?
>
> Hmm. You don't even need pid_ns afaics, you could simply look at
> pid->numbers[pid->level].

I got this moving in that direction, but I admit I probably didn't look
close enough.  I just remember it is always tricky when accessing a
process and dealing with races with things like unhash_process().

Eric
