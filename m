Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab1GJXIs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 19:08:48 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:54877 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756802Ab1GJXIr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 19:08:47 -0400
MIME-Version: 1.0
In-Reply-To: <1310244907-10144-1-git-send-email-dmitry.fink@palm.com>
References: <1310244149-9885-1-git-send-email-dmitry.fink@palm.com>
	<1310244907-10144-1-git-send-email-dmitry.fink@palm.com>
Date: Mon, 11 Jul 2011 08:08:46 +0900
Message-ID: <CAEwNFnDRZwSXnVP3EdXqYnNBrumcrihQ+m=N4fb9xouNE=TKRg@mail.gmail.com>
Subject: Re: [PATCH] mmap: Fix and tidy up overcommit page arithmetic
From: Minchan Kim <minchan.kim@gmail.com>
To: Dmitry Fink <dmitry.fink@palm.com>
Cc: Hugh Dickins <hughd@google.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 5:55 AM, Dmitry Fink <dmitry.fink@palm.com> wrote:
> - shmem pages are not immediately available, but they are not
> potentially available either, even if we swap them out, they will
> just relocate from memory into swap, total amount of immediate and
> potentially available memory is not going to be affected, so we
> shouldn't count them as potentially free in the first place.
>
> - nr_free_pages() is not an expensive operation anymore, there is
> no need to split the decision making in two halves and repeat code.
>
> Signed-off-by: Dmitry Fink <dmitry.fink@palm.com>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> Acked-by: Hugh Dickins <hughd@google.com>
> ---
>  mm/mmap.c  |   33 ++++++++++++---------------------
>  mm/nommu.c |   33 ++++++++++++---------------------
>  2 files changed, 24 insertions(+), 42 deletions(-)
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index d49736f..b6ed22e 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -122,9 +122,16 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
>                return 0;
>
>        if (sysctl_overcommit_memory == OVERCOMMIT_GUESS) {
> -               unsigned long n;
> +               free = global_page_state(NR_FREE_PAGES);
> +               free += global_page_state(NR_FILE_PAGES);
> +
> +               /* shmem pages shouldn't be counted as free in this

Nitpick.
You didn't correct comment style. It's not a linux kernel coding style.

-- 
Kind regards,
Minchan Kim
