Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab2BOSv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 13:51:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab2BOSv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 13:51:26 -0500
Date: Wed, 15 Feb 2012 19:43:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu,
        Michal Marek <mmarek@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + syscalls-x86-add-__nr_kcmp-syscall-v8.patch added to -mm tree
Message-ID: <20120215184336.GA24182@redhat.com>
References: <20120215143606.GA14037@redhat.com> <20120215151008.GL1894@moon> <20120215153816.GA15988@redhat.com> <20120215161329.GM1894@moon> <20120215162222.GA18266@redhat.com> <20120215175319.GG4533@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120215175319.GG4533@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15, Cyrill Gorcunov wrote:
>
> On Wed, Feb 15, 2012 at 05:22:22PM +0100, Oleg Nesterov wrote:
> >
> > > So I don't understand how it's different from what
> > > is provided in this patch. What I'm missing?
> >
> > environ_read() does
> >
> > 	mm = mm_access(task);
> > 	if (mm)
> > 		do_something(mm);
> >
> > even if it races with, say, execve(setuid_app) we can't read the
> > new ->mm.
>
> Wait, I'm confused
>
> 	process 1 (reader)	process 2 ("task" itself)
> 	mm = mm_access(task);
> 				task changes own credentials
> 				so reader can't access on next
> 				read if it would try, but since
> 				access already granted... it
> 				continues do_something(mm)
> 	if (mm)
> 		do_something(mm);
>
> So in the patch I tried the same, once access is granted it
> belongs to a caller.

See the "execve(setuid_app)", this is what I meant. Even if we
race with execve() and the task raises its privileges we can't
read the new ->mm, we will read the old mm for which we have
(had) the rights to access.

> > while your code (very roughly) does something like
> >
> > 	mm = mm_access(task);
> > 	if (mm)
> > 		do_something(task->mm);
> >
> > while it is quite possible that mm != task->mm.
>
> Oleg, could you please explain me where it happens
> that task->mm (I've got access to) will be changed
> to some new -mm while I'm inspecting it.

Cough... this is question I am trying to ask ;)

Let me try again. To simplify, lets discuss the KCMP_VM case
only.

I do not really understand why do we need ptrace_may_access().
I do not see any security problems with kcmp_ptr(task->mm), but
I am not expert.

However, you added this check so I assume you have some reason.
But this can race with execve(setuid_app) and KCMP_VM can play
with task->mm after this task raises its caps. If this is fine,
then why do we need ptrace_may_access?

OK, please ignore. I sent the initial email just becase KCMP_FILE
is buggy.

> > > +       for (i = 0; i < KCMP_TYPES; i++)
> > > +               cookies[i][1] |= (~(~0UL >>  1) | 1);
> >
> > I am puzzled, help ;) this is equal to
> >
> > 		cookies[i][1] |= -LONG_MAX;
> > or
> > 		cookies[i][1] |= (LONG_MIN | 1);
> >
> > for what? why do we want to set these 2 bits (MSB and LSB) ?
>
> Letme quote hpa@ here :)
>
>  | This code is wrong.  You will have a zero cookie, legitimately, once in
>  | 2^32 or 2^64 attempts, depending on the bitness.
>  |
>  | The other thing is that for the multiplicative cookie you should OR in
>  | the value (~(~0UL >> 1) | 1) in order to make sure that the value is (a)
>  | large and (b) odd.

OK, thanks.

Oleg.

