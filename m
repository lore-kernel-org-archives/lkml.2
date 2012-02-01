Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab2BAGwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 01:52:33 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53243 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752899Ab2BAGwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 01:52:32 -0500
Message-ID: <4F28E1D1.900@cn.fujitsu.com>
Date: Wed, 01 Feb 2012 14:55:13 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH 1/6] netprio_cgroup: fix an off-by-one bug
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-01 14:51:06,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-01 14:51:07,
	Serialize complete at 2012-02-01 14:51:07
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  # mount -t cgroup xxx /mnt
  # mkdir /mnt/tmp
  # cat /mnt/tmp/net_prio.ifpriomap
  lo 0
  eth0 0
  virbr0 0
  # echo 'lo 999' > /mnt/tmp/net_prio.ifpriomap
  # cat /mnt/tmp/net_prio.ifpriomap
  lo 999
  eth0 0
  virbr0 4101267344

We got weired output, because we exceeded the boundary of the array.
We may even crash the kernel..

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 net/core/netprio_cgroup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
index 3a9fd48..a296cbb 100644
--- a/net/core/netprio_cgroup.c
+++ b/net/core/netprio_cgroup.c
@@ -107,7 +107,7 @@ static void extend_netdev_table(struct net_device *dev, u32 new_len)
 static void update_netdev_tables(void)
 {
 	struct net_device *dev;
-	u32 max_len = atomic_read(&max_prioidx);
+	u32 max_len = atomic_read(&max_prioidx) + 1;
 	struct netprio_map *map;
 
 	rtnl_lock();
-- 
1.7.3.1
