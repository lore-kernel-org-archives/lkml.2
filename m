Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab2BXFcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 00:32:39 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58090 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab2BXFci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 00:32:38 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of koct9i@gmail.com designates 10.204.129.203 as permitted sender) smtp.mail=koct9i@gmail.com; dkim=pass header.i=koct9i@gmail.com
Message-ID: <4F4720F1.2060805@openvz.org>
Date: Fri, 24 Feb 2012 09:32:33 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20120201 Iceape/2.0.14
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v3 18/21] mm: add to lruvec isolated pages counters
References: <20120223133728.12988.5432.stgit@zurg> <20120223135314.12988.97364.stgit@zurg>
In-Reply-To: <20120223135314.12988.97364.stgit@zurg>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Khlebnikov wrote:
> @@ -2480,8 +2494,11 @@ static int mem_cgroup_move_parent(struct page *page,
>
>          if (nr_pages>  1)
>                  compound_unlock_irqrestore(page, flags);
> +       if (!ret)
> +               /* This also stabilize PageLRU() sign for lruvec lock holder. */
> +               mem_cgroup_adjust_isolated(lruvec, page, -nr_pages);
>   put_back:
> -       putback_lru_page(page);
> +       __putback_lru_page(page, !ret);
>   put:
>          put_page(page);
>   out:

Oh, no. There must be !!ret

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2482,7 +2482,7 @@ static int mem_cgroup_move_parent(struct page *page,
                 /* This also stabilize PageLRU() sign for lruvec lock holder. */
                 mem_cgroup_adjust_isolated(lruvec, page, -nr_pages);
  put_back:
-       __putback_lru_page(page, !ret);
+       __putback_lru_page(page, !!ret);
  put:
         put_page(page);
  out:
