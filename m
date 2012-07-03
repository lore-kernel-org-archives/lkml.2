Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933523Ab2GCXGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 19:06:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50349 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933064Ab2GCXGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 19:06:20 -0400
Date: Wed, 4 Jul 2012 01:06:08 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Calvin Walton <calvin.walton@kepstin.ca>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, shemminger@vyatta.com
Subject: Re: long boot delays caused by 070ad7e7 floppy change
In-Reply-To: <CA+55aFzn+dW+Aj5T_vVP3XG3n3P+7mqJwGQLsWY14yEwduku5Q@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1207040102120.17304@pobox.suse.cz>
References: <20120702224648.GA20361@tassilo.jf.intel.com> <CA+55aFwre6s=orjUaNKJA=51Fc1mxu_XGX80Bex4Sn-=mWPx5Q@mail.gmail.com> <1341323230.3292.10.camel@nayuki.kepstin.ca> <CA+55aFyvzz3Lp9zeA6X+QMan0iZFWq_0Xd+ff_trnP1tpn2iJQ@mail.gmail.com>
 <1341337257.2406.1.camel@nayuki.kepstin.ca> <CA+55aFzOD33eWj0FQuZ7RWmF-yYwaeNB-9J-YY+mX4mwP7VXuA@mail.gmail.com> <CA+55aFwQqTAHNafGBXaoPCzVYw83OZvbG_hOYEDUxmuoMODO3Q@mail.gmail.com> <alpine.LNX.2.00.1207032008350.17304@pobox.suse.cz>
 <20120703185808.GM11413@one.firstfloor.org> <CA+55aFzFQiYhJcBfGD7moL3gC-ocwXJ2-kTjuNrw5hBGGbz4ag@mail.gmail.com> <1341344200.2413.4.camel@nayuki.kepstin.ca> <CA+55aFzn+dW+Aj5T_vVP3XG3n3P+7mqJwGQLsWY14yEwduku5Q@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2012, Linus Torvalds wrote:

> >> What happens if you add a
> >>
> >>         cancel_delayed_work(&fd_timeout);
> >>
> >> to before the queue_delayed_work() in __reschedule_timeout()? Does
> >> that possibly make the delay really be 3 seconds?
> >
> > Yes, it does...
> 
> Ok. And I see the previous timeout - it's this:
> 
>         reschedule_timeout(MAXTIMEOUT, "floppy init");
> 
> that sets the fd_timeout to 20 seconds initially.

Still doesn't explain why reverting 070ad7e793dc6 (which made the whole 
thing completely serialized) doesn't fix it though; that's quite a mystery 
to me.

> That whole fd_timeout code is broken, though. I'm not sure what the 
> floppy init timeout is supposed to do, when the floppy reset code wants 
> to re-use it.
> 
> And yes, the 3-second timeout is still too long.
> 
> Doing it asynchronously like Andi does helps a bit, but I suspect we
> could make the reset timeout shorter still just to make the initial
> "you don't have a floppy drive" code go faster.
> 
> That said, why even compile in the floppy driver any more? Even if you
> have the hardware, it probably doesn't work after ten years of
> gathering dust. Those floppy drives weren't exactly reliable even back
> in the days..
> 
> Anyway, I looked up the 82078 docs for reset. Holding the reset low
> *does* cause an interrupt, but I'm not finding how long the reset
> might take. But for the controller it really should be milliseconds,
> not seconds, I suspect. Can anybody find the appropriate reset
> timeout?

I will look into it once I am back again from vacation next week. In the 
meantime, I'd propose to simply add the cancel_delayed_work() for 3.5; 
it's an obvious bug I made during the timer -> workqueue conversion, as we 
used to do del_timer() before.

-- 
Jiri Kosina
SUSE Labs
