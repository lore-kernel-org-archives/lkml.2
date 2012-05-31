Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890Ab2EaCqD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 22:46:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48695 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757757Ab2EaCqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 22:46:01 -0400
Date: Thu, 31 May 2012 11:45:53 +0900
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, agk@redhat.com
Subject: Re: [Bcache v13 14/16] bcache: Request, io and allocation code
Message-ID: <20120531024553.GD32121@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <9ea33658f2a71b3b9bd2ec10bee959bef146f23c.1336619038.git.koverstreet@google.com>
 <20120530072358.GB4854@google.com>
 <20120531005224.GA5645@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120531005224.GA5645@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Kent.

On Wed, May 30, 2012 at 05:52:25PM -0700, Kent Overstreet wrote:
> > > +int alloc_discards(struct cache *ca)
> > > +{
> > > +	for (int i = 0; i < 8; i++) {
> > > +		struct discard *d = kzalloc(sizeof(*d), GFP_KERNEL);
> > > +		if (!d)
> > > +			return -ENOMEM;
> > > +
> > > +		d->c = ca;
> > > +		INIT_WORK(&d->work, discard_work);
> > > +		list_add(&d->list, &ca->discards);
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > 
> > Why maintain separate pool of discards?  It it to throttle discard
> > commands?  And another evil number!
> 
> Yeah, it's just a mempool that also throttles. I don't particularly care
> for doing it that way, any suggestions? (Just fixed the magic number, at
> least).

I think the list is fine.  I'm curious how the 8 was chosen tho and
what are the implications of higher or lower number.  If it's just a
number you just liked and didn't cause any problem, that's fine too as
long as it's explained as such.

> > > +static long pop_bucket(struct cache *c, uint16_t priority, struct closure *cl)
> > > +{
> > > +	long r = -1;
> > > +again:
> > > +	free_some_buckets(c);
> > > +
> > > +	if ((priority == btree_prio ||
> > > +	     fifo_used(&c->free) > 8) &&
> > > +	    fifo_pop(&c->free, r)) {
> > 
> > This is unconventional and more difficult to read than
> > 
> > 	if ((priority == btree_prio || fifo_used(&c->free) > 8) &&
> > 	    fifo_pop(&c->free, r)) {
> > 
> > It harms readability by both being unnecessarily different and
> > visually less distinguishible.  Why do this?
> 
> I prefer extra linebreaks in complicated if statements as the
> indentation makes the way the parentheses group things clearer, but for
> this one I'm fine with your version.

Hmmm.... more on the subject of style conformance at the end.

> > > +static struct open_bucket *get_data_bucket(struct bkey *search,
> > > +					   struct search *s)
> > > +{
> > > +	struct closure cl, *w = NULL;
> > > +	struct cache_set *c = s->op.d->c;
> > > +	struct open_bucket *l, *ret, *ret_task;
> > > +
> > 
> > Unnecessary new line.
> 
> That one serves no purpose, fixed.
> 
> > > +	BKEY_PADDED(key) alloc;
> > 
> > Why BKEY_PADDED()?  What does it do?  Can we not do this?
> 
> Just a bare struct bkey on the stack won't be big enough for any
> pointers.
> 
> I _suppose_ I could do something like:
> 
> struct bkey_padded alloc_pad;
> struct bkey *alloc = &alloc_pad.key;
> 
> I like that marginally better. Any better ideas?

Looks sane enough to me.  Maybe just use padded_key.key directly?

> +/**
> + * get_data_bucket - pick out a bucket to write some data to, possibly
> + * allocating a new one.

If you're gonna do /** comments, please also add arguments section.
DocBook stuff may get unhappy.

> + * We keep multiple buckets open for writes, and try to segregate different
> + * write streams for better cache utilization: first we look for a bucket where
> + * the last write to it was sequential with the current write, and failing that
> + * we look for a bucket that was last used by the same task.
> + *
> + * The ideas is if you've got multiple tasks pulling data into the cache at the
> + * same time, you'll get better cache utilization if you try to segregate their
> + * data and preserve locality.
> + *
> + * For example, say you've starting Firefox at the same time you're copying a
> + * bunch of files. Firefox will likely end up being fairly hot and stay in the
> + * cache awhile, but the data you copied might not be; if you wrote all that
> + * data to the same buckets it'd get invalidated at the same time.
> + *
> + * Both of those tasks will be doing fairly random IO so we can't rely on
> + * detecting sequential IO to segregate their data, but going off of the task
> + * should be a sane heuristic.
> + */
>  static struct open_bucket *get_data_bucket(struct bkey *search,
>  					   struct search *s)
>  {
...
> > > +static void bio_insert(struct closure *cl)
> > 
> > Too generic name.  This and a lot of others.  Note that there are
> > issues other than direct compile time symbol collision - it makes the
> > code difficult to grep for and stack traces difficult to decipher.
> > I'm not gonna complain more about too generic names but please review
> > the code and fix other instances too.
> 
> I'm pretty terrible at naming, so if at some point you could help me
> come up with names that are descriptive _to you_, it'd be a big help.

The problem I'm having with names are two-fold.

* Name not descriptive enough.  It doesn't have to be super verbose
  but something which people can look at and associate with its type
  and/or role would be great.  e.g. instead of k, use key, d -> cdev,
  and so on.

* Generic names.  bio_insert() belongs to block layer.  Block layer
  may use it in the future and when one sees bio_insert(), it's
  natural for that person to assume that it's a block layer thing
  doing something with bio.  As for better name, I'm not sure.  Maybe
  just prefix it with bc_?

  Note that this isn't a 100% strict rule.  You can and people do get
  away with some generic names and many of them don't cause any
  problem over the lifetime of the code but it's just way too
  prevalent in this code.  You can bend stuff only so much.

> > > +
> > > +	if (cached_dev_get(dc)) {
> > > +		s = do_bio_hook(bio, d);
> > > +		trace_bcache_request_start(&s->op, bio);
> > > +
> > > +		(!bio_has_data(bio)	? request_nodata :
> > > +		 bio->bi_rw & REQ_WRITE ? request_write :
> > > +					  request_read)(dc, s);
> > 
> > Don't do this.  Among other things, it should be possible to search /
> > grep for "FUNCTION_NAME(" and find all the direct invocations.  Just
> > use if/else.  You're not gaining anything from doing things like the
> > above while basically aggravating other developers trying to
> > understand your code.
> 
> I don't buy the argument about finding direct invocations (tons of stuff
> is indirectly invoked today and i can't remember ever caring about
> direct invocations vs. calls via a pointer, and worse for grepping is
> all the set wrappers for things like merge_bvec_fn (it's inconsistent
> and what is this, C++?)
> 
> But I give up, changed it :P

So, I don't know.  I guess I might be too conservative but the
followings are the points I want to make.

* These small style issues don't really matter one way or the other.
  They're mostly the matter or taste or preference after all.  Most
  technical merits or shortcomings one perceives in this area tend to
  be highly subjective and marginal, and the overhead of being unusual
  tends to be way higher.  So, my or your taste doesn't weight that
  much unless there actually are tangible technical merits which
  people can agree upon.  I don't see that here (or in many other
  bcache oddities).

* These aren't hard and fast rules.  There isn't one true fixed
  standard that everyone conforms to.  There still are different
  styles and people adopt the ones they think are pretty.  That's how
  it evolves, but it too is a problem of degree and you can bend only
  so far before people start complaining.

  For example, here's a fictionalized process that I got irritated and
  felt generally hostile against the code base.

  1. Reading code.  Full of macros.

  2. Reading macros.  Single char arguments.  Starting to get
     irritated.

  3. Encountered closures.  Still unsure what they mean.  This one
     looks like a simple refcnt.  Wonders what the hell is wrong with
     the usual refcnts.  Maybe somehow this gets used differently
     somewhere else?  Of course, no explanation.

  4. While trying to follow the control flow, encounters a function
     with full of cryptic numbers with "different" formatting.  No
     high level explanation or anything.  Getting irritated.

  5. Now in the lower half of the function, forgot how @d was being
     used.  Pressed ctrl-s and then d to highlight the variable in the
     function.  Ooh, pretty.

  6. Saw the next function which seems static.  Tries to look for the
     immediate caller by searching for FUNC_NAME( - hmmm... no match.
     Maybe it's called indirectly somehow.  Looks for FUNC_NAME
     assignments / used as arguments.  Find the function symbol buried
     in ?:.

  7. kajga;wioegja;sdklbja; bkjhaw83ua;kdgjasl;dgjk aw;eig93ua;kgNACK
     NACK NACK NACK NACK

So, at least to me, you seem to be pushing unique style / concepts too
far and I can't identify the technical merits of doing so.  Code is to
be read and worked together on by peer developers.

Thanks.

-- 
tejun
