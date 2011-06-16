Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab1FPDzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 23:55:22 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37461 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab1FPDzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 23:55:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 16 Jun 2011 12:47:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        Ying Han <yinghan@google.com>, Michal Hocko <mhocko@suse.cz>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: [PATCH 0/7] memcg numa node scan update.
Message-Id: <20110616124730.d6960b8b.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In the last month, I added round-robin scan of numa nodes at
hittling limit, and wrote "a better algorithm is needed."

Here is update. Because some of patches are bugfixes, I may
cut out them as independent patch.

Pathc 6-7/7 implements a selection logic.

==
Tested on 8cpu/24GB system, which has 2 nodes.
limit memory to 300MB and run httpd under it.
httpd's working set is 4096files/600MB.

Then, do 40960 access by apache-bench. and see how memory reclaim costs.
Because a thread of httpd doesn't consume cpu much, the number of
working threads are not balanced between numa nodes and file caches
will be not balanced.

[round-robin]
 [kamezawa@bluextal ~]$ cat /cgroup/memory/test/memory.scan_stat
  scanned_pages_by_limit 550740
  freed_pages_by_limit 206473
  elapsed_ns_by_limit 9485418834

[After patch]
  scanned_pages_by_limit 521520
  freed_pages_by_limit 199330
  elapsed_ns_by_limit 7904913234

I can see elapsed time is decreased.
Test on big machine is welcomed.

Thanks,
-Kame

