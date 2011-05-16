Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab1EPQCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 12:02:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756511Ab1EPQCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 12:02:06 -0400
Date: Mon, 16 May 2011 18:00:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 6/9] job control: make task_clear_jobctl_pending()
	clear TRAPPING automatically
Message-ID: <20110516160019.GB15918@redhat.com>
References: <1305301580-9924-1-git-send-email-tj@kernel.org> <1305301580-9924-7-git-send-email-tj@kernel.org> <20110516122535.GD4898@redhat.com> <20110516132400.GY23665@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516132400.GY23665@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16, Tejun Heo wrote:
>
> Hello,
>
> On Mon, May 16, 2011 at 02:25:35PM +0200, Oleg Nesterov wrote:
> > On 05/13, Tejun Heo wrote:
> > >
> > > @@ -264,6 +267,9 @@ void task_clear_jobctl_pending(struct task_struct *task, unsigned int mask)
> > >  		mask |= JOBCTL_STOP_CONSUME | JOBCTL_STOP_DEQUEUED;
> > >
> > >  	task->jobctl &= ~mask;
> > > +
> > > +	if (!(task->jobctl & JOBCTL_PENDING_MASK))
> > > +		task_clear_jobctl_trapping(task);
> > >  }
> >
> > So, SIGCONT clears JOBCTL_TRAPPING and wakes up the tracer.
>
> If JOBCTL_TRAPPING is set && JOBCTL_STOP_PENDING was the only pending
> condition.
>
> > I can't really understand this without seeing the next changes, but
> > it seems this makes some things worse, although I am not sure.
>
> It's a safety mechanism.  We shouldn't have TRAPPING set when no
> stop/trap is pending and the above establishes that invariant

Hmm. I thought that SIGCONT should add the new TRAPPING... My head spins.

> > For example. PTRACE_SEIZE should guarantee the tracee will trap and
> > report. However, if the tracee is stopped during attach, we can race
> > with SIGCONT. The previous version had the similar problem afaics, but
> > it was easy (I think) to fix. Now that SIGCONT clears JOBCTL_TRAPPING
> > we need more complications.
>
> This problem doesn't exist anymore.

OK. Of course I do not understand your explanation right now, I do not
see the code, but I trust you ;)


My only point, I still think that it is better to not apply these
preparations right now, without the next SEIZE/etc changes.

Oleg.

