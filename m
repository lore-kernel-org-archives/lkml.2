Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab1G0VK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:10:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753839Ab1G0VK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:10:56 -0400
Date: Wed, 27 Jul 2011 14:10:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Keith Packard" <keithp@keithp.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: fault_in_pages_writeable/fault_in_pages_readable don't fault in
 everything
Message-Id: <20110727141053.51646796.akpm@linux-foundation.org>
In-Reply-To: <yunr55zf9sr.fsf@aiko.keithp.com>
References: <yunr55zf9sr.fsf@aiko.keithp.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 09 Jul 2011 14:01:24 -0700
"Keith Packard" <keithp@keithp.com> wrote:

> 
> fault_in_pages_writeable and fault_in_pages_readable are only willing to
> fault two pages at the most. I can't find any place where this is a good
> idea, and in fact ntfs has replaced fault_in_pages_readable with a
> private version which does the right thing.
> 
> Here's an (untested) patch which makes fault_in_pages_writeable hit
> every page instead of just the first and last. It seems like this might
> improve performance of larger read operations which may now end up
> taking the slow path when an intermediate page is faulted in
> __copy_to_user_inatomic.
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 716875e..f355f29 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -418,7 +418,13 @@ static inline int fault_in_pages_writeable(char __user *uaddr, int size)
>  	 * Writing zeroes into userspace here is OK, because we know that if
>  	 * the zero gets there, we'll be overwriting it.
>  	 */
> -	ret = __put_user(0, uaddr);
> +	for (;;) {
> +		ret = __put_user(0, uaddr);
> +		if (size < PAGE_SIZE)
> +			break;
> +		size -= PAGE_SIZE;
> +		uaddr += PAGE_SIZE;
> +	}
>  	if (ret == 0) {
>  		char __user *end = uaddr + size - 1;

I worry a bit about the "Writing zeroes into userspace here is OK,
because we know that if the zero gets there, we'll be overwriting it"
thing.  As we're now dealing with multiple pages I suspect there will
be scenarios in whcih the subsequent copy_to_user() will fail and we'll
be left having written a sprinkle of zeroes into userspace while
falsely telling userspace that the affected memory was unaltered (via a
short return from read()).

Should we alter fault_in_pages_readable() to match?

The functions are getting too large for inlining.  Perhaps make them
non-static inline in filemap.c so the most common callsite inlines it
as well as generating an out-of-line copy.  The compiler might uninline
it anyway in that case without addition of funky compiler options, but
it's a hot path in the read() and write() cases, so effort here is
warranted.

Extra marks for removing the custom code in ntfs.

More extra marks for designing the code in such a way that the
newly-added code gets elided by the compiler in the single-page cases
in filemap.c.

Even more extra marks for testing it ;)
