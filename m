Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab1C1SHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 14:07:06 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:53821 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab1C1SHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 14:07:03 -0400
Date: Mon, 28 Mar 2011 11:06:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Will Newton <will.newton@gmail.com>,
        Luke Kenneth Casson Leighton <luke.leighton@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: advice sought: practicality of SMP cache coherency implemented
 in assembler (and a hardware detect line)
Message-ID: <20110328180655.GI2287@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <AANLkTi=de3yDfXxCDp082+e3T+g_1wRWKWjqS0n1vy0+@mail.gmail.com>
 <AANLkTi=W0mW2o2muNgMnb1OQ6WaBeOmu1VBHr8Zf63r9@mail.gmail.com>
 <20110326120847.71b6ae4d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110326120847.71b6ae4d@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 26, 2011 at 12:08:47PM +0000, Alan Cox wrote:
> > Probably not. Is it a virtual or physical indexed cache? Do you have a
> > precise workload in mind? If you have a very precise workload and you
> > don't expect to get many write conflicts then it could be made to
> > work.
> 
> I'm unconvinced. The user space isn't the hard bit - little user memory
> is shared writable, the kernel data structures on the other hand,
> especially in the RCU realm are going to be interesting.

Indeed.  One approach is to flush the caches on each rcu_dereference().
Of course, this assumes that the updaters flush their caches on each
smp_wmb().  You probably also need to make ACCESS_ONCE() flush caches
(which would automatically take care of rcu_dereference()).  So might
work, but won't be fast.

You can of course expect a lot of odd bugs in taking this approach.
The assumption of cache coherence is baked pretty deeply into most
shared-memory parallel software.  As you might have heard in the 2005
discussion.  ;-)

> > There are a number of mature cores out there that can do this already
> > and can be bought off the shelf, I wouldn't underestimate the
> > difficulty of getting your cache coherency protocol right particularly
> > on a limited time/resource budget.
> 
> Architecturally you may want to look at running one kernel per device
> (remembering that you can share the non writable kernel pages between
> different instances a bit if you are careful) - and in theory certain
> remote mappings.
> 
> Basically it would become a cluster with a very very fast "page transfer"
> operation for moving data between nodes.

This works for applications coded specially for this platform, but unless
I am missing something, not for existing pthreads applications.  Might
be able to handle things like Erlang that do parallelism without shared
memory.

							Thanx, Paul
