Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab0EWGFv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 02:05:51 -0400
Received: from smtp-out.google.com ([74.125.121.35]:35143 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab0EWGFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 02:05:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=to:cc:subject:references:from:date:in-reply-to:message-id:
	user-agent:mime-version:content-type;
	b=tgmebvTkOwcxoJQrC7Ccu/84brpVeCewoiYQE8Wt+EOGt8nAeAB03Bwhi9+hEoWuR
	eRh7ZN8SzJMVMlfezxT0w==
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Kennedy <richard@rsk.demon.co.uk>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>, lkml <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Jeff Mahoney <jeffm@suse.com>,
       reiserfs-devel@vger.kernel.org
Subject: Re: [PATCH RFC]  buffer_head: remove redundant test from wait_on_buffer
References: <1271415499.2075.19.camel@localhost>
	<20100416145123.283f216c.akpm@linux-foundation.org>
From: Greg Thelen <gthelen@google.com>
Date: Sat, 22 May 2010 23:05:03 -0700
In-Reply-To: <20100416145123.283f216c.akpm@linux-foundation.org> (Andrew Morton's message of "Fri\, 16 Apr 2010 14\:51\:23 -0700")
Message-ID: <xr93ljbbw3u8.fsf@ninji.mtv.corp.google.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 16 Apr 2010 11:58:19 +0100
> Richard Kennedy <richard@rsk.demon.co.uk> wrote:
>
>> The comment suggests that when b_count equals zero it is calling
>> __wait_no_buffer to trigger some debug, but as there is no debug in
>> __wait_on_buffer the whole thing is redundant.
>> 
>> AFAICT from the git log this has been the case for at least 5 years, so
>> it seems safe just to remove this.
>> 
>> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
>> ---
>> 
>> This patch against 2.6.34-rc4
>> compiled & tested on x86_64
>> 
>> regards
>> Richard
>> 
>> 
>> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
>> index 16ed028..4c62dd4 100644
>> --- a/include/linux/buffer_head.h
>> +++ b/include/linux/buffer_head.h
>> @@ -305,15 +305,10 @@ map_bh(struct buffer_head *bh, struct super_block *sb, sector_t block)
>>  	bh->b_size = sb->s_blocksize;
>>  }
>>  
>> -/*
>> - * Calling wait_on_buffer() for a zero-ref buffer is illegal, so we call into
>> - * __wait_on_buffer() just to trip a debug check.  Because debug code in inline
>> - * functions is bloaty.
>> - */
>>  static inline void wait_on_buffer(struct buffer_head *bh)
>>  {
>>  	might_sleep();
>> -	if (buffer_locked(bh) || atomic_read(&bh->b_count) == 0)
>> +	if (buffer_locked(bh))
>>  		__wait_on_buffer(bh);
>>  }
>
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

My system is failing this VM_BUG_ON() occasionally.  I think this is due to
wait_on_buffer() calls with b_count=0 from locations within fs/buffer.c.  These
occasional b_count=0 callers are caused by buf reads that complete quickly -
after the I/O is issued but before it is waited upon.  Such fs/buffer.c callers
need to either bypass this assertion or increment b_count.  I don't think they
need to grab an b_count reference.  I suggest a bypass routine in the patch
below.  Does this look good?

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

From: Greg Thelen <gthelen@google.com>

Introduce new routine for waiting on buffers with zero b_count.

In limited cases it is expected that a buffer can have a zero b_count but
still be protected from reclamation.  Waiting on such buffers with
wait_on_buffer() risks failure of the b_count assertion.  To avoid failing
the b_count assertion in the normal wait_on_buffer() path, this patch
introduces a new routine, __wait_on_buffer_unsafe(), for the few cases
that wait on a buffer which may have a zero b_count.  wait_on_buffer()
indirectly asserts that b_count is non-zero.  This assertion is
generally useful, but causes problems for a few cases in fs/buffer.c:
* __block_prepare_write()
* nobh_write_begin()
* block_truncate_page()

Without this patch I found that a virtual machine would occasionally
fail the __wait_on_buffer() b_count assertion when called from
__block_prepare_write().  Visual inspection suggests that the other two
routines could also fail the same b_count assertion.  So all three
routines now make use of the new __wait_on_buffer_unsafe() routine,
which avoids asserting b_count.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 fs/buffer.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 2500ada..c715da4 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -92,21 +92,30 @@ void unlock_buffer(struct buffer_head *bh)
 EXPORT_SYMBOL(unlock_buffer);
 
 /*
+ * Block until a buffer comes unlocked.  This routine trusts the caller to
+ * ensure that the buffer will not be reclaimed.  Holding a b_count reference is
+ * one way, page lock is another.
+ */
+static void __wait_on_buffer_unsafe(struct buffer_head *bh)
+{
+	might_sleep();
+	wait_on_bit(&bh->b_state, BH_Lock, sync_buffer, TASK_UNINTERRUPTIBLE);
+}
+
+/*
  * Block until a buffer comes unlocked.  This doesn't stop it
  * from becoming locked again - you have to lock it yourself
  * if you want to preserve its state.
  */
 void __wait_on_buffer(struct buffer_head * bh)
 {
-	might_sleep();
-
 	/*
 	 * Calling wait_on_buffer() against a zero-ref buffer is a nasty bug
 	 * because it will almost always "work".  However this buffer can be
 	 * reclaimed at any time.  So check for it.
 	 */
 	VM_BUG_ON(atomic_read(&bh->b_count) == 0);
-	wait_on_bit(&bh->b_state, BH_Lock, sync_buffer, TASK_UNINTERRUPTIBLE);
+	__wait_on_buffer_unsafe(bh);
 }
 EXPORT_SYMBOL(__wait_on_buffer);
 
@@ -1934,7 +1943,7 @@ static int __block_prepare_write(struct inode *inode, struct page *page,
 	 * If we issued read requests - let them complete.
 	 */
 	while(wait_bh > wait) {
-		wait_on_buffer(*--wait_bh);
+		__wait_on_buffer_unsafe(*--wait_bh);
 		if (!buffer_uptodate(*wait_bh))
 			err = -EIO;
 	}
@@ -2603,7 +2612,7 @@ int nobh_write_begin(struct file *file, struct address_space *mapping,
 		 * for the buffer_head refcounts.
 		 */
 		for (bh = head; bh; bh = bh->b_this_page) {
-			wait_on_buffer(bh);
+			__wait_on_buffer_unsafe(bh);
 			if (!buffer_uptodate(bh))
 				ret = -EIO;
 		}
@@ -2865,7 +2874,7 @@ int block_truncate_page(struct address_space *mapping,
 	if (!buffer_uptodate(bh) && !buffer_delay(bh) && !buffer_unwritten(bh)) {
 		err = -EIO;
 		ll_rw_block(READ, 1, &bh);
-		wait_on_buffer(bh);
+		__wait_on_buffer_unsafe(bh);
 		/* Uhhuh. Read error. Complain and punt. */
 		if (!buffer_uptodate(bh))
 			goto unlock;
-- 
1.7.0.1
