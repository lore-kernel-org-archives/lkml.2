Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab2HYMrn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 08:47:43 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:43871 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756608Ab2HYMri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 08:47:38 -0400
MIME-Version: 1.0
In-Reply-To: <20120823171854.580076595@de.ibm.com>
References: <20120823171733.595087166@de.ibm.com>
	<20120823171854.580076595@de.ibm.com>
Date: Sat, 25 Aug 2012 20:47:37 +0800
Message-ID: <CAJd=RBBJa934R53AHYVhkxE+2e=RiKU1zJXsLMCBFw_NHZE0oQ@mail.gmail.com>
Subject: Re: [RFC patch 3/7] thp: make MADV_HUGEPAGE check for mm->def_flags
From: Hillf Danton <dhillf@gmail.com>
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org,
        ak@linux.intel.com, hughd@google.com, linux-kernel@vger.kernel.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 1:17 AM, Gerald Schaefer
<gerald.schaefer@de.ibm.com> wrote:
> This adds a check to hugepage_madvise(), to refuse MADV_HUGEPAGE
> if VM_NOHUGEPAGE is set in mm->def_flags. On System z, the VM_NOHUGEPAGE
> flag will be set in mm->def_flags for kvm processes, to prevent any
> future thp mappings. In order to also prevent MADV_HUGEPAGE on such an
> mm, hugepage_madvise() should check mm->def_flags.
>
> Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> ---
>  mm/huge_memory.c |    4 ++++
>  1 file changed, 4 insertions(+)
>
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1464,6 +1464,8 @@ out:
>  int hugepage_madvise(struct vm_area_struct *vma,
>                      unsigned long *vm_flags, int advice)
>  {
> +       struct mm_struct *mm = vma->vm_mm;
> +
>         switch (advice) {
>         case MADV_HUGEPAGE:
>                 /*
> @@ -1471,6 +1473,8 @@ int hugepage_madvise(struct vm_area_stru
>                  */
>                 if (*vm_flags & (VM_HUGEPAGE | VM_NO_THP))
>                         return -EINVAL;
> +               if (mm->def_flags & VM_NOHUGEPAGE)
> +                       return -EINVAL;

Looks ifdefinery needed for s390 to wrap the added check, and
a brief comment?

>                 *vm_flags &= ~VM_NOHUGEPAGE;
>                 *vm_flags |= VM_HUGEPAGE;
