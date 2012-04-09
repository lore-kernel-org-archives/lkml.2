Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515Ab2DIWV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 18:21:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45266 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab2DIWVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 18:21:25 -0400
Date: Mon, 9 Apr 2012 15:21:20 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Colin Cross <ccross@google.com>
Cc: David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Christian Bejram <christian.bejram@stericsson.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>, stable@vger.kernel.org
Subject: Re: v3.4-rc2 out-of-memory problems (was Re: 3.4-rc1
 sticks-and-crashs)
Message-ID: <20120409222120.GA14149@kroah.com>
References: <CA+55aFwTFXtMLhXo7g9F7uyHc3W8SCw7z1gTm9jbWXM3Nqc_ZA@mail.gmail.com>
 <20120408195044.13ea6c8e.akpm@linux-foundation.org>
 <CA+55aFw7GsiZbNW84WVMUMT6C0Sw82jxaYxeaaB8qq=41Ep5Wg@mail.gmail.com>
 <alpine.DEB.2.00.1204090235350.14879@chino.kir.corp.google.com>
 <CA+55aFxUQJC+_aA0qnj0b-LoGfCjfFoG3HXgQ+7LND7y8dFDhw@mail.gmail.com>
 <alpine.DEB.2.00.1204091355280.10873@chino.kir.corp.google.com>
 <CAMbhsRRUNVn9_eL_obZxcZv7LqDW_8SeRApdKzDePbaW_Y4uvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMbhsRRUNVn9_eL_obZxcZv7LqDW_8SeRApdKzDePbaW_Y4uvg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2012 at 03:13:00PM -0700, Colin Cross wrote:
> On Mon, Apr 9, 2012 at 2:22 PM, David Rientjes <rientjes@google.com> wrote:
> > On Mon, 9 Apr 2012, Linus Torvalds wrote:
> >
> >> The real bug is actually that those notifiers are a f*cking joke, and
> >> the return value from the notifier is a mistake.
> >>
> >> So I personally think that the real problem is this code in
> >> profile_handoff_task:
> >>
> >>         return (ret == NOTIFY_OK) ? 1 : 0;
> >>
> >> and ask yourself two questions:
> >>
> >>  - what the hell does NOTIFY_OK/NOTIFY_DONE mean?
> >>  - what happens if there are multiple notifiers that all (or some)
> >> return NOTIFY_OK?
> >>
> > NOTIFY_OK should never be a valid response for this notifier the way it's
> > currently implemented, it should be NOTIFY_STOP to stop iterating the call
> > chain to avoid a double free.  Right now it doesn't matter because only
> > oprofile is actually freeing the task_struct and lowmemorykiller should be
> > using NOTIFY_DONE.
> >
> > Then we have a completeness issue if multiple callbacks want to return
> > NOTIFY_STOP and an ordering issue if the oprofile callback is invoked
> > before lowmemorykiller.
> >
> >> I'll tell you what my answers are:
> >>
> >>  (a) NOTIFY_DONE is the "ok, everything is fine, you can free the
> >> task-struct". It's also what that handoff notifier thing returns if
> >> there are no notifiers registered at all.
> >>
> >>      So the fix to the Android lowmemorykiller is as simple as just
> >> changing NOTIFY_OK to NOTIFY_DONE, which will mean that the caller
> >> will properly free the task struct.
> >>
> >
> > I don't think so for Werner's config who also has CONFIG_OPROFILE=y, so
> > oprofile would return NOTIFY_OK and queue the task_struct for free, then
> > the second notifier callback to the lowmemorykiller would return
> > NOTIFY_DONE which would result in put_task_struct() doing free_task()
> > itself for a double free.
> >
> >>      The NOTIFY_OK/NOTIFY_DONE difference really does seem to be just
> >> "NOTIFY_OK means that I will free the task myself later". That's what
> >> the oprofile uses, and it frees the task.
> >>
> >>  (b) But the whole interface is a total f*cking mess. If *multiple*
> >> people return NOTIFY_OK, they're royally fucked. And the whole (and
> >> only) point of notifiers is that you can register multiple different
> >> ones independently.
> >>
> >> So quite frankly, the *real* bug is not in that android driver
> >> (although I'd say that we should just make it return NOTIFY_DONE and
> >> be done with it). The real bug is that the whole f*cking notifier is a
> >> mistake, and checking the error return was the biggest mistake of all.
> >>
> >
> > Right, we can't handoff the freeing of the task_struct to more than one
> > notifier.  It seems misdesigned from the beginning and what we really want
> > is to hijack task->usage for __put_task_struct(task) if we have such a
> > notifier callchain and require each one (currently just oprofile) to take
> > a reference on task->usage for NOTIFY_OK and then be responsible for
> > dropping the reference when it's done with it later instead of requiring
> > it to free the task_struct itself.
> >
> > That's _if_ we want to continue to have such an interface in the first
> > place where it's only really necessary right now for oprofile (and, hence,
> > wasn't implemented in an extendable way).  I'm thinking the
> > lowmemorykiller, as I eluded to, could be written in a way where we can
> > detect if a thread we've already killed has exited yet before killing
> > another one.  We can't just store a pointer to the task_struct of the
> > killed task since it could be reused for a fork later, but we could use
> > TIF_MEMDIE like the oom killer does.
> 
> This was a known issue in 2010, in the android tree the use of
> task_handoff_register was dropped one day after it was added and
> replaced with a new task_free_register hook.  I assume Greg dropped
> the fix during the android tree refresh in 3.0 because it depended on
> a change to kernel/fork.c.  The two relevant patches are (using
> codeaurora's gitweb becase we don't have one right now):
> 
> sched: Add a generic notifier when a task struct is about to be freed
> https://www.codeaurora.org/gitweb/quic/la/?p=kernel/common.git;a=commitdiff;h=667dffa787a87ef4ea43cc65957ce96077fdcd0a

Yes, I can't add a patch like that for this driver, that is why I
thought everyone was getting together to "properly" determine how to
solve this oom notifier problem.  Has that work stalled somwhere?

greg k-h
