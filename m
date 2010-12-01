Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab0LAA7O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 19:59:14 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:44075 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab0LAA7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 19:59:13 -0500
Date: Tue, 30 Nov 2010 19:59:09 -0500
From: Nelson Elhage <nelhage@ksplice.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm_release: Do a set_fs(USER_DS) before handling
 clear_child_tid.
Message-ID: <20101201005909.GC18995@ksplice.com>
References: <1291083556-5894-1-git-send-email-nelhage@ksplice.com>
 <20101130160950.96153286.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101130160950.96153286.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 04:09:50PM -0800, Andrew Morton wrote:
> On Mon, 29 Nov 2010 21:19:16 -0500
> Nelson Elhage <nelhage@ksplice.com> wrote:
> 
> > If a user manages to trigger a kernel BUG() or page fault with fs set to
> > KERNEL_DS, fs is not otherwise reset before do_exit(), allowing the user to
> > write a 0 to an arbitrary address in kernel memory.
> > 
> > Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
> > ---
> > AFAICT this is presently only triggerable in the presence of another bug, but
> > this potentially turns a lot of DoS bugs into privilege escalation, so it's
> > worth fixing. Among other things, sock_no_sendpage and the kernel_{read,write}v
> > calls in splice.c make it easy to call an awful lot of the kernel under
> > KERNEL_DS.
> > 
> > This isn't the only way we could fix this -- we could put the set_fs() at the
> > start of do_exit, or in all the callers that might call potentially do_exit with
> > KERNEL_DS set, or else we could do an access_ok inside fork(). I'm happy to put
> > together one of those patches if someone thinks another approach makes more
> > sense.
> > 
> >  kernel/fork.c |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index 3b159c5..a68445e 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -636,7 +636,12 @@ void mm_release(struct task_struct *tsk, struct mm_struct *mm)
> >  			/*
> >  			 * We don't check the error code - if userspace has
> >  			 * not set up a proper pointer then tough luck.
> > +			 *
> > +			 * We do set_fs() explicitly in case this task
> > +			 * exited while inside set_fs(KERNEL_DS) for
> > +			 * some reason (e.g. on a BUG()).
> >  			 */
> > +			set_fs(USER_DS);
> >  			put_user(0, tsk->clear_child_tid);
> >  			sys_futex(tsk->clear_child_tid, FUTEX_WAKE,
> >  					1, NULL, NULL, 0);
> 
> Confused.  The user can only exploit the wrong addr_limit if control
> returns to userspace for the user's code to execute.  But that won't be
> happening, because this thread will unconditionally exit.

The user can exploit the wrong addr_limit on the very next line, with the
put_user() there. clear_child_tid is not checked in any way before this
point. Writing a single zero might not seem like much, but it's enough for
privilege escalation (e.g. overwrite the top half of a function pointer to point
to userspace).

I have a PoC code that uses this bug, along with CVE-2010-3849, to write a zero
to an arbitrary kernel address, so I've tested that this is not theoretical.

That's also why I put the set_fs() hidden inside mm_release, since that's the
only place where (to my knowledge) it matters.

On re-reading, I didn't mention clear_child_tid anywhere in the commit message,
which was an error on my part, and explains the confusion. Sorry about that, and
I hope this clears that up.

Let me know if this makes more sense, and I'll send a revised patch.

- Nelson

> 
> 
> If/when you unconfuse me, I'd suggest this change only be done if the
> thread is *known* to have oopsed - doing it for non-oopsed threads
> seems unpleasant to my mind.  And I think it should be done nice and
> clearly, right up inside do_exit() by some means.  Or perhaps in the
> oops code, just before it calls do_exit().  Not hidden down in
> mm_release().
