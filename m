Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab1CBODv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 09:03:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab1CBODu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 09:03:50 -0500
Date: Wed, 2 Mar 2011 14:55:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Scott James Remnant <scott@canonical.com>,
        Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Casey Dahlin <cdahlin@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND][RFC PATCH v2] waitfd
Message-ID: <20110302135503.GB9838@redhat.com>
References: <49639EB8.40204@redhat.com> <4963ABF0.6070400@redhat.com> <20090107123457.GB16268@elte.hu> <20090107205322.5F8C7FC3E0@magilla.sf.frob.com> <1231598714.11642.53.camel@quest> <20090110155720.GA10954@redhat.com> <AANLkTimw5Z00uVsWYP0KGiQ8jDex9yYGNc61SG=9GsGj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimw5Z00uVsWYP0KGiQ8jDex9yYGNc61SG=9GsGj@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02, Denys Vlasenko wrote:
>
> On Sat, Jan 10, 2009 at 4:57 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > We do not need multiple signals in queue if we want to reap multiple
> > zombies. Once we have a single SIGCHLD (reported by signalfd or
> > whatever) we can do do_wait(WNOHANG) in a loop.
> >
> > Confused.
>
> I know I am terribly late for the party :)
>
> "do_wait(WNOHANG) in a loop" is a performance problem.

Yes.

> Oleg, do you remember that strace bug when it was swamped
> with gazillions of stop notifications from a multithreaded
> task, then by dealing with them one-by-one it was causing
> unfairness and ultimately "this program never finishes
> when run under strace" bug?

Yes. But, iirc, this was not connected to the performance problems
with do_wait(). The problem was, strace did a single do_wait()
instead of wait-them-all.

> And another typical nuisance that running multithreaded
> stuff under strace is much slower, even with -e option
> which limits the set of decoded syscalls?

IIUC, this is also because strace is single-threaded, I mean it
doesn't scale well.

> Having waitfd would help both cases: strace can gulp
> a lot of waitpid notifications in one go, and
> batch process them.

Perhaps.

I do not know how much do_wait() contributes to the slowness
though. And it is not exactly clear how we can implement the
"fast" waitfd.

For example, this patch (iirc!) just calls do_wait() in a loop.
I doubt very much it can really help to improve the performance.



Oh. Can't resist. The real problem is that ptrace API should
not be per-thread, and it should not use wait() at all. But
this is offtopic.

Oleg.

