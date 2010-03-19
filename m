Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab0CSI3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 04:29:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:37391 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab0CSI3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 04:29:30 -0400
Subject: Re: [Patch] fix MTD CFI/LPDDR flash driver huge latency bug
From: David Woodhouse <dwmw2@infradead.org>
To: Jamie Lokier <jamie@shareable.org>
Cc: Stefani Seibold <stefani@seibold.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Kreuzer, Michael (NSN - DE/Ulm)" <michael.kreuzer@nsn.com>,
       linux-mtd@lists.infradead.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100315142421.GB15133@shareable.org>
References: <1267894137.18869.0.camel@wall-e>
	 <20100312142344.174bd46f.akpm@linux-foundation.org>
	 <20100312233820.GH6491@shareable.org> <1268483744.6339.25.camel@wall-e>
	 <20100315030338.GR6491@shareable.org>
	 <1268633754.6012.4.camel@wall-e.seibold.net>
	 <20100315142421.GB15133@shareable.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Mar 2010 08:29:15 +0000
Message-ID: <1268987355.4028.33.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-15 at 14:24 +0000, Jamie Lokier wrote:
> > > > The problem is the memcpy operation which is very slow. A cond_resched
> > > > wouldn't help, since the cpu bus is blocked during the transfer of the
> > > > word.
> > > 
> > > I mean split the memcpy into multiple smaller memcpys, so that the
> > > total time in each memcpy is limited to something reasonable.
> > > 
> > > The check in cond_resched() is fast, especially once cached.  memcpy
> > > speed depends a lot on the attached flash and how everything's
> > > configured, varying from 2.5MB/s up to hundreds of MB/s.  So how about
> > > doing cond_resched() every 256 bytes?
> > > 
> > > -- Jamie
> > 
> > I thoght about this aporoach and i don't like this idea. Why not using a
> > preemptible kernel?
> 
> Because it introduces too many risks to enable CONFIG_PREEMPT in a
> stable rolled out device which isn't using it already.  Especially on
> devices where it's not well tested by other people, and with drivers
> that nobody ever used with CONFIG_PREEMPT before.
> 
> And because CONFIG_PREEMPT isn't always better.  (Why do you think
> it's a config option?)
> 
> As a bug fix for observed high scheduling latency when a flash I/O is
> occurring, splitting the memcpys is a good choice.  I will be trying
> it on my kernels, even if it doesn't get mainlined.  Thanks for the idea ;-)

Rather than pulling a number our of our posterior like "every 256 bytes"
which might _really_ screw up performance of some architectures' memcpy
routines, I suspect we might want the platform to provide an optimised
"sleepable_memcpy" function which does it at whatever interval is
appropriate for the memcpy routine in use. Or magically makes it
preemptable. Or uses a DMA engine. Or whatever.

I wonder where else we could use such a function...

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

