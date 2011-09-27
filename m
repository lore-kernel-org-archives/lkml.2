Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485Ab1I0P1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 11:27:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59969 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab1I0P1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 11:27:20 -0400
Date: Tue, 27 Sep 2011 10:27:11 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        Andrew Morton <akpm@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        serge@hallyn.com
Subject: Re: [PATCH] user namespace: make signal.c respect user namespaces
Message-ID: <20110927152711.GB2952@peqn>
References: <20110920185354.GA19629@sergelap>
 <20110921175357.GA25590@redhat.com>
 <20110923163113.GA3820@sergelap>
 <20110923173656.GA5233@redhat.com>
 <20110923212025.GA21330@sergelap>
 <20110924163709.GA6776@redhat.com>
 <20110925201723.GA5288@sergelap>
 <20110926160619.GA13736@redhat.com>
 <20110927142833.GA4876@peqn>
 <20110927143835.GA8450@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110927143835.GA8450@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> On 09/27, Serge Hallyn wrote:
> >
> > Quoting Oleg Nesterov (oleg@redhat.com):
> > > On 09/25, Serge E. Hallyn wrote:
> > > >
> > > > Yes, that's the case I was talking about.  That then proceeds through
> > > > send_signal().
> > >
> > > It doesn't?
> >
> > No, I was saying it *does*.
> 
> But it doesn't ;)
> 
> Serge, there is some misunderstanding. And I do not know who is confused,
> me or your.
> 
> ptrace_signal() simply fills *info with some "random" data before
> processing the signal. It doesn't pass this info to send_signal().

Oh, well not always, but it does in the case where
	sigismember(&current->blocked, signr);
But I suppose that's not a common path :)

> If the debuggure wants something meaningfull in *info, it should
> fill it itself via PTRACE_SETSIGINFO. This handles the case when
> the debugger doesn't really care and only changes signr.

Ok.

> > > +static inline fixup_uid(struct siginfo *info, struct task_struct *t)
> > > +{
> > > +#ifdef CONFIG_USER_NS
> > > +	if (current_user_ns() == task_cred_xxx(t, user_ns)))
> > > +#endif
> > > +		return;
> > > +
> > > +	if (SI_FROMKERNEL(info))
> > > +		switch (info->si_code & __SI_MASK) {
> > > +			default:
> > > +				return;
> > > +
> > > +			case __SI_CHLD:
> > > +			case __SI_MESGQ:
> > > +				break;
> > > +		}
> > > +
> > > +	info->si_uid = user_ns_map_uid(task_cred_xxx(t, user_ns),
> > > +					current_cred(), info->si_uid);
> > > +}
> > > +
> > >  static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
> > >  			int group, int from_ancestor_ns)
> > >  {
> > > @@ -1088,6 +1109,9 @@ static int __send_signal(int sig, struct
> > >  				q->info.si_pid = 0;
> > >  			break;
> > >  		}
> > > +
> > > +		fixup_uid(info, t);
> > > +
> > >  	} else if (!is_si_special(info)) {
> > >  		if (sig >= SIGRTMIN && info->si_code != SI_USER) {
> > >  			/*
> >
> > It certainly is much simpler.  I'll take some time to walk through all
> > of send_signal again and make sure I understand what it does in all
> > the cases.
> 
> Thanks.
> 
> 
> 
> As for ptrace_signal(), it can use the same helper too. Once again,
> debugger can use PTRACE_SETSIGINFO, if we really want to fixup si_uid
> we should do this even if signr == info->si_signo. OTOH, we do not
> know what debugger puts in this chunk of memory. This is like
> sigqueueinfo().

True.

> Or we can simply leave this code as is. I do not think this si_uid
> (in this case) is really important.

Ok, that sounds good to me.

thanks,
-serge
