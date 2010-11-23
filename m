Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab0KWRiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 12:38:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452Ab0KWRiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 12:38:22 -0500
Date: Tue, 23 Nov 2010 18:31:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:sched/core] cpu: Remove incorrect BUG_ON
Message-ID: <20101123173137.GA7205@redhat.com>
References: <tip-51a96c77815e7f139892a6e9c8275a50e9baebdf@git.kernel.org> <20101123143910.GA31502@redhat.com> <1290524704.2072.412.camel@laptop> <20101123150813.GA535@redhat.com> <1290532568.2072.416.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290532568.2072.416.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23, Peter Zijlstra wrote:
>
> On Tue, 2010-11-23 at 16:08 +0100, Oleg Nesterov wrote:
> > > Ah,. uhm,. you mean, not do anything at all?
> > >
> > > Dunno, really, let me try and read the code there.
> >
> > Thanks. This is very minor of course, but it would be nice to
> > undestand the reason. To me it looks unneeded, but I don't trust
> > myself.  (snippets from my previous email below).
> >
> I think because the call to __cpu_die (-> native_cpu_die) relies on the
> remote cpu running the idle thread,

How? It can't. By the time __cpu_die() is called, we do not even
know whether context_switch() was finished. All we know is that
rq->curr = idle.

native_cpu_die() correctly waits in a loop until the idle thread
sets CPU_DEAD.

And I think every smp_ops->cpu_die() implementation should synhcronize
with ->cpu_disable(), otherwise it is buggy.

> and the CPU_DEAD notifier callback
> wants to run with the guarantee the remote cpu is in fact dead as a
> doornail.

I think __cpu_die() should ensure it is dead.


OK. This is really minor. Perhaps it is safer to keep this wait just
to preserve the current behaviour.

Oleg.

