Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750941Ab2CFFDD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 00:03:03 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46559 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab2CFFDB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 00:03:01 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of lliubbo@gmail.com designates 10.52.98.200 as permitted sender) smtp.mail=lliubbo@gmail.com; dkim=pass header.i=lliubbo@gmail.com
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1203052046410.24068@eggly.anvils>
References: <alpine.LSU.2.00.1203052046410.24068@eggly.anvils>
Date: Tue, 6 Mar 2012 13:03:00 +0800
Message-ID: <CAA_GA1cQ4i8Rtrh6OBrgw-dPc7dqnoJbbPRBrBoawihtgn2zLA@mail.gmail.com>
Subject: Re: [PATCH] page_cgroup: fix horrid swap accounting regression
From: Bob Liu <lliubbo@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <jweiner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

On Tue, Mar 6, 2012 at 12:52 PM, Hugh Dickins <hughd@google.com> wrote:
> Why is memcg's swap accounting so broken?  Insane counts, wrong ownership,
> unfreeable structures, which later get freed and then accessed after free.
>
> Turns out to be a tiny a little 3.3-rc1 regression in 9fb4b7cc0724
> "page_cgroup: add helper function to get swap_cgroup": the helper
> function (actually named lookup_swap_cgroup()) returns an address
> using void* arithmetic, but the structure in question is a short.
>

Sorry for my mistake.

> Signed-off-by: Hugh Dickins <hughd@google.com>
> ---
>
>  mm/page_cgroup.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> --- 3.3-rc6/mm/page_cgroup.c    2012-01-20 08:42:35.320020840 -0800
> +++ linux/mm/page_cgroup.c      2012-03-05 19:51:13.535372098 -0800
> @@ -379,13 +379,15 @@ static struct swap_cgroup *lookup_swap_c
>        pgoff_t offset = swp_offset(ent);
>        struct swap_cgroup_ctrl *ctrl;
>        struct page *mappage;
> +       struct swap_cgroup *sc;
>
>        ctrl = &swap_cgroup_ctrl[swp_type(ent)];
>        if (ctrlp)
>                *ctrlp = ctrl;
>
>        mappage = ctrl->map[offset / SC_PER_PAGE];
> -       return page_address(mappage) + offset % SC_PER_PAGE;
> +       sc = page_address(mappage);
> +       return sc + offset % SC_PER_PAGE;
>  }
>
>  /**

Reviewed-by: Bob Liu <lliubbo@gmail.com>

-- 
Regards,
--Bob
