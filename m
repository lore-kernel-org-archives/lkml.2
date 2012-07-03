Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718Ab2GCDZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 23:25:05 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:34901 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab2GCDZC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 23:25:02 -0400
MIME-Version: 1.0
In-Reply-To: <4FF25EFA.1080004@huawei.com>
References: <1341047274-5616-1-git-send-email-jiang.liu@huawei.com>
	<CAE9FiQWzfLkeQs8O22MUEmuGUx=jPi5s=wZt2fcpFMcwrzt3uA@mail.gmail.com>
	<4FF100F0.9050501@huawei.com>
	<CAE9FiQXpeGFfWvUHHW_GjgTg+4Op7agsht5coZbcmn2W=f9bqw@mail.gmail.com>
	<4FF25EFA.1080004@huawei.com>
Date: Mon, 2 Jul 2012 20:25:00 -0700
X-Google-Sender-Auth: QMI0yZEENvUcmXlNGSMCZfOXNaM
Message-ID: <CAE9FiQVxY9E3L_xmRj10+9D6NVbKaxaAd2oJ6EFe1D+Gy2971w@mail.gmail.com>
Subject: Re: [PATCH] mm: setup pageblock_order before it's used by sparse
From: Yinghai Lu <yinghai@kernel.org>
To: Jiang Liu <jiang.liu@huawei.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Tony Luck <tony.luck@intel.com>, Xishi Qiu <qiuxishi@huawei.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Keping Chen <chenkeping@huawei.com>, linux-mm@kvack.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 2, 2012 at 7:54 PM, Jiang Liu <jiang.liu@huawei.com> wrote:
> On 2012-7-3 4:43, Yinghai Lu wrote:
>> On Sun, Jul 1, 2012 at 7:01 PM, Jiang Liu <jiang.liu@huawei.com> wrote:
>>> Hi Yinghai,
>>>         The patch fails compilation as below:
>>> mm/page_alloc.c:151: error: initializer element is not constant
>>> mm/page_alloc.c:151: error: expected ‘,’ or ‘;’ before ‘__attribute__’
>>>
>>> On IA64, HUGETLB_PAGE_ORDER has dependency on variable hpage_shift.
>>> # define HUGETLB_PAGE_ORDER        (HPAGE_SHIFT - PAGE_SHIFT)
>>> # define HPAGE_SHIFT               hpage_shift
>>>
>>> And hpage_shift could be changed by early parameter "hugepagesz".
>>> So seems will still need to keep function set_pageblock_order().
>>
>> ah,  then use use _DEFAULT instead and later could update that in earlyparam.
>>
>> So attached -v2 should  work.
> Hi Yinghai,
>
> I'm afraid the v2 will break powerpc. Currently only IA64 and PowerPC
> supports variable hugetlb size.
>
> HPAGE_SHIFT is a variable default to 0 on powerpc. But seems PowerPC
> is doing something wrong here, according to it's mm initialization
> sequence as below:
> start_kernel()
>         setup_arch()
>                 paging_init()
>                         free_area_init_node()
>                                 set_pageblock_order()
>                                         refer to HPAGE_SHIFT (still 0)
>         init_rest()
>                 do_initcalls()
>                         hugetlbpage_init()
>                                 setup HPAGE_SHIFT
> That means pageblock_order is always set to "MAX_ORDER - 1", not sure
> whether this is intended. And it has the same issue as IA64 of wasting
> memory if CONFIG_SPARSE is enabled.

adding BenH, need to know if it is powerpc intended.

>
> So it would be better to keep function set_pageblock_order(), it will
> fix the memory wasting on both IA64 and PowerPC.

Should setup pageblock_order as early as possible to avoid confusing.

Thanks

Yinghai
