Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab1I1CZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 22:25:19 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38515 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab1I1CZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 22:25:18 -0400
Date: Wed, 28 Sep 2011 11:25:10 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, jweiner@redhat.com, mel@csn.ul.ie,
        riel@redhat.com, lee.schermerhorn@hp.com
Subject: Re: [PATCH] vmscan: add barrier to prevent evictable page in
 unevictable list
Message-ID: <20110928022510.GB12100@barrios-desktop>
References: <1317174330-2677-1-git-send-email-minchan.kim@gmail.com>
 <4E8284C6.1050900@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8284C6.1050900@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 11:21:58AM +0900, KOSAKI Motohiro wrote:
> (2011/09/28 10:45), Minchan Kim wrote:
> > When racing between putback_lru_page and shmem_unlock happens,
> > progrom execution order is as follows, but clear_bit in processor #1
> > could be reordered right before spin_unlock of processor #1.
> > Then, the page would be stranded on the unevictable list.
> > 
> > spin_lock
> > SetPageLRU
> > spin_unlock
> >                                 clear_bit(AS_UNEVICTABLE)
> >                                 spin_lock
> >                                 if PageLRU()
> >                                         if !test_bit(AS_UNEVICTABLE)
> >                                         	move evictable list
> > smp_mb
> > if !test_bit(AS_UNEVICTABLE)
> >         move evictable list
> >                                 spin_unlock
> > 
> > But, pagevec_lookup in scan_mapping_unevictable_pages has rcu_read_[un]lock so
> > it could protect reordering before reaching test_bit(AS_UNEVICTABLE) on processor #1
> > so this problem never happens. But it's a unexpected side effect and we should
> > solve this problem properly.
> 
> Do we still need this after Hannes removes scan_mapping_unevictable_pages?
 
Hi KOSAKI,

What Hannes removes is scan_zone_unevictable_pages not scan_mapping_unevictable_pages.

-- 
Kinds regards,
Minchan Kim
