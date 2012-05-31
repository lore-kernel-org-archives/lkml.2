Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab2EaFN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 01:13:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35347 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab2EaFNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 01:13:25 -0400
Date: Thu, 31 May 2012 01:13:21 -0400
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tejun@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, agk@redhat.com
Subject: Re: [Bcache v13 14/16] bcache: Request, io and allocation code
Message-ID: <20120531051321.GA12602@dhcp-172-18-216-138.mtv.corp.google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <9ea33658f2a71b3b9bd2ec10bee959bef146f23c.1336619038.git.koverstreet@google.com>
 <20120530072358.GB4854@google.com>
 <20120531005224.GA5645@google.com>
 <20120531024327.GC32121@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120531024327.GC32121@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 11:43:27AM +0900, Tejun Heo wrote:
> Hey, Kent.
> 
> On Wed, May 30, 2012 at 05:52:25PM -0700, Kent Overstreet wrote:
> > > > +int alloc_discards(struct cache *ca)
> > > > +{
> > > > +	for (int i = 0; i < 8; i++) {
> > > > +		struct discard *d = kzalloc(sizeof(*d), GFP_KERNEL);
> > > > +		if (!d)
> > > > +			return -ENOMEM;
> > > > +
> > > > +		d->c = ca;
> > > > +		INIT_WORK(&d->work, discard_work);
> > > > +		list_add(&d->list, &ca->discards);
> > > > +	}
> > > > +
> > > > +	return 0;
> > > > +}
> > > 
> > > Why maintain separate pool of discards?  It it to throttle discard
> > > commands?  And another evil number!
> > 
> > Yeah, it's just a mempool that also throttles. I don't particularly care
> > for doing it that way, any suggestions? (Just fixed the magic number, at
> > least).
> 
> I think the list is fine.  I'm curious how the 8 was chosen tho and
> what are the implications of higher or lower number.  If it's just a
> number you just liked and didn't cause any problem, that's fine too as
> long as it's explained as such.

Just that, it was pretty arbitrary. Might actually be worth testing with
it set to 1-2 since it's an unqueued command in SATA, though.

> Looks sane enough to me.  Maybe just use padded_key.key directly?

Well, that is the current situation with the stack allocated ones. I'll
do something.

BKEY_PADDED() was originally for keys in other structs that needed
padded, where the transparent union thing actually works. Are you
against the macro in general or just for stack allocated keys?

> If you're gonna do /** comments, please also add arguments section.
> DocBook stuff may get unhappy.

Whoops, will do.

> The problem I'm having with names are two-fold.
> 
> * Name not descriptive enough.  It doesn't have to be super verbose
>   but something which people can look at and associate with its type
>   and/or role would be great.  e.g. instead of k, use key, d -> cdev,
>   and so on.

Some of those I'm not sure would be improved by expanding them - k ->
key mainly, key is still fairly generic but also k for a struct bkey is
used all over the place and fairly consistently (if I find k used for
anything else, I'll fix it).

I kind of dislike any-single-letter + dev, mainly because dev is used
all over the place and can mean damn near anything. (There's struct
device which is commonly referred to as dev, there's struct bdev, and
I'm pretty sure I could come up with more in a minute or two).

I would like more descriptive/unique variable names for cache,
cache_set, bcache_device and cached_dev, I'm just not coming up with
anything that's reasonably terse and seems to me like an improvement.

(I'm not really against cdev, it's just that bcache_device should then
be bdev by analogy and that's taken... argh).

Anyways, I'm not really attached to the current variable names like I am
some of the style issues, I just can't come up with anything I like.

> * Generic names.  bio_insert() belongs to block layer.  Block layer
>   may use it in the future and when one sees bio_insert(), it's
>   natural for that person to assume that it's a block layer thing
>   doing something with bio.  As for better name, I'm not sure.  Maybe
>   just prefix it with bc_?

Agreed on bio_insert() (there's a fair number of functions that I've
been meaning to rename for similarish reasons - get_bucket() and
pop_bucket() don't have anything to do with each other, for example).

I think the function names are easier to improve than variabe names,
though. The main obstacle (for me) to renaming stuff is that when I do I
want to come up with names that are patterned on the relationships in
the code, and that'll take some work.

>   Note that this isn't a 100% strict rule.  You can and people do get
>   away with some generic names and many of them don't cause any
>   problem over the lifetime of the code but it's just way too
>   prevalent in this code.  You can bend stuff only so much.

I'm really not arguing with you about the naming. It's just been
neglected for way too long.

> So, I don't know.  I guess I might be too conservative but the
> followings are the points I want to make.
> 
> * These small style issues don't really matter one way or the other.
>   They're mostly the matter or taste or preference after all.  Most
>   technical merits or shortcomings one perceives in this area tend to
>   be highly subjective and marginal, and the overhead of being unusual
>   tends to be way higher.  So, my or your taste doesn't weight that
>   much unless there actually are tangible technical merits which
>   people can agree upon.  I don't see that here (or in many other
>   bcache oddities).
> 
> * These aren't hard and fast rules.  There isn't one true fixed
>   standard that everyone conforms to.  There still are different
>   styles and people adopt the ones they think are pretty.  That's how
>   it evolves, but it too is a problem of degree and you can bend only
>   so far before people start complaining.
> 
>   For example, here's a fictionalized process that I got irritated and
>   felt generally hostile against the code base.
> 
>   1. Reading code.  Full of macros.
> 
>   2. Reading macros.  Single char arguments.  Starting to get
>      irritated.
> 
>   3. Encountered closures.  Still unsure what they mean.  This one
>      looks like a simple refcnt.  Wonders what the hell is wrong with
>      the usual refcnts.  Maybe somehow this gets used differently
>      somewhere else?  Of course, no explanation.
> 
>   4. While trying to follow the control flow, encounters a function
>      with full of cryptic numbers with "different" formatting.  No
>      high level explanation or anything.  Getting irritated.

Which function was that?

>   5. Now in the lower half of the function, forgot how @d was being
>      used.  Pressed ctrl-s and then d to highlight the variable in the
>      function.  Ooh, pretty.
> 
>   6. Saw the next function which seems static.  Tries to look for the
>      immediate caller by searching for FUNC_NAME( - hmmm... no match.
>      Maybe it's called indirectly somehow.  Looks for FUNC_NAME
>      assignments / used as arguments.  Find the function symbol buried
>      in ?:.
> 
>   7. kajga;wioegja;sdklbja; bkjhaw83ua;kdgjasl;dgjk aw;eig93ua;kgNACK
>      NACK NACK NACK NACK
> 
> So, at least to me, you seem to be pushing unique style / concepts too
> far and I can't identify the technical merits of doing so.  Code is to
> be read and worked together on by peer developers.

Well, there are a lot of style issues I'm happy to give on.

I think also I haven't been explicit about it but I do try to
differentiate between style issues that are of no consequence (whoever
feels more strongly about those can decide, for all I care) and things
that make the codebase harder to read and understand.

Hell, I've never pretended to be any good at writing code that's
understandable by others. There's things I _am_ good at - writing fast
code, writing complex asynchronous code that _reliably works_ - but
understandable code? Hell no.

(And I know I said I'd be writing design level documentation... I
haven't forgotten, it's just been busy).

Anyways, there's huge room for improvement in bcache in that respect and
while it's not going to happen overnight I am trying to steadily chip
away at it, and while I certainly understand your frustration in reading
the code it's not wasted.

That said, it does bug me when things are rejected out of hand merely
for being different and foreign.

Closures being the main example - I'd be more receptive to criticism if
I'd seen a half decent solution before, or if you or anyone else was
actually trying to come up with something better.

I'd really like to see what you come up with if you implement that bio
sequencer you've been talking about, because either you'll come up with
something better or you'll have a better understanding of the problems I
was trying to solve.

But, the thing about pushing a single purpose solution is - you might as
well tell the person who first invented the red-black tree to come back
with a simpler, single purpose solution to whatever he was working on.

If you want to tell me my sorted data structure/asynchronous programming
model is crap and should be done _better_, that's completely different.
I know closures could be improved, anyways.

But the previous tools for writing this kind of asynchronous code
_sucked_, and I can trivially do things that were near impossible
before, and my code is considerably more flexible and easier to work
with than it was before. So if you want to convince me there's a better
way to do what I'm doing - there is a genuinely high bar there.
