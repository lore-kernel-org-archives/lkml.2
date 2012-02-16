Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750991Ab2BPMdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 07:33:53 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37287 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab2BPMdw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 07:33:52 -0500
MIME-Version: 1.0
In-Reply-To: <1329366240-11663-3-git-send-email-david@gibson.dropbear.id.au>
References: <1329366240-11663-1-git-send-email-david@gibson.dropbear.id.au>
	<1329366240-11663-3-git-send-email-david@gibson.dropbear.id.au>
Date: Thu, 16 Feb 2012 20:33:51 +0800
Message-ID: <CAJd=RBAK-iTs6HfNm+Lv_5GKPbQfpALgYCgB+mitXUPofJ1gtA@mail.gmail.com>
Subject: Re: [PATCH 2/2] hugepages: Fix use after free bug in "quota" handling
From: Hillf Danton <dhillf@gmail.com>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: akpm@linux-foundation.org, abarry@cray.com, hughd@google.com,
        mgorman@suse.de, minchan.kim@gmail.com, paulus@samba.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 12:24 PM, David Gibson
<david@gibson.dropbear.id.au> wrote:
> @@ -1046,12 +1124,12 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
>        if (!page) {
>                page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
>                if (!page) {
> -                       hugetlb_put_quota(inode->i_mapping, chg);
> +                       hugepage_subpool_put_pages(spool, chg);
>                        return ERR_PTR(-VM_FAULT_SIGBUS);
>                }
>        }
>
> -       set_page_private(page, (unsigned long) mapping);
> +       set_page_private(page, (unsigned long)spool);
>

Page mapping is used in unmap_ref_private(), and I am
wondering it no longer works:-(

> @@ -2392,7 +2471,8 @@ retry_avoidcopy:
>
>        /* Drop page_table_lock as buddy allocator may be called */
>        spin_unlock(&mm->page_table_lock);
> -       new_page = alloc_huge_page(vma, address, outside_reserve);
> +       new_page = alloc_huge_page(vma, address, outside_reserve,
> +                                  subpool_vma(vma));

Change in the number of parameters of alloc_huge_page()
looks unnecessary.
