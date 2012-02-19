Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab2BSVVf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 16:21:35 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52259 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927Ab2BSVVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 16:21:34 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of hughd@google.com designates 10.68.241.70 as permitted sender) smtp.mail=hughd@google.com; dkim=pass header.i=hughd@google.com
Date: Sun, 19 Feb 2012 13:21:02 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] thp: optimize away unnecessary page table locking
In-Reply-To: <1328716302-16871-3-git-send-email-n-horiguchi@ah.jp.nec.com>
Message-ID: <alpine.LSU.2.00.1202191316320.1466@eggly.anvils>
References: <1328716302-16871-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1328716302-16871-3-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Feb 2012, Naoya Horiguchi wrote:
> Currently when we check if we can handle thp as it is or we need to
> split it into regular sized pages, we hold page table lock prior to
> check whether a given pmd is mapping thp or not. Because of this,
> when it's not "huge pmd" we suffer from unnecessary lock/unlock overhead.
> To remove it, this patch introduces a optimized check function and
> replace several similar logics with it.
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: David Rientjes <rientjes@google.com>
> 
> Changes since v4:
>   - Rethink returned value of __pmd_trans_huge_lock()

[snip]

> --- 3.3-rc2.orig/mm/mremap.c
> +++ 3.3-rc2/mm/mremap.c
> @@ -155,8 +155,6 @@ unsigned long move_page_tables(struct vm_area_struct *vma,
>  			if (err > 0) {
>  				need_flush = true;
>  				continue;
> -			} else if (!err) {
> -				split_huge_page_pmd(vma->vm_mm, old_pmd);
>  			}
>  			VM_BUG_ON(pmd_trans_huge(*old_pmd));
>  		}

Is that what you intended to do there?
I just hit that VM_BUG_ON on rc3-next-20120217.

Hugh
