Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab0JKHUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 03:20:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:58377 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab0JKHUt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 03:20:49 -0400
Subject: Re: [PATCH] sched: SCHED_RESET_ON_FORK to recalculate load weights
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Lennart Poettering <lennart@poettering.net>, stable@kernel.org
In-Reply-To: <AANLkTi=JfJknPNMiMXnK=kZj+ECJTE423AfjuiE67afu@mail.gmail.com>
References: <1286612169-27529-1-git-send-email-linus.walleij@stericsson.com>
	 <1286639626.1891.0.camel@laptop>
	 <AANLkTi=JfJknPNMiMXnK=kZj+ECJTE423AfjuiE67afu@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 11 Oct 2010 09:20:41 +0200
Message-ID: <1286781641.2336.63.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-11 at 01:05 +0200, Linus Walleij wrote:
> 2010/10/9 Peter Zijlstra <peterz@infradead.org>:
> 
> > On Sat, 2010-10-09 at 10:16 +0200, Linus Walleij wrote:
> >>
> >> So we always need to call set_load_weight(), not just if the
> >> niceval was changed, because the scheduler gives
> >> SCHED_RR/SCHED_FIFO processes very high weights.
> >
> > SCHED_RR/FIFO never uses that weight, we should remove all that cruft..
> 
> Hm I wonder if that is an ACK or "please throughly rewrite the
> scheduler" request ;-)

Nah, its an SCHED_FIFO/RR shouldn't care about p->se.load at all
statement, any patch that mentions that relation cannot be right ;-)

> Anyway I also saw you have started to get rid of RT weights it in
> commit e51fd5e2, so in set_load_weight():
> 
>        if (task_has_rt_policy(p)) {
>                 p->se.load.weight = prio_to_weight[0] * 2;
>                 p->se.load.inv_weight = prio_to_wmult[0] >> 1;
>                 return;
>         }
> 
> is now replaced by this:
> 
>         if (task_has_rt_policy(p)) {
>                 p->se.load.weight = 0;
>                 p->se.load.inv_weight = WMULT_CONST;
>                 return;
>         }

Right, that was to catch anybody relying on RR/FIFO tasks having a
sensible weight, I think we can now simply remove that whole clause.

> I backported that commit onto 2.6.34 (bah, just patch -p1)
> and tested. The problem persists, but mutates:

/me fails to see the relevance to .34 (or for that matter remember
what .34 looked like).

> Whereas before this commit the problem was that processes came
> back with enormous weights after forking of an RT process flagged
> with SCHED_RESET_ON_FORK, the problem is now the reverse:
> the process comes back with load weight zero making the forked
> process totally numb (when it has enormous weights it would atlest
> respond), so this patch is still needed to bring the weight back in
> balance AFAICT.

OK, so the problem is that if a RR/FIFO task does s fork() and it has
SCHED_RESET_ON_FORK set, the child normalization fails to properly set
the weight?

Does (as Mike just suggested) removing that whole RT clause in
set_load_weight() work for you?
