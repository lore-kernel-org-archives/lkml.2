Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab2KGWK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 17:10:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54388 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab2KGWK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 17:10:27 -0500
Date: Wed, 7 Nov 2012 14:10:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] memcg: oom: fix totalpages calculation for
 memory.swappiness==0
Message-Id: <20121107141025.2ac62206.akpm@linux-foundation.org>
In-Reply-To: <20121015220354.GA11682@dhcp22.suse.cz>
References: <20121011085038.GA29295@dhcp22.suse.cz>
	<1349945859-1350-1-git-send-email-mhocko@suse.cz>
	<20121015220354.GA11682@dhcp22.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012 00:04:08 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> As Kosaki correctly pointed out, the glogal reclaim doesn't have this
> issue because we _do_ swap on swappinnes==0 so the swap space has
> to be considered. So the v2 is just acks + changelog fix.
> 
> Changes since v1
> - drop a note about global swappiness affected as well from the
>   changelog
> - stable needs 3.2+ rather than 3.5+ because the fe35004f has been
>   backported to stable
> ---
> >From c2ae4849f09dbfda6b61472c6dd1fd8c2fe8ac81 Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Wed, 10 Oct 2012 15:46:54 +0200
> Subject: [PATCH] memcg: oom: fix totalpages calculation for
>  memory.swappiness==0
> 
> oom_badness takes totalpages argument which says how many pages are
> available and it uses it as a base for the score calculation. The value
> is calculated by mem_cgroup_get_limit which considers both limit and
> total_swap_pages (resp. memsw portion of it).
> 
> This is usually correct but since fe35004f (mm: avoid swapping out
> with swappiness==0) we do not swap when swappiness is 0 which means
> that we cannot really use up all the totalpages pages. This in turn
> confuses oom score calculation if the memcg limit is much smaller than
> the available swap because the used memory (capped by the limit) is
> negligible comparing to totalpages so the resulting score is too small
> if adj!=0 (typically task with CAP_SYS_ADMIN or non zero oom_score_adj).
> A wrong process might be selected as result.
> 
> The problem can be worked around by checking mem_cgroup_swappiness==0
> and not considering swap at all in such a case.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> Acked-by: David Rientjes <rientjes@google.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: stable [3.2+]

That's "Cc: <stable@vger.kernel.org>", please.

It's unobvious from the changelog that a -stable backport is really
needed.  The bug looks pretty obscure and has been there for a long
time.  Realistically, is anyone likely to hurt from this?

