Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab0IZRzX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 13:55:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756127Ab0IZRzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 13:55:22 -0400
Date: Sun, 26 Sep 2010 19:51:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ptrace: annotate siglock acquisition
Message-ID: <20100926175150.GA26579@redhat.com>
References: <1285415621-28548-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285415621-28548-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25, Namhyung Kim wrote:
>
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -435,7 +435,8 @@ static int ptrace_getsiginfo(struct task_struct *child, siginfo_t *info)
>  	unsigned long flags;
>  	int error = -ESRCH;
>
> -	if (lock_task_sighand(child, &flags)) {
> +	if (__cond_lock(&child->sighand->siglock,
> +			lock_task_sighand(child, &flags))) {

Well, this looks fine, but if we are going to make sparse happy
then we have more callers to fix.

Perhaps we should just renam lock_task_sighand to __lock_task_sighand
and add

	#define lock_task_sighand(tsk, flagsp)	\
		__cond_lock((tsk)->sighand->siglock, __lock_task_sighand((tsk), (flagsp)))

?

Oleg.

