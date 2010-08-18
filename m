Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab0HRCHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 22:07:11 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53570 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab0HRCHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 22:07:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 18 Aug 2010 11:02:00 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: jovi zhang <bookjovi@gmail.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, hughd@google.com,
        riel@redhat.com, minchan.kim@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: code improvement of check_stack_guard_page
Message-Id: <20100818110200.ff5b5615.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTinfgXOzbqgrRY4oCGXFtKtEyJO_rvQeeEEeEZz7@mail.gmail.com>
References: <AANLkTinfgXOzbqgrRY4oCGXFtKtEyJO_rvQeeEEeEZz7@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Aug 2010 13:07:56 +0800
jovi zhang <bookjovi@gmail.com> wrote:

> little code improvement of check_stack_guard_page function.
> this commit is on top of commit "mm: keep a guard page below a grow-down
> stack segment" of linus.
> 

Hmm. difference in binary code finally ?

-Kame

> diff --git a/mm/memory.c b/mm/memory.c
> index 9b3b73f..643b112 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2768,13 +2768,15 @@ out_release:
>   */
>  static inline int check_stack_guard_page(struct vm_area_struct *vma,
> unsigned long address)
>  {
> -       address &= PAGE_MASK;
> -       if ((vma->vm_flags & VM_GROWSDOWN) && address == vma->vm_start) {
> -               address -= PAGE_SIZE;
> -               if (find_vma(vma->vm_mm, address) != vma)
> -                       return -ENOMEM;
> -
> -               expand_stack(vma, address);
> +       if (vma->vm_flags & VM_GROWSDOWN) {
> +               address &= PAGE_MASK;
> +               if(address == vma->vm_start) {
> +                       address -= PAGE_SIZE;
> +                       if (unlikely(find_vma(vma->vm_mm, address) != vma))
> +                               return -ENOMEM;
> +
> +                       expand_stack(vma, address);
> +               }
>         }
>         return 0;
>  }

