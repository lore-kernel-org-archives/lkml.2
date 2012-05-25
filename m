Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab2EYV0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 17:26:10 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:38035 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab2EYV0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 17:26:08 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>
References: <20120516183920.GA19975@redhat.com> <878vgrsv7q.fsf@xmission.com>
	<20120517170015.GA12436@redhat.com> <87d3628oqa.fsf@xmission.com>
	<20120518123911.GA417@redhat.com> <87zk95kper.fsf@xmission.com>
	<20120521124414.GA20391@redhat.com> <87d35x5ank.fsf_-_@xmission.com>
	<20120522122315.c3f2118c.akpm@linux-foundation.org>
	<20120523145239.GA20378@redhat.com>
	<20120525151526.GA13111@redhat.com>
Date: Fri, 25 May 2012 15:25:55 -0600
In-Reply-To: <20120525151526.GA13111@redhat.com> (Oleg Nesterov's message of
	"Fri, 25 May 2012 17:15:26 +0200")
Message-ID: <87obpceyvw.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=208.38.5.102;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/LADf7IDr3X+S9Z/F96msm7GIsHfJUQtw=
X-SA-Exim-Connect-IP: 208.38.5.102
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  0.5 XMGappySubj_01 Very gappy subject
	*  0.1 XMSubLong Long Subject
	*  1.0 XMGappySubj_02 Gappier still
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1554]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH -mm] pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-r eaped-v2-fix-fix
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> So. Eric, Andrew, will you agree with this cleanup on top of
> pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2-fix.patch
> ?
>
> 1. Update the comments in zap_pid_ns_processes() and __unhash_process()

In zap_pid_ns_processes I wonder if we should update the big block
comment with a little more of the theory.  AKA we want as many children
to self-reap and become EXIT_DEAD children as possible becasue it
enables more parallelism and is thus faster.

> 2. Move the wake-up-reaper code in __unhash_process() under IS_ENABLED()

I don't really care, it ceartainly looks better than an #ifdef block.
However come to think of it, it is about time to just plain start
removing those config options.  The original point was so that there
would be a simple hammer people could throw while we were implementing
the namespaces to easily avoid any issues.  At this point with the
namespaces being about as stable as the rest of the kernel I don't know
that there is any advantage is having in having a config option.

> 3. Re-structure the wait-for-empty-children code in zap_pid_ns_processes()
The restructuring seems basically sane.

> @@ -76,13 +74,16 @@ static void __unhash_process(struct task_struct *p, bool group_dead)
>  
>  		/*
>  		 * If we are the last child process in a pid namespace to be
> -		 * reaped, notify the child_reaper.
> +		 * reaped, notify the child_reaper, see zap_pid_ns_processes().
>  		 */


How about instead:
>  		/*
>  		 * If we are the last child process in a pid namespace to be
> -		 * reaped, notify the child_reaper.
> +		 * reaped, wake up the child_reaper sleeping in zap_pid_ns_processes().
>  		 */


> -		parent = p->real_parent;
> -		if ((task_active_pid_ns(p)->child_reaper == parent) &&
> -		    list_empty(&parent->children) &&
> -		    (parent->flags & PF_EXITING))
> -			wake_up_process(parent);
> +		if (IS_ENABLED(CONFIG_PID_NS)) {
> +			struct task_struct *parent = p->real_parent;
> +
> +			if ((task_active_pid_ns(p)->child_reaper == parent) &&
> +			    list_empty(&parent->children) &&
> +			    (parent->flags & PF_EXITING))
> +				wake_up_process(parent);
> +		}
>  	}
>  	detach_pid(p, PIDTYPE_PID);
>  	list_del_rcu(&p->thread_group);

Eric
