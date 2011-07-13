Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964857Ab1GMRmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 13:42:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964797Ab1GMRms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 13:42:48 -0400
Date: Wed, 13 Jul 2011 19:40:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: drm_lock()->block_all_signals() is broken
Message-ID: <20110713174024.GA12471@redhat.com>
References: <20110712181536.GA30364@redhat.com> <CAPM=9tywf2_Y8maO4Tc8Z4nMfk8oJPoFic7+wMLxekjgcs=grw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPM=9tywf2_Y8maO4Tc8Z4nMfk8oJPoFic7+wMLxekjgcs=grw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12, Dave Airlie wrote:
>
> On Tue, Jul 12, 2011 at 7:15 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > Hello.
> >
> > I tried many times to ask about the supposed behaviour of
> > block_all_signals() in drm, but it seems nobody can answer.
>
> Its not hard to explain, basically there exists hardware that you
> program acceleration engines using MMIO, having multiple processes
> writing to the MMIO area at once is a bad idea, so we use the DRM lock
> which is like a pre-futex futex.

I guess LOCK_TEST_WITH_RETURN() does the check... This looks per-file,
not per process/thread but I guess this doesn't matter in practice.
And in any case, of course I do not understand this code.

> Now the problem is if you stop or
> kill a process in a critical section where it is writing to the
> hardware directly with MMIO you could crash the hardware, so the idea
> is that you block to the max until the critical section exits via the
> drm unlock.

OK, thanks.

But who can send SIGTSOP to the drm_lock() holder? I mean, can this
be a problem in practice?

As for SIGTSTP/SIGTTIN/SIGTTOU, the application can block them itself.

> I
> pretty much reckon we can deprecate block_all_signals as I forsee
> fixing all the problem you pointed out with it would be worse than
> just removing it.

Yes, I think we should kill it. May be we should implement something
else instead, I dunno.

> > So I am going to send the patch which simply removes
> > block_all_signals() and friends. There are numeruous problems
> > with this interace, I can't even enumerate them. But I think
> > that it is enough to mention that block_all_signals() simply
> > can not work. AT ALL. I am wondering, was it ever tested and
> > how.
>
> I wasn't around, but it did work back in linux-2.4.0-test7 when it was
> introduced,
>
> http://www.kernel.org/pub/linux/kernel/v2.4/old-test-kernels/patch-2.4.0-test7.gz
>
> is the initial patch. You should probably check that out and see if
> you can work out how it originally worked, and the work out
> if its really is broken now or if you haven't analysed it correctly.

Oh, 10 years ago ;) Of course I can't be sure if it ever worked or
not. Probably it mostly worked, although I _feel_ it was always buggy.
But it doesn't now, and I am pretty sure it was broken many years ago.

And no, I do not think we can fix it. It is not that the current
implementation is buggy (although it is buggy), this interface is
simply wrong, imho.

For example. block_all_signals(SIGINT) can not "block" SIGINT, it
can be transofmed into SIGKILL. Of course, I am not saying it is
not possible to do something which really works, but imho we should
not do this.

Currently it is only used by drm, and drm doesn't need the "generic"
interface anyway. If we decide that the kernel should help somehow
to the process holding drm_lock (I hope it shouldn't ;), then we
should implement something sane.

> > Just in case... Please look at the debugging patch below. With
> > this patch,
> >
> >        $ perl -le 'syscall 157,666 and die $!; sleep 1, print while ++$_'
> >        1
> >        2
> >        3
> >        ^Z
> >
> > Hang. So it does react to ^Z anyway, just it is looping in the
> > endless loop in the kernel. It can only look as if ^Z is ignored,
> > because obviously bash doesn't see it stopped.
>
> taking the drm lock usually means you will drop it without doing
> anything stupid like sleeping for a long time,

Yes, I understand. I added "sleep" to lessen the output. The point
is, it "stops" anyway even if block_all_signals() was called. It can't
return to the user-mode and release the lock.

> if the process dies,
> the lock gets dropped automatically also.

Just curious... do you mean drm_release() does this? Again, this is
per file. A thread can exit without drm_unlock(). OK, at least this
works if the process is killed and nobody else keeps this file opened.

> I've only second hand knowledge of how this works though, and I'm on
> holidays for another week or so, maybe once I get back I'll find some
> time to figure out how it works vs what happens, but really I suspect
> we can kill this with fire.

OK, thanks Dave. This is not urgent. I do not want to send the patch
which touches the code I do not understand and can't test. I'll wait
for your return.


To summarize: block_all_signals() do not work. Afaics, the _only_
effect it has is that we set _DRM_LOCK_CONT. If this is not that
important we can simply kill block_all_signals(), then we can think
if we need do something else.

Oleg.

