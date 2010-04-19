Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab0DSIoh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 04:44:37 -0400
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:47683 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752855Ab0DSIof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 04:44:35 -0400
Subject: Re: [PATCH RFC]  buffer_head: remove redundant test from
 wait_on_buffer
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>, lkml <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Jeff Mahoney <jeffm@suse.com>,
       reiserfs-devel@vger.kernel.org
In-Reply-To: <20100416145123.283f216c.akpm@linux-foundation.org>
References: <1271415499.2075.19.camel@localhost>
	 <20100416145123.283f216c.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 09:44:30 +0100
Message-ID: <1271666670.2049.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-16 at 14:51 -0700, Andrew Morton wrote:

> That debug check got inadvertently crippled during some wait_on_bit()
> conversion.
> 
> It's still a nasty bug to call wait_on_buffer() against a zero-ref
> buffer so perhaps we should fix it up rather than removing its remains.
> 
> diff -puN include/linux/buffer_head.h~buffer_head-remove-redundant-test-from-wait_on_buffer-fix include/linux/buffer_head.h
> --- a/include/linux/buffer_head.h~buffer_head-remove-redundant-test-from-wait_on_buffer-fix
> +++ a/include/linux/buffer_head.h
> @@ -305,10 +305,15 @@ map_bh(struct buffer_head *bh, struct su
>  	bh->b_size = sb->s_blocksize;
>  }
>  
> +/*
> + * Calling wait_on_buffer() for a zero-ref buffer is illegal, so we call into
> + * __wait_on_buffer() just to trip a debug check.  Because debug code in inline
> + * functions is bloaty.
> + */
>  static inline void wait_on_buffer(struct buffer_head *bh)
>  {
>  	might_sleep();
> -	if (buffer_locked(bh))
> +	if (buffer_locked(bh) || atomic_read(&bh->b_count) == 0)
>  		__wait_on_buffer(bh);
>  }
>  
> diff -puN fs/buffer.c~buffer_head-remove-redundant-test-from-wait_on_buffer-fix fs/buffer.c
> --- a/fs/buffer.c~buffer_head-remove-redundant-test-from-wait_on_buffer-fix
> +++ a/fs/buffer.c
> @@ -90,6 +90,12 @@ EXPORT_SYMBOL(unlock_buffer);
>   */
>  void __wait_on_buffer(struct buffer_head * bh)
>  {
> +	/*
> +	 * Calling wait_on_buffer() against a zero-ref buffer is a nasty bug
> +	 * because it will almost always "work".  However this buffer can be
> +	 * reclaimed at any time.  So check for it.
> +	 */
> +	VM_BUG_ON(atomic_read(&bh->b_count) == 0);
>  	wait_on_bit(&bh->b_state, BH_Lock, sync_buffer, TASK_UNINTERRUPTIBLE);
>  }
>  EXPORT_SYMBOL(__wait_on_buffer);
> _
> 
> 
> And while we're there...
> 
> This might make reiserfs explode.
> 
> 
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> The first thing __wait_on_buffer()->wait_on_bit() does is to test that the
> bit was set, so the buffer_locked() test is now redundant.  And once we
> remove that, we can remove the check for zero ->b_count also.
> 
> And now that wait_on_buffer() unconditionally calls __wait_on_buffer(), we
> can move the might_sleep() check into __wait_on_buffer() to save some text.
> 
> The downside of all of this is that wait_on_buffer() against an unlocked
> buffer will now always perform a function call.  Is it a common case?
> 
> We can remove __wait_on_buffer() altogether now.  For some strange reason
> reiserfs calls __wait_on_buffer() directly.  Maybe it's passing in
> zero-ref buffers.  If so, we'll get warnings now and shall need to look at
> that.
> 
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Cc: Nick Piggin <nickpiggin@yahoo.com.au>
> Cc: Richard Kennedy <richard@rsk.demon.co.uk>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/buffer.c                 |    2 ++
>  include/linux/buffer_head.h |    4 +---
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff -puN include/linux/buffer_head.h~wait_on_buffer-remove-the-buffer_locked-test include/linux/buffer_head.h
> --- a/include/linux/buffer_head.h~wait_on_buffer-remove-the-buffer_locked-test
> +++ a/include/linux/buffer_head.h
> @@ -312,9 +312,7 @@ map_bh(struct buffer_head *bh, struct su
>   */
>  static inline void wait_on_buffer(struct buffer_head *bh)
>  {
> -	might_sleep();
> -	if (buffer_locked(bh) || atomic_read(&bh->b_count) == 0)
> -		__wait_on_buffer(bh);
> +	__wait_on_buffer(bh);
>  }
>  
>  static inline int trylock_buffer(struct buffer_head *bh)
> diff -puN fs/buffer.c~wait_on_buffer-remove-the-buffer_locked-test fs/buffer.c
> --- a/fs/buffer.c~wait_on_buffer-remove-the-buffer_locked-test
> +++ a/fs/buffer.c
> @@ -90,6 +90,8 @@ EXPORT_SYMBOL(unlock_buffer);
>   */
>  void __wait_on_buffer(struct buffer_head * bh)
>  {
> +	might_sleep();
> +
>  	/*
>  	 * Calling wait_on_buffer() against a zero-ref buffer is a nasty bug
>  	 * because it will almost always "work".  However this buffer can be
> _
> 
Hi Andrew,
I've tested your patches against 2.6.34-rc4 on lvm/ext4. I'm not seeing
any vm bugs, so it all looks good to me.
thanks
Richard


