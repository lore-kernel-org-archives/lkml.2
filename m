Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688Ab2ISRL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 13:11:56 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:56351 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab2ISRLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 13:11:55 -0400
MIME-Version: 1.0
In-Reply-To: <1348040735-3897-1-git-send-email-minchan@kernel.org>
References: <1348040735-3897-1-git-send-email-minchan@kernel.org>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Wed, 19 Sep 2012 13:04:56 -0400
X-Google-Sender-Auth: RYL-_2nphcotrfCVymhYFyuKZas
Message-ID: <CAHGf_=rY-1R+68BWqW4653r_=AYkgE1CfM7wvSyvdSXRwjraUA@mail.gmail.com>
Subject: Re: [PATCH] mm: fix NR_ISOLATED_[ANON|FILE] mismatch
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Christoph Lameter <cl@linux.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 3:45 AM, Minchan Kim <minchan@kernel.org> wrote:
> When I looked at zone stat mismatch problem, I found
> migrate_to_node doesn't decrease NR_ISOLATED_[ANON|FILE]
> if check_range fails.
>
> It can make system hang out.
>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Christoph Lameter <cl@linux.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  mm/mempolicy.c |   16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 3d64b36..6bf0860 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -953,16 +953,16 @@ static int migrate_to_node(struct mm_struct *mm, int source, int dest,
>
>         vma = check_range(mm, mm->mmap->vm_start, mm->task_size, &nmask,
>                         flags | MPOL_MF_DISCONTIG_OK, &pagelist);
> -       if (IS_ERR(vma))
> -               return PTR_ERR(vma);
> -
> -       if (!list_empty(&pagelist)) {
> +       if (IS_ERR(vma)) {
> +               err = PTR_ERR(vma);
> +               goto out;
> +       }
> +       if (!list_empty(&pagelist))
>                 err = migrate_pages(&pagelist, new_node_page, dest,
>                                                         false, MIGRATE_SYNC);
> -               if (err)
> -                       putback_lru_pages(&pagelist);
> -       }
> -
> +out:
> +       if (err)
> +               putback_lru_pages(&pagelist);

Good catch!
This is a regression since following commit. So, I doubt we need
all or nothing semantics. Can we revert it instead? (and probably
we need more kind comment for preventing an accident)


commit 0def08e3acc2c9c934e4671487029aed52202d42
Author: Vasiliy Kulikov <segooon@gmail.com>
Date:   Tue Oct 26 14:21:32 2010 -0700

    mm/mempolicy.c: check return code of check_range
