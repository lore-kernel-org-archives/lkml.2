Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab0EJH5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 03:57:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:59907 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362Ab0EJH5E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 03:57:04 -0400
Subject: Re: [PATCH/RFC] mutex: Fix optimistic spinning vs. BKL
From: Peter Zijlstra <peterz@infradead.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tony Breeds <tonyb@au1.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1273271262.4861.134.camel@pasglop>
References: <1272429513.24542.83.camel@pasglop>
	 <201004281406.04080.arnd@arndb.de> <1272494121.24542.113.camel@pasglop>
	 <20100507042010.GR12389@ozlabs.org> <20100507053023.GF8069@nowhere>
	 <1273212116.4861.61.camel@pasglop>  <20100507212909.GD5401@nowhere>
	 <1273271262.4861.134.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 10 May 2010 09:55:59 +0200
Message-ID: <1273478159.5605.3324.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-08 at 08:27 +1000, Benjamin Herrenschmidt wrote:
> > Also, to solve this problem when several cpus may spin on the owner,
> > I wonder adaptive spinning is doing the right thing here. We should
> > have only one spinner I think, and the rest should go to sleep as the
> > time to spin on several subsequent owners would be much better gained
> > to do something else (schedule something else or power saving).
> > In fact, that too could deserve some tests.
> 
> Right, the problem is due to the fact that we skip spinning if there's
> already a waiter but we don't know that there is already a spinner so we
> can end up with multiple spinners.
> 
> I don't see a non invasive way to fix that.. we could add a spinner
> counter to the mutex but that sucks a bit. Might still be worthwhile,
> not sure. Peter, what do you reckon ? 

If its a large problem the lock is overly contended and _that_ needs
fixing. I don't at all feel like adding atomic ops to the spin loop to
try and detect this.

As to the 2 jiffy spin timeout, I guess we should add a lockdep warning
for that, because anybody holding a mutex for longer than 2 jiffies and
not sleeping does need fixing anyway.

