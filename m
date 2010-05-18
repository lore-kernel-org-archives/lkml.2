Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab0ERJeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 05:34:09 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37494 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab0ERJeD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 05:34:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kNHqDZu0h1X8kZGFLh4g/5Qj048q7XaKyp1sMueWZ5BC2swcK4NcJQKjAxMc2IduqL
         /IUSoDBjdQATTziQ+KUIgTSJOsgJ13gj7lTlillMqMZX8uIyl0l6jX4qhRDA2Kbl+XQu
         twI0xzYCeNO8pyb9gwmNk8cYfxgZi+ERLET/c=
MIME-Version: 1.0
In-Reply-To: <1270125903-6004-5-git-send-email-suokkos@gmail.com>
References: <1270125903-6004-1-git-send-email-suokkos@gmail.com>
	 <1270125903-6004-5-git-send-email-suokkos@gmail.com>
Date: Tue, 18 May 2010 19:34:01 +1000
Message-ID: <AANLkTilyGz86DlwOvtVolthE66VzkSwj9jDv0s138Egi@mail.gmail.com>
Subject: Re: [PATCH 5/7] arch/x86: Add array variants for setting memory to wc 
	caching.
From: Dave Airlie <airlied@gmail.com>
To: Pauli Nieminen <suokkos@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 1, 2010 at 10:45 PM, Pauli Nieminen <suokkos@gmail.com> wrote:
> Setting single memory pages at a time to wc takes a lot time in cache flush. To
> reduce number of cache flush set_pages_array_wc and set_memory_array_wc can be
> used to set multiple pages to WC with single cache flush.
>
> This improves allocation performance for wc cached pages in drm/ttm.
>

I've got this in drm-next for quite a while and almost forgot about
it, I'm meant to be on holidays and I'd really like to just have Linus
pull my tree,

I had only one issue with this as we had some problems with doing it
before but it looks like they've since been fixed in the x86 pat code
a kernel or two ago so this patch should be fine now.

its been well tested in drm-next on AGP machines by the author,

any objections to this?

Dave.

> CC: Suresh Siddha <suresh.b.siddha@intel.com>
> CC: Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>
> Signed-off-by: Pauli Nieminen <suokkos@gmail.com>
> ---
>  arch/x86/include/asm/cacheflush.h |    2 +
>  arch/x86/mm/pageattr.c            |   53 +++++++++++++++++++++++++++++++-----
>  2 files changed, 47 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
> index 634c40a..d92d63a 100644
> --- a/arch/x86/include/asm/cacheflush.h
> +++ b/arch/x86/include/asm/cacheflush.h
> @@ -139,9 +139,11 @@ int set_memory_np(unsigned long addr, int numpages);
>  int set_memory_4k(unsigned long addr, int numpages);
>
>  int set_memory_array_uc(unsigned long *addr, int addrinarray);
> +int set_memory_array_wc(unsigned long *addr, int addrinarray);
>  int set_memory_array_wb(unsigned long *addr, int addrinarray);
>
>  int set_pages_array_uc(struct page **pages, int addrinarray);
> +int set_pages_array_wc(struct page **pages, int addrinarray);
>  int set_pages_array_wb(struct page **pages, int addrinarray);
>
>  /*
> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> index cf07c26..0c98a75 100644
> --- a/arch/x86/mm/pageattr.c
> +++ b/arch/x86/mm/pageattr.c
> @@ -997,7 +997,8 @@ out_err:
>  }
>  EXPORT_SYMBOL(set_memory_uc);
>
> -int set_memory_array_uc(unsigned long *addr, int addrinarray)
> +int _set_memory_array(unsigned long *addr, int addrinarray,
> +               unsigned long new_type)
>  {
>        int i, j;
>        int ret;
> @@ -1007,13 +1008,19 @@ int set_memory_array_uc(unsigned long *addr, int addrinarray)
>         */
>        for (i = 0; i < addrinarray; i++) {
>                ret = reserve_memtype(__pa(addr[i]), __pa(addr[i]) + PAGE_SIZE,
> -                                       _PAGE_CACHE_UC_MINUS, NULL);
> +                                       new_type, NULL);
>                if (ret)
>                        goto out_free;
>        }
>
>        ret = change_page_attr_set(addr, addrinarray,
>                                    __pgprot(_PAGE_CACHE_UC_MINUS), 1);
> +
> +       if (!ret && new_type == _PAGE_CACHE_WC)
> +               ret = change_page_attr_set_clr(addr, addrinarray,
> +                                              __pgprot(_PAGE_CACHE_WC),
> +                                              __pgprot(_PAGE_CACHE_MASK),
> +                                              0, CPA_ARRAY, NULL);
>        if (ret)
>                goto out_free;
>
> @@ -1025,8 +1032,19 @@ out_free:
>
>        return ret;
>  }
> +
> +int set_memory_array_uc(unsigned long *addr, int addrinarray)
> +{
> +       return _set_memory_array(addr, addrinarray, _PAGE_CACHE_UC_MINUS);
> +}
>  EXPORT_SYMBOL(set_memory_array_uc);
>
> +int set_memory_array_wc(unsigned long *addr, int addrinarray)
> +{
> +       return _set_memory_array(addr, addrinarray, _PAGE_CACHE_WC);
> +}
> +EXPORT_SYMBOL(set_memory_array_wc);
> +
>  int _set_memory_wc(unsigned long addr, int numpages)
>  {
>        int ret;
> @@ -1153,26 +1171,34 @@ int set_pages_uc(struct page *page, int numpages)
>  }
>  EXPORT_SYMBOL(set_pages_uc);
>
> -int set_pages_array_uc(struct page **pages, int addrinarray)
> +static int _set_pages_array(struct page **pages, int addrinarray,
> +               unsigned long new_type)
>  {
>        unsigned long start;
>        unsigned long end;
>        int i;
>        int free_idx;
> +       int ret;
>
>        for (i = 0; i < addrinarray; i++) {
>                if (PageHighMem(pages[i]))
>                        continue;
>                start = page_to_pfn(pages[i]) << PAGE_SHIFT;
>                end = start + PAGE_SIZE;
> -               if (reserve_memtype(start, end, _PAGE_CACHE_UC_MINUS, NULL))
> +               if (reserve_memtype(start, end, new_type, NULL))
>                        goto err_out;
>        }
>
> -       if (cpa_set_pages_array(pages, addrinarray,
> -                       __pgprot(_PAGE_CACHE_UC_MINUS)) == 0) {
> -               return 0; /* Success */
> -       }
> +       ret = cpa_set_pages_array(pages, addrinarray,
> +                       __pgprot(_PAGE_CACHE_UC_MINUS));
> +       if (!ret && new_type == _PAGE_CACHE_WC)
> +               ret = change_page_attr_set_clr(NULL, addrinarray,
> +                                              __pgprot(_PAGE_CACHE_WC),
> +                                              __pgprot(_PAGE_CACHE_MASK),
> +                                              0, CPA_PAGES_ARRAY, pages);
> +       if (ret)
> +               goto err_out;
> +       return 0; /* Success */
>  err_out:
>        free_idx = i;
>        for (i = 0; i < free_idx; i++) {
> @@ -1184,8 +1210,19 @@ err_out:
>        }
>        return -EINVAL;
>  }
> +
> +int set_pages_array_uc(struct page **pages, int addrinarray)
> +{
> +       return _set_pages_array(pages, addrinarray, _PAGE_CACHE_UC_MINUS);
> +}
>  EXPORT_SYMBOL(set_pages_array_uc);
>
> +int set_pages_array_wc(struct page **pages, int addrinarray)
> +{
> +       return _set_pages_array(pages, addrinarray, _PAGE_CACHE_WC);
> +}
> +EXPORT_SYMBOL(set_pages_array_wc);
> +
>  int set_pages_wb(struct page *page, int numpages)
>  {
>        unsigned long addr = (unsigned long)page_address(page);
> --
> 1.7.0
>
>
> ------------------------------------------------------------------------------
> Download Intel&#174; Parallel Studio Eval
> Try the new software tools for yourself. Speed compiling, find bugs
> proactively, and fine-tune applications for parallel performance.
> See why Intel Parallel Studio got high marks during beta.
> http://p.sf.net/sfu/intel-sw-dev
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
>
