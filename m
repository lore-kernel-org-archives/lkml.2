Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab0ELAFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 20:05:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733Ab0ELAFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 20:05:21 -0400
Date: Tue, 11 May 2010 20:13:48 -0400
From: Josef Bacik <josef@redhat.com>
To: Josef Bacik <josef@redhat.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, hch@infradead.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 3/5] direct-io: honor dio->boundary a little more
	strictly
Message-ID: <20100512001347.GB27011@dhcp231-156.rdu.redhat.com>
References: <20100507174104.GD3360@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100507174104.GD3360@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 01:41:04PM -0400, Josef Bacik wrote:
> Because BTRFS needs to be able to lookup checksums when we submit the bio's, we
> need to be able to look up the logical offset in the inode we're submitting the
> bio for.  The way we do this is in our get_blocks function is return the map_bh
> with b_blocknr of the logical offset in the file, and then in the submit path
> turn that into an actual block number on the device.  This causes problems with
> the DIO stuff since it will try and merge requests that look like they are
> contiguous, even though they are not actually contiguous on disk.  So BTRFS sets
> buffer_boundary on the map_bh.  Unfortunately if there is not a bio already
> setup in the DIO stuff, dio->boundary gets cleared and then the next time a
> request is made they will get merged.  So instead of clearing dio->boundary in
> dio_new_bio, save the boundary value before doing anything, that way if
> dio->boundary gets cleared, we still submit the IO.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/direct-io.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index 2dbf2e9..98f6f42 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -615,6 +615,7 @@ static int dio_bio_add_page(struct dio *dio)
>   */
>  static int dio_send_cur_page(struct dio *dio)
>  {
> +	int boundary = dio->boundary;
>  	int ret = 0;
>  
>  	if (dio->bio) {
> @@ -627,7 +628,7 @@ static int dio_send_cur_page(struct dio *dio)
>  		 * Submit now if the underlying fs is about to perform a
>  		 * metadata read
>  		 */
> -		if (dio->boundary)
> +		if (boundary)
>  			dio_bio_submit(dio);
>  	}
>  
> @@ -644,6 +645,8 @@ static int dio_send_cur_page(struct dio *dio)
>  			ret = dio_bio_add_page(dio);
>  			BUG_ON(ret != 0);
>  		}
> +	} else if (boundary) {
> +		dio_bio_submit(dio);
>  	}
>  out:
>  	return ret;

Self-NACK on this one.  Seems to have an unwanted side-effect of forcing every
page to be submitted individually.  I'm going to fix this a different way.
Thanks,

Josef
