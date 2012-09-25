Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab2IYTEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 15:04:04 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:35409 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab2IYTEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 15:04:02 -0400
MIME-Version: 1.0
In-Reply-To: <1348592715-31006-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <CAHGf_=rbyk1UFGwyQ0BSN3qM_K+5J3Q-Aj=xjNDZFrTrZ6a3dw@mail.gmail.com>
 <1348592715-31006-1-git-send-email-n-horiguchi@ah.jp.nec.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Tue, 25 Sep 2012 15:03:41 -0400
X-Google-Sender-Auth: Kt6hJyE1PdfZmr4mlKRqYn0VKec
Message-ID: <CAHGf_=oOUc++B-wZ3b21aeTdSQEBvEO=PpfL0amnqmZhNun61w@mail.gmail.com>
Subject: Re: [PATCH] pagemap: fix wrong KPF_THP on slab pages
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi.kleen@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 1:05 PM, Naoya Horiguchi
<n-horiguchi@ah.jp.nec.com> wrote:
> On Tue, Sep 25, 2012 at 11:59:51AM -0400, KOSAKI Motohiro wrote:
>> On Tue, Sep 25, 2012 at 9:56 AM, Naoya Horiguchi
>> <n-horiguchi@ah.jp.nec.com> wrote:
>> > KPF_THP can be set on non-huge compound pages like slab pages, because
>> > PageTransCompound only sees PG_head and PG_tail. Obviously this is a bug
>> > and breaks user space applications which look for thp via /proc/kpageflags.
>> > Currently thp is constructed only on anonymous pages, so this patch makes
>> > KPF_THP be set when both of PageAnon and PageTransCompound are true.
>>
>> Indeed. Please add some comment too.
>
> Sure. I send revised one.
>
> Thanks,
> Naoya
> ---
> From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Date: Mon, 24 Sep 2012 16:28:30 -0400
> Subject: [PATCH v2] pagemap: fix wrong KPF_THP on slab pages
>
> KPF_THP can be set on non-huge compound pages like slab pages, because
> PageTransCompound only sees PG_head and PG_tail. Obviously this is a bug
> and breaks user space applications which look for thp via /proc/kpageflags.
> Currently thp is constructed only on anonymous pages, so this patch makes
> KPF_THP be set when both of PageAnon and PageTransCompound are true.
>
> Changelog in v2:
>   - add a comment in code
>
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> ---
>  fs/proc/page.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/fs/proc/page.c b/fs/proc/page.c
> index 7fcd0d6..f7cd2f6c 100644
> --- a/fs/proc/page.c
> +++ b/fs/proc/page.c
> @@ -115,7 +115,12 @@ u64 stable_page_flags(struct page *page)
>                 u |= 1 << KPF_COMPOUND_TAIL;
>         if (PageHuge(page))
>                 u |= 1 << KPF_HUGE;
> -       else if (PageTransCompound(page))
> +       /*
> +        * Since THP is relevant only for anonymous pages so far, we check it
> +        * explicitly with PageAnon. Otherwise thp is confounded with non-huge
> +        * compound pages like slab pages.
> +        */
> +       else if (PageTransCompound(page) && PageAnon(page))
>                 u |= 1 << KPF_THP;

Looks good to me.

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
