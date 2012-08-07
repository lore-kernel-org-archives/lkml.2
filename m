Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157Ab2HGBTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 21:19:09 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50110 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756936Ab2HGBTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 21:19:07 -0400
Message-ID: <1344302346.2026.23.camel@joe2Laptop>
Subject: Re: [RFC v3 1/7] hashtable: introduce a small and naive hashtable
From: Joe Perches <joe@perches.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: torvalds@linux-foundation.org, tj@kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@elte.hu, ebiederm@xmission.com, aarcange@redhat.com,
        ericvh@gmail.com, netdev@vger.kernel.org, josh@joshtriplett.org,
        eric.dumazet@gmail.com, mathieu.desnoyers@efficios.com
Date: Mon, 06 Aug 2012 18:19:06 -0700
In-Reply-To: <1344300317-23189-2-git-send-email-levinsasha928@gmail.com>
References: <1344300317-23189-1-git-send-email-levinsasha928@gmail.com>
	 <1344300317-23189-2-git-send-email-levinsasha928@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-07 at 02:45 +0200, Sasha Levin wrote:
> This hashtable implementation is using hlist buckets to provide a simple
> hashtable to prevent it from getting reimplemented all over the kernel.

> diff --git a/include/linux/hashtable.h b/include/linux/hashtable.h

Just trivial style notes and a typo

> +/* Use hash_32 when possible to allow for fast 32bit hashing in 64bit kernels. */
> +#define hash_min(val, bits) ((sizeof(val)==4)?hash_32((val), (bits)):hash_long((val), (bits)))

This is a pretty long line.  It doesn't use normal kernel spacing
style and it has unnecessary parentheses.

Maybe:

#define hash_min(val, bits)						\
	(sizeof(val) == 4 ? hash_32(val, bits) : hash_long(val, bits))

> +
> +/**
> + * hash_init - initialize a hash table
> + * @hashtable: hashtable to be initialized
> + * @bits: bit count of hashing function
> + *
> + * Initializes a hash table with 2**bits buckets.
> + */
> +static inline void hash_init(struct hlist_head *hashtable, int bits)
> +{
> +	int i;
> +
> +	for (i = 0; i < HASH_SIZE(bits); i++)
> +		INIT_HLIST_HEAD(hashtable + i);
> +}

Maybe use a struct hlist_head *last_hash_entry as a loop variable

{
	struct hlist_head *eo_hash = hashtable + HASH_SIZE(bits);

	while (hashtable < eo_hash)
		INIT_HLIST_HEAD(hashtable++);
}

The compiler might generate the same code anyway...

[]

> +/**
> + * hash_for_each_possible - iterate over all possible objects for a giver key
> + * @name: hashtable to iterate
> + * @obj: the type * to use as a loop cursor for each bucke

bucket


