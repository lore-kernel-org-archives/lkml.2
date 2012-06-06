Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab2FFP56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:57:58 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:43925 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869Ab2FFP54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:57:56 -0400
Date: Wed, 6 Jun 2012 08:55:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove
Message-ID: <20120606155515.GM19601@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120606151448.GJ19601@linux.vnet.ibm.com>
 <Pine.LNX.4.44L0.1206061143170.1788-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1206061143170.1788-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060615-7408-0000-0000-000005A16CA8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 11:44:50AM -0400, Alan Stern wrote:
> On Wed, 6 Jun 2012, Paul E. McKenney wrote:
> 
> > > That just seems wrong.  By the same reasoning, the compiler is within 
> > > its rights to transform either the original code or the code using 
> > > ACCESS_ONCE into:
> > > 
> > > 	b = 999;
> > > 	if (a)
> > > 		b = 9;
> > > 	else
> > > 		b = 42;
> > > 
> > > and again, other code would be confused.  The simple fact is that 
> > > SMP-safe code is not likely to be produced by a compiler that assumes 
> > > everything is single-threaded.
> > 
> > If you use ACCESS_ONCE(), the compiler is prohibited from inserting
> > the "b = 999".
> 
> What prohibits it?

The compiler cannot move a volatile access across a sequence point, for
example, across a statement boundary.

That said, yes, there might be code preceding the "if" that allowed the
spurious store to "b" to be generated.  And the compiler would definitely
be permitted to do something like this:

	tmp = ACCESS_ONCE(a);
	b = 999;
	if (tmp)
		b = 9;
	else
		b = 42;

I am having some difficulty coming up with a reasonable rationale for
this transformation, but it might happen if there was a variable "c"
adjacent to "b" in memory that was accessed after the "if" statement.

> >  If you don't use ACCESS_ONCE(), the compiler really
> > is permitted to insert the "b = 999".  So, why would the compiler do
> > such a thing?  One possible reason would be from optimizations using
> > large registers to hold multiple values.  A store from such a register
> > could clobber unrelated variables, but as long as the compiler fixes
> > up the clobbering after the fact, it is within its rights to do so.
> > 
> > The sad fact is that the C standard really does permit the compiler
> > to assume that it is generating sequential code.
> 
> Compiling the kernel requires quite a few extensions to the C standard.  
> Assumptions about generating sequential code may well be among them.

Yep.  We are making do with gcc extensions for the moment, imperfect though
they are.

							Thanx, Paul

