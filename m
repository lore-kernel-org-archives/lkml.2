Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab2FVXDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:03:17 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:53434 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab2FVXDP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:03:15 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1206221443210.23486@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1206221443210.23486@chino.kir.corp.google.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 22 Jun 2012 19:02:55 -0400
X-Google-Sender-Auth: QoBDbI_2Ju0zRf7RUt0HYPR-_s0
Message-ID: <CAHGf_=qyj25z2fair3J+BSTeFQpFVSv9DGoXQUpZHxRZp-ySgA@mail.gmail.com>
Subject: Re: [patch 3.5-rc3] mm, oom: fix potential killing of thread that is
 disabled from oom killing
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 5:44 PM, David Rientjes <rientjes@google.com> wrote:
> /proc/sys/vm/oom_kill_allocating_task will immediately kill current when
> the oom killer is called to avoid a potentially expensive tasklist scan
> for large systems.
>
> Currently, however, it is not checking current's oom_score_adj value
> which may be OOM_SCORE_ADJ_MIN, meaning that it has been disabled from
> oom killing.
>
> This patch avoids killing current in such a condition and simply falls
> back to the tasklist scan since memory still needs to be freed.
>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  mm/oom_kill.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -720,9 +720,9 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
>        check_panic_on_oom(constraint, gfp_mask, order, mpol_mask);
>
>        read_lock(&tasklist_lock);
> -       if (sysctl_oom_kill_allocating_task &&
> +       if (sysctl_oom_kill_allocating_task && current->mm &&
>            !oom_unkillable_task(current, NULL, nodemask) &&
> -           current->mm) {
> +           current->signal->oom_score_adj != OOM_SCORE_ADJ_MIN) {
>                oom_kill_process(current, gfp_mask, order, 0, totalpages, NULL,
>                                 nodemask,
>                                 "Out of memory (oom_kill_allocating_task)");

Seems straight forward and reasonable.

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
