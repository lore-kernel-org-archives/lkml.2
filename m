Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab2GCC7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 22:59:42 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:57092 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab2GCC7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 22:59:41 -0400
Message-ID: <4FF25EFA.1080004@huawei.com>
Date: Tue, 3 Jul 2012 10:54:50 +0800
From: Jiang Liu <jiang.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Tony Luck <tony.luck@intel.com>, Xishi Qiu <qiuxishi@huawei.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Keping Chen <chenkeping@huawei.com>, <linux-mm@kvack.org>,
        <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] mm: setup pageblock_order before it's used by sparse
References: <1341047274-5616-1-git-send-email-jiang.liu@huawei.com> <CAE9FiQWzfLkeQs8O22MUEmuGUx=jPi5s=wZt2fcpFMcwrzt3uA@mail.gmail.com> <4FF100F0.9050501@huawei.com> <CAE9FiQXpeGFfWvUHHW_GjgTg+4Op7agsht5coZbcmn2W=f9bqw@mail.gmail.com>
In-Reply-To: <CAE9FiQXpeGFfWvUHHW_GjgTg+4Op7agsht5coZbcmn2W=f9bqw@mail.gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.108.108.229]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-7-3 4:43, Yinghai Lu wrote:
> On Sun, Jul 1, 2012 at 7:01 PM, Jiang Liu <jiang.liu@huawei.com> wrote:
>> Hi Yinghai,
>>         The patch fails compilation as below:
>> mm/page_alloc.c:151: error: initializer element is not constant
>> mm/page_alloc.c:151: error: expected ‘,’ or ‘;’ before ‘__attribute__’
>>
>> On IA64, HUGETLB_PAGE_ORDER has dependency on variable hpage_shift.
>> # define HUGETLB_PAGE_ORDER        (HPAGE_SHIFT - PAGE_SHIFT)
>> # define HPAGE_SHIFT               hpage_shift
>>
>> And hpage_shift could be changed by early parameter "hugepagesz".
>> So seems will still need to keep function set_pageblock_order().
> 
> ah,  then use use _DEFAULT instead and later could update that in earlyparam.
> 
> So attached -v2 should  work.
Hi Yinghai,

I'm afraid the v2 will break powerpc. Currently only IA64 and PowerPC
supports variable hugetlb size. 

HPAGE_SHIFT is a variable default to 0 on powerpc. But seems PowerPC 
is doing something wrong here, according to it's mm initialization 
sequence as below:
start_kernel()
	setup_arch()
		paging_init()
			free_area_init_node()
				set_pageblock_order()
					refer to HPAGE_SHIFT (still 0)
	init_rest()	
		do_initcalls()
			hugetlbpage_init()
				setup HPAGE_SHIFT
That means pageblock_order is always set to "MAX_ORDER - 1", not sure
whether this is intended. And it has the same issue as IA64 of wasting
memory if CONFIG_SPARSE is enabled.

So it would be better to keep function set_pageblock_order(), it will
fix the memory wasting on both IA64 and PowerPC.

Thanks!
Gerry

> 
> Thanks
> 
> Yinghai


