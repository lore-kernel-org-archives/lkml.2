Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab0IOAYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 20:24:47 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34002 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab0IOAYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 20:24:46 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [PATCH] After swapout/swapin private dirty mappings become clean
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        balbir@linux.vnet.ibm.com, rguenther@novell.com, matz@novell.com
In-Reply-To: <201009141640.55650.knikanth@suse.de>
References: <201009141640.55650.knikanth@suse.de>
Message-Id: <20100915092239.C9D9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 15 Sep 2010 09:24:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Why can't gdb check Swap: field in smaps? I think Swap!=0 mean we need dump out.

Am I missing anything?

 - kosaki

> 
> Export this information in smaps by prepending file-names with "[anon]+", when
> some of the pages in a file backed vma become anonymous.
> 
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
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 



