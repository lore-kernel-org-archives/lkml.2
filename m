Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab2EaBJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 21:09:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54694 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338Ab2EaBJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 21:09:44 -0400
Date: Wed, 30 May 2012 18:09:41 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, agk@redhat.com
Subject: Re: [Bcache v13 11/16] bcache: Core btree code
Message-ID: <20120531010940.GB5645@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <7f1de39b6d7040b3fe271500776f4b985b21ea82.1336619038.git.koverstreet@google.com>
 <20120530074708.GA32121@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120530074708.GA32121@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 04:47:08PM +0900, Tejun Heo wrote:
> A couple more comments from this round of reading.
> 
> On Wed, May 09, 2012 at 11:10:48PM -0400, Kent Overstreet wrote:
> > +#define btree_prio		USHRT_MAX
> > +#define initial_prio		32768
> 
> Why are these in lower case?

No good reason. I'll change it.

> 
> > +#define PTR_BUCKET(c, k, n)						\
> > +	(PTR_CACHE(c, k, n)->buckets + PTR_BUCKET_NR(c, k, n))
> 
> PTR_BUCKET(c, k, n)
> 
> Awesome.  I don't know what type it takes or what each single
> character argument stands for.

Yeah, that should be an inline function, along with some others. Fixed -
well, have to convert the rest of the code to the lowercase names:

Maybe ptr_bucket_idx() instead of ptr_bucket_nr()?

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 1011a73..0617885 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -717,15 +717,41 @@ PTR_FIELD(PTR_GEN,		0,  8)
 #define PTR(gen, offset, dev)						\
 	((((uint64_t) dev) << 51) | ((uint64_t) offset) << 8 | gen)
 
-#define sector_to_bucket(c, s)	((long) ((s) >> (c)->bucket_bits))
-#define bucket_to_sector(c, b)	(((sector_t) (b)) << (c)->bucket_bits)
-#define bucket_remainder(c, b)	((b) & ((c)->sb.bucket_size - 1))
+static inline size_t sector_to_bucket(struct cache_set *c, sector_t s)
+{
+	return s >> c->bucket_bits;
+}
+
+static inline sector_t bucket_to_sector(struct cache_set *c, size_t b)
+{
+	return ((sector_t) b) << c->bucket_bits;
+}
 
-#define PTR_CACHE(c, k, n)	((c)->cache[PTR_DEV(k, n)])
-#define PTR_BUCKET_NR(c, k, n)	sector_to_bucket(c, PTR_OFFSET(k, n))
+static inline sector_t bucket_remainder(struct cache_set *c, sector_t s)
+{
+	return s & (c->sb.bucket_size - 1);
+}
 
-#define PTR_BUCKET(c, k, n)						\
-	(PTR_CACHE(c, k, n)->buckets + PTR_BUCKET_NR(c, k, n))
+static inline struct cache *ptr_cache(struct cache_set *c,
+				      struct bkey *k,
+				      unsigned ptr)
+{
+	return c->cache[PTR_DEV(k, ptr)];
+}
+
+static inline size_t ptr_bucket_nr(struct cache_set *c,
+				   struct bkey *k,
+				   unsigned ptr)
+{
+	return sector_to_bucket(c, PTR_OFFSET(k, ptr));
+}
+
+static inline struct bucket *ptr_bucket(struct cache_set *c,
+					struct bkey *k,
+					unsigned ptr)
+{
+	return ptr_cache(c, k, ptr)->buckets + ptr_bucket_nr(c, k, ptr);
+}
 
 /* Btree key macros */
 
> 
> > +static inline bool cached_dev_get(struct cached_dev *d)
> > +{
> > +	if (!atomic_inc_not_zero(&d->count))
> > +		return false;
> > +
> > +	smp_mb__after_atomic_inc();
> 
> What is this mb() paired with?  Whenever using a mb, please specify
> what the mb is paired with.

super.c, cached_dev_attach():

	smp_wmb();
	/* d->c must be set before d->count != 0 */
	atomic_set(&d->count, 1);

I'm improving the comments.

> 
> > +	return true;
> > +}
> 
> Thanks.
> 
> -- 
> tejun
