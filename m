Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab1ETFgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 01:36:15 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45189 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab1ETFgO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 01:36:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KbMYpy5eRiNKuTzzuqXJ+dXx37OVdMLSSBP0asGFS8HgM06bRel7gfwmsxyNgt+hL/
         mEdgb5dL39lBupoWzIk0gA+7At+M24s1HQuV5tJQccLCbaw9vxBv5LiaSOwAlborY4Qv
         PdQ/YD3N5FVcRkJxjHWcszGFWlx5teJlVQJ4M=
MIME-Version: 1.0
In-Reply-To: <20110520140856.fdf4d1c8.kamezawa.hiroyu@jp.fujitsu.com>
References: <BANLkTikhj1C7+HXP_4T-VnJzPefU2d7b3A@mail.gmail.com>
	<BANLkTi=fk3DUT9cYd2gAzC98c69F6HXX7g@mail.gmail.com>
	<BANLkTikofp5rHRdW5dXfqJXb8VCAqPQ_7A@mail.gmail.com>
	<20110514165346.GV6008@one.firstfloor.org>
	<BANLkTik6SS9NH7XVSRBoCR16_5veY0MKBw@mail.gmail.com>
	<20110514174333.GW6008@one.firstfloor.org>
	<BANLkTinst+Ryox9VZ-s7gdXKa574XXqt5w@mail.gmail.com>
	<20110515152747.GA25905@localhost>
	<BANLkTim-AnEeL=z1sYm=iN7sMnG0+m0SHw@mail.gmail.com>
	<20110517060001.GC24069@localhost>
	<BANLkTi=TOm3aLQCD6j=4va6B+Jn2nSfwAg@mail.gmail.com>
	<BANLkTi=9W6-JXi94rZfTtTpAt3VUiY5fNw@mail.gmail.com>
	<BANLkTikHMUru=w4zzRmosrg2bDbsFWrkTQ@mail.gmail.com>
	<BANLkTima0hPrPwe_x06afAh+zTi-bOcRMg@mail.gmail.com>
	<BANLkTi=NTLn4Lx7EkybuA8-diTVOvMDxBw@mail.gmail.com>
	<BANLkTinEDXHuRUYpYN0d95+fz4+F7ccL4w@mail.gmail.com>
	<4DD5DC06.6010204@jp.fujitsu.com>
	<BANLkTik=7C5qFZTsPQG4JYY-MEWDTHdc6A@mail.gmail.com>
	<BANLkTins7qxWVh0bEwtk1Vx+m98N=oYVtw@mail.gmail.com>
	<20110520140856.fdf4d1c8.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 20 May 2011 14:36:13 +0900
Message-ID: <BANLkTinJbYrQoye7qjPzPxP8_deCSK0g7w@mail.gmail.com>
Subject: Re: Kernel falls apart under light memory pressure (i.e. linking vmlinux)
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Lutomirski <luto@mit.edu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        fengguang.wu@intel.com, andi@firstfloor.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, hannes@cmpxchg.org,
        riel@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 2:08 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Fri, 20 May 2011 13:20:15 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> So I want to resolve your problem asap.
>> We don't have see report about that. Could you do git-bisect?
>> FYI, Recently, big change of mm is compaction,transparent huge pages.
>> Kame, could you point out thing related to memcg if you have a mind?
>>
>
> I don't doubt memcg at this stage because it never modify page->flags.
> Consdering the case, PageActive() is set against off-LRU pages after
> clear_active_flags() clears it.
>
> Hmm, I think I don't understand the lock system fully but...how do you
> think this ?
>
> ==
>
> At splitting a hugepage, the routine marks all pmd as "splitting".
>
> But assume a racy case where 2 threads run into spit at the
> same time, one thread wins compound_lock() and do split, another
> thread should not touch splitted pages.

Sorry. Now I don't have a time to review in detail.
When I look it roughly,  page_lock_anon_vma have to prevent it.
But Andrea needs current this problem and he will catch something we lost. :)


>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Index: mmotm-May11/mm/huge_memory.c
> ===================================================================
> --- mmotm-May11.orig/mm/huge_memory.c
> +++ mmotm-May11/mm/huge_memory.c
> @@ -1150,7 +1150,7 @@ static int __split_huge_page_splitting(s
>        return ret;
>  }
>
> -static void __split_huge_page_refcount(struct page *page)
> +static bool __split_huge_page_refcount(struct page *page)
>  {
>        int i;
>        unsigned long head_index = page->index;
> @@ -1161,6 +1161,11 @@ static void __split_huge_page_refcount(s
>        spin_lock_irq(&zone->lru_lock);
>        compound_lock(page);
>
> +       if (!PageCompound(page)) {
> +               compound_unlock(page);
> +               spin_unlock_irq(&zone->lru_lock);
> +               return false;
> +       }
>        for (i = 1; i < HPAGE_PMD_NR; i++) {
>                struct page *page_tail = page + i;
>
> @@ -1258,6 +1263,7 @@ static void __split_huge_page_refcount(s
>         * to be pinned by the caller.
>         */
>        BUG_ON(page_count(page) <= 0);
> +       return true;
>  }
>
>  static int __split_huge_page_map(struct page *page,
> @@ -1367,7 +1373,8 @@ static void __split_huge_page(struct pag
>                       mapcount, page_mapcount(page));
>        BUG_ON(mapcount != page_mapcount(page));
>
> -       __split_huge_page_refcount(page);
> +       if (!__split_huge_page_refcount(page))
> +               return;
>
>        mapcount2 = 0;
>        list_for_each_entry(avc, &anon_vma->head, same_anon_vma) {
>
>



-- 
Kind regards,
Minchan Kim
