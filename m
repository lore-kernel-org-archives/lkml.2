Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804Ab0FPPQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 11:16:58 -0400
Received: from mail.gmx.net ([213.165.64.20]:40349 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754954Ab0FPPQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 11:16:57 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/uR449MuHu8/8Xze2BR2Qlfg4l0Ogc9T2duw8x/B
	Y6mVn7XnZSxabG
Subject: Re: Slow pty's (was Re: libdivecomputer interfaces?)
From: Mike Galbraith <efault@gmx.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Brian Bloniarz <bmb@athenacr.com>, Chris Wedgwood <cw@f00f.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Jef Driesen <jefdriesen@telenet.be>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LRH.2.00.1006161702470.2497@twin.jikos.cz>
References: <AANLkTinLth4iKXAwszEEsPm_9ZDlj8HtqsiG5cdFE1cZ@mail.gmail.com>
	 <20100610181042.GA19210@puku.stupidest.org> <4C116652.8010408@athenacr.com>
	 <alpine.LRH.2.00.1006161702470.2497@twin.jikos.cz>
Content-Type: text/plain
Date: Wed, 16 Jun 2010 17:16:51 +0200
Message-Id: <1276701411.30669.6.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 17:03 +0200, Jiri Kosina wrote:
> On Thu, 10 Jun 2010, Brian Bloniarz wrote:
> 
> > On 06/10/2010 02:10 PM, Chris Wedgwood wrote:
> > > (sorry if this reponse isn't on target, i was just pointed to this
> > > thread a few minutes ago)
> > > 
> > > 
> > > On Thu, Jun 10, 2010 at 10:25:36AM -0700, Linus Torvalds wrote:
> > > 
> > >>  I thought we long since (ie back last fall) fixed the latency
> > >> problems with pty's, but there does seem to be something very fishy
> > >> going on there still.
> > > 
> > > this might not be related, but i have slow serial ports with NOHZ that
> > > goes away when i revert 39c0cbe2150cbd848a25ba6cdb271d1ad46818ad.
> > 
> > Unrelated or not, I think Chris is right about this. Somewhere before
> > -rc1, the emulated serial console on my KVM instance became slow
> > to echo input. I just tested with the commit reverted and it's
> > back to normal.
> 
> So let's CC Mike then.

Chris already gave me a heads up, it's on my todo.  The old P4 box I use
for a serial console box is exploding on boot, or I would have already
had a look.
  
> > > and looking at the only two interesting hunks it's not clear why:

Complete mystery to me.

> > > +int nohz_ratelimit(int cpu)
> > > +{
> > > +       struct rq *rq = cpu_rq(cpu);
> > > +       u64 diff = rq->clock - rq->nohz_stamp;
> > > +
> > > +       rq->nohz_stamp = rq->clock;
> > > +
> > > +       return diff < (NSEC_PER_SEC / HZ) >> 1;
> > > +}
> > > 
> > > +       if (nohz_ratelimit(cpu))
> > > +               goto end;
> > > +
> > > 
> > > network latnecy is fine, and if i create lots of wakeups (network IO
> > > is fine) then the serial port latency is noticable

