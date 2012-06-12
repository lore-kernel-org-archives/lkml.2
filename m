Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab2FLRfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 13:35:47 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43170 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753688Ab2FLRfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:35:45 -0400
Message-ID: <1339522543.2404.3.camel@joe2Laptop>
Subject: Re: [Bcache v14 16/16] bcache: Debug and tracing code
From: Joe Perches <joe@perches.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: g@google.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tejun@google.com, agk@redhat.com,
        dan.j.williams@intel.com
Date: Tue, 12 Jun 2012 10:35:43 -0700
In-Reply-To: <20120612172444.GA11365@google.com>
References: <1339515562-14638-1-git-send-email-koverstreet@google.com>
	 <1339515562-14638-17-git-send-email-koverstreet@google.com>
	 <1339519858.2017.10.camel@joe2Laptop> <20120612172444.GA11365@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 10:24 -0700, Kent Overstreet wrote:
> On Tue, Jun 12, 2012 at 09:50:58AM -0700, Joe Perches wrote:
> > On Tue, 2012-06-12 at 08:39 -0700, Kent Overstreet wrote:
> > 
> > > diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
> > 
> > > +static void dump_bset(struct btree *b, struct bset *i)
> > > +{
> > > +	for (struct bkey *k = i->start; k < end(i); k = bkey_next(k)) {
> > > +		printk(KERN_ERR "block %zu key %zu/%i: %s", index(i, b),
> > > +		       (uint64_t *) k - i->d, i->keys, pkey(k));
> > 
> > Add #define pr_fmt and use pr_<level> not printk everywhere.
> 
> I've got the pr_fmt, but I don't want to use it here because it's
> dumping a btree node (100s of lines) so the bcache: would be redundant,
> but more importantly I don't want lines getting truncated.
> 
> > Doesn't this throw a gcc warning for argument mismatch?
> 
> No, why?

"(uint64_t *)k - i->d" is what type again?
What is a %zu?

Isn't that a mismatch?

> > > +static int debug_seq_show(struct seq_file *f, void *data)
> > > +{
> > > +	static const char *tabs = "\t\t\t\t\t";
> > 
> > Seems a _very_ odd use.
> 
> It is a strange hack.
> 
> The idea is that we want to indent more as we recurse; we could build up
> a new string of tabs each time we recurse that's got one more tab than
> our parent's, but that'd be a pain in the ass and it'd use more stack
> space (though that should be fine here), so instead it's just
> decrementing the pointer to the tab string to produce a string with one
> more tab.

It's a nice idea, but that's not what's happening
as I believe you reference tabs only once as &tabs[4]

> I'm not opposed to taking it out if you know cleaner way that isn't
> ridiculously verbose. But this code needs to be rewritten to not use
> single_open() (which I tihnk is going to be a pain in the ass) so it's
> not really at the top of my list.
> 
> > 
> > > +	uint64_t last = 0, sectors = 0;
> > > +	struct cache_set *c = f->private;
> > > +
> > > +	struct btree_op op;
> > > +	bch_btree_op_init_stack(&op);
> > > +
> > > +	btree_root(dump, c, &op, f, &tabs[4], &last, &sectors);
> > > +
> > 
> > Why not just:
> > 
> > 	btree_root(dump, c, &op, "\t", &last, &sectors);


