Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933532Ab1ESQ3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 12:29:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932850Ab1ESQ3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 12:29:32 -0400
Date: Thu, 19 May 2011 18:27:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 07/10] ptrace: make group stop state visible via
	PTRACE_GETSIGINFO
Message-ID: <20110519162741.GD17265@redhat.com>
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <1305569849-10448-8-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305569849-10448-8-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16, Tejun Heo wrote:
>
>  static int ptrace_getsiginfo(struct task_struct *child, siginfo_t *info)
>  {
> +	struct signal_struct *sig;
>  	unsigned long flags;
>  	int error;
>
>  	if (!lock_task_sighand(child, &flags))
>  		return -ESRCH;
> +	sig = child->signal;
>
>  	error = -EINVAL;
>  	if (!child->last_siginfo)
> @@ -585,6 +587,23 @@ static int ptrace_getsiginfo(struct task_struct *child, siginfo_t *info)
>
>  	error = 0;
>  	*info = *child->last_siginfo;
> +
> +	/*
> +	 * If reporting ptrace trap for a seized tracee, enable reporting
> +	 * of info->si_pt_flags.
> +	 */
> +	if ((child->ptrace & PT_SEIZED) &&
> +	    (info->si_code & __SI_MASK) == __SI_TRAP) {
> +		/*
> +		 * Report whether group stop is in effect w/ SI_STOPPED and
> +		 * if so which signal caused it.
> +		 */
> +		if (sig->group_stop_count || sig->flags & SIGNAL_STOP_STOPPED) {

Cosmetic nit, you could declare "struct signal_struct *sig" here, under
if (PT_SEIZED && __SI_TRAP).


I must admit, personally I still dislike this new PTRACE_GETSIGINFO API...
But I can't suggest anything better, so I am not going to argue.

Oleg.

