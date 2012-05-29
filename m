Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab2E2Gen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 02:34:43 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45060 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab2E2Gek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 02:34:40 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>
References: <87zk95kper.fsf@xmission.com> <20120521124414.GA20391@redhat.com>
	<87d35x5ank.fsf_-_@xmission.com>
	<20120522122315.c3f2118c.akpm@linux-foundation.org>
	<20120523145239.GA20378@redhat.com>
	<20120525151526.GA13111@redhat.com>
	<20120525155941.GA16885@redhat.com>
	<20120525160008.GB16885@redhat.com> <87pq9sdjhn.fsf@xmission.com>
	<20120527191032.GB13929@redhat.com>
	<20120527191106.GC13929@redhat.com>
Date: Tue, 29 May 2012 00:34:27 -0600
In-Reply-To: <20120527191106.GC13929@redhat.com> (Oleg Nesterov's message of
	"Sun, 27 May 2012 21:11:06 +0200")
Message-ID: <874nqzmr64.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=208.38.5.102;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19Do11mrUdegGmtKxlAE9DtqUUAvCgRvV0=
X-SA-Exim-Connect-IP: 208.38.5.102
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_05 8+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v2 -mm 1/1] pidns: find_new_reaper() can no longer switch to init_pid_ns.child_reaper
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> find_new_reaper() changes pid_ns->child_reaper, see add0d4df
> "pid_ns: zap_pid_ns_processes: fix the ->child_reaper changing".
>
> The original reason has gone away after the previous patch,
> ->children list must be empty after zap_pid_ns_processes().
>
> However now we can not switch to init_pid_ns.child_reaper.
> __unhash_process() relies on the "->child_reaper == parent"
> check, but this check does not work if the last exiting task
> is also the child reaper.
>
> As Eric sugested, we can change __unhash_process() to use the
> parent's pid_ns and remove this code.
>
> Also, with this change we can move detach_pid(PIDTYPE_PID) back,
> where it was before the previous fix.

This looks good to me. 

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

I will be on the road for next two days so I don't expect I will
be particularly active in this converation for a while.

Eric


> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/exit.c |   10 ++--------
>  1 files changed, 2 insertions(+), 8 deletions(-)
>
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 6d66cd2..6424e6b 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -64,6 +64,7 @@ static void exit_mm(struct task_struct * tsk);
>  static void __unhash_process(struct task_struct *p, bool group_dead)
>  {
>  	nr_threads--;
> +	detach_pid(p, PIDTYPE_PID);
>  	if (group_dead) {
>  		detach_pid(p, PIDTYPE_PGID);
>  		detach_pid(p, PIDTYPE_SID);
> @@ -79,13 +80,12 @@ static void __unhash_process(struct task_struct *p, bool group_dead)
>  		if (IS_ENABLED(CONFIG_PID_NS)) {
>  			struct task_struct *parent = p->real_parent;
>  
> -			if ((task_active_pid_ns(p)->child_reaper == parent) &&
> +			if ((task_active_pid_ns(parent)->child_reaper == parent) &&
>  			    list_empty(&parent->children) &&
>  			    (parent->flags & PF_EXITING))
>  				wake_up_process(parent);
>  		}
>  	}
> -	detach_pid(p, PIDTYPE_PID);
>  	list_del_rcu(&p->thread_group);
>  }
>  
> @@ -732,12 +732,6 @@ static struct task_struct *find_new_reaper(struct task_struct *father)
>  
>  		zap_pid_ns_processes(pid_ns);
>  		write_lock_irq(&tasklist_lock);
> -		/*
> -		 * We can not clear ->child_reaper or leave it alone.
> -		 * There may by stealth EXIT_DEAD tasks on ->children,
> -		 * forget_original_parent() must move them somewhere.
> -		 */
> -		pid_ns->child_reaper = init_pid_ns.child_reaper;
>  	} else if (father->signal->has_child_subreaper) {
>  		struct task_struct *reaper;
