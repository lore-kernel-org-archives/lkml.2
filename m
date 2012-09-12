Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760533Ab2ILQnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:43:09 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35974 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760498Ab2ILQnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:43:04 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Maxim Patlasov <mpatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@openvz.org
Subject: Re: [PATCH 5/6] fuse: rework fuse_perform_write()
References: <20120907172536.1343.80497.stgit@maximpc.sw.ru>
	<20120907174145.1343.35017.stgit@maximpc.sw.ru>
Date: Wed, 12 Sep 2012 18:44:33 +0200
In-Reply-To: <20120907174145.1343.35017.stgit@maximpc.sw.ru> (Maxim Patlasov's
	message of "Fri, 07 Sep 2012 21:41:49 +0400")
Message-ID: <87oblbw5qm.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim Patlasov <mpatlasov@parallels.com> writes:

> The patch allocates as many page pointers in fuse_req as needed to cover
> interval [pos .. pos+len-1]. FUSE_WR_PAGES macro is introduced to hide this
> cumbersome arithmetics.

Please don't ever use a macro for something which you can use an inline
function.

> ---
>  fs/fuse/file.c |   15 +++++++++++----
>  1 files changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 9a6dcc6..84cc83c 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -815,7 +815,8 @@ static size_t fuse_send_write_pages(struct fuse_req *req, struct file *file,
>  
>  static ssize_t fuse_fill_write_pages(struct fuse_req *req,
>  			       struct address_space *mapping,
> -			       struct iov_iter *ii, loff_t pos)
> +			       struct iov_iter *ii, loff_t pos,
> +			       unsigned nr_pages)
>  {
>  	struct fuse_conn *fc = get_fuse_conn(mapping->host);
>  	unsigned offset = pos & (PAGE_CACHE_SIZE - 1);
> @@ -875,11 +876,16 @@ static ssize_t fuse_fill_write_pages(struct fuse_req *req,
>  		if (!fc->big_writes)
>  			break;
>  	} while (iov_iter_count(ii) && count < fc->max_write &&
> -		 req->num_pages < FUSE_MAX_PAGES_PER_REQ && offset == 0);
> +		 req->num_pages < nr_pages && offset == 0);
>  
>  	return count > 0 ? count : err;
>  }
>  
> +#define FUSE_WR_PAGES(pos, len) min_t(unsigned,				      \
> +				      ((pos + len - 1) >> PAGE_CACHE_SHIFT) - \
> +				      (pos >> PAGE_CACHE_SHIFT) + 1,	      \
> +				      FUSE_MAX_PAGES_PER_REQ)
> +
>  static ssize_t fuse_perform_write(struct file *file,
>  				  struct address_space *mapping,
>  				  struct iov_iter *ii, loff_t pos)
> @@ -895,14 +901,15 @@ static ssize_t fuse_perform_write(struct file *file,
>  	do {
>  		struct fuse_req *req;
>  		ssize_t count;
> +		unsigned nr_pages = FUSE_WR_PAGES(pos, iov_iter_count(ii));
>  
> -		req = fuse_get_req_multipage(fc, FUSE_MAX_PAGES_PER_REQ);
> +		req = fuse_get_req_multipage(fc, nr_pages);
>  		if (IS_ERR(req)) {
>  			err = PTR_ERR(req);
>  			break;
>  		}
>  
> -		count = fuse_fill_write_pages(req, mapping, ii, pos);
> +		count = fuse_fill_write_pages(req, mapping, ii, pos, nr_pages);
>  		if (count <= 0) {
>  			err = count;
>  		} else {
