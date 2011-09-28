Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab1I1CTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 22:19:10 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33984 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab1I1CTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 22:19:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E8284C6.1050900@jp.fujitsu.com>
Date: Wed, 28 Sep 2011 11:21:58 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: minchan.kim@gmail.com
CC: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, jweiner@redhat.com, mel@csn.ul.ie,
        riel@redhat.com, lee.schermerhorn@hp.com
Subject: Re: [PATCH] vmscan: add barrier to prevent evictable page in unevictable
 list
References: <1317174330-2677-1-git-send-email-minchan.kim@gmail.com>
In-Reply-To: <1317174330-2677-1-git-send-email-minchan.kim@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/09/28 10:45), Minchan Kim wrote:
> When racing between putback_lru_page and shmem_unlock happens,
> progrom execution order is as follows, but clear_bit in processor #1
> could be reordered right before spin_unlock of processor #1.
> Then, the page would be stranded on the unevictable list.
> 
> spin_lock
> SetPageLRU
> spin_unlock
>                                 clear_bit(AS_UNEVICTABLE)
>                                 spin_lock
>                                 if PageLRU()
>                                         if !test_bit(AS_UNEVICTABLE)
>                                         	move evictable list
> smp_mb
> if !test_bit(AS_UNEVICTABLE)
>         move evictable list
>                                 spin_unlock
> 
> But, pagevec_lookup in scan_mapping_unevictable_pages has rcu_read_[un]lock so
> it could protect reordering before reaching test_bit(AS_UNEVICTABLE) on processor #1
> so this problem never happens. But it's a unexpected side effect and we should
> solve this problem properly.

Do we still need this after Hannes removes scan_mapping_unevictable_pages?


> 
> This patch adds a barrier after mapping_clear_unevictable.
> 
> side-note: I didn't meet this problem but just found during review.


