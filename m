Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab2JDScV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:32:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:40265 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab2JDScT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:32:19 -0400
Message-ID: <1349375519.14388.16.camel@twins>
Subject: Re: Seems like "sched: Add missing call to calc_load_exit_idle()"
 should be reverted in 3.5 branch
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Huacai Chen <chenhc@lemote.com>, Charles Wang <muming.wq@taobao.com>,
        Ingo Molnar <mingo@kernel.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 04 Oct 2012 20:31:59 +0200
In-Reply-To: <20121004174626.GB14301@kroah.com>
References: <CAAhV-H54CJdg+UekpucZ=kOgCY5r5vvYQ+v4VwAMTCv+mCedXA@mail.gmail.com>
	 <20121004174626.GB14301@kroah.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-04 at 10:46 -0700, Greg Kroah-Hartman wrote:
> On Thu, Oct 04, 2012 at 12:11:01PM +0800, Huacai Chen wrote:
> > Hi, Greg
> > 
> > I found that Linux-3.5.5 accept this commit "sched: Add missing call
> > to calc_load_exit_idle()" but I think this isn't needed. Because
> > "5167e8d5417b sched/nohz: Rewrite and fix load-avg computation --
> > again not fully applied" is true for 3.6 branch, but not for 3.5
> > branch.
> 
> But 5167e8d5417b is in 3.5, so shouldn't this commit still be necessary?
> 
> > In 3.5 branch, calc_load_exit_idle() is already called in
> > tick_nohz_idle_exit(), it doesn't need to be called at
> > tick_nohz_update_jiffies() again. In 3.6 branch, some code of
> > tick_nohz_idle_exit() is splitted to tick_nohz_restart_sched_tick()
> > and calc_load_exit_idle() is missing by accident, so commit "sched:
> > Add missing call to calc_load_exit_idle()" is needed.
> 
> So this really should be dropped from 3.5?  Charles, Peter, Ingo, any
> thoughts here?

Bah, lots of code movement there recently.. let me try and untangle all
that afresh.. /me checks out v3.5.5.

OK, assuming ->tick_stopped means what the label says, then we only want
to call calc_load_enter_idle() when it flips to 1 and
calc_load_exit_idle() when it flips back to 0, such that when an actual
tick happens its got correct state.

Now the actual patch "5167e8d5417b sched/nohz: Rewrite and fix load-avg
computation -- again not fully applied" modifies
tick_nohz_restart_sched_tick() which doesn't appear to exist in v3.5.5
and the patch fobbed it into tick_nohz_update_jiffies() which is called
from interrupt entry when nohz-idle so that the interrupt (and possible
tailing softirq) see a valid jiffies count.

However, since we don't restart the tick, we won't be sampling load muck
and calling calc_load_exit_idle() from there is bound to confuse state.

I hope.. damn this code ;-)

I can't find wtf went wrong either, the initial patch 5167e8d5417bf5c
contains both hunks, but in that case the fixup 749c8814f0 doesn't make
sense, not can I find anything in merge commits using:

  git log -S calc_load_exit_idle kernel/time/tick-sched.c

/me puzzled
