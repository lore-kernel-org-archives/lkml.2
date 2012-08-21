Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab2HUGoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 02:44:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:35246 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752427Ab2HUGnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 02:43:55 -0400
X-IronPort-AV: E=Sophos;i="4.77,801,1336320000"; 
   d="scan'208";a="5681252"
Message-ID: <50332B37.2000500@cn.fujitsu.com>
Date: Tue, 21 Aug 2012 14:31:19 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, mgorman@suse.de,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, hughd@google.com,
        minchan@kernel.org, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] memory hotplug: reset pgdat->kswapd to NULL if creating kernel
 thread fails
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/21 14:26:04,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/21 14:26:08,
	Serialize complete at 2012/08/21 14:26:08
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kthread_run() fails, pgdat->kswapd contains errno. When we stop
this thread, we only check whether pgdat->kswapd is NULL and access
it. If it contains errno, it will cause page fault. Reset pgdat->kswapd
to NULL when creating kernel thread fails can avoid this problem.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 mm/vmscan.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 347b3ff..1e8e2aa 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2953,6 +2953,7 @@ int kswapd_run(int nid)
 		/* failure at boot is fatal */
 		BUG_ON(system_state == SYSTEM_BOOTING);
 		printk("Failed to start kswapd on node %d\n",nid);
+		pgdat->kswapd = NULL;
 		ret = -1;
 	}
 	return ret;
-- 
1.7.1
