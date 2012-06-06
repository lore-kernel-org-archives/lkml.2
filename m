Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab2FFP1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:27:35 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:57605 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008Ab2FFP1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:27:33 -0400
Date: Wed, 6 Jun 2012 08:14:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove
Message-ID: <20120606151448.GJ19601@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CACVXFVPjQmvmXnYNm4sSjJXq83qe-Xg8=YjRppSNMpUQYLokjQ@mail.gmail.com>
 <Pine.LNX.4.44L0.1206061022020.1788-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1206061022020.1788-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060615-2398-0000-0000-000007415C71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 10:44:05AM -0400, Alan Stern wrote:
> On Wed, 6 Jun 2012, Ming Lei wrote:

[ . . . ]

> > There are some similar examples(check on global variable is moved) with
> > ACCESS_ONCE usage in Documentation/atomic_ops.txt. (from line 88)
> 
> Most of those examples involve repeatedly reading a global variable.  
> In your case there is no repetition, and you are writing rather than 
> reading.
> 
> Furthermore, I think some of those examples go a little too far.  
> Here's an extract from the file:
> 
> -------------------------------------------------------------------
> For a final example, consider the following code, assuming that the
> variable a is set at boot time before the second CPU is brought online
> and never changed later, so that memory barriers are not needed:
> 
> 	if (a)
> 		b = 9;
> 	else
> 		b = 42;
> 
> The compiler is within its rights to manufacture an additional store
> by transforming the above code into the following:
> 
> 	b = 42;
> 	if (a)
> 		b = 9;
> 
> This could come as a fatal surprise to other code running concurrently
> that expected b to never have the value 42 if a was zero.  To prevent
> the compiler from doing this, write something like:
> 
> 	if (a)
> 		ACCESS_ONCE(b) = 9;
> 	else
> 		ACCESS_ONCE(b) = 42;
> -------------------------------------------------------------------
> 
> That just seems wrong.  By the same reasoning, the compiler is within 
> its rights to transform either the original code or the code using 
> ACCESS_ONCE into:
> 
> 	b = 999;
> 	if (a)
> 		b = 9;
> 	else
> 		b = 42;
> 
> and again, other code would be confused.  The simple fact is that 
> SMP-safe code is not likely to be produced by a compiler that assumes 
> everything is single-threaded.

If you use ACCESS_ONCE(), the compiler is prohibited from inserting
the "b = 999".  If you don't use ACCESS_ONCE(), the compiler really
is permitted to insert the "b = 999".  So, why would the compiler do
such a thing?  One possible reason would be from optimizations using
large registers to hold multiple values.  A store from such a register
could clobber unrelated variables, but as long as the compiler fixes
up the clobbering after the fact, it is within its rights to do so.

The sad fact is that the C standard really does permit the compiler
to assume that it is generating sequential code.

							Thanx, Paul

