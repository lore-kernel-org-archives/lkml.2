Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395Ab2ICMpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 08:45:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45007 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756070Ab2ICMpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 08:45:49 -0400
Date: Mon, 3 Sep 2012 14:45:48 +0200
From: Jan Kara <jack@suse.cz>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org,
        Ashish Sangwan <ashish.sangwan2@gmail.com>
Subject: Re: [PATCH] udf: add writepages support for udf
Message-ID: <20120903124548.GF21109@quack.suse.cz>
References: <1346431747-3581-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346431747-3581-1-git-send-email-linkinjeon@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 31-08-12 12:49:07, Namjae Jeon wrote:
> Use mpage_writepages() instead of multiple calls to udf_writepage()
> to make performance higher.
> 
> *Write Speed with writepage() =
>  RecSize     ReadSpeed    WriteSpeed  RanReadSpeed RanWriteSpeed
> 10485760    0.00MB/sec    8.56MB/sec    0.00MB/sec    8.20MB/sec
>  1048576    0.00MB/sec    8.57MB/sec    0.00MB/sec    6.42MB/sec
>   524288    0.00MB/sec    8.59MB/sec    0.00MB/sec    5.24MB/sec
>   262144    0.00MB/sec    8.59MB/sec    0.00MB/sec    4.17MB/sec
>   131072    0.00MB/sec    8.53MB/sec    0.00MB/sec    3.32MB/sec
>    65536    0.00MB/sec    8.49MB/sec    0.00MB/sec    2.31MB/sec
> 
> *Write Speed with writepages()
> RecSize     ReadSpeed    WriteSpeed  RanReadSpeed RanWriteSpeed
> 10485760    0.00MB/sec    9.88MB/sec    0.00MB/sec    9.60MB/sec
>  1048576    0.00MB/sec    9.95MB/sec    0.00MB/sec    7.52MB/sec
>   524288    0.00MB/sec    9.98MB/sec    0.00MB/sec    6.16MB/sec
>   262144    0.00MB/sec    9.90MB/sec    0.00MB/sec    4.98MB/sec
>   131072    0.00MB/sec    9.89MB/sec    0.00MB/sec    3.78MB/sec
>    65536    0.00MB/sec    9.81MB/sec    0.00MB/sec    2.50MB/sec
> 
> There is about 1.4MB/sec speed improvement over 8.5MB/sec,
> whcih comes out around 16% improvement.
  Nice. I've added the patch to my tree. Thanks.

								Honza
> 
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> Signed-off-by: Ashish Sangwan <ashish.sangwan2@gmail.com>
> ---
>  fs/udf/inode.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
> index aa23346..1a0588e 100644
> --- a/fs/udf/inode.c
> +++ b/fs/udf/inode.c
> @@ -100,6 +100,12 @@ static int udf_writepage(struct page *page, struct writeback_control *wbc)
>  	return block_write_full_page(page, udf_get_block, wbc);
>  }
>  
> +static int udf_writepages(struct address_space *mapping,
> +			struct writeback_control *wbc)
> +{
> +	return mpage_writepages(mapping, wbc, udf_get_block);
> +}
> +
>  static int udf_readpage(struct file *file, struct page *page)
>  {
>  	return mpage_readpage(page, udf_get_block);
> @@ -145,6 +151,7 @@ const struct address_space_operations udf_aops = {
>  	.readpage	= udf_readpage,
>  	.readpages	= udf_readpages,
>  	.writepage	= udf_writepage,
> +	.writepages	= udf_writepages,
>  	.write_begin		= udf_write_begin,
>  	.write_end		= generic_write_end,
>  	.bmap		= udf_bmap,
> -- 
> 1.7.9.5
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
