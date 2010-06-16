Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966Ab0FPPD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 11:03:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53117 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755114Ab0FPPD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 11:03:26 -0400
Date: Wed, 16 Jun 2010 17:03:22 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Brian Bloniarz <bmb@athenacr.com>
Cc: Chris Wedgwood <cw@f00f.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Jef Driesen <jefdriesen@telenet.be>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: Slow pty's (was Re: libdivecomputer interfaces?)
In-Reply-To: <4C116652.8010408@athenacr.com>
Message-ID: <alpine.LRH.2.00.1006161702470.2497@twin.jikos.cz>
References: <AANLkTinLth4iKXAwszEEsPm_9ZDlj8HtqsiG5cdFE1cZ@mail.gmail.com> <20100610181042.GA19210@puku.stupidest.org> <4C116652.8010408@athenacr.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jun 2010, Brian Bloniarz wrote:

> On 06/10/2010 02:10 PM, Chris Wedgwood wrote:
> > (sorry if this reponse isn't on target, i was just pointed to this
> > thread a few minutes ago)
> > 
> > 
> > On Thu, Jun 10, 2010 at 10:25:36AM -0700, Linus Torvalds wrote:
> > 
> >>  I thought we long since (ie back last fall) fixed the latency
> >> problems with pty's, but there does seem to be something very fishy
> >> going on there still.
> > 
> > this might not be related, but i have slow serial ports with NOHZ that
> > goes away when i revert 39c0cbe2150cbd848a25ba6cdb271d1ad46818ad.
> 
> Unrelated or not, I think Chris is right about this. Somewhere before
> -rc1, the emulated serial console on my KVM instance became slow
> to echo input. I just tested with the commit reverted and it's
> back to normal.

So let's CC Mike then.

> 
> > commit 39c0cbe2150cbd848a25ba6cdb271d1ad46818ad
> > Author: Mike Galbraith <efault@gmx.de>
> > Date:   Thu Mar 11 17:17:13 2010 +0100
> > 
> >     sched: Rate-limit nohz
> > 
> >     Entering nohz code on every micro-idle is costing ~10% throughput for netperf
> >     TCP_RR when scheduling cross-cpu.  Rate limiting entry fixes this, but raises
> >     ticks a bit.  On my Q6600, an idle box goes from ~85 interrupts/sec to 128.
> > 
> >     The higher the context switch rate, the more nohz entry costs.  With this patch
> >     and some cycle recovery patches in my tree, max cross cpu context switch rate is
> >     improved by ~16%, a large portion of which of which is this ratelimiting.
> > 
> > and looking at the only two interesting hunks it's not clear why:
> > 
> > +int nohz_ratelimit(int cpu)
> > +{
> > +       struct rq *rq = cpu_rq(cpu);
> > +       u64 diff = rq->clock - rq->nohz_stamp;
> > +
> > +       rq->nohz_stamp = rq->clock;
> > +
> > +       return diff < (NSEC_PER_SEC / HZ) >> 1;
> > +}
> > 
> > +       if (nohz_ratelimit(cpu))
> > +               goto end;
> > +
> > 
> > network latnecy is fine, and if i create lots of wakeups (network IO
> > is fine) then the serial port latency is noticable

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

