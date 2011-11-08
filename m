Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab1KHBo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 20:44:28 -0500
Received: from netrider.rowland.org ([192.131.102.5]:44916 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752823Ab1KHBo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 20:44:26 -0500
Date: Mon, 7 Nov 2011 20:44:25 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
cc: Tim Vlaar <Tvlaar@ptgrey.com>, Greg KH <greg@kroah.com>,
        Markus Rechberger <mrechberger@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-aio@vger.kernel.org>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
In-Reply-To: <20111107230731.GB13764@xanatos>
Message-ID: <Pine.LNX.4.44L0.1111072032001.26304-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Nov 2011, Sarah Sharp wrote:

> > > Yeah, the choice is not obvious and we're probably going to get it
> > > wrong, but as Tim said, he does need ~600MB in flight at once, so I knew
> > > 16MB was too small.  I guess the question really should be not "What is
> > > the smallest limit we need?" but "When will the system start breaking
> > > down due to memory pressure?" and set the limit somewhere pretty close
> > > to there.
> > 
> > It might not be so easy to identify that value.  I wouldn't know how to
> > do it.
> 
> I wouldn't know how to test it either, and I suspect it would be
> system-specific.  Are you at least OK with setting the limit to 600MB so
> that Tim's userspace driver will work by default?  I think we still need
> the modparam for the usb core to set the limit as well.

I don't know; 600 MB sounds kind of high for some systems.  It's
entirely possible to run Linux on a machine with < 1 GB of RAM.  I'd
feel a lot safer making the default value small, like 16 MB, and asking
Tim's clients to increase it.

> > Again, I don't know.  Those subsystems are a lot more complicated than
> > usbfs, and they probably have arrangements to allocate intermediate
> > buffers a piece at a time.  We could do something like that, but the
> > end result would be the same as our current limit on URB sizes -- the
> > only difference being that transfers would be split into multiple URBs
> > by the usbfs driver instead of by the user program.
> 
> Or splitting the transfer into multiple scatter-gather list entries,
> right?

Not really, because the problem is to avoid loading all the buffers
into kernel space at the same time.  That means using multiple URBs --
although each URB could use SG to handle more than 16 KB at once.

>  There's no need to submit multiple URBs if you can just use
> sglists instead.  If the host can't handle sglists, the core can just
> split it up into multiple URBs.  I'd like to push the biggest data
> chucks we can as far down in the stack as possible to avoid performance
> hits from completing many URBs.  But that's a separate issue...

Right.  For example, usbfs could support an iov sort of interface.  
That would translate naturally into an SG list.

> > In fact, it's not all that easy for a program to generate many I/O 
> > requests concurrently.  The old async I/O mechanism is one way, and you 
> > spent a lot of time working on it.  Do you remember if it had any 
> > limits?
> 
> I haven't looked at that in about four years, so if it did I don't
> remember it.  Maybe someone from the aio list knows?

One point that hasn't been emphasized very strongly (although it was
mentioned once) is that our _current_ kernel allows programs to submit
many USB transfers and thus eat up all available kernel memory.  That
definitely could be considered a bug.

Alan Stern

