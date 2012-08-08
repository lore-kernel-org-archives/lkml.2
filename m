Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030406Ab2HHQB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 12:01:29 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47207 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030325Ab2HHQB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 12:01:28 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Maxim Patlasov <mpatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@openvz.org
Subject: Re: [PATCH 1/4] fuse: add basic support of iovec[] to fuse_req
References: <20120720114653.15517.74290.stgit@maximpc.sw.ru>
	<20120720115015.15517.5557.stgit@maximpc.sw.ru>
Date: Wed, 08 Aug 2012 18:02:47 +0200
In-Reply-To: <20120720115015.15517.5557.stgit@maximpc.sw.ru> (Maxim Patlasov's
	message of "Fri, 20 Jul 2012 15:50:23 +0400")
Message-ID: <87zk65id7c.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim Patlasov <mpatlasov@parallels.com> writes:

> The patch allows fuse_req to refer to array of iovec-s describing
> layout of user-data over req->pages. fuse_copy_pages() is re-worked to
> support both cased: former layout where pages[] corresponded to <buf, len>
> and newer one where pages[] corresponds to iovec[].
>
> Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
> ---
>  fs/fuse/dev.c    |   52 +++++++++++++++++++++++++++++++++++++++++++++++++---
>  fs/fuse/fuse_i.h |   12 ++++++++++--
>  2 files changed, 59 insertions(+), 5 deletions(-)
>
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index 7df2b5e..cdae525 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -850,9 +850,9 @@ static int fuse_copy_page(struct fuse_copy_state *cs, struct page **pagep,
>  	return 0;
>  }
>  
> -/* Copy pages in the request to/from userspace buffer */
> -static int fuse_copy_pages(struct fuse_copy_state *cs, unsigned nbytes,
> -			   int zeroing)
> +/* Start from addr(pages[0]) + page_offset. No holes in the middle. */
> +static int fuse_copy_pages_for_buf(struct fuse_copy_state *cs, unsigned nbytes,
> +				   int zeroing)
>  {
>  	unsigned i;
>  	struct fuse_req *req = cs->req;
> @@ -874,6 +874,52 @@ static int fuse_copy_pages(struct fuse_copy_state *cs, unsigned nbytes,
>  	return 0;
>  }
>  
> +/* Take iov_offset as offset in iovec[0]. Iterate based on iovec[].iov_len */
> +static int fuse_copy_pages_for_iovec(struct fuse_copy_state *cs,
> +				     unsigned nbytes, int zeroing)
> +{
> +	unsigned i;
> +	struct fuse_req *req = cs->req;
> +	const struct iovec *iov = req->iovec;
> +	unsigned iov_offset = req->iov_offset;
> +
> +	for (i = 0; i < req->num_pages && (nbytes || zeroing); i++) {
> +		int err;
> +		unsigned long user_addr = (unsigned long)iov->iov_base +
> +					  iov_offset;
> +		unsigned offset = user_addr & ~PAGE_MASK;
> +		unsigned count = min_t(size_t, PAGE_SIZE - offset,
> +				       iov->iov_len - iov_offset);

It would be much cleaner if we didn't have to deal with the original
iovec here, but only offset and length relative to the page.

I understand that that would mean allocating an array for these.  In the
other thread I mentioned the possibility of allocating the page array.
Instead of a page array, we could have an array of (pageptr, offset,
len) which would simplify the whole thing.

Thanks,
Miklos
