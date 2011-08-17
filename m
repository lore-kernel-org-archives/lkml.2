Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab1HQQYK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 12:24:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745Ab1HQQYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 12:24:05 -0400
Date: Wed, 17 Aug 2011 18:20:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        lennart@poettering.net, linux-man@vger.kernel.org,
        roland@hack.frob.com, torvalds@linux-foundation.org
Subject: Re: +
	prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision
	.patch added to -mm tree
Message-ID: <20110817162041.GA21406@redhat.com>
References: <201108162011.p7GKBcY0023134@imap1.linux-foundation.org> <20110817115543.GA8745@redhat.com> <CAPXgP12rYf2HmmsJAuJw=nrtcjTRR1WzDhLNM47eKhKA1UTfJQ@mail.gmail.com> <20110817134516.GA14136@redhat.com> <CAPXgP101N_GESzpqu=P_H8cLoekMzb2_W2eWyAqATSjm4Gj9CA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP101N_GESzpqu=P_H8cLoekMzb2_W2eWyAqATSjm4Gj9CA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17, Kay Sievers wrote:
>
> On Wed, Aug 17, 2011 at 15:45, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > OK. So, this patch can only help to handle the legacy services?
>
> It helps them with services that need it. It is not recommended to
> double-fork ever with a modern init system, but it's historic default
> and common practice, and we are not going to change that any time
> soon.
>
> > And
> > the service should participate (write pid files for example). And,
>
> This is not meant as a security feature, if that's what your asking.

Not at all.

> It will not prevent services from doing nasty things and escape the
> process that started them. But it's still a feature that today only
> PID 1 and which we need for more processes.
>
> >> > What if wait(WEXITED) succeeds because C in turn does
> >> > fork + exit?
> >>
> >> Nothing is really doing this.
> >
> > OK. But this means you propose this patch to solve the very specific
> > problems.
>
> No, it's for a very common problem. But again, it's not a security feature.

Once again, I didn't meant security.

> > IOW, imho this doesn't look very useful "in general" to me.
>
> It is very useful if you have an init-like daemon.

Well, this is subjective, but personally I don't agree.

> > May be we need something else instead... And iiuc you don't really
> > need to change the reparenting, you only want the notification if
> > the process exits.
>
> No, we want to be the parent of the process,
> ...
> The sub-init is the babysitter of all the things it has
> started, and that should be reflected in the parent child relation.

OK. But could you explain why do we want this? This is not clear from
the changelog/discussion.

> > You should check ->child_reaper only. But see above, it can be multithreaded.
>
> The main PID 1 from the system has no ->child_reaper set as far as I
> see, hence we check for init_task.

No, you don't. Once again, if pid_ns->child_reaper exits, you should
not even try to find the sub-reaper in its parents chain.

see also below...

> >> > Also. You shouldn't do this if the sub-namespace init exits, this is
> >> > wrong.
> >>
> >> It we find a sub-init, before the namespace PID1, why wouldn't we return it?
> >
> > Ah, I meant pid_ns->child_reaper, not task->child_reaper.
> >
> > If pid_ns->child_reaper exits we should never try to "reparent" its
> > children, see zap_pid_ns_processes() in particular. IOW, this should
> > go into the "else" branch of "if (pid_ns->child_reaper == father)"
>
> I don't understand this. If we find a marked task->child_reaper
> _before_ we find a pid_ns->child_reaper in the chain of parents,

This is fine.

OK. I guess I wasn't clear, and I do not know how to explaine better.
Please look at your code ;) Suppose that a sub-namespace init exits.
Not the global /sbin/init. Not the caller of prctl(REAPER).

In this case we should kill the children, not reparent them. Or panic
if it is the global init (see above).

See?

Oleg.

