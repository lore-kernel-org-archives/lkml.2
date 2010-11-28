Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab0K1UhH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 15:37:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460Ab0K1UhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 15:37:04 -0500
Date: Sun, 28 Nov 2010 21:30:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        "rjw@sisk.plpavel"@ucw.cz
Subject: Re: [PATCH 11/14] ptrace: make group stop notification reliable
	against ptrace
Message-ID: <20101128203000.GD12896@redhat.com>
References: <1290768569-16224-1-git-send-email-tj@kernel.org> <1290768569-16224-12-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290768569-16224-12-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26, Tejun Heo wrote:
>
> Group stop notifications are unreliable if one or more tasks of the
> task group are being ptraced.  If a ptraced task ends up finishing a
> group stop, the notification is sent to the ptracer and the real
> parent never gets notified.

Yes. I do not even know if this is bug or not, but certainly I agree,
this doesn't look very nice.

>  	if (likely(!task_ptrace(current))) {
> +		bool do_notify = false;
> +
> +		if (sig->flags & SIGNAL_NOTIFY_STOP) {
> +			sig->flags &= ~SIGNAL_NOTIFY_STOP;
> +			do_notify = true;
> +		}
> +
>  		spin_unlock_irq(&current->sighand->siglock);
>
> -		if (notify) {
> +		if (do_notify) {
>  			read_lock(&tasklist_lock);
> -			do_notify_parent_cldstop(current, notify);
> +			do_notify_parent_cldstop(current, CLD_STOPPED);

This can race with ptrace_attach() in between.

IOW, this notification can go to the new tracer anyway.

Oleg.

