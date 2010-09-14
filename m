Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab0INLeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 07:34:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:58365 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715Ab0INLeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 07:34:02 -0400
Date: Tue, 14 Sep 2010 13:33:59 +0200 (CEST)
From: Richard Guenther <rguenther@suse.de>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        balbir@linux.vnet.ibm.com, Michael Matz <matz@novell.com>,
        Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] After swapout/swapin private dirty mappings become
 clean
In-Reply-To: <201009141640.55650.knikanth@suse.de>
Message-ID: <alpine.LNX.2.00.1009141330030.28912@zhemvz.fhfr.qr>
References: <201009141640.55650.knikanth@suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010, Nikanth Karthikesan wrote:

> /proc/$pid/smaps broken: After swapout/swapin private dirty mappings become
> clean.
> 
> When a page with private file mapping becomes dirty, the vma will be in both
> i_mmap tree and anon_vma list. The /proc/$pid/smaps will account these pages
> as dirty and backed by the file.
> 
> But when those dirty pages gets swapped out, and when they are read back from
> swap, they would be marked as clean, as it should be, as they are part of swap
> cache now.
> 
> But the /proc/$pid/smaps would report the vma as a mapping of a file and it is
> clean. The pages are actually in same state i.e., dirty with respect to file
> still, but which was once reported as dirty is now being reported as clean to
> user-space.
> 
> This confuses tools like gdb which uses this information. Those tools think
> that those pages were never modified and it creates problem when they create
> dumps.
> 
> The file mapping of the vma also cannot be broken as pages never read earlier,
> will still have to come from the file. Just that those dirty pages have become
> clean anonymous pages.
> 
> During swaping in, restoring the exact state as dirty file-backed pages before
> swapout would be useless, as there in no real bug. Breaking the vma with only
> anonymous pages as seperate vmas unnecessary may not be a good thing as well.
> So let us just export the information that a file-backed vma has anonymous
> dirty pages.
> 
> Export this information in smaps by prepending file-names with "[anon]+", when
> some of the pages in a file backed vma become anonymous.

For the sake of not breaking existing tools I'd prefer appending
" [anon]" instead.

Though a much simpler thing would be to account
the clean anon pages as Private_Dirty (with respect to the backing
file displayed).  Anonymous vmas in /proc/smaps seem to contain
Private_Dirty pages as well.  So I still don't understand why this
isn't just an accounting bug.

Thanks,
Richard.

> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> 
> ---
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 439fc1f..68f9806 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -242,6 +242,8 @@ static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
>  	 */
>  	if (file) {
>  		pad_len_spaces(m, len);
> +		if (vma->anon_vma)
> +			seq_puts(m, "[anon]+");
>  		seq_path(m, &file->f_path, "\n");
>  	} else {
>  		const char *name = arch_vma_name(vma);
> 
> 
> 

-- 
Richard Guenther <rguenther@suse.de>
Novell / SUSE Labs
SUSE LINUX Products GmbH - Nuernberg - AG Nuernberg - HRB 16746 - GF: Markus Rex
