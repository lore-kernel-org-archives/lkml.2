Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423428Ab2KNVFE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 16:05:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37938 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505Ab2KNVFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 16:05:01 -0500
Date: Wed, 14 Nov 2012 13:05:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scatterlist: don't BUG when we can trivially return a
 proper error.
Message-Id: <20121114130500.250dd5b8.akpm@linux-foundation.org>
In-Reply-To: <1351796580-20600-1-git-send-email-nbowler@elliptictech.com>
References: <1351796580-20600-1-git-send-email-nbowler@elliptictech.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  1 Nov 2012 15:03:00 -0400
Nick Bowler <nbowler@elliptictech.com> wrote:

> There is absolutely no reason to crash the kernel when we have a
> perfectly good return value already available to use for conveying
> failure status.

Yes, I suppose that's true.  I don't see a case for BUGging the kernel
here.

> Let's return an error code instead of crashing the kernel: that sounds
> like a much better plan.
> 
> Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
> ---
>  lib/scatterlist.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/scatterlist.c b/lib/scatterlist.c
> index 3675452b23ca..11ecaf000696 100644
> --- a/lib/scatterlist.c
> +++ b/lib/scatterlist.c
> @@ -248,7 +248,8 @@ int __sg_alloc_table(struct sg_table *table, unsigned int nents,
>  	unsigned int left;
>  
>  #ifndef ARCH_HAS_SG_CHAIN
> -	BUG_ON(nents > max_ents);
> +	if (WARN_ON_ONCE(nents > max_ents))
> +		return -E2BIG;
>  #endif

OK, pet peeve: if this E2BIG gets returned to userspace, our poor user
will look it up and see "Argument list too long; used when the
arguments passed to a new program being executed with one of the exec
functions occupy too much memory space".  He then gets to spend half a
day reviewing his code's exec() callsites!

See?  Although the error's name sounds like a nice match to the
internal state, it isn't really a match at all and our use of it is
misleading.

Unfortunately there is no EKERNELSCREWEDUP, so we usually use EINVAL.
