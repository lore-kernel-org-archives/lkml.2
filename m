Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab1K2AQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 19:16:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58305 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab1K2AQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 19:16:28 -0500
Date: Mon, 28 Nov 2011 16:16:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Youquan Song <youquan.song@intel.com>
Cc: linux-kernel@vger.kernel.org, aarcange@redhat.com, wli@holomorphy.com,
        david.woodhouse@intel.com, allen.m.kay@intel.com, mtosatti@redhat.com,
        chrisw@redhat.com, andi@firstfloor.org, chaohong.guo@intel.com,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH 1/2] thp: Add compound tail page _mapcount when mapped
Message-Id: <20111128161626.e4be400a.akpm@linux-foundation.org>
In-Reply-To: <1322200030-26350-1-git-send-email-youquan.song@intel.com>
References: <1322200030-26350-1-git-send-email-youquan.song@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Nov 2011 13:47:09 +0800
Youquan Song <youquan.song@intel.com> wrote:

> With 3.2-rc kernel, the IOMMU 2M page in KVM works. While I try to us IOMMU
> 1GB page in KVM, I encounter a oops and 1GB page total fail to be used.
> The root cause is that 1GB page allocation calls gup_huge_pud() while 2M
>  page calls gup_huge_pmd. If compound pages are used and the page is tail page,
> gup_huge_pmd increase _mapcount to record tail page are mapped while
> gup_huge_pud does not include this process. So when the mapped page is relesed,
> it will result in kernel oops because the page does not mark mapped.
> 
> This patch add tail process for compound page in 1GB huge page which keeps the
> same process as 2M page.
> 
> Reproduce like:
> 1. Add grub boot option: hugepagesz=1G hugepages=8
> 2. mount -t hugetlbfs -o pagesize=1G hugetlbfs /dev/hugepages
> 3.qemu-kvm -m 2048 -hda os-kvm.img -cpu kvm64 -smp 4 -mem-path /dev/hugepages
>  -net none -device pci-assign,host=07:00.1
> 
> kernel BUG at mm/swap.c:114!
>
> ...
>
> --- a/arch/x86/mm/gup.c
> +++ b/arch/x86/mm/gup.c
> @@ -201,6 +201,8 @@ static noinline int gup_huge_pud(pud_t pud, unsigned long addr,
>  	do {
>  		VM_BUG_ON(compound_head(page) != head);
>  		pages[*nr] = page;
> +		if (PageTail(page))
> +			get_huge_page_tail(page);
>  		(*nr)++;
>  		page++;
>  		refs++;

Is the patch also applicable to 3.1.x?
