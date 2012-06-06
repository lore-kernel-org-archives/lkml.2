Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab2FFPsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:48:36 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:58110 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab2FFPsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:48:33 -0400
Date: Wed, 6 Jun 2012 08:48:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove
Message-ID: <20120606154808.GK19601@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120606134214.GC19601@linux.vnet.ibm.com>
 <Pine.LNX.4.44L0.1206061110360.1788-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1206061110360.1788-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060615-1780-0000-0000-000006358884
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000281; HX=3.00000190; KW=3.00000007;
 PH=3.00000001; SC=3.00000002; SDB=6.00145719; UDB=6.00033382; UTC=2012-06-06
 15:48:31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 11:21:52AM -0400, Alan Stern wrote:
> On Wed, 6 Jun 2012, Paul E. McKenney wrote:
> 
> > No sane compiler would change it to a byte-at-a-time store, but the
> > compiler would nevertheless be within its rights to do so.  And a quick
> > review of certain LKML threads could easily cause anyone to question gcc's
> > sanity.  Furthermore, the compiler is permitted to make transformations
> > like the following, which it might well do to save a branch:
> > 
> > 	if (b)				a = 0;
> > 		a = 1;			if (b)
> > 	else					a = 1;
> > 		a = 0;
> 
> The compiler would be forbidden if the original code were
> 
> 	if (b)
> 		ACCESS_ONCE(a) = 1;
> 	else
> 		ACCESS_ONCE(a) = 0;
> 
> But if I remember correctly, the code snippet we were talking was more 
> like:
> 
> 	if (ACCESS_ONCE(b))
> 		a = 1;
> 
> Isn't this use of ACCESS_ONCE unnecessary?

That would depend on what else is nearby.

> > In short, without ACCESS_ONCE(), the compiler is within its rights to
> > assume that the code is single-threaded.  There are a large number of
> > non-obvious optimizations that are safe in single-threaded code but
> > destructive in multithreaded code.
> 
> Followed to its logical conclusion, this means that virtually every
> access to a shared variable that isn't protected by some sort of lock
> or isn't one of the special atomic operations needs to use
> ACCESS_ONCE.  The kernel must be riddled with places that don't do 
> this.

Agreed, we are relying on the compiler being unaggressive about
optimizations, which it usually is.  But it will continue becoming
more aggressive over time, so we should at least apply ACCESS_ONCE()
to new code.

> Besides, how sure are you that even in the presence of ACCESS_ONCE, the
> compiler will not make any unsafe transformations?  For example, is the
> compiler forbidden from transforming
> 
> 	if (a)
> 		ACCESS_ONCE(b) = 5;
> 
> into
> 
> 	tmp = c;
> 	c = 999;
> 	if (a)
> 		ACCESS_ONCE(b) = 5;
> 	c = tmp;
> 
> ?  After all, the c variable isn't protected by ACCESS_ONCE in the 
> original code.  And yet this transformation is clearly _unsafe_ for 
> multi-threaded operation.

There are some limitations because volatile accesses are not allowed to
move past "sequence points", but it would be possible to come up with
similar examples.  This sort of thing is why C1x has a memory model and
why it allows variables to be designated as needing to be SMP-safe.

In the meantime, things like ACCESS_ONCE() are what is available, limited
though they are.

							Thanx, Paul

> > In addition, and perhaps more important, ACCESS_ONCE() serves as useful
> > documentation of the fact that the variable is accessed outside of locks.
> 
> True.
> 
> Alan Stern
> 
> 
> 

