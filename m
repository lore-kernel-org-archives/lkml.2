Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab2AWULN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 15:11:13 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:52936 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab2AWULM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 15:11:12 -0500
MIME-Version: 1.0
In-Reply-To: <20120119161445.b3a8a9d2.kamezawa.hiroyu@jp.fujitsu.com>
References: <20120119161445.b3a8a9d2.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 23 Jan 2012 12:11:11 -0800
Message-ID: <CALWz4ixufzgi2kDRgTMAzty-S2AKMmPfqdGc1sBRNFJxf-WTAQ@mail.gmail.com>
Subject: Re: [PATCH] memcg: remove unnecessary thp check at page stat accounting
From: Ying Han <yinghan@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 11:14 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> Thank you very much for reviewing previous RFC series.
> This is a patch against memcg-devel and linux-next (can by applied without HUNKs).
>
> ==
>
> From 64641b360839b029bb353fbd95f7554cc806ed05 Mon Sep 17 00:00:00 2001
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date: Thu, 12 Jan 2012 16:08:33 +0900
> Subject: [PATCH] memcg: remove unnecessary thp check in mem_cgroup_update_page_stat()
>
> commit 58b318ecf(memcg-devel)
>    memcg: make mem_cgroup_split_huge_fixup() more efficient
> removes move_lock_page_cgroup() in thp-split path.
>
> So, We do not have to check PageTransHuge in mem_cgroup_update_page_stat
> and fallback into the locked accounting because both move charge and thp
> split up are done with compound_lock so they cannot race. update vs.
> move is protected by the mem_cgroup_stealed sufficiently.

Sorry, i don't see we changed the "move charge" to "move account" ?

--Ying
>
> PageTransHuge pages shouldn't appear in this code path currently because
> we are tracking only file pages at the moment but later we are planning
> to track also other pages (e.g. mlocked ones).
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
>  mm/memcontrol.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 5073474..fb2dfc3 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1801,7 +1801,7 @@ void mem_cgroup_update_page_stat(struct page *page,
>        if (unlikely(!memcg || !PageCgroupUsed(pc)))
>                goto out;
>        /* pc->mem_cgroup is unstable ? */
> -       if (unlikely(mem_cgroup_stealed(memcg)) || PageTransHuge(page)) {
> +       if (unlikely(mem_cgroup_stealed(memcg))) {
>                /* take a lock against to access pc->mem_cgroup */
>                move_lock_page_cgroup(pc, &flags);
>                need_unlock = true;
> --
> 1.7.4.1
>
>
