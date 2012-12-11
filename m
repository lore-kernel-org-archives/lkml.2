Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab2LKDhC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 22:37:02 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43684 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab2LKDhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 22:37:01 -0500
Date: Tue, 11 Dec 2012 04:36:59 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: Andi Kleen <andi@firstfloor.org>, Fengguang Wu <fengguang.wu@intel.com>,
        Simon Jeons <simon.jeons@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        WuJianguo <wujianguo@huawei.com>, Liujiang <jiang.liu@huawei.com>,
        Vyacheslav.Dubeyko@huawei.com, Borislav Petkov <bp@alien8.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, wency@cn.fujitsu.com,
        Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH V2] MCE: fix an error of mce_bad_pages statistics
Message-ID: <20121211033659.GA16230@one.firstfloor.org>
References: <20121207141102.4fda582d.akpm@linux-foundation.org> <20121210083342.GA31670@hacker.(null)> <50C5A62A.6030401@huawei.com> <1355136423.1700.2.camel@kernel.cn.ibm.com> <50C5C4A2.2070002@huawei.com> <20121210153805.GS16230@one.firstfloor.org> <50C6997C.1080702@huawei.com> <20121211024522.GA10505@localhost> <20121211025857.GX16230@one.firstfloor.org> <50C6A7BC.8010200@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C6A7BC.8010200@huawei.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> "There are not so many free pages in a typical server system", sorry I don't
> quite understand it.

Linux tries to keep most memory in caches. As Linus says "free memory is
bad memory"

>
> buffered_rmqueue()
> 	prep_new_page()
> 		check_new_page()
> 			bad_page()
> 
> If we alloc 2^10 pages and one of them is a poisoned page, then the whole 4M
> memory will be dropped.

prep_new_page() is only called on whatever is allocated.
MAX_ORDER is much smaller than 2^10

If you allocate a large order page then yes the complete page is
dropped. This is today generally true in hwpoison. It would be one
possible area of improvement (probably mostly if 1GB pages become
more common than they are today)

It's usually not a problem because usually most allocations are
small order and systems have generally very few memory errors,
and even the largest MAX_ORDER pages are a small fraction of the 
total memory.

If you lose larger amounts of memory usually you quickly hit something
that HWPoison cannot handle.

-Andi
