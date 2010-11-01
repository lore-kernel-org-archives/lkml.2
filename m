Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab0KAHHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 03:07:04 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47273 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab0KAHHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 03:07:02 -0400
Date: Mon, 1 Nov 2010 16:05:52 +0900 (JST)
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH] RFC: vmscan: add min_filelist_kbytes sysctl for protecting the working set
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, wad@chromium.org, olofj@chromium.org,
        hughd@chromium.org
In-Reply-To: <20101028191523.GA14972@google.com>
References: <20101028191523.GA14972@google.com>
Message-Id: <20101101012322.605C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> On ChromiumOS, we do not use swap. When memory is low, the only way to
> free memory is to reclaim pages from the file list. This results in a
> lot of thrashing under low memory conditions. We see the system become
> unresponsive for minutes before it eventually OOMs. We also see very
> slow browser tab switching under low memory. Instead of an unresponsive
> system, we'd really like the kernel to OOM as soon as it starts to
> thrash. If it can't keep the working set in memory, then OOM.
> Losing one of many tabs is a better behaviour for the user than an
> unresponsive system.
> 
> This patch create a new sysctl, min_filelist_kbytes, which disables reclaim
> of file-backed pages when when there are less than min_filelist_bytes worth
> of such pages in the cache. This tunable is handy for low memory systems
> using solid-state storage where interactive response is more important
> than not OOMing.
> 
> With this patch and min_filelist_kbytes set to 50000, I see very little
> block layer activity during low memory. The system stays responsive under
> low memory and browser tab switching is fast. Eventually, a process a gets
> killed by OOM. Without this patch, the system gets wedged for minutes
> before it eventually OOMs. Below is the vmstat output from my test runs.

I've heared similar requirement sometimes from embedded people. then also
don't use swap. then, I don't think this is hopeless idea. but I hope to 
clarify some thing at first.

Yes, a system often have should-not-be-evicted-file-caches. Typically, they
are libc, libX11 and some GUI libraries. Traditionally, we was making tiny
application which linked above important lib and call mlockall() at startup.
such technique prevent reclaim. So, Q1: Why do you think above traditional way
is insufficient? 

Q2: In the above you used min_filelist_kbytes=50000. How do you decide 
such value? Do other users can calculate proper value?

In addition, I have two request. R1: I think chromium specific feature is
harder acceptable because it's harder maintable. but we have good chance to
solve embedded generic issue. Please discuss Minchan and/or another embedded
developers. R2: If you want to deal OOM combination, please consider to 
combination of memcg OOM notifier too. It is most flexible and powerful OOM
mechanism. Probably desktop and server people never use bare OOM killer intentionally.

Thanks.



