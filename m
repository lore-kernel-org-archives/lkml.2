Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab0KOAPa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 19:15:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755158Ab0KOAP3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 19:15:29 -0500
MIME-Version: 1.0
In-Reply-To: <1289778189.5154.10.camel@maggy.simson.net>
References: <1289489200.11397.21.camel@maggy.simson.net> <20101111202703.GA16282@redhat.com>
 <1289514000.21413.204.camel@maggy.simson.net> <20101112181240.GB8659@redhat.com>
 <1289648524.22764.149.camel@maggy.simson.net> <1289755150.3228.44.camel@maggy.simson.net>
 <20101114174921.GA1569@arch.trippelsdorf.de> <1289758238.17491.12.camel@maggy.simson.net>
 <AANLkTimy5DdF8qwGuk09iT3wHfXMjkiwRKxo-LuvEJzW@mail.gmail.com>
 <AANLkTikjSCbcRnKOU=nd4os1sdW-GJkD6QVj=U5zPyu8@mail.gmail.com>
 <20101114202734.GA1627@arch.trippelsdorf.de> <AANLkTimHtjH3YvtX6i542_XjfFeuvG-AnU8i224a1R4j@mail.gmail.com>
 <1289778189.5154.10.camel@maggy.simson.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 14 Nov 2010 16:15:05 -0800
Message-ID: <AANLkTimwSktAQ5PkXNGY2EQz71DFmKY3Bt2fbZYasD0G@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
To: Mike Galbraith <efault@gmx.de>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 14, 2010 at 3:43 PM, Mike Galbraith <efault@gmx.de> wrote:
>
> Not only. pinned tasks would stay in their autogroup until somebody
> moved them to a cgroup.  Them wandering back over time would be fine,
> and all but pinned tasks will.

But why is a problem?

That's kind of my point. Why do we care about some special case that
(a) likely doesn't happen and (b) even if it happens, what's the
problem with it happening?

Let me put it this way: the autogroup thing modifies the scheduler in
some subtle ways, but it doesn't make any _semantic_ difference. And
it's not like enabling/disabling autogroup scheduling is something
critical to begin with. It's a heuristic.

THAT is why I think it's so silly to try to be so strict and walk over
all processes while holding a couple of spinlocks.

Ok, so you disable autogroups after having used them, _and_ having
done some really specific things, and some processes that used to be
in a group may end up still scheduling in that group. Why care? It's
not like random people can enable/disable autogroup scheduling and try
to use this as a way to get unfair scheduling.

In fact, I'd go as far as saying that for the tty-based autogroup
scheduling, if you want the autogroup policy to take effect, it would
be perfectly ok if it really only affected the actual group
_allocation_. So when you turn it on, old tty associations that
existed before autogroup being turned on would not actually be in
their own groups at all. And when you turn it off, existing tty groups
would continue to exist, and you'd actually have to open a new window
to get processes to no longer be part of any autogroup behavior.

See what I'm saying? I still think you're bending over backwards to be
"careful" in ways that don't seem to make much sense to me.

Now, if there is some really fundamental reason why processes _have_
to be disassociated with the group when the autogroup policy changes,
that would be a different issue. If the scheduler oopses when it hits
a process that was in a tty autogroup but autogrouping has been turned
off, _that_ would be a reason to say "recalculate everything when you
disable/enable policy groups". But I don't think that's the case.

                  Linus
