Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309Ab0FVVeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 17:34:04 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:32817 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822Ab0FVVeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 17:34:01 -0400
Date: Tue, 22 Jun 2010 23:33:01 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Larry Woodman <lwoodman@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [Patch] Call cond_resched() at bottom of main look in balance_pgdat()
Message-ID: <20100622213301.GA26285@cmpxchg.org>
References: <20100622112416.B554.A69D9226@jp.fujitsu.com> <AANLkTilN3EcYq400ajA2-rf3Xs4MhD-sKCg44fjzKlX1@mail.gmail.com> <20100622114739.B563.A69D9226@jp.fujitsu.com> <AANLkTimleJIOdYquPwJvgGK3Dj_JDijoNjCQh4dfXxAY@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimleJIOdYquPwJvgGK3Dj_JDijoNjCQh4dfXxAY@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 01:29:17PM +0900, Minchan Kim wrote:
> On Tue, Jun 22, 2010 at 12:23 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> >> >> Kosaki's patch's goal is that kswap doesn't yield cpu if the zone doesn't meet its
> >> >> min watermark to avoid failing atomic allocation.
> >> >> But this patch could yield kswapd's time slice at any time.
> >> >> Doesn't the patch break your goal in bb3ab59683?
> >> >
> >> > No. it don't break.
> >> >
> >> > Typically, kswapd periodically call shrink_page_list() and it call
> >> > cond_resched() even if bb3ab59683 case.
> >>
> >> Hmm. If it is, bb3ab59683 is effective really?
> >>
> >> The bb3ab59683's goal is prevent CPU yield in case of free < min_watermark.
> >> But shrink_page_list can yield cpu from kswapd at any time.
> >> So I am not sure what is bb3ab59683's benefit.
> >> Did you have any number about bb3ab59683's effectiveness?
> >> (Of course, I know it's very hard. Just out of curiosity)
> >>
> >> As a matter of fact, when I saw this Larry's patch, I thought it would
> >> be better to revert bb3ab59683. Then congestion_wait could yield CPU
> >> to other process.
> >>
> >> What do you think about?
> >
> > No. The goal is not prevent CPU yield. The goal is avoid unnecessary
> > _long_ sleep (i.e. congestion_wait(BLK_RW_ASYNC, HZ/10)).
> 
> I meant it.
> 
> > Anyway we can't refuse CPU yield on UP. it lead to hangup ;)
> >
> > What do you mean the number? If it mean how much reduce congestion_wait(),
> > it was posted a lot of time. If it mean how much reduce page allocation
> > failure bug report, I think it has been observable reduced since half
> > years ago.
> 
> I meant second.
> Hmm. I doubt it's observable since at that time, Mel had posted many
> patches to reduce page allocation fail. bb3ab59683 was just one of
> them.
> 
> >
> > If you have specific worried concern, can you please share it?
> >
> 
> My concern is that I don't want to add new band-aid on uncertain
> feature to solve
> regression of uncertain feature.(Sorry for calling Larry's patch as band-aid.).
> If we revert bb3ab59683, congestion_wait in balance_pgdat could yield
> cpu from kswapd.
> 
> If you insist on bb3ab59683's effective and have proved it at past, I
> am not against it.
> 
> And If it's regression of bb3ab59683, Doesn't it make sense following as?
> It could restore old behavior.
> 
> ---
>                  * OK, kswapd is getting into trouble.  Take a nap, then take
>                  * another pass across the zones.
>                  */
>                 if (total_scanned && (priority < DEF_PRIORITY - 2)) {
>                         if (has_under_min_watermark_zone) {
>                                 count_vm_event(KSWAPD_SKIP_CONGESTION_WAIT);
>                                 /* allowing CPU yield to go on
> watchdog or OOMed task */
>                                 cond_resched();

We have two things here: one is waiting for some IO to complete, which
we skip if we are in a hurry.  The other thing is that we have a
potentially long-running loop with no garuanteed rescheduling point in
it.  I would rather not mix up those two and let this cond_resched()
for #2 stand on it's own and be self-explanatory.

So,

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

to Larry's patch (or KOSAKI-san's version of it for that matter).
