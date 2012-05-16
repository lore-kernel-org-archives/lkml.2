Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab2EPUyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 16:54:31 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:32945 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080Ab2EPUy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 16:54:29 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>
References: <1335604790.5995.22.camel@marge.simpson.net>
	<20120428142605.GA20248@redhat.com> <m14ns355ru.fsf@fess.ebiederm.org>
	<20120429165846.GA19054@redhat.com>
	<1335754867.17899.4.camel@marge.simpson.net>
	<m1zk9rmyh4.fsf@fess.ebiederm.org>
	<20120501134214.f6b44f4a.akpm@linux-foundation.org>
	<87havs7rvv.fsf_-_@xmission.com> <8762c87rrd.fsf_-_@xmission.com>
	<20120516183920.GA19975@redhat.com>
Date: Wed, 16 May 2012 13:54:17 -0700
In-Reply-To: <20120516183920.GA19975@redhat.com> (Oleg Nesterov's message of
	"Wed, 16 May 2012 20:39:20 +0200")
Message-ID: <878vgrsv7q.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=208.38.5.102;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/Ta7uUc+Xys6B5IMWQ7SVdvuSufqfio1c=
X-SA-Exim-Connect-IP: 208.38.5.102
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0678]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 2/3] pidns: Guarantee that the pidns init will be the last pidns process reaped.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> Eric, sorry for the huge delay, I was on vacation when you sent this patch...
>
> On 05/06, Eric W. Biederman wrote:
>>
>> @@ -798,6 +815,12 @@ static void forget_original_parent(struct task_struct *father)
>>  	exit_ptrace(father);
>>  	reaper = find_new_reaper(father);
>>
>> +	/* Return immediately if we aren't going to reparent anything */
>> +	if (unlikely(reaper == father)) {
>> +		write_unlock_irq(&tasklist_lock);
>> +		return;
>> +	}
>
> I was confused by the comment. Afaics, it is not that "we aren't
> going to reparent", we need this change because we can't "reparent"
> to the same thread, list_for_each_entry_safe() below can never stop.
> But this is off-topic...

True.  We will get stuck if we try to reparent to the same process.

> Hmm. I don't think the patch is 100% correct. Afaics, this needs more
> delay_pidns_leader() checks.
>
> For example. Suppose we have a CLONE_NEWPID zombie I, it has an
> EXIT_DEAD child D so delay_pidns_leader(I) == T.
>
> Now suppose that I->real_parent exits, lets denote this task as P.
>
> Suppose that P->real_parent ignores SIGCHLD.
>
> In this case P will do release_task(I) prematurely. And worse, when
> D finally does realease_task(D) it will do realease_task(I) again.

Good point.  I will fix that and post a patch shortly.  It doesn't
need a full delay_pidns_leader test just a test for children.

In looking for any other weird corner case bugs I am noticing that
I don't think I handled the case of a ptraced init quite right.
I don't understand the change signaling semantics when the
ptracer is our parent.

Eric
