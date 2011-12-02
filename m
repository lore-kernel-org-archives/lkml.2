Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab1LBArn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 19:47:43 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46525 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987Ab1LBArm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 19:47:42 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 2 Dec 2011 09:46:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Rientjes <rientjes@google.com>, Dang Bo <bdang@vmware.com>,
        Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        John Stultz <john.stultz@linaro.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Ensure that pfn_valid is called once per pageblock
 when reserving pageblocks
Message-Id: <20111202094629.f91e2d3f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111201102904.GA8809@tiehlicka.suse.cz>
References: <20111201102904.GA8809@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Dec 2011 11:29:04 +0100
Michal Hocko <mhocko@suse.cz> wrote:

> Hi,
> the patch bellow fixes a crash during boot (when we set up reserved
> page blocks) if zone start_pfn is not block aligned. The issue has
> been introduced in 3.0-rc1 by 6d3163ce: mm: check if any page in a
> pageblock is reserved before marking it MIGRATE_RESERVE.
> 
> I think this is 3.2 and stable material.
> ---
> From f4da723adb36b247b80283ae520e33726caf485f Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Tue, 29 Nov 2011 16:58:38 +0100
> Subject: [PATCH] mm: Ensure that pfn_valid is called once per pageblock when
>  reserving pageblocks
> 
> setup_zone_migrate_reserve expects that zone->start_pfn starts
> at pageblock_nr_pages aligned pfn otherwise we could access
> beyond an existing memblock resulting in the following panic if
> CONFIG_HOLES_IN_ZONE is not configured and we do not check pfn_valid:
> 
> IP: [<c02d331d>] setup_zone_migrate_reserve+0xcd/0x180
> *pdpt = 0000000000000000 *pde = f000ff53f000ff53
> Oops: 0000 [#1] SMP
> Modules linked in:
> Supported: Yes
> 
> Pid: 1, comm: swapper Not tainted 3.0.7-0.7-pae #1 VMware, Inc.
> VMware Virtual Platform/440BX Desktop Reference Platform
> EIP: 0060:[<c02d331d>] EFLAGS: 00010006 CPU: 0
> EIP is at setup_zone_migrate_reserve+0xcd/0x180
> EAX: 000c0000 EBX: f5801fc0 ECX: 000c0000 EDX: 00000000
> ESI: 000c01fe EDI: 000c01fe EBP: 00140000 ESP: f2475f58
> DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process swapper (pid: 1, ti=f2474000 task=f2472cd0 task.ti=f2474000)
> Stack:
> f4000800 00000000 f4000800 000006b8 00000000 000c6cd5 c02d389c 000003b2
> 00036aa9 00000292 f4000830 c08cfe78 00000000 00000000 c08a76f5 c02d3a1f
> c08a771c c08cfe78 c020111b 35310001 00000000 00000000 00000100 f24730c4
> Call Trace:
> [<c02d389c>] __setup_per_zone_wmarks+0xec/0x160
> [<c02d3a1f>] setup_per_zone_wmarks+0xf/0x20
> [<c08a771c>] init_per_zone_wmark_min+0x27/0x86
> [<c020111b>] do_one_initcall+0x2b/0x160
> [<c086639d>] kernel_init+0xbe/0x157
> [<c05cae26>] kernel_thread_helper+0x6/0xd
> Code: a5 39 f5 89 f7 0f 46 fd 39 cf 76 40 8b 03 f6 c4 08 74 32 eb 91 90 89 c8 c1 e8 0e 0f be 80 80 2f 86 c0 8b 14 85 60 2f 86 c0 89 c8 <2b> 82 b4 12 00 00 c1 e0 05 03 82 ac 12 00 00 8b 00 f6 c4 08 0f
> EIP: [<c02d331d>] setup_zone_migrate_reserve+0xcd/0x180 SS:ESP 0068:f2475f58
> CR2: 00000000000012b4
> ---[ end trace 93d72a36b9146f22 ]---
> 
> We crashed in pageblock_is_reserved() when accessing pfn 0xc0000 because
> highstart_pfn = 0x36ffe.
> 
> Make sure that start_pfn is always aligned to pageblock_nr_pages to
> ensure that pfn_valid s always called at the start of each pageblock.
> Architectures with holes in pageblocks will be correctly handled by
> pfn_valid_within in pageblock_is_reserved.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Tested-by: Dang Bo <bdang@vmware.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

