Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833Ab0KVHWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 02:22:17 -0500
Received: from mga14.intel.com ([143.182.124.37]:59005 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206Ab0KVHWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 02:22:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,235,1288594800"; 
   d="scan'208";a="351616797"
Subject: -tip tree resume fail, bisect to 5bd5a45(x86: Add NX protection
 for kernel data)
From: Lin Ming <ming.m.lin@intel.com>
To: Matthieu Castet <castet.matthieu@free.fr>,
        Siarhei Liakh <sliakh.lkml@gmail.com>,
        Xuxian Jiang <jiang@cs.ncsu.edu>, Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Nov 2010 15:23:01 +0800
Message-ID: <1290410581.2405.24.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

Current -tip tree(92c883a) fail to resume after suspend to mem.
Bisect to commit 5bd5a45(x86: Add NX protection for kernel data).

commit 5bd5a452662bc37c54fb6828db1a3faf87e6511c
Author: Matthieu Castet <castet.matthieu@free.fr>
Date:   Tue Nov 16 22:31:26 2010 +0100

    x86: Add NX protection for kernel data


I did some debug and found the regression is caused by below line.

-       set_memory_nx(rodata_start, (end - rodata_start) >> PAGE_SHIFT);
+       set_memory_nx(rodata_start, (kernel_end - rodata_start) >> PAGE_SHIFT);

In my machine,
rodata_start=0xffffffff81a00000, end=0xffffffff81e00000, kernel_end=0xffffffff82200000

Without this commit, kernel page table dumps

---[ High Kernel Mapping ]---
....
0xffffffff81a00000-0xffffffff81c00000           2M     ro         PSE GLB NX pmd
0xffffffff81c00000-0xffffffff81d91000        1604K     ro             GLB NX pte
0xffffffff81d91000-0xffffffff81e00000         444K     ro             GLB NX pte
0xffffffff81e00000-0xffffffff82000000           2M     RW         PSE GLB x  pmd
0xffffffff82000000-0xffffffff8200c000          48K     RW             GLB x  pte
0xffffffff8200c000-0xffffffff82100000         976K     RW             GLB x  pte
0xffffffff82100000-0xffffffff82200000           1M     RW             GLB x  pte
.....

With this commit, kernel page table dumps

---[ High Kernel Mapping ]---
....
0xffffffff81a00000-0xffffffff81c00000           2M     ro         PSE GLB NX pmd
0xffffffff81c00000-0xffffffff81d91000        1604K     ro             GLB NX pte
0xffffffff81d91000-0xffffffff81e00000         444K     ro             GLB NX pte
0xffffffff81e00000-0xffffffff82000000           2M     RW         PSE GLB NX pmd
0xffffffff82000000-0xffffffff8200c000          48K     RW             GLB NX pte
0xffffffff8200c000-0xffffffff82100000         976K     RW             GLB NX pte
0xffffffff82100000-0xffffffff82200000           1M     RW             GLB NX pte
.....

The only difference is 0xffffffff81e00000(end) to 0xffffffff82200000(kernel_end) is set to NX.

I guess this range code is used by resume wakeup code. So setting it to NX causes problem.

Any idea?

Thanks,
Lin Ming


