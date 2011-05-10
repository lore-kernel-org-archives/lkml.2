Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab1EJKJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 06:09:01 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47776 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab1EJKJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 06:09:00 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 10 May 2011 19:02:16 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ying Han <yinghan@google.com>, Johannes Weiner <jweiner@redhat.com>,
        Michal Hocko <mhocko@suse.cz>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [RFC][PATCH 0/7] memcg async reclaim
Message-Id: <20110510190216.f4eefef7.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, thank you for all comments on previous patches for watermarks for memcg.

This is a new series as 'async reclaim', no watermark.
This version is a RFC again and I don't ask anyone to test this...but
comments/review are appreciated. 

Major changes are
  - no configurable watermark
  - hierarchy support
  - more fix for static scan rate round robin scanning of memcg.

(assume x86-64 in following.)

'async reclaim' works when
   - usage > limit - 4MB.
until
   - usage < limit - 8MB.

when the limit is larger than 128MB. This value of margin to limit
has some purpose for helping to reduce page fault latency at using
Transparent hugepage.

Considering THP, we need to reclaim HPAGE_SIZE(2MB) of pages when we hit
limit and consume HPAGE_SIZE(2MB) immediately. Then, the application need to
scan 2MB per each page fault and get big latency. So, some margin > HPAGE_SIZE
is required. I set it as 2*HPAGE_SIZE/4*HPAGE_SIZE, here. The kernel
will do async reclaim and reduce usage to limit - 8MB in background.

BTW, when an application gets a page, it tend to do some action to fill the
gotton page. For example, reading data from file/network and fill buffer.
This implies the application will have a wait or consumes cpu other than
reclaiming memory. So, if the kernel can help memory freeing in background
while application does another jobs, application latency can be reduced.
Then, this kind of asyncronous reclaim of memory will be a help for reduce
memory reclaim latency by memcg. But the total amount of cpu time consumed
will not have any difference.

This patch series implements
  - a logic for trigger async reclaim
  - help functions for async reclaim
  - core logic for async reclaim, considering memcg's hierarchy.
  - static scan rate memcg reclaim.
  - workqueue for async reclaim.

Some concern is that I didn't implement a code for handle the case
most of pages are mlocked or anon memory in swapless system. I need some
detection logic to avoid hopless async reclaim.

Any comments are welcome.

Thanks,
-Kame

