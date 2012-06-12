Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab2FLQvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 12:51:01 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44149 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751074Ab2FLQvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 12:51:00 -0400
Message-ID: <1339519858.2017.10.camel@joe2Laptop>
Subject: Re: [Bcache v14 16/16] bcache: Debug and tracing code
From: Joe Perches <joe@perches.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tejun@google.com, agk@redhat.com,
        dan.j.williams@intel.com
Date: Tue, 12 Jun 2012 09:50:58 -0700
In-Reply-To: <1339515562-14638-17-git-send-email-koverstreet@google.com>
References: <1339515562-14638-1-git-send-email-koverstreet@google.com>
	 <1339515562-14638-17-git-send-email-koverstreet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 08:39 -0700, Kent Overstreet wrote:

> diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c

> +static void dump_bset(struct btree *b, struct bset *i)
> +{
> +	for (struct bkey *k = i->start; k < end(i); k = bkey_next(k)) {
> +		printk(KERN_ERR "block %zu key %zu/%i: %s", index(i, b),
> +		       (uint64_t *) k - i->d, i->keys, pkey(k));

Add #define pr_fmt and use pr_<level> not printk everywhere.
Doesn't this throw a gcc warning for argument mismatch?

> +static void vdump_bucket_and_panic(struct btree *b, const char *m, va_list args)
> +{

m should be renamed fmt

> +	struct bset *i;
> +
> +	console_lock();
> +
> +	for_each_sorted_set(b, i)
> +		dump_bset(b, i);
> +
> +	vprintk(m, args);
> +
> +	console_unlock();
> +
> +	panic("at %s\n", pbtree(b));
> +}
> +
> +static void dump_bucket_and_panic(struct btree *b, const char *m, ...)
> +{

here too.

> +	va_list args;
> +	va_start(args, m);
> +	vdump_bucket_and_panic(b, m, args);
> +	va_end(args);
> +}
> +
> +static void __maybe_unused
> +dump_key_and_panic(struct btree *b, struct bset *i, int j)
> +{
> +	long bucket = PTR_BUCKET_NR(b->c, node(i, j), 0);
> +	long r = PTR_OFFSET(node(i, j), 0) & ~(~0 << b->c->bucket_bits);
> +
> +	printk(KERN_ERR "level %i block %zu key %i/%i: %s "
> +	       "bucket %llu offset %li into bucket\n",

coalesce formats please.

> +	       b->level, index(i, b), j, i->keys, pkey(node(i, j)),
> +	       (uint64_t) bucket, r);
> +	dump_bucket_and_panic(b, "");
> +}

[]

> +static int debug_seq_show(struct seq_file *f, void *data)
> +{
> +	static const char *tabs = "\t\t\t\t\t";

Seems a _very_ odd use.

> +	uint64_t last = 0, sectors = 0;
> +	struct cache_set *c = f->private;
> +
> +	struct btree_op op;
> +	bch_btree_op_init_stack(&op);
> +
> +	btree_root(dump, c, &op, f, &tabs[4], &last, &sectors);
> +

Why not just:

	btree_root(dump, c, &op, "\t", &last, &sectors);

Please don't be lazy when modifying code.

[]

> diff --git a/drivers/md/bcache/debug.h b/drivers/md/bcache/debug.h
[]
> +#define KEYHACK_SIZE 80
> +struct keyprint_hack {
> +	char s[KEYHACK_SIZE];
> +};

structures named _hack are generally a bad idea.


