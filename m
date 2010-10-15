Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab0JOILz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 04:11:55 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55439 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab0JOILx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 04:11:53 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 15 Oct 2010 17:06:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        Greg Thelen <gthelen@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [RFC][PATCH 0/2] memcg: some updates to move_account and file_stat
 races
Message-Id: <20101015170627.e5033fa4.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


At implementing dirty page accounting support, one of problem is that
PG_writeback update can be called in IRQ context. So, following kind of dead-lock
can be considered.

  lock_page_cgroup()
	<--------------- IRQ
			  try to update Writeback state of memcg
		          lock_page_cgroup()
			  DEAD LOCK

To avoid this, one idea is IRQ disabling in lock_page_cgroup() but our concern is
it's too heavy. 

Considering more, there are facts
  -  why update_file_stat() has to take lock_page_cgroup() is just for avoiding
     race with move_account(). There are no race with charge/uncharge.

So, this series adds a new lock for mutual exection of move_account() and
update_file_stat(). This lock is always taken under IRQ disable.
This adds new lock to move_account()....so this makes move_account() slow.
It's a trade-off to be considered.


This series contains 2 patches. One is a trial to performance improvement,
next one is adding a new lock.
They are independent from each other.
All are onto mmotm-1014 + removing memcg-reduce-lock-hold-time-during-charge-moving.patch

Scores on my box at moving 8GB anon process.

== mmotm ==
root@bluextal kamezawa]# time echo 2530 > /cgroup/B/tasks

real    0m0.792s
user    0m0.000s
sys     0m0.780s

== After patch 1==
[root@bluextal kamezawa]# time echo 2257 > /cgroup/B/tasks

real    0m0.694s
user    0m0.000s
sys     0m0.683s

[After Patch #2]
[root@bluextal kamezawa]# time echo 2238 > /cgroup/B/tasks

real    0m0.741s
user    0m0.000s
sys     0m0.730s

Any comments/advices are welcome.

Thanks,
-Kame



