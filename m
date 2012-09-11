Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001Ab2IKDHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 23:07:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51841 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754967Ab2IKDHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 23:07:33 -0400
X-IronPort-AV: E=Sophos;i="4.80,401,1344182400"; 
   d="scan'208";a="5817779"
Message-ID: <504EAB67.7060604@cn.fujitsu.com>
Date: Tue, 11 Sep 2012 11:09:27 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [V4 PATCH 00/26] memory,numa: introduce MOVABLE-dedicated node
 and online_movable for hotplug
References: <1347267558-6707-1-git-send-email-laijs@cn.fujitsu.com> <504E8874.5020605@jp.fujitsu.com> <504E9270.8040006@cn.fujitsu.com> <504E95DE.8000102@jp.fujitsu.com>
In-Reply-To: <504E95DE.8000102@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/11 11:07:00,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/11 11:07:00,
	Serialize complete at 2012/09/11 11:07:00
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2012 09:37 AM, Yasuaki Ishimatsu wrote:
> Hi Lai,
> 
> 2012/09/11 10:22, Lai Jiangshan wrote:
>> On 09/11/2012 08:40 AM, Yasuaki Ishimatsu wrote:
>>> Hi Lai,
>>>
>>> Using memory_online to hot-added node's memory, the following kernel messages
>>> were shown. Is this a known issue?
>>
>> Thank you for your report.
>>
>> What operations did you have performed ?
> 
> My operations are as follows:
> 
> 1. Hot-add a new node by container driver.
>    In my system, container driver hot-addes a new nodes which includes CPUs and
>    memorys.
> 
> 2. echo online_movable to hot-added nodes's memory
>    When container driver hot-adds a new nodes, my system creates node2 sysfs.
>    And the sysfs has memory768-memory1023 sysfs. So I echo "online_movable"
>    to memory1023/state file.
>    # echo online_movable > memory1023/state
> 


I can't reproduce the bug. and my system is a little different from you.
could you show me the /proc/zoneinfo?

also, could you add following patch, it will help me know which constraint I have broken.

Thanks,
Lai

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3878170..68302ef 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -549,6 +549,9 @@ static inline void __free_one_page(struct page *page,
 
 	page_idx = page_to_pfn(page) & ((1 << MAX_ORDER) - 1);
 
+	VM_BUG_ON(page_outside_zone_boundaries(zone, page));
+	VM_BUG_ON(!pfn_valid_within(page_to_pfn(page)));
+	VM_BUG_ON(zone != page_zone(page));
 	VM_BUG_ON(page_idx & ((1 << order) - 1));
 	VM_BUG_ON(bad_range(zone, page));
 
