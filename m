Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762394Ab2EQWyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:54:41 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:46885 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758092Ab2EQWyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:54:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Sasha Levin <levinsasha928@gmail.com>
Cc: oleg@redhat.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        davej@redhat.com
References: <1337290299-11057-1-git-send-email-levinsasha928@gmail.com>
Date: Thu, 17 May 2012 16:54:27 -0600
In-Reply-To: <1337290299-11057-1-git-send-email-levinsasha928@gmail.com>
	(Sasha Levin's message of "Thu, 17 May 2012 23:31:39 +0200")
Message-ID: <87k40as9jw.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=208.38.5.102;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18sTUItj50JJBn32sR0o7XeYtHJJEN/2fk=
X-SA-Exim-Connect-IP: 208.38.5.102
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Sasha Levin <levinsasha928@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] cred: use correct cred accessor with regards to rcu read lock
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <levinsasha928@gmail.com> writes:

> Commit "userns: Convert setting and getting uid and gid system calls to use
> kuid and kgid has modified the accessors in wait_task_continued() and
> wait_task_stopped() to use __task_cred() instead of task_uid().
>
> __task_cred() assumes that we're inside a rcu read lock, which is untrue
> for these two functions.
>
> Modify it to use task_uid() instead.

Thanks applied.

Eric


> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
>  kernel/exit.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 6818cbb..7e54635 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -1455,7 +1455,7 @@ static int wait_task_stopped(struct wait_opts *wo,
>  	if (!unlikely(wo->wo_flags & WNOWAIT))
>  		*p_code = 0;
>  
> -	uid = from_kuid_munged(current_user_ns(), __task_cred(p)->uid);
> +	uid = from_kuid_munged(current_user_ns(), task_uid(p));
>  unlock_sig:
>  	spin_unlock_irq(&p->sighand->siglock);
>  	if (!exit_code)
> @@ -1528,7 +1528,7 @@ static int wait_task_continued(struct wait_opts *wo, struct task_struct *p)
>  	}
>  	if (!unlikely(wo->wo_flags & WNOWAIT))
>  		p->signal->flags &= ~SIGNAL_STOP_CONTINUED;
> -	uid = from_kuid_munged(current_user_ns(), __task_cred(p)->uid);
> +	uid = from_kuid_munged(current_user_ns(), task_uid(p));
>  	spin_unlock_irq(&p->sighand->siglock);
>  
>  	pid = task_pid_vnr(p);
