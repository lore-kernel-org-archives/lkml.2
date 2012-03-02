Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266Ab2CBUJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 15:09:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756423Ab2CBUJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 15:09:21 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] memcg: avoid THP split in task migration
Date: Fri,  2 Mar 2012 15:09:06 -0500
Message-Id: <1330718946-19490-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <CAJd=RBD46TioS0n7k6nZRG7p8+hiJkUddayr8=0sCxKq8Qct1Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2012 at 08:22:29PM +0800, Hillf Danton wrote:
> On Fri, Mar 2, 2012 at 8:31 AM, Naoya Horiguchi
> <n-horiguchi@ah.jp.nec.com> wrote:
...
> > --- linux-next-20120228.orig/mm/memcontrol.c
> > +++ linux-next-20120228/mm/memcontrol.c
> > @@ -5211,6 +5211,39 @@ static int is_target_pte_for_mc(struct vm_area_struct *vma,
> >    return ret;
> > }
> >
> > +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > +/*
> > + * We don't consider swapping or file mapped pages because THP does not
> > + * support them for now.
> > + * Caller should make sure that pmd_trans_huge(pmd) is true.
> > + */
> > +static int is_target_thp_for_mc(struct vm_area_struct *vma,
> > +        unsigned long addr, pmd_t pmd, union mc_target *target)
> > +{
> > +    struct page *page = NULL;
> > +    struct page_cgroup *pc;
> > +    int ret = 0;
> > +
>
> Need to check move_anon() ?

Right, we need it and page_mapcount check to be consistent with non thp code.

BTH it is maybe a bit off-topic, but I feel strange the following:

  static struct page *mc_handle_present_pte(struct vm_area_struct *vma,
                                            unsigned long addr, pte_t ptent)
  {
          ...
          if (PageAnon(page)) {
                  /* we don't move shared anon */
                  if (!move_anon() || page_mapcount(page) > 2)
                          return NULL;

Here page_mapcount(page) > 2 means that a given page is shared among more
than _three_ users. Documentation/cgroups/memory.txt sec.8.2 says that

  "(for file pages) mapcount of the page is ignored(the page can be
    moved even if page_mapcount(page) > 1)."

It implies that we do not move charge for anonymous page if mapcount > 1.
So I think the above mapcount check should be "> 1."
I'll post fix patch separately if it's correct.

> Other than that,
> Acked-by: Hillf Danton <dhillf@gmail.com>

Thank you!

It's small fix, but I'll resend whole renewed patchset for Andrew to handle
it easier.

Thanks,
Naoya
