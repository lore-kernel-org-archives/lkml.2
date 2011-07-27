Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab1G0FwC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 01:52:02 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39012 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab1G0FwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 01:52:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 27 Jul 2011 14:44:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [PATCH v4 0/5] memcg : make numa scanning better
Message-Id: <20110727144438.a9fdfd5b.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When 889976db(memcg: reclaim memory from nodes in round-robin order) is
pushed, I mentioned "But yes, a better algorithm is needed."

Here is one. 

I already cut out some of pieces, which was in this set, and pushed to upstream.
This series contains more fixes and a new core logic.

The concept is to select a node with regard to page usages.
This patch calculates weight of nodes and does scheduling proportionally
fair to each node's weight. The weight is calculated in adaptive way
considering the status of the whole memcg. In short, if a node contains
much (inactive) file caches, the node will be a victim.


As I did before, I did apache-bench test as following.

Host
   Host : Xeon 8cpu 
   Memory: 24GB

What test ?
   access a CGI script which reads a file in random. And access it by
   apatch-bench. The randomnes of file access is normalized.
   Full working set is 600MB.
   And run httpd under memcg. This will cause memory reclaim and read I/O.

[Set limit as 300M]
 
<mmotm-0709 + some merged bugfixes>
Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.1      0       1
Processing:    41   48  15.0     46    1161
Waiting:       40   46  10.5     44     623
Total:         41   48  15.0     46    1161

scanned_pages_by_limit 410693
elapsed_ns_by_limit 2393975561

<mmotm-0709 + cpuset's page cache spread nodes>
Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.1      0       1
Processing:    42   48  16.9     46    1616
Waiting:       40   46  14.7     44    1614
Total:         42   48  16.9     46    1616

scanned_pages_by_limit 271733
elapsed_ns_by_limit 1415085661

<patch>
Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       1
Processing:    41   46   7.5     45     706
Waiting:       39   45   6.4     44     630
Total:         41   46   7.5     45     706

scanned_pages_by_limit 302282
elapsed_ns_by_limit 1312758481

<patch + cpuset's page cache spread nodes>
Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.1      0       4
Processing:    42   47  11.4     46     962
Waiting:       40   45   8.7     44     493
Total:         42   47  11.4     46     962

scanned_pages_by_limit 349020
elapsed_ns_by_limit 1594144061

[Set Limit as 400M]
<mmotm-0709>
Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       3
Processing:    40   45   4.7     45     467
Waiting:       39   44   4.4     43     465
Total:         40   45   4.7     45     467

scanned_pages_by_limit 156279
elapsed_ns_by_limit 1274982214

<mmotm-0709 + cpuset's node spread>
Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.1      0       1
Processing:    41   46   6.9     45     458
Waiting:       40   44   4.5     44     388
Total:         41   46   6.9     45     459

scanned_pages_by_limit 346534
elapsed_ns_by_limit 2612352442


<Patch>
Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       1
Processing:    42   45   5.1     45     467
Waiting:       38   44   4.5     43     465
Total:         42   45   5.1     45     467

scanned_pages_by_limit 116307
elapsed_ns_by_limit 624529569

<patch+spread>
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       1
Processing:    41   46   5.3     45     392
Waiting:       39   44   4.1     43     388
Total:         41   46   5.3     45     392

scanned_pages_by_limit 154865
elapsed_ns_by_limit 830638510


In general, this patch set reduce memory reclaim scans and time and
helps reclaiming memory in efficient way.

Thanks,
-Kame









