Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab2KETej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 14:34:39 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:45476 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab2KETeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 14:34:37 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Containers <containers@lists.linux-foundation.org>
References: <20121105163810.GJ14789@redhat.com>
Date: Mon, 05 Nov 2012 11:34:26 -0800
In-Reply-To: <20121105163810.GJ14789@redhat.com> (Aristeu Rozanski's message
	of "Mon, 5 Nov 2012 11:38:11 -0500")
Message-ID: <87r4o7alod.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+LwJinhNBXkXrMBbtuRpZaNsv9Gcne9fA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1853]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Aristeu Rozanski <aris@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] coredump: run the coredump helper using the same namespace as the dead process
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aristeu Rozanski <aris@redhat.com> writes:

> /proc/sys/kernel/core_pattern can be used to specify a userspace helper
> to handle core files and it currently runs in the root namespace.
> This patch allows the helper to run in the same namespace in a step
> towards letting containers setting their own helpers.

I would argue that you very much need to define what it means to have a
per container core dump at the same time as you argue this.

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Running in a namespace different than whoever set the core dump
pattern/helper makes core dump helpers much more attackable.  With this
patch and a little creativity I expect I can get root to write to
whatever file I would like.  Since I also control the content of what is
going into that file.... This design seems emintely exploitable.

Furthermore not all namespaces are pointed at by nsproxy, so even
for it's original design this patch is buggy.


I do think supporting a per container coredump setting makes a lot of
sense but I do not think this patch is the way to do it.

Eric


> Cc: "Serge E. Hallyn" <serge@hallyn.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Aristeu Rozanski <aris@redhat.com>
>
> diff --git a/fs/coredump.c b/fs/coredump.c
> index ce47379..fa14ea1 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -455,6 +455,19 @@ static int umh_pipe_setup(struct subprocess_info *info, struct cred *new)
>  	/* and disallow core files too */
>  	current->signal->rlim[RLIMIT_CORE] = (struct rlimit){1, 1};
>  
> +	/*
> +	 * We want to run the helper within the same namespace. Since we
> +	 * already forked, current here is using init_nsproxy and the usage
> +	 * was already accounted. switch_task_namespace() will revert that
> +	 * but we need to bump the dead process' nsproxy before calling the
> +	 * the helper. Once it exits, the dead process' nsproxy usage will be
> +	 * decremented as part of normal process exit.
> +	 */
> +	if (current->nsproxy != cp->nsproxy) {
> +		get_nsproxy(cp->nsproxy);
> +		switch_task_namespaces(current, cp->nsproxy);
> +	}
> +
>  	return err;
>  }
>  
> @@ -482,6 +495,8 @@ void do_coredump(siginfo_t *siginfo, struct pt_regs *regs)
>  		 * by any locks.
>  		 */
>  		.mm_flags = mm->flags,
> +		/* we run the helper in the same namespace */
> +		.nsproxy = current->nsproxy,
>  	};
>  
>  	audit_core_dumps(siginfo->si_signo);
> diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
> index cfcc6bf..45113e6 100644
> --- a/include/linux/binfmts.h
> +++ b/include/linux/binfmts.h
> @@ -63,6 +63,7 @@ struct coredump_params {
>  	struct file *file;
>  	unsigned long limit;
>  	unsigned long mm_flags;
> +	struct nsproxy *nsproxy;
>  };
>  
>  /*
