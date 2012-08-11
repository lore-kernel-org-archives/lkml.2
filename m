Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab2HKLPV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 07:15:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:4334 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294Ab2HKLPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 07:15:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,749,1336374000"; 
   d="scan'208";a="184974495"
From: Andi Kleen <andi@firstfloor.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi.kleen@intel.com>, Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Rik van Riel <riel@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Naoya Horiguchi <nhoriguc@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] HWPOISON: improve handling/reporting of memory error on dirty pagecache
References: <1344634913-13681-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1344634913-13681-4-git-send-email-n-horiguchi@ah.jp.nec.com>
Date: Sat, 11 Aug 2012 04:15:06 -0700
In-Reply-To: <1344634913-13681-4-git-send-email-n-horiguchi@ah.jp.nec.com>
	(Naoya Horiguchi's message of "Fri, 10 Aug 2012 17:41:53 -0400")
Message-ID: <m21ujdd6it.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:

I'm sceptical on the patch, but here's my review.

>   - return -EHWPOISON when we access to the error-affected address with
>     read(), partial-page write(), fsync(),

Note that a lot of user space does not like new errnos (nothing in
strerror etc.). It's probably better to reuse some existing errno.

> @@ -270,6 +273,9 @@ int filemap_fdatawait_range(struct address_space *mapping, loff_t start_byte,
>  	if (end_byte < start_byte)
>  		return 0;
>  
> +	if (unlikely(hwpoison_file_range(mapping, start_byte, end_byte)))
> +		return -EHWPOISON;
> +

That function uses a global lock. fdatawait is quite common. This will
likely cause performance problems in IO workloads.

You need to get that lock out of the hot path somehow.

Probably better to try to put the data into a existing data structure,
or if you cannot do that you would need some way to localize the lock.

Or at least make it conditional of hwpoison errors being around. 


>  	pagevec_init(&pvec, 0);
>  	while ((index <= end) &&
>  			(nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
> @@ -369,6 +375,16 @@ int filemap_write_and_wait_range(struct address_space *mapping,
>  				err = err2;
>  		}
>  	}
> +
> +	/*
> +	 * When AS_HWPOISON is set, dirty page with memory error is
> +	 * removed from pagecache and mapping->nrpages is decreased by 1.
> +	 * So in order to detect memory error on single page file, we need
> +	 * to check AS_HWPOISON bit outside if(mapping->nrpages) block below.
> +	 */
> +	if (unlikely(hwpoison_file_range(mapping, lstart, lend)))
> +		return -EHWPOISON;

Same here.
>  					ra, filp, page,
> @@ -2085,6 +2123,9 @@ inline int generic_write_checks(struct file *file, loff_t *pos, size_t *count, i
>          if (unlikely(*pos < 0))
>                  return -EINVAL;
>  
> +	if (unlikely(hwpoison_partial_write(file->f_mapping, *pos, *count)))
> +		return -EHWPOISON;

Same here.
> +
> +		/*
> +		 * Memory error is reported to userspace by AS_HWPOISON flags
> +		 * in mapping->flags. The mechanism is similar to that of
> +		 * AS_EIO, but we have separete flags because there'are two
> +		 * differences between them:
> +		 *  1. Expected userspace handling. When user processes get
> +		 *     -EIO, they can retry writeback hoping the error in IO
> +		 *     devices is temporary, switch to write to other devices,
> +		 *     or do some other application-specific handling.
> +		 *     For -EHWPOISON, we can clear the error by overwriting
> +		 *     the corrupted page.
> +		 *  2. When to clear. For -EIO, we can think that we recover
> +		 *     from the error when writeback succeeds. For -EHWPOISON
> +		 *     OTOH, we can see that things are back to normal when
> +		 *     corrupted data are overwritten from user buffer.
> +		 */
> +		hwp = kmalloc(sizeof(struct hwp_dirty), GFP_ATOMIC);

You need to check the return value, especially for GFP_ATOMIC which is
common to fail

> +		hwp->page = p;
> +		hwp->fpage = NULL;
> +		hwp->mapping = mapping;
> +		hwp->index = page_index(p);
> +		hwp->ino = inode->i_ino;
> +		hwp->dev = inode->i_sb->s_dev;
> +		add_hwp_dirty(hwp);

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
