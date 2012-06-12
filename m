Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab2FLRYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 13:24:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48160 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab2FLRYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:24:48 -0400
Date: Tue, 12 Jun 2012 10:24:44 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Joe Perches <joe@perches.com>, g@google.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tejun@google.com, agk@redhat.com,
        dan.j.williams@intel.com
Subject: Re: [Bcache v14 16/16] bcache: Debug and tracing code
Message-ID: <20120612172444.GA11365@google.com>
References: <1339515562-14638-1-git-send-email-koverstreet@google.com>
 <1339515562-14638-17-git-send-email-koverstreet@google.com>
 <1339519858.2017.10.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339519858.2017.10.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 09:50:58AM -0700, Joe Perches wrote:
> On Tue, 2012-06-12 at 08:39 -0700, Kent Overstreet wrote:
> 
> > diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
> 
> > +static void dump_bset(struct btree *b, struct bset *i)
> > +{
> > +	for (struct bkey *k = i->start; k < end(i); k = bkey_next(k)) {
> > +		printk(KERN_ERR "block %zu key %zu/%i: %s", index(i, b),
> > +		       (uint64_t *) k - i->d, i->keys, pkey(k));
> 
> Add #define pr_fmt and use pr_<level> not printk everywhere.

I've got the pr_fmt, but I don't want to use it here because it's
dumping a btree node (100s of lines) so the bcache: would be redundant,
but more importantly I don't want lines getting truncated.

> Doesn't this throw a gcc warning for argument mismatch?

No, why?

> 
> > +static void vdump_bucket_and_panic(struct btree *b, const char *m, va_list args)
> > +{
> 
> m should be renamed fmt

Agreed.

> 
> > +	struct bset *i;
> > +
> > +	console_lock();
> > +
> > +	for_each_sorted_set(b, i)
> > +		dump_bset(b, i);
> > +
> > +	vprintk(m, args);
> > +
> > +	console_unlock();
> > +
> > +	panic("at %s\n", pbtree(b));
> > +}
> > +
> > +static void dump_bucket_and_panic(struct btree *b, const char *m, ...)
> > +{
> 
> here too.
> 
> > +	va_list args;
> > +	va_start(args, m);
> > +	vdump_bucket_and_panic(b, m, args);
> > +	va_end(args);
> > +}
> > +
> > +static void __maybe_unused
> > +dump_key_and_panic(struct btree *b, struct bset *i, int j)
> > +{
> > +	long bucket = PTR_BUCKET_NR(b->c, node(i, j), 0);
> > +	long r = PTR_OFFSET(node(i, j), 0) & ~(~0 << b->c->bucket_bits);
> > +
> > +	printk(KERN_ERR "level %i block %zu key %i/%i: %s "
> > +	       "bucket %llu offset %li into bucket\n",
> 
> coalesce formats please.

The "block %zu key %i/%i" part? I think I can do that.

> 
> > +	       b->level, index(i, b), j, i->keys, pkey(node(i, j)),
> > +	       (uint64_t) bucket, r);
> > +	dump_bucket_and_panic(b, "");
> > +}
> 
> []
> 
> > +static int debug_seq_show(struct seq_file *f, void *data)
> > +{
> > +	static const char *tabs = "\t\t\t\t\t";
> 
> Seems a _very_ odd use.

It is a strange hack.

The idea is that we want to indent more as we recurse; we could build up
a new string of tabs each time we recurse that's got one more tab than
our parent's, but that'd be a pain in the ass and it'd use more stack
space (though that should be fine here), so instead it's just
decrementing the pointer to the tab string to produce a string with one
more tab.

I'm not opposed to taking it out if you know cleaner way that isn't
ridiculously verbose. But this code needs to be rewritten to not use
single_open() (which I tihnk is going to be a pain in the ass) so it's
not really at the top of my list.

> 
> > +	uint64_t last = 0, sectors = 0;
> > +	struct cache_set *c = f->private;
> > +
> > +	struct btree_op op;
> > +	bch_btree_op_init_stack(&op);
> > +
> > +	btree_root(dump, c, &op, f, &tabs[4], &last, &sectors);
> > +
> 
> Why not just:
> 
> 	btree_root(dump, c, &op, "\t", &last, &sectors);
> 
> Please don't be lazy when modifying code.
> 
> []
> 
> > diff --git a/drivers/md/bcache/debug.h b/drivers/md/bcache/debug.h
> []
> > +#define KEYHACK_SIZE 80
> > +struct keyprint_hack {
> > +	char s[KEYHACK_SIZE];
> > +};
> 
> structures named _hack are generally a bad idea.

Heh. Well, I don't try to hide my terrible hacks. Ugly stuff should be
ugly.

If you missed what it's for, it lets you do
printk("some key: %s\n", pkey(k));

which is very handy.

IMO it ought to be a vsnprintf extension, except that there's no plugin
mechanism to do that so it could be specific to bcache. I'd love to
implement that (shouldn't be very hard), but in the meantime this gets
the job done.
