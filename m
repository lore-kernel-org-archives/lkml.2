Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926Ab1BANse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:48:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756920Ab1BANsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:48:33 -0500
Date: Tue, 1 Feb 2011 14:40:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] ptrace: use safer wake up on ptrace_detach()
Message-ID: <20110201134037.GA25392@redhat.com>
References: <1296227324-25295-1-git-send-email-tj@kernel.org> <1296227324-25295-3-git-send-email-tj@kernel.org> <20110128184601.CBF7C180996@magilla.sf.frob.com> <20110131103855.GD7459@htj.dyndns.org> <20110201102618.GE14211@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201102618.GE14211@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01, Tejun Heo wrote:
>
> --- work.orig/kernel/ptrace.c
> +++ work/kernel/ptrace.c
> @@ -313,7 +313,7 @@ int ptrace_detach(struct task_struct *ch
>  		child->exit_code = data;
>  		dead = __ptrace_detach(current, child);
>  		if (!child->exit_state)
> -			wake_up_process(child);
> +			wake_up_state(child, TASK_TRACED | TASK_STOPPED);

Well, it can't be TASK_TRACED at this point. And of course this still
contradicts to __set_task_state(child, TASK_STOPPED) in ptrace_untrace().
IOW, to me the previous patch makes more sense.

But OK, I understand Roland's concerns. And, at least this change
fixes the bug mentioned in 95a3540d.

Acked-by: Oleg Nesterov <oleg@redhat.com>

