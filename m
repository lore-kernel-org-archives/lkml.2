Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab2JCDA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 23:00:57 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:53583 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab2JCDAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 23:00:54 -0400
Date: Tue, 2 Oct 2012 20:00:20 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: Zach Brown <zab@zabbo.net>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tytso@google.com,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        michael.mesnier@intel.com, jeffrey.d.skirvin@intel.com,
        Martin Petersen <martin.petersen@oracle.com>
Subject: Re: [RFC, PATCH] Extensible AIO interface
Message-ID: <20121003030020.GB19788@moria.home.lan>
References: <20121001222341.GF26488@google.com>
 <20121001231222.GB14533@lenny.home.zabbo.net>
 <20121001232235.GH26488@google.com>
 <20121001234439.GC14533@lenny.home.zabbo.net>
 <20121002002216.GI26488@google.com>
 <20121002174323.GE14533@lenny.home.zabbo.net>
 <20121002214113.GV26488@google.com>
 <20121003014106.GC15806@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121003014106.GC15806@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 10:41:06AM +0900, Tejun Heo wrote:
> Hello, Kent.
> 
> On Tue, Oct 02, 2012 at 02:41:13PM -0700, Kent Overstreet wrote:
> > Seems to me it'd be no different from security considerations when
> > introducing new ioctls. I.e., messy, ad hoc, easy to get wrong, but
> > sometimes no way around it.
> > 
> > It really has to be ad hoc if it's extensible, unfortunately.
> > 
> > The only way of getting around _that_ would be with some kind of
> > reflective type system, so that generic code could parse (in some
> > fashion) the types of the various attributes, and for pointers copy the
> > user data into the kernel and do whatever access controls in generic
> > code.
> 
> I'm not userland API expert by any stretch of imagination but the
> basic mechanism to pass data around seems sane to me and aio as stinky
> as it is seems to be the only logical stuff for IOs w/ extra
> attributes although alignment is always painful with any form of
> concatenated opaque structures.
> 
> However, I don't think it's a good idea to try to implement something
> which is a neutral transport of opaque data between userland and lower
> layers.  Things like that sound attractive with unlimited
> possibilities but reality seems to have the tendancy to make a big
> mess out of setups like that.

I don't see how the "neutral transport of opaque data" itself is a bad
thing. We want something simple and sane to build actual interfaces on
top of - once we've got that, we can either build clean generic well
defined interfaces or we can make a mess like with ioctls :P

It's like any other mechanism. There's good syscalls and bad syscalls...

> So, if we're gonna do this, let's define what attributes we want to
> have and let them be processed at the interface layer and fed to lower
> layers afterwards - e.g. for cgroup context association, associate the
> resulting bios with the target cgroup from the aio layer.

That sounds perfectly reasonable to me (the emails with Zach ended up
heading in that direction).

> I'm quite skeptical of general usefulness of having opaque knobs to
> lower IO stack which don't have proper generic abstraction.  Nobody
> can make proper use of things like that.  Well, not nobody, maybe if
> the lower stack, the interface and the application are implemented by
> a single organization over relatively short span of time, maybe it
> would be useful for them, but that isn't something which generic
> interface design should focus on.

I think it could work fine, but I'm not convinced either way on what the
correct approach is.

Say we implement an attr to control a block layer cache. That attr could
be parsed/validated in high level code (if there's any to do) - that I
don't object to. But the high level code isn't going to /know/ whether
there was any block cache in the stack that handled the attr. If the
attr is passed down to the block cache, that block cache can return that
it was handled.

Or if we implement an attr that says "return whether it was a cache hit
or miss, and maybe other statistics". Similar thing.

We could conceivably confine attrs to the upper layer, and define in
kernel interfaces for passing all this stuff around, but I'm doubtful
it's worth the trouble - at least if attrs themselves are implemented
sanely. And honestly I think it'd make (more of) a mess of the block
layer and the rest of the io stack to have to explicitly pass around
cache hints/cache controlling options/whatever else we think of in the
future - especially when most of this stuff isn't going to be in use
most of the time.

But, like I sort of mentioned in another email with Zach - passing the
attrs from userspace around is _not_ mutually exclusive with standard
code for parsing/validating them that exists in one place. We shouldn't
have driver code reaching in and grabbing the raw attr unless there _is_
no parsing/validation to do.


> It's okay to allow some side channel thing for specific hacky uses but
> I really hope the general design were focused around properly
> abstracted attributes which can be understood and handled by the upper
> layer.

Completely agreed. I want to leave that side channel open for
experimentation, and so we have a way of implementing one off hacky
stuff when we need to - but normal mainline stuff should be sane and
well designed.
