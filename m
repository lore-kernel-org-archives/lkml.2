Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab0FSMgb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 08:36:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:43841 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602Ab0FSMga convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 08:36:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NW95tis7OStmFlSEHtjNRNcEzDdDEVSL1lgPiE3VsgcA3rkJZN/bNP5l6+ScHPZQaQ
         SDdmjfZYytVzv3P2K25pBCtZAkiTdhgz+hxUBJoYd04SykDyPNtIp54YKJU33VXyo4L+
         IBQfEPWEbstoFRdJ/cV9fuqFCAv4AzewjVvxU=
MIME-Version: 1.0
In-Reply-To: <20091208211647.9B032B151F@basil.firstfloor.org>
References: <200912081016.198135742@firstfloor.org>
	<20091208211647.9B032B151F@basil.firstfloor.org>
Date: Sat, 19 Jun 2010 14:36:28 +0200
X-Google-Sender-Auth: xxkGIXZ11VzsZOqOTO0M7F4rSno
Message-ID: <AANLkTimBhQAYn7BDXd1ykSN90v0ClWybIe2Pe1qv_6vA@mail.gmail.com>
Subject: Re: [PATCH] [31/31] HWPOISON: Add a madvise() injector for soft page 
	offlining
From: Michael Kerrisk <mtk.manpages@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: fengguang.wu@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Michael Kerrisk <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Tue, Dec 8, 2009 at 11:16 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> Process based injection is much easier to handle for test programs,
> who can first bring a page into a specific state and then test.
> So add a new MADV_SOFT_OFFLINE to soft offline a page, similar
> to the existing hard offline injector.

I see that this made its way into 2.6.33. Could you write a short
piece on it for the madvise.2 man page?

Thanks,

Michael


> Signed-off-by: Andi Kleen <ak@linux.intel.com>
>
> ---
>  include/asm-generic/mman-common.h |    1 +
>  mm/madvise.c                      |   15 ++++++++++++---
>  2 files changed, 13 insertions(+), 3 deletions(-)
>
> Index: linux/include/asm-generic/mman-common.h
> ===================================================================
> --- linux.orig/include/asm-generic/mman-common.h
> +++ linux/include/asm-generic/mman-common.h
> @@ -35,6 +35,7 @@
>  #define MADV_DONTFORK  10              /* don't inherit across fork */
>  #define MADV_DOFORK    11              /* do inherit across fork */
>  #define MADV_HWPOISON  100             /* poison a page for testing */
> +#define MADV_SOFT_OFFLINE 101          /* soft offline page for testing */
>
>  #define MADV_MERGEABLE   12            /* KSM may merge identical pages */
>  #define MADV_UNMERGEABLE 13            /* KSM may not merge identical pages */
> Index: linux/mm/madvise.c
> ===================================================================
> --- linux.orig/mm/madvise.c
> +++ linux/mm/madvise.c
> @@ -9,6 +9,7 @@
>  #include <linux/pagemap.h>
>  #include <linux/syscalls.h>
>  #include <linux/mempolicy.h>
> +#include <linux/page-isolation.h>
>  #include <linux/hugetlb.h>
>  #include <linux/sched.h>
>  #include <linux/ksm.h>
> @@ -222,7 +223,7 @@ static long madvise_remove(struct vm_are
>  /*
>  * Error injection support for memory error handling.
>  */
> -static int madvise_hwpoison(unsigned long start, unsigned long end)
> +static int madvise_hwpoison(int bhv, unsigned long start, unsigned long end)
>  {
>        int ret = 0;
>
> @@ -233,6 +234,14 @@ static int madvise_hwpoison(unsigned lon
>                int ret = get_user_pages_fast(start, 1, 0, &p);
>                if (ret != 1)
>                        return ret;
> +               if (bhv == MADV_SOFT_OFFLINE) {
> +                       printk(KERN_INFO "Soft offlining page %lx at %lx\n",
> +                               page_to_pfn(p), start);
> +                       ret = soft_offline_page(p, MF_COUNT_INCREASED);
> +                       if (ret)
> +                               break;
> +                       continue;
> +               }
>                printk(KERN_INFO "Injecting memory failure for page %lx at %lx\n",
>                       page_to_pfn(p), start);
>                /* Ignore return value for now */
> @@ -333,8 +342,8 @@ SYSCALL_DEFINE3(madvise, unsigned long,
>        size_t len;
>
>  #ifdef CONFIG_MEMORY_FAILURE
> -       if (behavior == MADV_HWPOISON)
> -               return madvise_hwpoison(start, start+len_in);
> +       if (behavior == MADV_HWPOISON || behavior == MADV_SOFT_OFFLINE)
> +               return madvise_hwpoison(behavior, start, start+len_in);
>  #endif
>        if (!madvise_behavior_valid(behavior))
>                return error;
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
