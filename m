Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab0IPQ4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 12:56:50 -0400
Received: from smtp-out.google.com ([216.239.44.51]:36679 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab0IPQ4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 12:56:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=EUPp4I+q5WYA71ND2cSXC1okz8W55qiKAus35Aw5D2/LxZ34zCoHr4asmtsocF6MA
	MIK8C4NPlOXytFPXuBTDw==
Date: Thu, 16 Sep 2010 09:56:35 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hughd@tigran.mtv.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Nikanth Karthikesan <knikanth@suse.de>, Matt Mackall <mpm@selenic.com>,
        Richard Guenther <rguenther@suse.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Matz <matz@novell.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smaps: fix dirty pages accounting
In-Reply-To: <20100916153420.3BBD.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1009160950500.24798@tigran.mtv.corp.google.com>
References: <20100916125147.CA08.A69D9226@jp.fujitsu.com> <201009161135.00129.knikanth@suse.de> <20100916153420.3BBD.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010, KOSAKI Motohiro wrote:

> Currently, /proc/<pid>/smaps have wrong dirty pages accounting.
> Shared_Dirty and Private_Dirty output only pte dirty pages and
> ignore PG_dirty page flag. It is difference against documentation,
> but also inconsistent against Referenced field. (Referenced checks
> both pte and page flags)
> 
> This patch fixes it.
> 
> Test program:
> 
>  large-array.c
>  ---------------------------------------------------
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
>  #include <unistd.h>
> 
>  char array[1*1024*1024*1024L];
> 
>  int main(void)
>  {
>          memset(array, 1, sizeof(array));
>          pause();
> 
>          return 0;
>  }
>  ---------------------------------------------------
> 
> Test case:
>  1. run ./large-array
>  2. cat /proc/`pidof large-array`/smaps
>  3. swapoff -a
>  4. cat /proc/`pidof large-array`/smaps again
> 
> Test result:
>  <before patch>
> 
> 00601000-40601000 rw-p 00000000 00:00 0
> Size:            1048576 kB
> Rss:             1048576 kB
> Pss:             1048576 kB
> Shared_Clean:          0 kB
> Shared_Dirty:          0 kB
> Private_Clean:    218992 kB   <-- showed pages as clean incorrectly
> Private_Dirty:    829584 kB
> Referenced:       388364 kB
> Swap:                  0 kB
> KernelPageSize:        4 kB
> MMUPageSize:           4 kB
> 
>  <after patch>
> 
> 00601000-40601000 rw-p 00000000 00:00 0
> Size:            1048576 kB
> Rss:             1048576 kB
> Pss:             1048576 kB
> Shared_Clean:          0 kB
> Shared_Dirty:          0 kB
> Private_Clean:         0 kB
> Private_Dirty:   1048576 kB  <-- fixed
> Referenced:       388480 kB
> Swap:                  0 kB
> KernelPageSize:        4 kB
> MMUPageSize:           4 kB
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Certainly you can have my

Acked-by: Hugh Dickins <hughd@google.com>

but I think it's for Matt to decide what he's wanting to show there,
and whether it's safe to change after all this time.  I hadn't noticed
the descrepancy between "dirty" and "referenced", that certainly argues
for your patch.

> ---
>  fs/proc/task_mmu.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 439fc1f..7415f13 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -362,13 +362,13 @@ static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  			mss->referenced += PAGE_SIZE;
>  		mapcount = page_mapcount(page);
>  		if (mapcount >= 2) {
> -			if (pte_dirty(ptent))
> +			if (pte_dirty(ptent) || PageDirty(page))
>  				mss->shared_dirty += PAGE_SIZE;
>  			else
>  				mss->shared_clean += PAGE_SIZE;
>  			mss->pss += (PAGE_SIZE << PSS_SHIFT) / mapcount;
>  		} else {
> -			if (pte_dirty(ptent))
> +			if (pte_dirty(ptent) || PageDirty(page))
>  				mss->private_dirty += PAGE_SIZE;
>  			else
>  				mss->private_clean += PAGE_SIZE;
> -- 
> 1.6.5.2
