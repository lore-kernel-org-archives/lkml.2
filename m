Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab3AIT1E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 14:27:04 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:35538 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932451Ab3AIT1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 14:27:02 -0500
Date: Wed, 9 Jan 2013 11:26:59 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: migrate: Check page_count of THP before migrating
 accounting fix
In-Reply-To: <20130109120447.GB13304@suse.de>
Message-ID: <alpine.LNX.2.00.1301091120580.4818@eggly.anvils>
References: <20130107170815.GO3885@suse.de> <alpine.LNX.2.00.1301081931530.20504@eggly.anvils> <20130109120447.GB13304@suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2013, Mel Gorman wrote:

> As pointed out by Hugh Dickins, "mm: migrate: Check page_count of THP
> before migrating" can leave nr_isolated_anon elevated, correct it. This
> is a fix to mm-migrate-check-page_count-of-thp-before-migrating.patch
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Thanks: to this and the one it's fixing (I expect akpm will merge)

Acked-by: Hugh Dickins <hughd@google.com>

> ---
>  mm/migrate.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index f466827..c387786 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1689,8 +1689,11 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
>  	if (!isolated || page_count(page) != 2) {
>  		count_vm_events(PGMIGRATE_FAIL, HPAGE_PMD_NR);
>  		put_page(new_page);
> -		if (isolated)
> +		if (isolated) {
>  			putback_lru_page(page);
> +			isolated = 0;
> +			goto out;
> +		}
>  		goto out_keep_locked;
>  	}
