Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab1HQNsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 09:48:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230Ab1HQNsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 09:48:45 -0400
Date: Wed, 17 Aug 2011 15:45:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        lennart@poettering.net, linux-man@vger.kernel.org,
        roland@hack.frob.com, torvalds@linux-foundation.org
Subject: Re: +
	prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision
	.patch added to -mm tree
Message-ID: <20110817134516.GA14136@redhat.com>
References: <201108162011.p7GKBcY0023134@imap1.linux-foundation.org> <20110817115543.GA8745@redhat.com> <CAPXgP12rYf2HmmsJAuJw=nrtcjTRR1WzDhLNM47eKhKA1UTfJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPXgP12rYf2HmmsJAuJw=nrtcjTRR1WzDhLNM47eKhKA1UTfJQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17, Kay Sievers wrote:
>
> On Wed, Aug 17, 2011 at 13:55, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > I try to never argue with the new features. But to be honest, this
> > doesn't look very good to me.
> >
> > OK, a service manager M does prctl(PR_SET_CHILD_REAPER), then it forks
> > a service X which forks another child C and exits. Then C exits and
> > notifies M.
> >
> > But. How can M know that the service X should be restarted? It only
> > knows the pid.
>
> Legacy services write pid files and we read them, so we know the pid
> to watch for. Proper services never double-fork and reparent in a
> modern init environment.

OK. So, this patch can only help to handle the legacy services? And
the service should participate (write pid files for example). And,

>
> > What if wait(WEXITED) succeeds because C in turn does
> > fork + exit?
>
> Nothing is really doing this.

OK. But this means you propose this patch to solve the very specific
problems. IOW, imho this doesn't look very useful "in general" to me.

May be we need something else instead... And iiuc you don't really
need to change the reparenting, you only want the notification if
the process exits.



> >> @@ -1296,6 +1296,8 @@ struct task_struct {
> >>                                * execve */
> >>       unsigned in_iowait:1;
> >>
> >> +     /* Reparent child processes to this process instead of pid 1. */
> >> +     unsigned child_reaper:1;
> >
> > First of all - this is already very wrong imho. This should be
> > per-process, not per-thread.
>
> What do you mean? That would go where instead?

You should mark the whole process as sub-reaper, not a single thread
which does prctl(). The parent/child relationship is process-wide.

If nothing else. Suppose that application does pthread_create(), the
new thread does prctl(REAPER) and exits.

> >> +     /* find the first ancestor which is marked as child_reaper */
> >> +     for (reaper = father->parent;
> >> +          reaper != &init_task && reaper != pid_ns->child_reaper;
> >> +          reaper = reaper->parent)
> >
> > This loop can never reach init_task/child_reaper and crash the kernel.
>
> You mean: *if* this loop can never ...?

Yes.

> > For example, father->parent can point to init_task's sub-thread.
> >
> > OTOH you shouldn't use init_task at all.
>
> What would we use instead?

You should check ->child_reaper only. But see above, it can be multithreaded.

> > Also. You shouldn't do this if the sub-namespace init exits, this is
> > wrong.
>
> It we find a sub-init, before the namespace PID1, why wouldn't we return it?

Ah, I meant pid_ns->child_reaper, not task->child_reaper.

If pid_ns->child_reaper exits we should never try to "reparent" its
children, see zap_pid_ns_processes() in particular. IOW, this should
go into the "else" branch of "if (pid_ns->child_reaper == father)"

Oleg.

