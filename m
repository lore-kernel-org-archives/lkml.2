Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936500Ab0COOYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 10:24:53 -0400
Received: from mail2.shareable.org ([80.68.89.115]:46473 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935728Ab0COOYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 10:24:51 -0400
Date: Mon, 15 Mar 2010 14:24:21 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       "Kreuzer, Michael (NSN - DE/Ulm)" <michael.kreuzer@nsn.com>,
       linux-mtd@lists.infradead.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] fix MTD CFI/LPDDR flash driver huge latency bug
Message-ID: <20100315142421.GB15133@shareable.org>
References: <1267894137.18869.0.camel@wall-e> <20100312142344.174bd46f.akpm@linux-foundation.org> <20100312233820.GH6491@shareable.org> <1268483744.6339.25.camel@wall-e> <20100315030338.GR6491@shareable.org> <1268633754.6012.4.camel@wall-e.seibold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268633754.6012.4.camel@wall-e.seibold.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefani Seibold wrote:
> Am Montag, den 15.03.2010, 03:03 +0000 schrieb Jamie Lokier:
> > Stefani Seibold wrote:
> > > Am Freitag, den 12.03.2010, 23:38 +0000 schrieb Jamie Lokier:
> > > > Andrew Morton wrote:
> > > > > On Sat, 06 Mar 2010 17:48:57 +0100
> > > > > Stefani Seibold <stefani@seibold.net> wrote:
> > > > > 
> > > 
> > > 
> > > > > > The patch change all the use of spin_lock operations for xxxx->mutex
> > > > > > into mutex operations, which is exact what the name says and means.
> > > > 
> > > > It would be even better if it also split the critical sections into
> > > > smaller ones with cond_resched() between, so that non-preemptible
> > > > kernels benefit too.
> > > 
> > > The problem is the memcpy operation which is very slow. A cond_resched
> > > wouldn't help, since the cpu bus is blocked during the transfer of the
> > > word.
> > 
> > I mean split the memcpy into multiple smaller memcpys, so that the
> > total time in each memcpy is limited to something reasonable.
> > 
> > The check in cond_resched() is fast, especially once cached.  memcpy
> > speed depends a lot on the attached flash and how everything's
> > configured, varying from 2.5MB/s up to hundreds of MB/s.  So how about
> > doing cond_resched() every 256 bytes?
> > 
> > -- Jamie
> 
> I thoght about this aporoach and i don't like this idea. Why not using a
> preemptible kernel?

Because it introduces too many risks to enable CONFIG_PREEMPT in a
stable rolled out device which isn't using it already.  Especially on
devices where it's not well tested by other people, and with drivers
that nobody ever used with CONFIG_PREEMPT before.

And because CONFIG_PREEMPT isn't always better.  (Why do you think
it's a config option?)

As a bug fix for observed high scheduling latency when a flash I/O is
occurring, splitting the memcpys is a good choice.  I will be trying
it on my kernels, even if it doesn't get mainlined.  Thanks for the idea ;-)

-- Jamie

