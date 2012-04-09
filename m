Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629Ab2DIVFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 17:05:20 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61629 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411Ab2DIVFR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 17:05:17 -0400
MIME-Version: 1.0
In-Reply-To: <20120409200336.8368.63793.stgit@zurg>
References: <20120409200336.8368.63793.stgit@zurg>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Mon, 9 Apr 2012 17:04:56 -0400
Message-ID: <CAHGf_=oWj-hz-E5ht8-hUbQKdsZ1bzP80n987kGYnFm8BpXBVQ@mail.gmail.com>
Subject: Re: [PATCH] mm: sync rss-counters at the end of exit_mm()
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 9, 2012 at 4:03 PM, Konstantin Khlebnikov
<khlebnikov@openvz.org> wrote:
> On task's exit do_exit() calls sync_mm_rss() but this is not enough,
> there can be page-faults after this point, for example exit_mm() ->
> mm_release() -> put_user() (for processing tsk->clear_child_tid).
> Thus there may be some rss-counters delta in current->rss_stat.

Seems reasonable. but I have another question. Do we have any reason to
keep sync_mm_rss() in do_exit()? I havn't seen any reason that thread exiting
makes rss consistency.


>
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  kernel/exit.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/kernel/exit.c b/kernel/exit.c
> index d8bd3b42..8e09dbe 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -683,6 +683,7 @@ static void exit_mm(struct task_struct * tsk)
>        enter_lazy_tlb(mm, current);
>        task_unlock(tsk);
>        mm_update_next_owner(mm);
> +       sync_mm_rss(mm);
>        mmput(mm);
>  }
>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
