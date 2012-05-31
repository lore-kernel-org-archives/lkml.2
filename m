Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab2EaGp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 02:45:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35958 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab2EaGpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 02:45:23 -0400
Date: Thu, 31 May 2012 15:45:15 +0900
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: Tejun Heo <tj@kernel.org>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com
Subject: Re: [Bcache v13 14/16] bcache: Request, io and allocation code
Message-ID: <20120531064515.GA18984@mtj.dyndns.org>
References: <cover.1336619038.git.koverstreet@google.com>
 <9ea33658f2a71b3b9bd2ec10bee959bef146f23c.1336619038.git.koverstreet@google.com>
 <20120530072358.GB4854@google.com>
 <20120531005224.GA5645@google.com>
 <20120531024327.GC32121@google.com>
 <20120531051321.GA12602@dhcp-172-18-216-138.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120531051321.GA12602@dhcp-172-18-216-138.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

On Thu, May 31, 2012 at 01:13:21AM -0400, Kent Overstreet wrote:
> BKEY_PADDED() was originally for keys in other structs that needed
> padded, where the transparent union thing actually works. Are you
> against the macro in general or just for stack allocated keys?

Macro in general.  If it needs an extra union / struct member deref,
so be it.  No need to be smart for things like this.

> I would like more descriptive/unique variable names for cache,
> cache_set, bcache_device and cached_dev, I'm just not coming up with
> anything that's reasonably terse and seems to me like an improvement.
> 
> (I'm not really against cdev, it's just that bcache_device should then
> be bdev by analogy and that's taken... argh).
>
> Anyways, I'm not really attached to the current variable names like I am
> some of the style issues, I just can't come up with anything I like.

Heh, yeah, naming isn't easy.  In most cases, it just has to be
something consistent which has some association tho.

> > * Generic names.  bio_insert() belongs to block layer.  Block layer
> >   may use it in the future and when one sees bio_insert(), it's
> >   natural for that person to assume that it's a block layer thing
> >   doing something with bio.  As for better name, I'm not sure.  Maybe
> >   just prefix it with bc_?
> 
> Agreed on bio_insert() (there's a fair number of functions that I've
> been meaning to rename for similarish reasons - get_bucket() and
> pop_bucket() don't have anything to do with each other, for example).
> 
> I think the function names are easier to improve than variabe names,
> though. The main obstacle (for me) to renaming stuff is that when I do I
> want to come up with names that are patterned on the relationships in
> the code, and that'll take some work.

It doesn't have to be perfect.  Naming schemes like anything else tend
to lose consistency over time anyway, so something good enough is
usually good enough.

> > * These aren't hard and fast rules.  There isn't one true fixed
> >   standard that everyone conforms to.  There still are different
> >   styles and people adopt the ones they think are pretty.  That's how
> >   it evolves, but it too is a problem of degree and you can bend only
> >   so far before people start complaining.
> > 
> >   For example, here's a fictionalized process that I got irritated and
> >   felt generally hostile against the code base.
> > 
> >   1. Reading code.  Full of macros.
> > 
> >   2. Reading macros.  Single char arguments.  Starting to get
> >      irritated.
> > 
> >   3. Encountered closures.  Still unsure what they mean.  This one
> >      looks like a simple refcnt.  Wonders what the hell is wrong with
> >      the usual refcnts.  Maybe somehow this gets used differently
> >      somewhere else?  Of course, no explanation.
> > 
> >   4. While trying to follow the control flow, encounters a function
> >      with full of cryptic numbers with "different" formatting.  No
> >      high level explanation or anything.  Getting irritated.
> 
> Which function was that?

Heh, this was dramatized for maximum effect.  I was thinking about the
condition check functions / macros with hard-coded constants.

...
> I think also I haven't been explicit about it but I do try to
> differentiate between style issues that are of no consequence (whoever
> feels more strongly about those can decide, for all I care) and things
> that make the codebase harder to read and understand.
> 
> Hell, I've never pretended to be any good at writing code that's
> understandable by others. There's things I _am_ good at - writing fast
> code, writing complex asynchronous code that _reliably works_ - but
> understandable code? Hell no.

I don't think your style is inferior or anything.  It's just different
from the one used in the kernel.  I don't think it's anything
difficult either.  It's just a matter of habit.

...
> That said, it does bug me when things are rejected out of hand merely
> for being different and foreign.
> 
> Closures being the main example - I'd be more receptive to criticism if
> I'd seen a half decent solution before, or if you or anyone else was
> actually trying to come up with something better.
> 
> I'd really like to see what you come up with if you implement that bio
> sequencer you've been talking about, because either you'll come up with
> something better or you'll have a better understanding of the problems I
> was trying to solve.

I still don't understand what's being made better by closure.  At
least the ones I've seen didn't seem to be justified, so if you have
some examples which highlight the benefits of closure, please go ahead
and explain them.

I'll write more about it later but here are some of my current
thoughts.

* I personally think async (using something other than stack for
  execution state) programming inherently sucks, no matter how it's
  done.  The programming language and even the processor we use assume
  that stack is used to track execution context after all.  My opinion
  about async programming can essentially be summarized as "avoid it
  as much as possible".

* This itself may be too abstract but excess is often worse than lack,
  especially for abstraction and design.  Problems caused by excess is
  much more difficult to rectify as the problems are intentional and
  systematic.  That's the part I dislike the most about kobject and
  friends.

* I don't (yet anyway) believe that you have something drastically
  better in closure.  You just have something very different and maybe
  a bit more convenient.  Both async and refcnting are well known
  problems with established patterns.

  In a sense, I think it's similar to the style argument although at a
  higher level.  I don't think the amount of benefit justifies the
  amount of deviation.

So, at least to me, the bar for highly abstract refcnty async thingy
is pretty high.  It's a ugly problem and I'd prefer to leave it ugly
and painful unless it can be drastically better.

Thanks.

-- 
tejun
