Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab1ALLRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 06:17:17 -0500
Received: from www.tglx.de ([62.245.132.106]:45031 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754212Ab1ALLRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 06:17:14 -0500
Date: Wed, 12 Jan 2011 12:16:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Cochran <richardcochran@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>
Subject: Re: [PATCH V8 08/13] posix clocks: cleanup the CLOCK_DISPTACH
 macro
In-Reply-To: <20110112073728.GA2935@riccoc20.at.omicron.at>
Message-ID: <alpine.LFD.2.00.1101121201080.12146@localhost6.localdomain6>
References: <cover.1293820862.git.richard.cochran@omicron.at> <503cd1fa268867573001cfc9bb5681ee3b5b32fa.1293820862.git.richard.cochran@omicron.at> <alpine.LFD.2.00.1101111224280.12146@localhost6.localdomain6> <20110112073728.GA2935@riccoc20.at.omicron.at>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jan 2011, Richard Cochran wrote:

> On Tue, Jan 11, 2011 at 01:57:23PM +0100, Thomas Gleixner wrote:
> > I wonder whether we should be a bit more clever here and create an
> > extra entry for posix_cpu_timers in the posix_clocks array and do the
> > following:
> ...
> > That reduces the code significantly and the MAX_CLOCKS check in
> > clock_get_array_id() replaces the invalid_clock() check in the
> > syscalls as well. It does not matter whether we check this before or
> > after copying stuff from user.
> 
> Well, this does reduce the number of LOC, but the number of
> comparisons is the same. I think the code size would be also no
> different.

Right, It's about lines of code and ever repeated if / else constructs
in the dispatch functions. The number of comparisons is probably the
same, but I'm sure that the binary size will be smaller.

We probably can remove the dispatch inlines that way completely and do
the call directly from the syscall function.
 
> > Adding your new stuff requires just another entry in the array, the
> > setup of the function pointers and the CLOCKFD check in
> > clock_get_array_id(). Everything else just falls in place.
> 
> For me, I am not sure if either version is really very pretty or easy
> to understand.

Well, if we document clock_get_array_id() proper, then it's easier to
follow than 10 dispatch functions which have all the same checks and
comparisons inside.
 
> My instinct is to keep the posix_cpu_X and pc_X functions out of the
> array of static clock id functions, if only to make the distinction
> between the legacy static ids and new dynamic ids clear.
> 
> The conclusion from the "dynamic clock as file" discussion was that we
> don't want to add any more static clock ids, and new clocks should use
> the new, dynamic clock API. So, we should discourage any future
> attempt to add to that function array!

These IDs are not public, they are helpers to make the code simpler,
nothing else. I agree, that we don't want to extend the static ids for
public consumption, but implementation wise we can do that confined to
posix-timers.c.

> Having said that, if you insist on it, I won't mind reworking the
> dispatch code as you suggested.

I'm not insisting. I just saw the repeated if/else constructs and
added the clockfd check mentally :) That's where I started to wonder
about a way to do the same thing with way less lines of code.

> > >  clock_nanosleep_restart(struct restart_block *restart_block)
> > >  {
> > > -	clockid_t which_clock = restart_block->arg0;
> > > -
> > 
> > How does that compile ?
> 
> Because the CLOCK_DISPATCH macro, above, makes no use of the first

Missed that, sorry.

> argument! I have removed the macro for the next round.

Cool.

Thanks,

	tglx
