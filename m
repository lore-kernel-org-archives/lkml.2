Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab1HVUwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 16:52:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51606 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753884Ab1HVUwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 16:52:34 -0400
Date: Mon, 22 Aug 2011 13:52:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Joern Engel <joern@logfs.org>, logfs@logfs.org,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-arch@vger.kernel.org
Subject: Re: [PATCH 3/4] string: introduce memchr_inv
Message-Id: <20110822135218.f2d9f462.akpm@linux-foundation.org>
In-Reply-To: <1314030548-21082-4-git-send-email-akinobu.mita@gmail.com>
References: <1314030548-21082-1-git-send-email-akinobu.mita@gmail.com>
	<1314030548-21082-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Aug 2011 01:29:07 +0900
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> memchr_inv() is mainly used to check whether the whole buffer is filled
> with just a specified byte.
> 
> The function name and prototype are stolen from logfs and the
> implementation is from SLUB.
> 
> ...
>
> +/**
> + * memchr_inv - Find a character in an area of memory.
> + * @s: The memory area
> + * @c: The byte to search for
> + * @n: The size of the area.

This text seems to be stolen from memchr().  I guess it's close enough.

> + * returns the address of the first character other than @c, or %NULL
> + * if the whole buffer contains just @c.
> + */
> +void *memchr_inv(const void *start, int c, size_t bytes)
> +{
> +	u8 value = c;
> +	u64 value64;
> +	unsigned int words, prefix;
> +
> +	if (bytes <= 16)
> +		return check_bytes8(start, value, bytes);
> +
> +	value64 = value | value << 8 | value << 16 | value << 24;
> +	value64 = (value64 & 0xffffffff) | value64 << 32;
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

OK, problem.  This will explode if passed a misaligned address on
certain (non-x86) architectures.  This is nasty because people will
develop and test code on x86 and it works.  Much later, the
alpha/ia64/etc guys discover the problem.

One fix would be to use get_unaligned().  This might be slow on some
architectures, I don't know.  Another fix is to restrict the caller's
alignment freedom; document this and add a runtime WARN_ON().

> +			return check_bytes8(start, value, 8);
> +		start += 8;
> +		words--;
> +	}
> +
> +	return check_bytes8(start, value, bytes % 8);
> +}
> +EXPORT_SYMBOL(memchr_inv);

