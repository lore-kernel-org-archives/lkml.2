Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab1FCQh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 12:37:26 -0400
Received: from smtp-out.google.com ([74.125.121.67]:62943 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab1FCQhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 12:37:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=leD/jMTow4ogO5wy8nnsnB042W05pR/aNPERjynJkOzHiMTdcyK1U3GQcWtw1y/TSm
         B0BdMg0/2Omod3f8S/TQ==
Date: Fri, 3 Jun 2011 09:37:13 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Chris Wright <chrisw@sous-sol.org>
cc: Andrea Righi <andrea@betterlinux.com>, CAI Qian <caiqian@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ksm: fix race between ksmd and exiting task
In-Reply-To: <20110602173549.GL23047@sequoia.sous-sol.org>
Message-ID: <alpine.LSU.2.00.1106030934130.1810@sister.anvils>
References: <20110601222032.GA2858@thinkpad> <2144269697.363041.1306998593180.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com> <20110602141927.GA2011@thinkpad> <20110602164841.GK23047@sequoia.sous-sol.org>
 <20110602173549.GL23047@sequoia.sous-sol.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jun 2011, Chris Wright wrote:

> Andrea Righi reported a case where an exiting task can race against
> ksmd.
> 
> ksm_scan.mm_slot == the only registered mm
> CPU 1 (bug program)		CPU 2 (ksmd)
>  				list_empty() is false
> lock
> ksm_scan.mm_slot
> list_del
> unlock
>  				slot == &ksm_mm_head (but list is now empty_)
> 
> Close this race by revalidating that the new slot is not simply the list
> head again.

Remarkably similar to my patch: it must be good!
But yours appears to be more popular - thanks, Chris.

> 
> Reported-by: Andrea Righi <andrea@betterlinux.com>
> Cc: Hugh Dickins <hughd@google.com>

Acked-by: Hugh Dickins <hughd@google.com>

> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>

Cc: stable@kernel.org

> ---
>  mm/ksm.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 942dfc7..0373ce4 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -1301,6 +1301,9 @@ static struct rmap_item *scan_get_next_rmap_item(struct page **page)
>  		slot = list_entry(slot->mm_list.next, struct mm_slot, mm_list);
>  		ksm_scan.mm_slot = slot;
>  		spin_unlock(&ksm_mmlist_lock);
> +		/* We raced against exit of last slot on the list */
> +		if (slot == &ksm_mm_head)
> +			return NULL;
>  next_mm:
>  		ksm_scan.address = 0;
>  		ksm_scan.rmap_list = &slot->rmap_list;
