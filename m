Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662Ab2F1A2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 20:28:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab2F1A2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 20:28:48 -0400
Message-ID: <4FEBA520.4030205@redhat.com>
Date: Wed, 27 Jun 2012 20:28:16 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Jim Schutt <jaschut@sandia.gov>, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: excessive CPU utilization by isolate_freepages?
References: <4FEB8237.6030402@sandia.gov> <4FEB9E73.5040709@kernel.org>
In-Reply-To: <4FEB9E73.5040709@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2012 07:59 PM, Minchan Kim wrote:

> I doubt compaction try to migrate continuously although we have no free memory.
> Could you apply this patch and retest?
>
> https://lkml.org/lkml/2012/6/21/30

Another possibility is that compaction is succeeding every time,
but since we always start scanning all the way at the beginning
and end of each zone, we waste a lot of CPU time rescanning the
same pages (that we just filled up with moved pages) to see if
any are free.

In short, due to the way compaction behaves right now,
compaction + isolate_freepages are essentially quadratic.

What we need to do is remember where we left off after a
successful compaction, so we can continue the search there
at the next invocation.

-- 
All rights reversed
