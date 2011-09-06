Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab1IFSxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 14:53:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951Ab1IFSxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 14:53:12 -0400
Date: Tue, 6 Sep 2011 20:49:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] posix-timers: turn it_signal into it_valid flag
Message-ID: <20110906184926.GA25997@redhat.com>
References: <1314661157-22173-1-git-send-email-andi@firstfloor.org> <1314661157-22173-4-git-send-email-andi@firstfloor.org> <alpine.LFD.2.02.1109021135270.2723@ionos> <20110904165658.GA23948@redhat.com> <20110904202907.GA3404@redhat.com> <20110906031411.GA24024@alboin.amr.corp.intel.com> <20110906145124.GA15390@redhat.com> <1315323596.2899.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <alpine.LFD.2.02.1109061823100.2723@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.02.1109061823100.2723@ionos>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06, Thomas Gleixner wrote:
>
> On Tue, 6 Sep 2011, Eric Dumazet wrote:
>
> > Le mardi 06 septembre 2011 à 16:51 +0200, Oleg Nesterov a écrit :
> > > On 09/05, Andi Kleen wrote:
> > > >
> > > > > I forgot everything I knew about ->it_requeue_pending logic, but it
> > > > > seems to me that do_schedule_next_timer()->lock_timer() can find and
> > > > > lock successfully the wrong timer. Another thread can do timer_delete()
> > > > > and then re-create the timer with the same id.
> > > >
> > > > Do you mean after my patches or even before?
> > >
> > > Ah, sorry for confusion.
> > >
> > > Before. And after. IOW, I think this has nothing to do with your patches.
> > >
> >
> > Hmm, you mean following patch is needed ?
> >
> > Before release of timer id to idr pool, we should make sure
> > do_schedule_next_timer() wont be called, or it could find another timer
> > reusing the just released id.
>
> I don't see how that makes it sure. If the signal is queued, then it
> stays queued and the put_pid() has no effect either.

Yes.

But "If the signal is queued" is simple, in this case we could, say,
do "tmr->sigq->info.si_tid = -1" to ensure lock_timer()->find_idr()
can't succeed after dequeue_signal().

The problem is, it can be already dequeued.

Oleg.

