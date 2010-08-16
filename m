Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab0HPLFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 07:05:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53690 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab0HPLFw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 07:05:52 -0400
Subject: Re: [RFC][PATCH] Per file dirty limit throttling
From: Peter Zijlstra <peterz@infradead.org>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Wu Fengguang <fengguang.wu@intel.com>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
In-Reply-To: <201008160949.51512.knikanth@suse.de>
References: <201008160949.51512.knikanth@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 16 Aug 2010 13:05:42 +0200
Message-ID: <1281956742.1926.1217.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 09:49 +0530, Nikanth Karthikesan wrote:
> When the total dirty pages exceed vm_dirty_ratio, the dirtier is made to do
> the writeback. But this dirtier may not be the one who took the system to this
> state. Instead, if we can track the dirty count per-file, we could throttle
> the dirtier of a file, when the file's dirty pages exceed a certain limit.
> Even though this dirtier may not be the one who dirtied the other pages of
> this file, it is fair to throttle this process, as it uses that file.
> 
> This patch
> 1. Adds dirty page accounting per-file.
> 2. Exports the number of pages of this file in cache and no of pages dirty via
> proc-fdinfo.
> 3. Adds a new tunable, /proc/sys/vm/file_dirty_bytes. When a files dirty data
> exceeds this limit, the writeback of that inode is done by the current
> dirtier.
> 
> This certainly will affect the throughput of certain heavy-dirtying workloads,
> but should help for interactive systems.

I'm not really charmed by this.. it adds another random variable to prod
at. Nor does it really tell me why you're wanting to do this. We already
have per-task invluence on the dirty limits, a task that sporadically
dirties pages (your vi) will already end up with a higher dirty limit
than a task that only dirties pages (your dd).

> diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
> index b606c2c..4f8bc06 100644
> --- a/Documentation/sysctl/vm.txt
> +++ b/Documentation/sysctl/vm.txt
> @@ -133,6 +133,15 @@ Setting this to zero disables periodic writeback altogether.
>  
>  ==============================================================
>  
> +file_dirty_bytes
> +
> +When a files total dirty data exceeds file_dirty_bytes, the current generator
> +of dirty data would be made to do the writeback of dirty pages of that file.
> +
> +0 disables this behaviour.
> +
> +==============================================================
> +
>  drop_caches
>  
>  Writing to this will cause the kernel to drop clean caches, dentries and

> diff --git a/fs/read_write.c b/fs/read_write.c
> index 74e3658..8881b7d 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -16,6 +16,8 @@
>  #include <linux/syscalls.h>
>  #include <linux/pagemap.h>
>  #include <linux/splice.h>
> +#include <linux/buffer_head.h>
> +#include <linux/writeback.h>
>  #include "read_write.h"
>  
>  #include <asm/uaccess.h>
> @@ -414,9 +416,19 @@ SYSCALL_DEFINE3(write, unsigned int, fd, const char __user *, buf,
>  
>  	file = fget_light(fd, &fput_needed);
>  	if (file) {
> +		struct address_space *as = file->f_mapping;
> +		unsigned long file_dirty_pages;
>  		loff_t pos = file_pos_read(file);
> +
>  		ret = vfs_write(file, buf, count, &pos);
>  		file_pos_write(file, pos);
> +		/* Start write-out ? */
> +		if (file_dirty_bytes) {
> +			file_dirty_pages = file_dirty_bytes / PAGE_SIZE;
> +			if (as->nrdirty > file_dirty_pages)
> +				write_inode_now(as->host, 0);
> +		}
> +
>  		fput_light(file, fput_needed);
>  	}


This seems wrong, wth are you doing it here and not in the generic
balance_dirty_pages thing called by set_page_dirty()?


> diff --git a/mm/memory.c b/mm/memory.c
> index 9606ceb..0961f70 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2873,6 +2873,7 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  	struct vm_fault vmf;
>  	int ret;
>  	int page_mkwrite = 0;
> +	unsigned long file_dirty_pages;
>  
>  	vmf.virtual_address = (void __user *)(address & PAGE_MASK);
>  	vmf.pgoff = pgoff;
> @@ -3024,6 +3025,13 @@ out:
>  		/* file_update_time outside page_lock */
>  		if (vma->vm_file)
>  			file_update_time(vma->vm_file);
> +
> +		/* Start write-back ? */
> +		if (mapping && file_dirty_bytes) {
> +			file_dirty_pages = file_dirty_bytes / PAGE_SIZE;
> +			if (mapping->nrdirty > file_dirty_pages)
> +				write_inode_now(mapping->host, 0);
> +		}
>  	} else {
>  		unlock_page(vmf.page);
>  		if (anon)

Idem, replicating that code at every site that can dirty a page is just
wrong, hook into the regular set_page_dirty()->balance_dirty_pages()
code.

> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 20890d8..1cabd7f 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -87,6 +87,13 @@ int vm_dirty_ratio = 20;
>  unsigned long vm_dirty_bytes;
>  
>  /*
> + * When a files total dirty data exceeds file_dirty_bytes, the current generator
> + * of dirty data would be made to do the writeback of dirty pages of that file.
> + * 0 disables this behaviour.
> + */
> +unsigned long file_dirty_bytes = 0;

So you're adding a extra cacheline to dirty even though its not used by
default, that seems like suckage..


> @@ -1126,6 +1137,7 @@ void account_page_dirtied(struct page *page, struct address_space *mapping)
>  {
>  	if (mapping_cap_account_dirty(mapping)) {
>  		__inc_zone_page_state(page, NR_FILE_DIRTY);
> +		mapping->nrdirty++;
>  		__inc_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
>  		task_dirty_inc(current);
>  		task_io_account_write(PAGE_CACHE_SIZE);
> @@ -1301,6 +1313,7 @@ int clear_page_dirty_for_io(struct page *page)
>  		 */
>  		if (TestClearPageDirty(page)) {
>  			dec_zone_page_state(page, NR_FILE_DIRTY);
> +			mapping->nrdirty--;
>  			dec_bdi_stat(mapping->backing_dev_info,
>  					BDI_RECLAIMABLE);
>  			return 1;
> diff --git a/mm/truncate.c b/mm/truncate.c
> index ba887bf..5846d6a 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -75,6 +75,7 @@ void cancel_dirty_page(struct page *page, unsigned int account_size)
>  		struct address_space *mapping = page->mapping;
>  		if (mapping && mapping_cap_account_dirty(mapping)) {
>  			dec_zone_page_state(page, NR_FILE_DIRTY);
> +			mapping->nrdirty--;
>  			dec_bdi_stat(mapping->backing_dev_info,
>  					BDI_RECLAIMABLE);
>  			if (account_size)


Preferably we don't add any extra fields under tree_lock so that we can
easily split it up if/when we decide to use a fine-grain locked radix
tree.

Also, like mentioned, you just added a whole new cacheline to dirty.
