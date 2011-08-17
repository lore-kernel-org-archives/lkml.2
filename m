Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab1HQTAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 15:00:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919Ab1HQTAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 15:00:43 -0400
Date: Wed, 17 Aug 2011 20:57:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        lennart@poettering.net, linux-man@vger.kernel.org,
        roland@hack.frob.com, torvalds@linux-foundation.org
Subject: Re: +
	prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision
	.patch added to -mm tree
Message-ID: <20110817185709.GA27663@redhat.com>
References: <201108162011.p7GKBcY0023134@imap1.linux-foundation.org> <20110817115543.GA8745@redhat.com> <CAPXgP12rYf2HmmsJAuJw=nrtcjTRR1WzDhLNM47eKhKA1UTfJQ@mail.gmail.com> <20110817134516.GA14136@redhat.com> <CAPXgP101N_GESzpqu=P_H8cLoekMzb2_W2eWyAqATSjm4Gj9CA@mail.gmail.com> <20110817162041.GA21406@redhat.com> <CAPXgP13Dn2c-OnYg-Cty5r4JbqeH_zYPtXDj5GAfK1btoKYmDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP13Dn2c-OnYg-Cty5r4JbqeH_zYPtXDj5GAfK1btoKYmDg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17, Kay Sievers wrote:
>
> On Wed, Aug 17, 2011 at 18:20, Oleg Nesterov <oleg@redhat.com> wrote:
> > On 08/17, Kay Sievers wrote:
>
> >> No, we want to be the parent of the process,
> >> ...
> >> The sub-init is the babysitter of all the things it has
> >> started, and that should be reflected in the parent child relation.
> >
> > OK. But could you explain why do we want this? This is not clear from
> > the changelog/discussion.
>
> As said, PID1 has the privilege of reaping all processes that
> double-fork. Any sub-init wants to do the same for the stuff it
> watches. The process that reaps has all the information about the
> process as long as wants, it can look up stuff in /proc if needed or
> has all the return values of wait().

OK.

> Async notifications like
> taskstats just can not provide what SIGCHLD, /proc and wait() offer.

Why not? Async notifications can't delay the reaping, yes. But I am
not sure /proc/ is that useful when the task exits. OK, I won't argue.




> >> > You should check ->child_reaper only. But see above, it can be multithreaded.
> >>
> >> The main PID 1 from the system has no ->child_reaper set as far as I
> >> see, hence we check for init_task.
> >
> > No, you don't.
>
> Don't? I don't check, or we don't have it set?

Argh, sorry. "No, this is not needed", this is what I tried to say.

> > Once again, if pid_ns->child_reaper exits, you should
> > not even try to find the sub-reaper in its parents chain.
>
> That would mean we can never run a sub-init in a pid namespace? Why not?
>
> Or do you mean that we *are* already the pid_ns->child_reaper, not
> that one *exists*?

I already got lost a bit, not sure I understand.
I meant we *are* (the caller) the exiting pid_ns->child_reaper thread.

> >> >> > Also. You shouldn't do this if the sub-namespace init exits, this is
> >> >> > wrong.
> >> >>
> >> >> It we find a sub-init, before the namespace PID1, why wouldn't we return it?
> >> >
> >> > Ah, I meant pid_ns->child_reaper, not task->child_reaper.
> >> >
> >> > If pid_ns->child_reaper exits we should never try to "reparent" its
> >> > children, see zap_pid_ns_processes() in particular. IOW, this should
> >> > go into the "else" branch of "if (pid_ns->child_reaper == father)"
> >>
> >> I don't understand this. If we find a marked task->child_reaper
> >> _before_ we find a pid_ns->child_reaper in the chain of parents,
> >
> > This is fine.
> >
> > OK. I guess I wasn't clear, and I do not know how to explaine better.
> > Please look at your code ;) Suppose that a sub-namespace init exits.
> > Not the global /sbin/init. Not the caller of prctl(REAPER).
> >
> > In this case we should kill the children, not reparent them. Or panic
> > if it is the global init (see above).
> >
> > See?
>
> Not sure. You mean that the lookup for a possible task->cild_reaper
> should be _before_ the check for pid_ns->child_reaper == father which
> is currently below?

Hmm. I am even more confused.

So. I actually applied your patch. The code is

	for (reaper = father->parent;
	     reaper != &init_task && reaper != pid_ns->child_reaper;
	     reaper = reaper->parent)
		if (reaper->child_reaper)
			return reaper;

	if (unlikely(pid_ns->child_reaper == father)) {
		...

The lookup is already _before_ the check for pid_ns->child_reaper == father,
what do you mean?

And, ignoring the mt problems I mentioned, I mean we should do

	if (pid_ns->child_reaper == father) {

		panic_or_kill_this_namespace;	// the current code

	} else {
		for (reaper = father->parent;
		     reaper != pid_ns->child_reaper;
		     reaper = reaper->parent)
			if (reaper->child_reaper)
				return reaper;
	}

Oleg.

