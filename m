Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab1KRRiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 12:38:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52382 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab1KRRiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 12:38:09 -0500
Date: Fri, 18 Nov 2011 11:37:52 -0600
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, richard@nod.at,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        eparis@redhat.com, oleg@redhat.com, dhowells@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: user namespace: make signal.c respect user namespaces (v5)
Message-ID: <20111118173752.GB11823@sergelap>
References: <20111117045230.GA26345@hallyn.com>
 <m1aa7u2jv1.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1aa7u2jv1.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serge@hallyn.com> writes:
> 
> > ipc/mqueue.c: for __SI_MESQ, convert the uid being sent to recipient's
> > user namespace. (new, thanks Oleg)
> >
> > __send_signal: convert current's uid to the recipient's user namespace
> > for any siginfo which is not SI_FROMKERNEL (patch from Oleg, thanks
> > again :)
> >
> > do_notify_parent and do_notify_parent_cldstop: map task's uid to parent's
> > user namespace
> >
> > ptrace_signal maps parent's uid into current's user namespace before
> > including in signal to current.  IIUC Oleg has argued that this shouldn't
> > matter as the debugger will play with it, but it seems like not converting
> > the value currently being set is misleading.
> >
> > Changelog:
> > Sep 20: Inspired by Oleg's suggestion, define map_cred_ns() helper to
> > 	simplify callers and help make clear what we are translating
> >         (which uid into which namespace).  Passing the target task would
> > 	make callers even easier to read, but we pass in user_ns because
> > 	current_user_ns() != task_cred_xxx(current, user_ns).
> > Sep 20: As recommended by Oleg, also put task_pid_vnr() under rcu_read_lock
> > 	in ptrace_signal().
> > Sep 23: In send_signal(), detect when (user) signal is coming from an
> > 	ancestor or unrelated user namespace.  Pass that on to __send_signal,
> > 	which sets si_uid to 0 or overflowuid if needed.
> > Oct 12: Base on Oleg's fixup_uid() patch.  On top of that, handle all
> > 	SI_FROMKERNEL cases at callers, because we can't assume sender is
> > 	current in those cases.
> > Nov 10: (mhelsley) rename fixup_uid to more meaningful usern_fixup_signal_uid
> > Nov 10: (akpm) make the !CONFIG_USER_NS case clearer
> >
> 
> > @@ -1088,6 +1117,9 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
> >  				q->info.si_pid = 0;
> >  			break;
> >  		}
> > +
> > +		userns_fixup_signal_uid(info, t);
> 
> There is a small bug here.  You want to fixup q->info, not info.
> Otherwise you might try dereferencing one of the special signals and get
> a NULL pointer dereference.

Thanks, Eric.  Oddly I've not seen this happen in quite a bit of
testing with the kernel, but you certainly must be right.  I sent
out a new patch to fix that.

thanks,
-serge
