Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab2FFPVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:21:55 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51235 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756603Ab2FFPVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:21:54 -0400
Date: Wed, 6 Jun 2012 11:21:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove
In-Reply-To: <20120606134214.GC19601@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.44L0.1206061110360.1788-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2012, Paul E. McKenney wrote:

> No sane compiler would change it to a byte-at-a-time store, but the
> compiler would nevertheless be within its rights to do so.  And a quick
> review of certain LKML threads could easily cause anyone to question gcc's
> sanity.  Furthermore, the compiler is permitted to make transformations
> like the following, which it might well do to save a branch:
> 
> 	if (b)				a = 0;
> 		a = 1;			if (b)
> 	else					a = 1;
> 		a = 0;

The compiler would be forbidden if the original code were

	if (b)
		ACCESS_ONCE(a) = 1;
	else
		ACCESS_ONCE(a) = 0;

But if I remember correctly, the code snippet we were talking was more 
like:

	if (ACCESS_ONCE(b))
		a = 1;

Isn't this use of ACCESS_ONCE unnecessary?

> In short, without ACCESS_ONCE(), the compiler is within its rights to
> assume that the code is single-threaded.  There are a large number of
> non-obvious optimizations that are safe in single-threaded code but
> destructive in multithreaded code.

Followed to its logical conclusion, this means that virtually every
access to a shared variable that isn't protected by some sort of lock
or isn't one of the special atomic operations needs to use
ACCESS_ONCE.  The kernel must be riddled with places that don't do 
this.

Besides, how sure are you that even in the presence of ACCESS_ONCE, the
compiler will not make any unsafe transformations?  For example, is the
compiler forbidden from transforming

	if (a)
		ACCESS_ONCE(b) = 5;

into

	tmp = c;
	c = 999;
	if (a)
		ACCESS_ONCE(b) = 5;
	c = tmp;

?  After all, the c variable isn't protected by ACCESS_ONCE in the 
original code.  And yet this transformation is clearly _unsafe_ for 
multi-threaded operation.

> In addition, and perhaps more important, ACCESS_ONCE() serves as useful
> documentation of the fact that the variable is accessed outside of locks.

True.

Alan Stern



