Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab1EKRCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:02:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477Ab1EKRCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:02:36 -0400
Date: Wed, 11 May 2011 19:00:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 10/11] ptrace: move JOBCTL_TRAPPING wait to wait(2) and
	ptrace_check_attach()
Message-ID: <20110511170058.GB26383@redhat.com>
References: <1304869745-1073-1-git-send-email-tj@kernel.org> <1304869745-1073-11-git-send-email-tj@kernel.org> <20110511164947.GA26383@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110511164947.GA26383@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11, Oleg Nesterov wrote:
>
> You know, I'd wish I could find the serious bugs in this patch. The
> code becomes really hairy. -EAGAIN in do_wait() doesn't make it more
> simple ;)

Mwahaha! I seem to see the bug ;)

	bool ptrace_wait_trapping(struct task_struct *child)
		__releases(&child->sighand->siglock)
		__releases(&tasklist_lock)
	{
		if (likely(!(child->jobctl & JOBCTL_TRAPPING)))
			return false;

		spin_unlock_irq(&child->sighand->siglock);
		get_task_struct(child);
		read_unlock(&tasklist_lock);

--> WINDOW

		wait_event(current->signal->wait_chldexit,
			   !(child->jobctl & JOBCTL_TRAPPING));
		put_task_struct(child);
		return true;
	}

When the caller is do_wait(), we can't assume we are the tracer when
we drop tasklist. Original tracer can detach, then another unrelated
process can attach again and provoke JOBCTL_TRAPPING. wait_event()
can hang forever.

Unfortunately, this is easy to fix :/

Oleg.

