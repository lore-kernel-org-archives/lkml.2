Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab0FAVwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 17:52:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754355Ab0FAVv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 17:51:58 -0400
Date: Tue, 1 Jun 2010 14:51:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
       Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2 1/2] tmpfs: Quick token library to allow scalable
 retrieval of tokens from token jar
Message-Id: <20100601145126.f46572d1.akpm@linux-foundation.org>
In-Reply-To: <1274902371.31973.9392.camel@mudge.jf.intel.com>
References: <1274902371.31973.9392.camel@mudge.jf.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 12:32:51 -0700
Tim Chen <tim.c.chen@linux.intel.com> wrote:

> This patch creates a quick token (qtoken) library to maintain local
> caches of tokens. This avoids lock contention when a token is
> retrieved or returned to the token jar to improve scalability performance
> on system with many cpus.
>
> ...
>
> +/*
> + * This library is useful when we have a large number of threads
> + * running concurrently on many cpus trying to access tokens in a token jar
> + * at the same time.
> + *
> + * The token jar is implemented with per cpu cache of tokens.
> + * This library allows tokens to be obtained from or returned quickly to
> + * the local cpu cache without any lock acquisition most of the time.
> + * We only need to lock and modify tokens in the common pool for the
> + * following cases:
> + *
> + * 1) Not enough tokens are in our local cache and we need to get tokens
> + * from the common pool
> + * 2) We have too many tokens in local cache and need to return
> + * some tokens to the common pool
> + * 3) We want to resize the token jar and need to freeze the free tokens
> + *
> + * The local token cache is disabled by setting it to -1 and tokens
> + * reaped into the common pool when we find the common pool low in tokens.
> + * The token jar should be initialized with a cache size large enough
> + * to avoid touching the common pool's tokens frequently.
> + *
> + * It is possible to implement the token jar with just a single
> + * atomic variable for all free tokens.  However, this approach is
> + * not used here to prevent excessive cache line bouncing which causes poor
> + * performance when token jar is accessed by large number of simultaneous
> + * threads.
> + */

OK, thanks.  But I'm still struggling a bit in understanding the
applicability.  Where else might one use this?  What particular
problem is it good at solving?

I think the problem here is that you're using the term "token jar" as
if others already know what a token jar _is_.  I guess I was asleep
during that compsci lecture, but google doesn't appear to know about
the term either.

And from looking at the tmpfs caller, it appears that the token jar is
being used to speed up the access to a single `unsigned long
free_blocks'.  Could we have used say a percpu_counter instead?

>
> ...
>
> +static void qtoken_reap_cache(struct qtoken *token_jar)
> +{
> +	long cnt;
> +	int i;
> +
> +	for_each_possible_cpu(i) {
> +		atomic_long_t	*cache;
> +
> +		cache = per_cpu_ptr(token_jar->cache, i);
> +		cnt = atomic_long_xchg(cache, -1);
> +		if (cnt > 0)
> +			token_jar->pool += cnt;
> +	}
> +}

Not cpu-hotplug aware.  Also, inefficient if num_online_cpus is much
less than num_possible_cpus.

It's really not hard to do!  lib/percpu_counter.c is per-cpu aware and
it does this by sneakily connecting all counters together system-wide.

> +/**
> + * qtoken_from pool: Get tokens from common pool in token jar
> + *
> + * @token_jar: pointer to struct qtoken
> + * @tokens: the number of tokens to acquire from token jar
> + * @reserve: number of tokens to reserve in token jar after getting tokens
> + *
> + * Get @tokens from the token jar's common pool but keep @reserve tokens.
> + * We will fail the operation if we cannot keep @reserve tokens in token jar.
> + *
> + * Return 0 if operations succeeds and -ENOSPC if operation fails.
> + */
> +static int qtoken_from_pool(struct qtoken *token_jar, unsigned long tokens,
> +				unsigned long reserve)
> +{
> +	int	allocated = -ENOSPC;
> +
> +	/* We should have acquired lock of token pool before coming here */
> +	if (token_jar->pool < (reserve + tokens))
> +		qtoken_reap_cache(token_jar);
> +	if (token_jar->pool >= (reserve + tokens)) {
> +		token_jar->pool -= tokens;
> +		allocated = 0;
> +	}
> +	return allocated;
> +}

ENOSPC means "your disk is full".  But my disk isn't full.  If this
inappropriate (indeed, incorrect) error code is ever propagated back to
userspace then users will be justifiably confused.

>
> ...
>


Have some comment fixes.  I don't know if the " - " is compulsory in
the kerneldoc, but it is conventional.


From: Andrew Morton <akpm@linux-foundation.org>

fix comment typo
repair kerneldoc

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/qtoken.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN lib/qtoken.c~tmpfs-quick-token-library-to-allow-scalable-retrieval-of-tokens-from-token-jar-fix lib/qtoken.c
--- a/lib/qtoken.c~tmpfs-quick-token-library-to-allow-scalable-retrieval-of-tokens-from-token-jar-fix
+++ a/lib/qtoken.c
@@ -58,7 +58,7 @@
  * the cache is disabled (i.e. value -1).  For this case,
  * @tokens are returned to common pool.
  * If the number of tokens in current cpu's cache exceed
- * a a highmark, we will return the extra tokens into the
+ * a highmark, we will return the extra tokens into the
  * common pool.
  */
 void qtoken_return(struct qtoken *token_jar, unsigned long tokens)
@@ -100,7 +100,7 @@ void qtoken_return(struct qtoken *token_
 EXPORT_SYMBOL(qtoken_return);
 
 /**
- * qtoken_reap cache: Move tokens from cache into common pool in token jar
+ * qtoken_reap_cache - move tokens from cache into common pool in token jar
  *
  * @token_jar: pointer to token jar
  *
@@ -123,7 +123,7 @@ static void qtoken_reap_cache(struct qto
 }
 
 /**
- * qtoken_from pool: Get tokens from common pool in token jar
+ * qtoken_from_pool - get tokens from common pool in token jar
  *
  * @token_jar: pointer to struct qtoken
  * @tokens: the number of tokens to acquire from token jar
@@ -150,7 +150,7 @@ static int qtoken_from_pool(struct qtoke
 }
 
 /**
- * qtoken_get: Get tokens from token jar
+ * qtoken_get - get tokens from token jar
  *
  * @token_jar: pointer to struct qtoken
  * @tokens: the number of tokens to acquire from token jar
@@ -217,7 +217,7 @@ int qtoken_get(struct qtoken *token_jar,
 EXPORT_SYMBOL(qtoken_get);
 
 /**
- * qtoken_init: Init token jar
+ * qtoken_init - init token jar
  *
  * @token_jar: pointer to token jar
  * @total_tokens: the total number of tokens that the token jar holds
@@ -266,7 +266,7 @@ void qtoken_free(struct qtoken *token_ja
 EXPORT_SYMBOL(qtoken_free);
 
 /**
- * qtoken_avail: Calculates token available in token jar
+ * qtoken_avail - calculates token available in token jar
  *
  * @token_jar: pointer to token jar
  *
@@ -295,7 +295,7 @@ unsigned long qtoken_avail(struct qtoken
 EXPORT_SYMBOL(qtoken_avail);
 
 /**
- * qtoken_resize: Resize the total number of tokens in token jar
+ * qtoken_resize - resize the total number of tokens in token jar
  *
  * @token_jar: pointer to token jar
  * @new_size: new total number of tokens in token jar
@@ -337,7 +337,7 @@ void qtoken_return(struct qtoken *token_
 EXPORT_SYMBOL(qtoken_return);
 
 /**
- * qtoken_get: Get tokens from token jar
+ * qtoken_get - get tokens from token jar
  *
  * @token_jar: pointer to struct qtoken
  * @tokens: the number of tokens to acquire from token jar
@@ -364,7 +364,7 @@ int qtoken_get(struct qtoken *token_jar,
 EXPORT_SYMBOL(qtoken_get);
 
 /**
- * qtoken_init: Init token jar
+ * qtoken_init - init token jar
  *
  * @token_jar: pointer to token jar
  * @total_tokens: the total number of tokens that the token jar holds
@@ -383,7 +383,7 @@ int qtoken_init(struct qtoken *token_jar
 EXPORT_SYMBOL(qtoken_init);
 
 /**
- * qtoken_free: Free token jar
+ * qtoken_free - free token jar
  *
  * @token_jar: pointer to token jar
  *
@@ -397,7 +397,7 @@ void qtoken_free(struct qtoken *token_ja
 EXPORT_SYMBOL(qtoken_free);
 
 /**
- * qtoken_avail: Calculate the tokens available in token jar
+ * qtoken_avail - calculate the tokens available in token jar
  *
  * @token_jar: pointer to token jar
  *
@@ -409,7 +409,7 @@ unsigned long qtoken_avail(struct qtoken
 EXPORT_SYMBOL(qtoken_avail);
 
 /**
- * qtoken_resize: Resize the total number of tokens in token jar
+ * qtoken_resize - resize the total number of tokens in token jar
  *
  * @token_jar: pointer to token jar
  * @new_size: new total number of tokens in token jar
@@ -434,7 +434,7 @@ EXPORT_SYMBOL(qtoken_resize);
 #endif /* CONFIG_SMP */
 
 /**
- * qtoken_total: Return the total number of tokens configured for token jar
+ * qtoken_total - return the total number of tokens configured for token jar
  *
  * @token_jar: pointer to token jar
  *
_

