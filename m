Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861Ab1FVUOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 16:14:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:11756 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758022Ab1FVUOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 16:14:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,407,1304319600"; 
   d="scan'208";a="16997429"
Message-ID: <4E024D2D.6070308@linux.intel.com>
Date: Wed, 22 Jun 2011 13:14:37 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, peterz@infradead.org,
        eric.dumazet@gmail.com, david@rgmadvisors.com,
        linux-kernel@vger.kernel.org, zvonler@rgmadvisors.com,
        hughd@google.com, tglx@linutronix.de, mingo@elte.hu
Subject: Re: [PATCH RFC] futex: Fix regression with read only mappings
References: <4DF8FFF6.4060000@linux.intel.com> <1308770340-21895-1-git-send-email-sbohrer@rgmadvisors.com>
In-Reply-To: <1308770340-21895-1-git-send-email-sbohrer@rgmadvisors.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shawn,

Thanks for taking this up. Would you share your testcases as well?

On 06/22/2011 12:19 PM, Shawn Bohrer wrote:
> commit 7485d0d3758e8e6491a5c9468114e74dc050785d (futexes: Remove rw
> parameter from get_futex_key()) in 2.6.33 introduced a user-mode
> regression in that it additionally prevented futex operations on a
> region within a read only memory mapped file.  For example this breaks
> workloads that have one or more reader processes doing a FUTEX_WAIT on a
> futex within a read only shared mapping, and a writer processes that has
> a writable mapping issuing the FUTEX_WAKE.
> 
> This fixes the regression for futex operations that should be valid on
> RO mappings by trying a RO get_user_pages_fast() when the RW
> get_user_pages_fast() fails so as not to slow down the common path of
> writable anonymous maps and bailing when we used the RO path on
> anonymous memory.
> 
> Patch based on Peter Zijlstra's initial patch with modifications to only
> allow RO mappings for futex operations that need VERIFY_READ access.
> 
> Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
> ---
> 
> Interestingly this patch also allows doing a FUTEX_WAIT on a RO private
> mapping.

I don't see any harm in this.

>  Where my tests on 2.6.18 show that this used to wait
> indefinitely.  Performing a FUTEX_WAIT on a RW private mapping waits
> indefinitely in 2.6.18, 3.0.0, and with this patch applied.  It is
> unclear to me if this is a good thing or a bug.
> 
>  kernel/futex.c |   38 ++++++++++++++++++++++++++------------
>  1 files changed, 26 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index fe28dc2..e8cd532 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -218,6 +218,8 @@ static void drop_futex_key_refs(union futex_key *key)
>   * @uaddr:	virtual address of the futex
>   * @fshared:	0 for a PROCESS_PRIVATE futex, 1 for PROCESS_SHARED
>   * @key:	address where result is stored.
> + * @rw:		mapping needs to be read/write (values: VERIFY_READ,
> + *		VERIFY_WRITE)
>   *


I'm OK with this, but ideally I I'd prefer fshared and rw be replaced
with flags. We already have a FLAGS_SHARED, adding a FLAGS_WRITE would
be simple, and most call sites could be updated to send the bare flags
rather than a logical and with FLAGS_SHARED as they do now.


>   * Returns a negative error code or 0
>   * The key words are stored in *key on success.
> @@ -229,12 +231,12 @@ static void drop_futex_key_refs(union futex_key *key)
>   * lock_page() might sleep, the caller should not hold a spinlock.
>   */
>  static int
> -get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
> +get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, int rw)
>  {
>  	unsigned long address = (unsigned long)uaddr;
>  	struct mm_struct *mm = current->mm;
>  	struct page *page, *page_head;
> -	int err;
> +	int err, ro = 0;
>  
>  	/*
>  	 * The futex address must be "naturally" aligned.
> @@ -262,6 +264,10 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
>  
>  again:
>  	err = get_user_pages_fast(address, 1, 1, &page);
> +	if (err == -EFAULT && rw == VERIFY_READ) {
> +		err = get_user_pages_fast(address, 1, 0, &page);

I verified this is correct .... we ran into a little trouble a while
back mixing up the parameters of get_user_pages_fast. This is correct :)

> +		ro = 1;
> +	}
>  	if (err < 0)
>  		return err;
>  
> @@ -316,6 +322,11 @@ again:
>  	 * the object not the particular process.
>  	 */
>  	if (PageAnon(page_head)) {
> +		if (ro) {
> +			err = -EFAULT;
> +			goto out;
> +		}

This if block needs a comment as to why RO anonymous pages trigger a
failure. In fact... I thought you said with this patch FUTEX_WAIT waits
indefinitely on RO private mappings? This test suggests that it
shouldn't. Are you testing this via glibc pthread_mutexes? If so, and if
I remember correctly, glibc loops forever on -EFAULT here, unfortunately.

> +
>  		key->both.offset |= FUT_OFF_MMSHARED; /* ref taken on mm */
>  		key->private.mm = mm;
>  		key->private.address = address;
> @@ -327,9 +338,11 @@ again:
>  
>  	get_futex_key_refs(key);
>  
> +	err = 0;

Shouldn't this be 0 anyway? If it was non-zero, you would have jumped to
out: earlier, right?

<snip/>

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
