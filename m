Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab0DPVvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 17:51:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48532 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932523Ab0DPVvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 17:51:54 -0400
Date: Fri, 16 Apr 2010 14:51:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>, lkml <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Jeff Mahoney <jeffm@suse.com>,
       reiserfs-devel@vger.kernel.org
Subject: Re: [PATCH RFC]  buffer_head: remove redundant test from
 wait_on_buffer
Message-Id: <20100416145123.283f216c.akpm@linux-foundation.org>
In-Reply-To: <1271415499.2075.19.camel@localhost>
References: <1271415499.2075.19.camel@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Apr 2010 11:58:19 +0100
Richard Kennedy <richard@rsk.demon.co.uk> wrote:

> The comment suggests that when b_count equals zero it is calling
> __wait_no_buffer to trigger some debug, but as there is no debug in
> __wait_on_buffer the whole thing is redundant.
> 
> AFAICT from the git log this has been the case for at least 5 years, so
> it seems safe just to remove this.
> 
> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
> ---
> 
> This patch against 2.6.34-rc4
> compiled & tested on x86_64
> 
> regards
> Richard
> 
> 
> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
> index 16ed028..4c62dd4 100644
> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -305,15 +305,10 @@ map_bh(struct buffer_head *bh, struct super_block *sb, sector_t block)
>  	bh->b_size = sb->s_blocksize;
>  }
>  
> -/*
> - * Calling wait_on_buffer() for a zero-ref buffer is illegal, so we call into
> - * __wait_on_buffer() just to trip a debug check.  Because debug code in inline
> - * functions is bloaty.
> - */
>  static inline void wait_on_buffer(struct buffer_head *bh)
>  {
>  	might_sleep();
> -	if (buffer_locked(bh) || atomic_read(&bh->b_count) == 0)
> +	if (buffer_locked(bh))
>  		__wait_on_buffer(bh);
>  }

That debug check got inadvertently crippled during some wait_on_bit()
conversion.

It's still a nasty bug to call wait_on_buffer() against a zero-ref
buffer so perhaps we should fix it up rather than removing its remains.

diff -puN include/linux/buffer_head.h~buffer_head-remove-redundant-test-from-wait_on_buffer-fix include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~buffer_head-remove-redundant-test-from-wait_on_buffer-fix
+++ a/include/linux/buffer_head.h
@@ -305,10 +305,15 @@ map_bh(struct buffer_head *bh, struct su
 	bh->b_size = sb->s_blocksize;
 }
 
+/*
+ * Calling wait_on_buffer() for a zero-ref buffer is illegal, so we call into
+ * __wait_on_buffer() just to trip a debug check.  Because debug code in inline
+ * functions is bloaty.
+ */
 static inline void wait_on_buffer(struct buffer_head *bh)
 {
 	might_sleep();
-	if (buffer_locked(bh))
+	if (buffer_locked(bh) || atomic_read(&bh->b_count) == 0)
 		__wait_on_buffer(bh);
 }
 
diff -puN fs/buffer.c~buffer_head-remove-redundant-test-from-wait_on_buffer-fix fs/buffer.c
--- a/fs/buffer.c~buffer_head-remove-redundant-test-from-wait_on_buffer-fix
+++ a/fs/buffer.c
@@ -90,6 +90,12 @@ EXPORT_SYMBOL(unlock_buffer);
  */
 void __wait_on_buffer(struct buffer_head * bh)
 {
+	/*
+	 * Calling wait_on_buffer() against a zero-ref buffer is a nasty bug
+	 * because it will almost always "work".  However this buffer can be
+	 * reclaimed at any time.  So check for it.
+	 */
+	VM_BUG_ON(atomic_read(&bh->b_count) == 0);
 	wait_on_bit(&bh->b_state, BH_Lock, sync_buffer, TASK_UNINTERRUPTIBLE);
 }
 EXPORT_SYMBOL(__wait_on_buffer);
_


And while we're there...

This might make reiserfs explode.



From: Andrew Morton <akpm@linux-foundation.org>

The first thing __wait_on_buffer()->wait_on_bit() does is to test that the
bit was set, so the buffer_locked() test is now redundant.  And once we
remove that, we can remove the check for zero ->b_count also.

And now that wait_on_buffer() unconditionally calls __wait_on_buffer(), we
can move the might_sleep() check into __wait_on_buffer() to save some text.

The downside of all of this is that wait_on_buffer() against an unlocked
buffer will now always perform a function call.  Is it a common case?

We can remove __wait_on_buffer() altogether now.  For some strange reason
reiserfs calls __wait_on_buffer() directly.  Maybe it's passing in
zero-ref buffers.  If so, we'll get warnings now and shall need to look at
that.

Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Richard Kennedy <richard@rsk.demon.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |    2 ++
 include/linux/buffer_head.h |    4 +---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/buffer_head.h~wait_on_buffer-remove-the-buffer_locked-test include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~wait_on_buffer-remove-the-buffer_locked-test
+++ a/include/linux/buffer_head.h
@@ -312,9 +312,7 @@ map_bh(struct buffer_head *bh, struct su
  */
 static inline void wait_on_buffer(struct buffer_head *bh)
 {
-	might_sleep();
-	if (buffer_locked(bh) || atomic_read(&bh->b_count) == 0)
-		__wait_on_buffer(bh);
+	__wait_on_buffer(bh);
 }
 
 static inline int trylock_buffer(struct buffer_head *bh)
diff -puN fs/buffer.c~wait_on_buffer-remove-the-buffer_locked-test fs/buffer.c
--- a/fs/buffer.c~wait_on_buffer-remove-the-buffer_locked-test
+++ a/fs/buffer.c
@@ -90,6 +90,8 @@ EXPORT_SYMBOL(unlock_buffer);
  */
 void __wait_on_buffer(struct buffer_head * bh)
 {
+	might_sleep();
+
 	/*
 	 * Calling wait_on_buffer() against a zero-ref buffer is a nasty bug
 	 * because it will almost always "work".  However this buffer can be
_

