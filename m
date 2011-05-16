Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab1EPM0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:26:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031Ab1EPM0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:26:53 -0400
Date: Mon, 16 May 2011 14:25:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 6/9] job control: make task_clear_jobctl_pending()
	clear TRAPPING automatically
Message-ID: <20110516122535.GD4898@redhat.com>
References: <1305301580-9924-1-git-send-email-tj@kernel.org> <1305301580-9924-7-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305301580-9924-7-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13, Tejun Heo wrote:
>
> @@ -264,6 +267,9 @@ void task_clear_jobctl_pending(struct task_struct *task, unsigned int mask)
>  		mask |= JOBCTL_STOP_CONSUME | JOBCTL_STOP_DEQUEUED;
>
>  	task->jobctl &= ~mask;
> +
> +	if (!(task->jobctl & JOBCTL_PENDING_MASK))
> +		task_clear_jobctl_trapping(task);
>  }

So, SIGCONT clears JOBCTL_TRAPPING and wakes up the tracer.

I can't really understand this without seeing the next changes, but
it seems this makes some things worse, although I am not sure.

For example. PTRACE_SEIZE should guarantee the tracee will trap and
report. However, if the tracee is stopped during attach, we can race
with SIGCONT. The previous version had the similar problem afaics, but
it was easy (I think) to fix. Now that SIGCONT clears JOBCTL_TRAPPING
we need more complications.

Oleg.

