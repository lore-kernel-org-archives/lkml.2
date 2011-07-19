Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853Ab1GSU2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 16:28:08 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43735 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403Ab1GSU2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 16:28:06 -0400
Date: Tue, 19 Jul 2011 13:27:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jan =?iso-8859-1?Q?H=2E_Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>
Cc: Dipankar Sarma <dipankar@in.ibm.com>, Corey Minyard <minyard@acm.org>,
        Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcu: Fix wrong check in list_splice_init_rcu()
Message-ID: <20110719202752.GO2357@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1311102626-14831-1-git-send-email-schnhrr@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1311102626-14831-1-git-send-email-schnhrr@cs.tu-berlin.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 09:10:26PM +0200, Jan H. Schönherr wrote:
> Hi.
> 
> If I don't miss something obvious, the following patch would
> be a good idea.
> 
> There are currently two users of list_splice_init_rcu(): IPMI and btrfs.
> For these, list_splice_init_rcu() is currently a NOP.
> 
> If I interpret the code correctly, this fixes a memory leak for
> IPMI and something probably worse for btrfs.
> 
> The call from within btrfs was introduced only after v2.6.39 with commit
> 1f78160 ("Btrfs: using rcu lock in the reader side of devices list") by
> converting a list_splice_init() call.
> 
> Therefore, this patch might be a candidate for v3.0.

Excellent catch!  This one has been around for some time, so my guess
is that it goes into v3.1.  Either way, I have queued it, thank you!

							Thanx, Paul

> Regards
> Jan
> 
> ----8<----
> From: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
> 
> Splicing something into an empty list should work, while there is
> nothing to do if the source list is empty.
> 
> Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
> ---
>  include/linux/rculist.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> index e3beb31..d079290 100644
> --- a/include/linux/rculist.h
> +++ b/include/linux/rculist.h
> @@ -183,7 +183,7 @@ static inline void list_splice_init_rcu(struct list_head *list,
>  	struct list_head *last = list->prev;
>  	struct list_head *at = head->next;
> 
> -	if (list_empty(head))
> +	if (list_empty(list))
>  		return;
> 
>  	/* "first" and "last" tracking list, so initialize it. */
> -- 
> 1.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
