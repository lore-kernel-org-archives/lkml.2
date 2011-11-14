Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab1KNRyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 12:54:41 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:59924 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab1KNRyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 12:54:40 -0500
Date: Mon, 14 Nov 2011 09:54:23 -0800
From: Mandeep Singh Baines <msb@chromium.org>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com,
        Will Drewry <wad@chromium.org>, Elly Jones <ellyjones@chromium.org>,
        Milan Broz <mbroz@redhat.com>, Olof Johansson <olofj@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dm: verity target
Message-ID: <20111114175423.GA13132@google.com>
References: <20111110074408.GE10138@secunet.com>
 <1321032884-14621-1-git-send-email-msb@chromium.org>
 <20111114092252.GA11359@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111114092252.GA11359@secunet.com>
X-Operating-System: Linux/2.6.38.8-gg621 (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steffen Klassert (steffen.klassert@secunet.com) wrote:
> On Fri, Nov 11, 2011 at 09:34:44AM -0800, Mandeep Singh Baines wrote:
> >
> > +/**
> > + * dm_bht_compute_hash: hashes a page of data
> > + */
> > +static int dm_bht_compute_hash(struct dm_bht *bht, struct page *pg,
> > +			       unsigned int offset, u8 *digest)
> > +{
> > +	struct shash_desc *hash_desc = bht->hash_desc[smp_processor_id()];
> > +	void *data;
> > +	int err;
> 
> You don't need to have one shash_desc per cpu. As the shash interface is
> synchronous, you could either allocate a new shash_desc with every call
> to dm_bht_compute_hash, or just place the shash_desc with the context to
> the stack of this function. The easiest thing would be to add the
> shash transformation direct to dm_bht and then something like
> 
>         struct {
>                 struct shash_desc desc;        
>                 char ctx[crypto_shash_descsize(bht->tfm)];                                                
>         } hash_desc;
> 
> 	hash_desc.desc.tfm = bmt->tfm;
> 
> The intermediate and final digest values are stored to hash_desc.ctx.
> This is local, hence it's reentrant.
> 

Hi Steffen,

We use a hash per CPU to avoid allocating and freeing a context per
computation. We could allocate the context on the stack as you suggest.
However, we were worried about overflowing the stack. The context can be
quite large (close to 200 bytes for sha512).

We use a hash per CPU because there can be at most one hash in progress
on each CPU at any one time.

Regards,
Mandeep

> > +
> > +	/* Note, this is synchronous. */
> > +	if (crypto_shash_init(hash_desc)) {
> > +		DMCRIT("failed to reinitialize crypto hash (proc:%d)",
> > +			smp_processor_id());
> > +		return -EINVAL;
> > +	}
> > +	data = kmap_atomic(pg);
> > +	err = crypto_shash_update(hash_desc, data + offset, PAGE_SIZE);
> > +	kunmap_atomic(data);
> > +	if (err) {
> > +		DMCRIT("crypto_hash_update failed");
> > +		return -EINVAL;
> > +	}
> > +	if (crypto_shash_update(hash_desc, bht->salt, sizeof(bht->salt))) {
> > +		DMCRIT("crypto_hash_update failed");
> > +		return -EINVAL;
> > +	}
> > +	if (crypto_shash_final(hash_desc, digest)) {
> > +		DMCRIT("crypto_hash_final failed");
> > +		return -EINVAL;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> 
> [snip]
> 
> > + * TODO(wad): All hash storage memory is pre-allocated and freed once an
> > + * entire branch has been verified.
> > + */
> > +struct dm_bht {
> > +	/* Configured values */
> > +	int depth;  /* Depth of the tree including the root */
> > +	unsigned int block_count;  /* Number of blocks hashed */
> > +	unsigned int block_size;  /* Size of a hash block */
> > +	char hash_alg[CRYPTO_MAX_ALG_NAME];
> > +	unsigned char salt[DM_BHT_SALT_SIZE];
> > +
> > +	/* Computed values */
> > +	unsigned int node_count;  /* Data size (in hashes) for each entry */
> > +	unsigned int node_count_shift;  /* first bit set - 1 */
> > +	/* There is one per CPU so that verified can be simultaneous. */
> > +	struct shash_desc *hash_desc[NR_CPUS];  /* Container for the hash alg */
> 
> As mentioned above, you don't need to have one shash_desc per cpu.
> Replace this with a 'struct crypto_shash *tfm;' and add this transformation
> to the local hash_desc.
> 
