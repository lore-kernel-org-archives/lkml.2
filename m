Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761Ab2IYUYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 16:24:43 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53236 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab2IYUYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 16:24:38 -0400
Message-ID: <1348604673.12068.30.camel@maxim-laptop>
Subject: Re: [PATCH 2/2] memstick: add support for legacy memorysticks
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Dubov <oakad@yahoo.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 25 Sep 2012 22:24:33 +0200
In-Reply-To: <20120925193826.GJ16296@google.com>
References: <1348562326-10462-1-git-send-email-maximlevitsky@gmail.com>
	 <1348562326-10462-3-git-send-email-maximlevitsky@gmail.com>
	 <20120925182500.GD16296@google.com>
	 <1348601173.12068.11.camel@maxim-laptop>
	 <20120925193826.GJ16296@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-25 at 12:38 -0700, Tejun Heo wrote: 
> Hello, Maxim.
> 
> On Tue, Sep 25, 2012 at 09:26:13PM +0200, Maxim Levitsky wrote:
> > > Probably not the best idea to use a name this generic in driver code.
> > > linux/scatterlist.h likely might wanna use the name.
> >
> > Lets not go this route again. I already once submitted these, and had
> > a share of problems with merging these poor functions into the scatter
> > list.
> > scatter list users mostly dont need these as they just translate it into
> > hardware specific representation.
> > In my case, I don't and yet its easier that working with BIOs. 
> 
> Hmmm... then please at least add a prefix to the names.
Will do! 
> 
> > > Also, from what it does, it seems sg_copy() is a bit of misnomer.
> > > Rename it to sg_remap_with_offset() or something and move it to
> > > lib/scatterlist.c?
> >
> > Don't think so. This copies part of a scatter list into another
> > scatterlist.
> > I have to use is as memstick underlying drivers expect a single
> > scatterlist for each 512 bytes sector I read. Yes, it contains just one
> > entry, but still. I haven't designed the interface. 
> 
> It doesn't really matter if it's a function only used in the driver,
> but please don't use sg_copy() as its name.
Sure! 
> 
> > > Maybe we can make sg_copy_buffer() more generic so that it takes a
> > > callback and implement this on top of it?  Having sglist manipulation
> > > scattered isn't too attractive.
> >
> > Again this is very specific to my driver. Usually nobody pokes the
> > scatterlists. 
> 
> The problem is that there are talks of improving sglist handling (make
> it more generic, unify it with bvec and so on) and this sort of one
> off direct manipulations often become headaches afterwards, so if at
> all possible it's best to keep stuff centralized.
If the sglist gets improved, I will be glad to update my driver to use
the new generic code.

Compared to my xD driver, which just works directly with pointers to 512
byte buffers (with the price of not utilizing highmem), the sglist (and
bios are even worse, I recall), gave me lot of headaches :-(

> 
> > > Is it really necessary to implement explicit state machine?  Can't you
> > > just throw a work item at it and process it synchronously?  Explicit
> > > state machines can save some resources at the cost of a lot more
> > > complexity and generally making things a lot more fragile.  Is it
> > > really worth it here?
> >
> > It would be awesome to not use these ugly state machines, but I have to,
> > because this is required by underlying driver interface.
> > Its callback driven, that is underlying driver calls into this driver,
> > when it wants, and I supply it new command to execute.
> > Unfortunately with legacy memsticks, to read or write a sector, one
> > needs to send it many different commands. Thats why these state
> > machines. I at least made them more or less consistent.
> > Just take a look at mspro_blk.c....
> 
> I see.  Eeeek...

I tried once to improve it, dunno if I did or made it even worse, its a
long story.... Anyway it wasn't liked my its author.

Anyway, my goal now is to get this driver merged, as its the last piece
of the puzzle to make my card reader perfect. If can now read/write
everything, and its the only such reader supported by Linux.

To be honest the Jmicron reader I have doesn't have a driver for xD
part, and I need to stop beeing lazy and write a driver, I do have even
docs for it.

Thanks for review, I will address these comments soon,

Best regards,
        Maxim Levitsky




