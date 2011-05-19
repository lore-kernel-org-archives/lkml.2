Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933494Ab1ESQUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 12:20:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754532Ab1ESQUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 12:20:43 -0400
Date: Thu, 19 May 2011 18:19:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 02/10] job control: introduce JOBCTL_TRAP_STOP and use
	it for group stop trap
Message-ID: <20110519161922.GB17265@redhat.com>
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <1305569849-10448-3-git-send-email-tj@kernel.org> <20110518164814.GA28848@redhat.com> <20110519101930.GC627@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519101930.GC627@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19, Tejun Heo wrote:
>
> On Wed, May 18, 2011 at 06:48:14PM +0200, Oleg Nesterov wrote:
> > > Although this adds an unlock-relocking between checking of
> > > JOBCTL_STOP_PENDING and actually trapping for STOP, this doesn't
> > > affect correctness.
> >
> > Well, I think it does affect. Although the problem is minor.
> >
> > > ptrace_stop() already had conditional unlock-relocking
> >
> > Yes, but ptrace_stop() can't send the CLD_STOPPED notfication before
> > the tracee is ready for do_wait(WNOHANG). Contrary, get_signal_to_deliver()
> > can if we race with SIGCONT.
>
> That CLD_STOPPED notification is actually for continuation (although
> it's indistinguishible from actual stopped notification) and as such
> the ptracer has to query the tracee state after the notification
> signal and can't expect it to be in TRACED.  Please consider the
> following scenario.

OK, agreed.

> > Hmm. And afaics there is a bug in do_signal_stop(), after
> > "[PATCH 6/9] job control: make task_clear_jobctl_pending() clear TRAPPING automatically"
> > ->jobctl &= ~JOBCTL_STOP_SIGMASK is no longer safe. We can clear _TRAPPING
> > without wakeup.
>
> Hmmm?  ->jobctl &= ~JOBCTL_STOP_SIGMASK clears lower sixteen bits.
> All the flags including TRAPPING live in the upper sixteen bits.

Indeed, I was confused. Thanks for correcting me.

Oleg.

