Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab1AFCti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 21:49:38 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49841 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab1AFCth convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 21:49:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=obil8b9HeazhLaAW1fdkTgh26F5PtBk5851W6nDKeiAKvGnHWWGjJuRGxvTzRJZWJ+
         FQGrJX08yUS8zfavuJ84xK1Ah4wNLuJp0b+AaJEK7iyVEVZSncj2LC6nzE2lPNMWhNOB
         OKYOHtGgyf+iT4Y3DX0PseSlTo0loGgONlISc=
MIME-Version: 1.0
In-Reply-To: <20110106100923.24b1dd12.nishimura@mxp.nes.nec.co.jp>
References: <20110105130020.e2a854e4.nishimura@mxp.nes.nec.co.jp>
	<20110105115840.GD4654@cmpxchg.org>
	<20110106100923.24b1dd12.nishimura@mxp.nes.nec.co.jp>
Date: Thu, 6 Jan 2011 11:49:36 +0900
Message-ID: <AANLkTi=rp=WZa7PP4V6anU0SQ3BM-RJQwiDu1fJuoDig@mail.gmail.com>
Subject: Re: [BUGFIX][PATCH] memcg: fix memory migration of shmem swapcache
From: Minchan Kim <minchan.kim@gmail.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 10:09 AM, Daisuke Nishimura
<nishimura@mxp.nes.nec.co.jp> wrote:
> On Wed, 5 Jan 2011 12:58:40 +0100
> Johannes Weiner <hannes@cmpxchg.org> wrote:
>
>> On Wed, Jan 05, 2011 at 01:00:20PM +0900, Daisuke Nishimura wrote:
>> > In current implimentation, mem_cgroup_end_migration() decides whether the page
>> > migration has succeeded or not by checking "oldpage->mapping".
>> >
>> > But if we are tring to migrate a shmem swapcache, the page->mapping of it is
>> > NULL from the begining, so the check would be invalid.
>> > As a result, mem_cgroup_end_migration() assumes the migration has succeeded
>> > even if it's not, so "newpage" would be freed while it's not uncharged.
>> >
>> > This patch fixes it by passing mem_cgroup_end_migration() the result of the
>> > page migration.
>>
>> Are there other users that rely on unused->mapping being NULL after
>> migration?
>>
> As long as I can see, no.
>
>> If so, aren't they prone to misinterpreting this for shmem swapcache
>> as well?
>>
>> If not, wouldn't it be better to remove that page->mapping = NULL from
>> migrate_page_copy() altogether?  I think it's an ugly exception where
>> the outcome of PageAnon() is not meaningful for an LRU page.
>>
> IIUC, oldpage will be freed on success of page migration, so we hit bad_page
> check at freeing the page unless we clear oldpage->mapping,
>
>> To your patch:
>>
>> > --- a/mm/memcontrol.c
>> > +++ b/mm/memcontrol.c
>> > @@ -2856,7 +2856,7 @@ int mem_cgroup_prepare_migration(struct page *page,
>> >
>> >  /* remove redundant charge if migration failed*/
>> >  void mem_cgroup_end_migration(struct mem_cgroup *mem,
>> > -   struct page *oldpage, struct page *newpage)
>> > +   struct page *oldpage, struct page *newpage, int result)
>> >  {
>> >     struct page *used, *unused;
>> >     struct page_cgroup *pc;
>> > @@ -2865,8 +2865,7 @@ void mem_cgroup_end_migration(struct mem_cgroup *mem,
>> >             return;
>> >     /* blocks rmdir() */
>> >     cgroup_exclude_rmdir(&mem->css);
>> > -   /* at migration success, oldpage->mapping is NULL. */
>> > -   if (oldpage->mapping) {
>> > +   if (result) {
>>
>> Since this function does not really need more than a boolean value,
>> wouldn't it make the code more obvious if the parameter was `bool
>> success'?
>>
>>       if (!success) {
>> >             used = oldpage;
>> >             unused = newpage;
>> >     } else {
>>
>> Minor nit, though.  I agree with the patch in general.
>>
> Thank you for your review.
> How about this ?
>
> ===
> From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
>
> In current implimentation, mem_cgroup_end_migration() decides whether the page
> migration has succeeded or not by checking "oldpage->mapping".
>
> But if we are tring to migrate a shmem swapcache, the page->mapping of it is
> NULL from the begining, so the check would be invalid.
> As a result, mem_cgroup_end_migration() assumes the migration has succeeded
> even if it's not, so "newpage" would be freed while it's not uncharged.
>
> This patch fixes it by passing mem_cgroup_end_migration() the result of the
> page migration.
>
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Below minor nitpick.

> ---
>  include/linux/memcontrol.h |    5 ++---
>  mm/memcontrol.c            |    5 ++---
>  mm/migrate.c               |    2 +-
>  3 files changed, 5 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 159a076..cc5a8fd 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -93,7 +93,7 @@ extern int
>  mem_cgroup_prepare_migration(struct page *page,
>        struct page *newpage, struct mem_cgroup **ptr);
>  extern void mem_cgroup_end_migration(struct mem_cgroup *mem,
> -       struct page *oldpage, struct page *newpage);
> +       struct page *oldpage, struct page *newpage, bool success);

The term "success" implies present or future tense.
The event this variable cares about in the past so "succeed" might be
a more appropriate term.
Sorry to be picky about the English but there is an important
distinction here since we don't have any comment about the variable.

Am I being too fussy?
I don't want to bother you since Kame already acked it so I will
depend on your decision.

-- 
Kind regards,
Minchan Kim
