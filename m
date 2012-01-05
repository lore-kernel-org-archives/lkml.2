Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab2AELum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 06:50:42 -0500
Received: from smtp.nokia.com ([147.243.128.26]:21939 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755942Ab2AELul convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 06:50:41 -0500
From: <leonid.moiseichuk@nokia.com>
To: <gregkh@suse.de>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <cesarb@cesarb.net>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <emunson@mgebm.net>,
        <penberg@kernel.org>, <aarcange@redhat.com>, <riel@redhat.com>,
        <mel@csn.ul.ie>, <rientjes@google.com>, <dima@android.com>,
        <rebecca@android.com>, <san@google.com>, <akpm@linux-foundation.org>,
        <vesa.jaaskelainen@nokia.com>
Subject: RE: [PATCH 3.2.0-rc1 0/3] Used Memory Meter pseudo-device and
 related changes in MM
Thread-Topic: [PATCH 3.2.0-rc1 0/3] Used Memory Meter pseudo-device and
 related changes in MM
Thread-Index: AQHMyxrzN1IXGAcozUyLCM5upAjFdpX9o6Hw
Date: Thu, 5 Jan 2012 11:47:21 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB98269045542B5@008-AM1MPN1-003.mgdnok.nokia.com>
References: <cover.1325696593.git.leonid.moiseichuk@nokia.com>
 <20120104195612.GB19181@suse.de>
In-Reply-To: <20120104195612.GB19181@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.23.171]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 05 Jan 2012 11:47:22.0699 (UTC) FILETIME=[C97469B0:01CCCB9F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Android OOM (AOOM) is a different thing. Briefly Android OOM is a safety belt, but I try to introduce look-ahead radar to stop before hitting wall.

As I understand AOOM it wait until situation is reached bad conditions which required memory reclaiming, selects application according to free memory and oom_adj level and kills it.
So no intermediate levels could be checked (e.g. 75% usage),  nothing could be done in user-space to prevent killing, no notification for case when memory becomes OK.

What I try to do is to get notification in any application that memory becomes low, and do something about it like stop processing data, close unused pages or correctly shuts applications, daemons.
Application(s) might have necessity to install several notification levels, so reaction could be adjusted based on current utilization level per each application, not globally.

Rik van Riel have pointed Kosaki-san's low memory notification. I know about mem_notify but according to Anton Vorontsov's statement [1] it is died since 2008 and for me it is really good news that is still not. 
I need to re-investigate it.

With Best Wishes,
Leonid

[1] http://permalink.gmane.org/gmane.linux.kernel.mm/71626

-----Original Message-----
From: ext Greg KH [mailto:gregkh@suse.de] 
Sent: 04 January, 2012 21:56
To: Moiseichuk Leonid (Nokia-MP/Helsinki)
Cc: linux-mm@kvack.org; linux-kernel@vger.kernel.org; cesarb@cesarb.net; kamezawa.hiroyu@jp.fujitsu.com; emunson@mgebm.net; penberg@kernel.org; aarcange@redhat.com; riel@redhat.com; mel@csn.ul.ie; rientjes@google.com; dima@android.com; rebecca@android.com; san@google.com; akpm@linux-foundation.org; Jaaskelainen Vesa (Nokia-MP/Helsinki)
Subject: Re: [PATCH 3.2.0-rc1 0/3] Used Memory Meter pseudo-device and related changes in MM

On Wed, Jan 04, 2012 at 07:21:53PM +0200, Leonid Moiseichuk wrote:
> The main idea of Used Memory Meter (UMM) is to provide low-cost 
> interface for user-space to notify about memory consumption using 
> similar approach /proc/meminfo does but focusing only on "modified" pages which cannot be fogotten.
> 
> The calculation formula in terms of meminfo looks the following:
>   UsedMemory = (MemTotal - MemFree - Buffers - Cached - SwapCached) +
>                                                (SwapTotal - SwapFree) 
> It reflects well amount of system memory used in applications in heaps and shared pages.
> 
> Previously (n770..n900) we had lowmem.c [1] which used LSM and did a 
> lot other things,
> n9 implementation based on memcg [2] which has own problems, so the 
> proposed variant I hope is the best one for n9:
> - Keeps connections from user space
> - When amount of modified pages reaches crossed pointed value for particular connection
>   makes POLLIN and allow user-space app to read it and react
> - Economic as much as possible, so currently its operates if allocation higher than 487
>   pages or last check happened 250 ms before Of course if no 
> allocation happened then no activities performed, use-time must be not 
> affected.
> 
> Testing results:
> - Checkpatch produced 0 warning
> - Sparse does not produce warnings
> - One check costs ~20 us or less (could be checked with probe=1 
> insmod)
> - One connection costs 20 bytes in kernel-space  (see observer 
> structure) for 32-bit variant
> - For 10K connections poll update in requested in ~10ms, but for practically device expected
>   to will have about 10 connections (like n9 has now).
> 
> Known weak points which I do not know how to fix but will if you have a brillian idea:
> - Having hook in MM is nasty but MM/shrinker cannot be used there and 
> LSM even worse idea
> - If I made 
> 	$cat /dev/used_memory
>   it is produced lines in non-stop mode. Adding position check in umm_read seems doesn not help,
>   so "head -1 /dev/used_memory" should be used if you need to quick 
> check
> - Format of output is USED_PAGES:AVAILABLE_PAGES, primitive but enough 
> for tasks module does
> 
> Tested on ARM, x86-32 and x86-64 with and without CONFIG_SWAP. Seems works in all combinations.
> Sorry for wide distributions but list of names were produced by 
> scripts/get_maintainer.pl

How does this compare with the lowmemorykiller.c driver from the android developers that is currently in the linux-next tree?

thanks,

greg k-h
