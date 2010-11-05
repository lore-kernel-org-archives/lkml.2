Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab0KEDv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:51:26 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53674 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab0KEDvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:51:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=d3jqvxeNOKz9L9xmxrBDFT9njdFbsc0x+pOusws8hQmCFx/Aeej1AU1BhddvolOLup
         q7G7Vo4/RT+w9/exh6l+SW3ORbR/b5tJKqRvq0EbXyehIIvrQw6kFq2UmYGrxJQqKB/1
         Fyvst+8GNIhLDZhemNaCkGL6F+PbIqPr7QPd8=
Date: Fri, 5 Nov 2010 04:51:17 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@intel.com>
Subject: Re: [RFD] Perf generic context based exclusion/inclusion (was Re:
	[PATCH 0/4] Finer granularity and task/cgroup irq time accounting)
Message-ID: <20101105035114.GA6698@nowhere>
References: <AANLkTikCYjENib2zfz-rmAM2fZbZEzK-9jgL4D-b40xs@mail.gmail.com> <AANLkTikukr3d+GmWDdPB9jfwAAuMUgNwb06WXPZgRFwc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikukr3d+GmWDdPB9jfwAAuMUgNwb06WXPZgRFwc@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 12:46:42PM -0700, Venkatesh Pallipadi wrote:
> On Thu, Nov 4, 2010 at 8:40 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > (Answering thousand years later)
> >
> > Concerning the softirq/hardirq filtering in perf, this is still
> > something I want to do,
> > but now I think we should do it differently, especially we should
> > extend the idea of exclusion to the generic level.
> >
> > A "context" is a generic idea: this is something that starts and ends
> > at specific events. It means this can be expressed with
> > perf events, for example:
> >
> > - a context of "lock X held" starts when X is acquired and stops when
> > X is released
> > - a context of "irq" starts when we enter irq and ends when we exits irq.
> >
> 
> I think this is will be a useful abstraction to have, mostly beyond
> just irq/softirq. Couple of comments:
> - For locks, we may want to track both "wait context" and "hold context"



Sure. In which case you want to play with both lock_acquire and lock_acquired
events.                                                                     ^

lock_acquire is the "I request this lock" event.
lock_acquired is the "I have grabed this lock" event.

Well, there might be some time between the two events due to various
things, mainly lockdep checks I guess because those events are very
tight to lockdep internals (or lockstats). If you want to
know if there has been some waiting for the lock, you need lock_contended
event.

So, you can play some games here with those events.


> - This may be a bit odd and probably there is some other way of doing
> this better. But, one other context we may want to track is the sleep
> or wait at certain points. What I am thinking is something like how
> long are we waiting on this kmalloc when we are holding this mutex
> kind of info. May be it is best to do this as having sleep in kmalloc
> as a context.



If I understand you well, you want to define a context made of a
sleeping time?

The problem is that it means defining an empty context:
nothing happens in task X while it is sleeping (by definition), so
capturing any events, or counting whatever counter in this slice
would never report anything.

OTOH you can capture trace events and get the time between a
sleep and a wake up event, then you can compute the difference
from a post processing script in perf tools.



> - Few other examples of this being useful is to count events only when
> these two or more locks are held together or how long we were waiting
> on one spinlock while we are holding one spinlock.


Agreed. For that you can combine two levels of contexts, let's say you want
to count instructions when we hold lock Y when we also hold lock X
(the lock dependency order beeing X -> Y), but you don't want to count
when you hold Y without X:

- create two perf events: lock_acquire and lock_release, apply filter on lock name X
- create two perf events: lock_acquire and lock_release, apply filter on lock name Y
- apply the first pair of lock events as an inclusive context for the second pair
  (which means the second pair must only count/sample on the context delimited by the
  first pair)
- create a perf event that count instructions, apply the second above pair as an
  inclusive context.


