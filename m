Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab1I2MuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 08:50:24 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64061 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab1I2MuW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 08:50:22 -0400
MIME-Version: 1.0
In-Reply-To: <1317290085-3804-1-git-send-email-minchan.kim@gmail.com>
References: <20110928081452.GC23535@redhat.com> <1317290085-3804-1-git-send-email-minchan.kim@gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Thu, 29 Sep 2011 21:50:02 +0900
X-Google-Sender-Auth: y_9UP-XPKTOZXTRj_SRD7KEQcAI
Message-ID: <CAHGf_=rH4QThPidf9TD_d1qt3QJ-_mAJnH+XmP+ZJ0pOjpOTTQ@mail.gmail.com>
Subject: Re: [PATCH v2] vmscan: add barrier to prevent evictable page in
 unevictable list
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <jweiner@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/29 Minchan Kim <minchan.kim@gmail.com>:
> When racing between putback_lru_page and shmem_lock with lock=0 happens,
> progrom execution order is as follows, but clear_bit in processor #1
> could be reordered right before spin_unlock of processor #1.
> Then, the page would be stranded on the unevictable list.
>
> spin_lock
> SetPageLRU
> spin_unlock
>                                clear_bit(AS_UNEVICTABLE)
>                                spin_lock
>                                if PageLRU()
>                                        if !test_bit(AS_UNEVICTABLE)
>                                                move evictable list
> smp_mb
> if !test_bit(AS_UNEVICTABLE)
>        move evictable list
>                                spin_unlock
>
> But, pagevec_lookup in scan_mapping_unevictable_pages has rcu_read_[un]lock so
> it could protect reordering before reaching test_bit(AS_UNEVICTABLE) on processor #1
> so this problem never happens. But it's a unexpected side effect and we should
> solve this problem properly.
>
> This patch adds a barrier after mapping_clear_unevictable.
>
> side-note: I didn't meet this problem but just found during review.
>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
> Acked-by: Johannes Weiner <jweiner@redhat.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>

  Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
