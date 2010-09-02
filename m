Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab0IBAjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 20:39:52 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:28917 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752178Ab0IBAjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 20:39:51 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: dls6OpoVM1kEw6KdpEVUTyIXoy69tNP3KgfjK5fBaeqH89L
 7MoVgVncaBY_dCv2H4e56Z5LVbEdYvg9an102BYykBkS.qnsn3uWCPF990wg
 N.HGJLjcvBwuWMkavQ0pv3.yixa1u_11zfh2LqZvodcv7iUmGpRxyftpP8Cu
 GKhzahkJdLEeIWvr0YPxW4iwoymWEVIAP4t2y1jYvtIX.iqZSWwmwGvNrZMF
 3HJfFtNKAkY9xPll2zL_QTMuG5wod
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 1 Sep 2010 19:39:43 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 2/3] mm: page allocator: Calculate a better estimate of
 NR_FREE_PAGES when memory is low and kswapd is awake
In-Reply-To: <20100902092628.D065.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1009011935040.20518@router.home>
References: <20100901203422.GA19519@csn.ul.ie> <alpine.DEB.2.00.1009011919110.20518@router.home> <20100902092628.D065.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Sep 2010, KOSAKI Motohiro wrote:

> > 	nr_free_pages += delta;
> > 	if (nr_free_pages < 0)
> > 		nr_free_pages = 0;
>
> nr_free_pages is unsined. this wouldn't works ;)

The VM counters are signed and must be signed otherwise the deferred
update scheme would cause desasters. For treatment in the page allocator
these may be converted to unsigned.

The effect needs to be the same as retrieving a global or
zone ZVC counter. Which is currently implemented in the following way:

static inline unsigned long zone_page_state(struct zone *zone,
                                        enum zone_stat_item item)
{
        long x = atomic_long_read(&zone->vm_stat[item]);
#ifdef CONFIG_SMP
        if (x < 0)
                x = 0;
#endif
        return x;
}
