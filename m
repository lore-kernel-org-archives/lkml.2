Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750973Ab1ITQpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 12:45:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57657 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab1ITQpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 12:45:32 -0400
Date: Tue, 20 Sep 2011 11:45:24 -0500
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        Andrew Morton <akpm@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        serge@hallyn.com
Subject: Re: [PATCH] user namespace: make signal.c respect user namespaces
Message-ID: <20110920164524.GA8214@sergelap>
References: <20110919214531.GA18085@sergelap>
 <20110920122202.GA26504@redhat.com>
 <20110920153944.GA11531@peqn>
 <20110920162455.GB18891@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110920162455.GB18891@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> On 09/20, Serge Hallyn wrote:
> >
> > Quoting Oleg Nesterov (oleg@redhat.com):
> > >
> > > As for __send_signal() in particular, I guess we could do
> > >
> > > 		q->info.si_uid = from_ancestor_ns ? 0 : current_uid();
> >
> > But wait - can't __send_signal end up being triggered through fcntl
> > F_SETSIG+F_SETOWN to another but none-ancestor namespace?
> 
> I didn't really check, but afaics send_sigio_to_task/etc never use
> SEND_SIG_NOINFO. And they shouldn't, there is no the sending process.

(I'm sure you're right - but I'll have to take a closer look for my
own understanding)

> > do actually need to call the full user_ns_map_uid() there.  However,
> > the uid sent in ptrace_signal() can (if i'm thinking right) be set
> > using
> >
> > 	info->si_uid = (current_user_ns() == parent_user_ns()) ?
> > 			0 : current_uid();
> >
> > Not much of a win performance-wise, but perhaps better by making it
> > clear that those are the only possibilities (and overflowuid is not
> > possible).
> 
> I think you are right right, except s/==/!=/.

Yes :)

> This is like send_signal()
> which can only send the signal down or to the same namespace.
> 
> I guess ptrace_signal() can even do
> 
> 	info->si_pid = task_pid_vnr(current->parent);
> 
> 	if (info->si_pid)	// same namespace
> 		info->si_uid = current_uid();
> 	else			// can't see the tracer, we are from the sub-namespace
> 		info->si_uid = 0;
> 
> Whatever you like more.

Except you don't have to split pid and user namespaces at the same
time.

> And just in case let me repeat, I won't argue if you use
> user_ns_map_uid/helper for consistency. Without CONFIG_USER_NS it is
> even better performance-wise (even if we add a helper I guess).

Ok.  On the one hand, using your new mapping helper will make it
easier to make sure everything is right.  This special code may be
more educational to the new reader, but isn't as trivial to
review.

Maybe I'll go with the mapping.

thanks,
-serge
