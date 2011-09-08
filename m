Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab1IHAov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 20:44:51 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58779 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757565Ab1IHAou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 20:44:50 -0400
Date: Thu, 8 Sep 2011 09:44:38 +0900
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        dvlasenk@redhat.com
Subject: Re: [PATCH v2] Make PTRACE_SEIZE set ptrace options specified in
 'data' parameter
Message-ID: <20110908004438.GC3987@mtj.dyndns.org>
References: <201109072340.31460.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109072340.31460.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Sep 07, 2011 at 11:40:31PM +0200, Denys Vlasenko wrote:
> +	if (seize) {
> +		if (addr != 0)
> +			goto out;
> +		if ((flags & ~(long)PTRACE_O_MASK) != PTRACE_SEIZE_DEVEL)

Please use (unsigned long).  Also, wouldn't it be better to do the
following instead?

	if (!(flags & PTRACE_SEIZE_DEVEL))
		goto out;
	flags &= ~PTRACE_SEIZE_DEVEL;

	if ((flags & ~(unsigned long(PTRACE_O_MASK))))
		goto out;

Then, we can later just delete the first three lines when removing
SEIZE_DEVEL.

> @@ -263,11 +272,9 @@ static int ptrace_attach(struct task_struct *task, long request,
>  	if (task->ptrace)
>  		goto unlock_tasklist;
>  
> -	task->ptrace = PT_PTRACED;
> -	if (seize)
> -		task->ptrace |= PT_SEIZED;
>  	if (task_ns_capable(task, CAP_SYS_PTRACE))
> -		task->ptrace |= PT_PTRACE_CAP;
> +		flags |= PT_PTRACE_CAP;
> +	task->ptrace = flags;

Can you please put this in a separate patch?  Hmm... also I think we
probably want to set ->ptrace while holding siglock too.  There are
places which assume ->ptrace is protected by siglock.  We can move
siglock locking above so that both ->ptrace setting and linking are
protected by siglock and use send_signal() instead of send_sig_info()
for the implied SIGSTOP.  Note that __ptrace_unlink() would need
similar update too.

Thank you.

-- 
tejun
