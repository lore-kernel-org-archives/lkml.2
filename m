Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab2IFHSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 03:18:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43792 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab2IFHSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 03:18:09 -0400
Message-ID: <50484E2C.1060107@gmail.com>
Date: Thu, 06 Sep 2012 15:18:04 +0800
From: wujianguo <wujianguo106@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: tony.luck@intel.com, akpm@linux-foundation.org, fenghua.yu@intel.com
CC: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, jiang.liu@huawei.com, guohanjun@huawei.com,
        qiuxishi@huawei.com, wujianguo@huawei.com, wency@cn.fujitsu.com
Subject: [PATCH RESEND]mm/ia64: fix a node distance bug
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jianguo Wu <wujianguo@huawei.com>

In arch ia64, has following definition:
extern u8 numa_slit[MAX_NUMNODES * MAX_NUMNODES];
#define node_distance(from,to) (numa_slit[(from) * num_online_nodes() + (to)])

num_online_nodes() is a variable value, it can be changed after hot-remove/add
a node.

I my practice, I found node distance is wrong after offline
a node in IA64 platform. For example system has 4 nodes:
node distances:
node   0   1   2   3
  0:  10  21  21  32
  1:  21  10  32  21
  2:  21  32  10  21
  3:  32  21  21  10

linux-drf:/sys/devices/system/node/node0 # cat distance
10  21  21  32
linux-drf:/sys/devices/system/node/node1 # cat distance
21  10  32  21

After offline node2:
linux-drf:/sys/devices/system/node/node0 # cat distance
10 21 32
linux-drf:/sys/devices/system/node/node1 # cat distance
32 21 32	--------->expected value is: 21  10  21


Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 arch/ia64/include/asm/numa.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/include/asm/numa.h b/arch/ia64/include/asm/numa.h
index 6a8a27c..2e27ef1 100644
--- a/arch/ia64/include/asm/numa.h
+++ b/arch/ia64/include/asm/numa.h
@@ -59,7 +59,7 @@ extern struct node_cpuid_s node_cpuid[NR_CPUS];
  */

 extern u8 numa_slit[MAX_NUMNODES * MAX_NUMNODES];
-#define node_distance(from,to) (numa_slit[(from) * num_online_nodes() + (to)])
+#define node_distance(from,to) (numa_slit[(from) * MAX_NUMNODES + (to)])

 extern int paddr_to_nid(unsigned long paddr);

-- 1.7.6.1 .
