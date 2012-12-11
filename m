Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab2LKGuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 01:50:20 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:49339 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab2LKGuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 01:50:19 -0500
Message-ID: <50C6D762.4030507@huawei.com>
Date: Tue, 11 Dec 2012 14:49:06 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: Simon Jeons <simon.jeons@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        WuJianguo <wujianguo@huawei.com>, Liujiang <jiang.liu@huawei.com>,
        <Vyacheslav.Dubeyko@huawei.com>, Borislav Petkov <bp@alien8.de>,
        <andi@firstfloor.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <wency@cn.fujitsu.com>
Subject: Re: [PATCH V2] MCE: fix an error of mce_bad_pages statistics
References: <50C1AD6D.7010709@huawei.com> <20121207141102.4fda582d.akpm@linux-foundation.org> <20121210083342.GA31670@hacker.(null)> <50C5A62A.6030401@huawei.com> <1355136423.1700.2.camel@kernel.cn.ibm.com> <50C5C4A2.2070002@huawei.com> <1355140561.1821.5.camel@kernel.cn.ibm.com> <50C5D844.8050707@huawei.com> <1355143664.1821.8.camel@kernel.cn.ibm.com> <20121211011643.GA15754@hacker.(null)>
In-Reply-To: <20121211011643.GA15754@hacker.(null)>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Hi Simon,

>>>
>>> If we use "/sys/devices/system/memory/soft_offline_page" to offline a
>>> free page, the value of mce_bad_pages will be added. Then the page is marked
>>> HWPoison, but it is still managed by page buddy alocator.
>>>
>>> So if we offline it again, the value of mce_bad_pages will be added again.
>>> Assume the page is not allocated during this short time.
>>>
>>> soft_offline_page()
>>> 	get_any_page()
>>> 		"else if (is_free_buddy_page(p))" branch return 0
>>> 			"goto done";
>>> 				"atomic_long_add(1, &mce_bad_pages);"
>>>
>>> I think it would be better to move "if(PageHWPoison(page))" at the beginning of
>>> soft_offline_page(). However I don't know what do these words mean,
>>> "Synchronized using the page lock with memory_failure()"
> 
> Hi Xishi,
> 
> Unpoison will clear PG_hwpoison flag after hold page lock, memory_failure() and 
> soft_offline_page() take the lock to avoid unpoison clear the flag behind them.
> 
> Regards,
> Wanpeng Li 
> 

Hi Wanpeng,

As you mean, it is the necessary to get the page lock first when we check the
HWPoison flag every time, this is in order to avoid conflict, right?

So why not use a globe lock here? For example lock_memory_hotplug() is used in
online_pages() and offline_pages()?

Thanks,
Xishi Qiu

