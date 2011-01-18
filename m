Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab1ARCl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 21:41:27 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53900 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab1ARCl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 21:41:26 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 18 Jan 2011 11:35:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: [PATCH 0/4] fix THP and memcg issues v3
Message-Id: <20110118113528.fd24928f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I found PCG_ACCT_LRU is copied at splitting in patch 2/4 but it will cause
VM_BUG_ON(). The fix for it was in patch 3/4...This set is a corrected one.
==
Now, when THP is enabled, memcg's counter goes wrong. Moreover, rmdir()
may not end. I fixed some races since v1.


This series is a fix for obviouse counter breakage. When you test,
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y

is appreciated. Tests should be done is:

# mount -t cgroup none /cgroup/memory -omemory
# mkdir /cgroup/memory/A
# mkdir /cgroup/memory/A/B
# run some programs under B.
# echo 0 > /cgroup/memory/A/B/memory.force_empty

and check B's memory.stat shows RSS/CACHE/LRU are all 0.
Moving tasks while running is another good test.

I know there are another problem when memory cgroup hits limit and
reclaim in busy. But I will fix it in another patch.

Thanks,
-Kame

