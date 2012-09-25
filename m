Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab2IYTic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 15:38:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52615 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab2IYTia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 15:38:30 -0400
Date: Tue, 25 Sep 2012 12:38:26 -0700
From: Tejun Heo <tj@kernel.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Dubov <oakad@yahoo.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] memstick: add support for legacy memorysticks
Message-ID: <20120925193826.GJ16296@google.com>
References: <1348562326-10462-1-git-send-email-maximlevitsky@gmail.com>
 <1348562326-10462-3-git-send-email-maximlevitsky@gmail.com>
 <20120925182500.GD16296@google.com>
 <1348601173.12068.11.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348601173.12068.11.camel@maxim-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Maxim.

On Tue, Sep 25, 2012 at 09:26:13PM +0200, Maxim Levitsky wrote:
> > Probably not the best idea to use a name this generic in driver code.
> > linux/scatterlist.h likely might wanna use the name.
>
> Lets not go this route again. I already once submitted these, and had
> a share of problems with merging these poor functions into the scatter
> list.
> scatter list users mostly dont need these as they just translate it into
> hardware specific representation.
> In my case, I don't and yet its easier that working with BIOs. 

Hmmm... then please at least add a prefix to the names.

> > Also, from what it does, it seems sg_copy() is a bit of misnomer.
> > Rename it to sg_remap_with_offset() or something and move it to
> > lib/scatterlist.c?
>
> Don't think so. This copies part of a scatter list into another
> scatterlist.
> I have to use is as memstick underlying drivers expect a single
> scatterlist for each 512 bytes sector I read. Yes, it contains just one
> entry, but still. I haven't designed the interface. 

It doesn't really matter if it's a function only used in the driver,
but please don't use sg_copy() as its name.

> > Maybe we can make sg_copy_buffer() more generic so that it takes a
> > callback and implement this on top of it?  Having sglist manipulation
> > scattered isn't too attractive.
>
> Again this is very specific to my driver. Usually nobody pokes the
> scatterlists. 

The problem is that there are talks of improving sglist handling (make
it more generic, unify it with bvec and so on) and this sort of one
off direct manipulations often become headaches afterwards, so if at
all possible it's best to keep stuff centralized.

> > Is it really necessary to implement explicit state machine?  Can't you
> > just throw a work item at it and process it synchronously?  Explicit
> > state machines can save some resources at the cost of a lot more
> > complexity and generally making things a lot more fragile.  Is it
> > really worth it here?
>
> It would be awesome to not use these ugly state machines, but I have to,
> because this is required by underlying driver interface.
> Its callback driven, that is underlying driver calls into this driver,
> when it wants, and I supply it new command to execute.
> Unfortunately with legacy memsticks, to read or write a sector, one
> needs to send it many different commands. Thats why these state
> machines. I at least made them more or less consistent.
> Just take a look at mspro_blk.c....

I see.  Eeeek...

Thanks.

-- 
tejun
