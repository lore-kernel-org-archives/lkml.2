Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab1GGSHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 14:07:38 -0400
Received: from mail-bw0-f52.google.com ([209.85.214.52]:40885 "EHLO
	mail-bw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab1GGSHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 14:07:35 -0400
Date: Thu, 7 Jul 2011 21:07:27 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tiger
To: Marcin Slusarz <marcin.slusarz@gmail.com>
cc: Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
        rientjes@google.com, linux-mm@kvack.org
Subject: Re: [PATCH] slub: reduce overhead of slub_debug
In-Reply-To: <20110626193918.GA3339@joi.lan>
Message-ID: <alpine.DEB.2.00.1107072106560.6693@tiger>
References: <20110626193918.GA3339@joi.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Jun 2011, Marcin Slusarz wrote:
> slub checks for poison one byte by one, which is highly inefficient
> and shows up frequently as a highest cpu-eater in perf top.
>
> Joining reads gives nice speedup:
>
> (Compiling some project with different options)
>                                 make -j12    make clean
> slub_debug disabled:             1m 27s       1.2 s
> slub_debug enabled:              1m 46s       7.6 s
> slub_debug enabled + this patch: 1m 33s       3.2 s
>
> check_bytes still shows up high, but not always at the top.
>
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: linux-mm@kvack.org
> ---

Looks good to me. Christoph, David, ?

> mm/slub.c |   36 ++++++++++++++++++++++++++++++++++--
> 1 files changed, 34 insertions(+), 2 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 35f351f..a40ef2d 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -557,10 +557,10 @@ static void init_object(struct kmem_cache *s, void *object, u8 val)
> 		memset(p + s->objsize, val, s->inuse - s->objsize);
> }
>
> -static u8 *check_bytes(u8 *start, unsigned int value, unsigned int bytes)
> +static u8 *check_bytes8(u8 *start, u8 value, unsigned int bytes)
> {
> 	while (bytes) {
> -		if (*start != (u8)value)
> +		if (*start != value)
> 			return start;
> 		start++;
> 		bytes--;
> @@ -568,6 +568,38 @@ static u8 *check_bytes(u8 *start, unsigned int value, unsigned int bytes)
> 	return NULL;
> }
>
> +static u8 *check_bytes(u8 *start, u8 value, unsigned int bytes)
> +{
> +	u64 value64;
> +	unsigned int words, prefix;
> +
> +	if (bytes <= 16)
> +		return check_bytes8(start, value, bytes);
> +
> +	value64 = value | value << 8 | value << 16 | value << 24;
> +	value64 = value64 | value64 << 32;
> +	prefix = 8 - ((unsigned long)start) % 8;
> +
> +	if (prefix) {
> +		u8 *r = check_bytes8(start, value, prefix);
> +		if (r)
> +			return r;
> +		start += prefix;
> +		bytes -= prefix;
> +	}
> +
> +	words = bytes / 8;
> +
> +	while (words) {
> +		if (*(u64 *)start != value64)
> +			return check_bytes8(start, value, 8);
> +		start += 8;
> +		words--;
> +	}
> +
> +	return check_bytes8(start, value, bytes % 8);
> +}
> +
> static void restore_bytes(struct kmem_cache *s, char *message, u8 data,
> 						void *from, void *to)
> {
> -- 
> 1.7.5.3
>
>
