Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449Ab1BCO2A (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 3 Feb 2011 09:28:00 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:40517 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755086Ab1BCO1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 09:27:11 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: memcg: save 20% of per-page memcg memory overhead
Date: Thu,  3 Feb 2011 15:26:01 +0100
Message-Id: <1296743166-9412-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series removes the direct page pointer from struct
page_cgroup, which saves 20% of per-page memcg memory overhead (Fedora
and Ubuntu enable memcg per default, openSUSE apparently too).

The node id or section number is encoded in the remaining free bits of
pc->flags which allows calculating the corresponding page without the
extra pointer.

I ran, what I think is, a worst-case microbenchmark that just cats a
large sparse file to /dev/null, because it means that walking the LRU
list on behalf of per-cgroup reclaim and looking up pages from
page_cgroups is happening constantly and at a high rate.  But it made
no measurable difference.  A profile reported a 0.11% share of the new
lookup_cgroup_page() function in this benchmark.

	Hannes
