Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab1IDHVY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 03:21:24 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65436 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab1IDHVT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 03:21:19 -0400
MIME-Version: 1.0
In-Reply-To: <1315098933-29464-1-git-send-email-kirill@shutemov.name>
References: <1315098933-29464-1-git-send-email-kirill@shutemov.name>
From: Paul Menage <paul@paulmenage.org>
Date: Sun, 4 Sep 2011 00:20:59 -0700
X-Google-Sender-Auth: kcx9W3shE9F4iyHjwW4pfBgsp-o
Message-ID: <CALdu-PA09QKbL97dZHs1TZv-n=xDUyQvOXatSKOAHExKjfHS+Q@mail.gmail.com>
Subject: Re: [PATCH] memcg: drain all stocks for the cgroup before read usage
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 3, 2011 at 6:15 PM, Kirill A. Shutemov <kirill@shutemov.name> wrote:
> From: "Kirill A. Shutemov" <kirill@shutemov.name>
>
> Currently, mem_cgroup_usage() for non-root cgroup returns usage
> including stocks.
>
> Let's drain all socks before read resource counter value. It makes
> memory{,.memcg}.usage_in_bytes and memory.stat consistent.

Isn't that quite an expensive operation, and bear in mind that
resource control trackers may be reading this file very frequently,
maybe every second or so.

How about having a trigger file that can be written to force the drain
for cases where the consistency is really desired? Or a separate
usage_in_bytes_consistent file that does the drain.

Paul

>
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> ---
>  mm/memcontrol.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ebd1e86..e091022 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3943,6 +3943,7 @@ static inline u64 mem_cgroup_usage(struct mem_cgroup *mem, bool swap)
>        u64 val;
>
>        if (!mem_cgroup_is_root(mem)) {
> +               drain_all_stock_sync(mem);
>                if (!swap)
>                        return res_counter_read_u64(&mem->res, RES_USAGE);
>                else
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
