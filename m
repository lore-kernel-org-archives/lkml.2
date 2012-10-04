Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab2JDTuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 15:50:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50208 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757105Ab2JDTuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 15:50:16 -0400
Date: Thu, 4 Oct 2012 12:50:12 -0700
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
Message-ID: <20121004195012.GA29494@google.com>
References: <20121001222341.GF26488@google.com>
 <20121001231222.GB14533@lenny.home.zabbo.net>
 <20121001232235.GH26488@google.com>
 <20121001234439.GC14533@lenny.home.zabbo.net>
 <20121002002216.GI26488@google.com>
 <20121002174323.GE14533@lenny.home.zabbo.net>
 <20121002214113.GV26488@google.com>
 <20121003014106.GC15806@localhost>
 <20121003030020.GB19788@moria.home.lan>
 <20121003215806.GA19248@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121003215806.GA19248@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 06:58:06AM +0900, Tejun Heo wrote:
> Hello, Kent.
> 
> On Tue, Oct 02, 2012 at 08:00:20PM -0700, Kent Overstreet wrote:
> > > However, I don't think it's a good idea to try to implement something
> > > which is a neutral transport of opaque data between userland and lower
> > > layers.  Things like that sound attractive with unlimited
> > > possibilities but reality seems to have the tendancy to make a big
> > > mess out of setups like that.
> > 
> > I don't see how the "neutral transport of opaque data" itself is a bad
> > thing. We want something simple and sane to build actual interfaces on
> > top of - once we've got that, we can either build clean generic well
> > defined interfaces or we can make a mess like with ioctls :P
> > 
> > It's like any other mechanism. There's good syscalls and bad syscalls...
> 
> Depending on what a feature aims for, the design and implementation
> vary greatly.  If you go for completely generic extensible stuff which
> can be used to warp space-time continuum, it's easy to end up with a
> monstrosity with generic and programmable parser, verifier, accessor
> and so on.

I don't think that's concrete enough that I can comment - I think this
is becoming too abstract.

You didn't have any complaints when I showed you the code I posted, I
don't plan on making it really any more complicated than that - I think
we do need explicit return values but honestly that makes it less
generic.


> > Say we implement an attr to control a block layer cache. That attr could
> > be parsed/validated in high level code (if there's any to do) - that I
> > don't object to. But the high level code isn't going to /know/ whether
> > there was any block cache in the stack that handled the attr. If the
> > attr is passed down to the block cache, that block cache can return that
> > it was handled.
> 
> My point is that if it doesn't fit the generic abstract model as in
> fadvise(2), it probably isn't worth supporting in any generic manner.

How so? Do you mean the file range part? I think that's orthogonal to
the rest (the hints fadvise specifies could be used per IO or with a
file range like they are now), but the hints themselves are inadequate
for SSD caches.

> > > It's okay to allow some side channel thing for specific hacky uses but
> > > I really hope the general design were focused around properly
> > > abstracted attributes which can be understood and handled by the upper
> > > layer.
> > 
> > Completely agreed. I want to leave that side channel open for
> > experimentation, and so we have a way of implementing one off hacky
> > stuff when we need to - but normal mainline stuff should be sane and
> > well designed.
> 
> So, I think we can aim for something simple and modest (the only thing
> I can think of at the moment is task association) and provide simple
> framework which can be used for specific custom usages.  Let's please
> not go overboard with generic parser / verifier which supports pointer
> indirection or whatnot.

I wasn't seriously proposing implementing a generic parser/verifier -
certainly not just for this, that was idle musing; all I'm saying is
that when an attr needs parsing/verification, that should be done in the
attr code, not driver code.
