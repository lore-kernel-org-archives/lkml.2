Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab0KATva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:51:30 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21540 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab0KATv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:51:28 -0400
Date: Mon, 1 Nov 2010 20:40:56 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: linux-mm@kvack.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
        Pavel Emelianov <xemul@openvz.org>,
        Minchan Kim <minchan.kim@gmail.com>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org
Subject: [PATCH] cgroup: prefer [kv]zalloc over [kv]malloc+memset in memory
 controller code.
Message-ID: <alpine.LNX.2.00.1011012038490.12889@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi (please CC me on replies),


Apologies to those who receive this multiple times. I screwed up the To: 
field in my original mail :-(


In mem_cgroup_alloc() we currently do either kmalloc() or vmalloc() then 
followed by memset() to zero the memory. This can be more efficiently 
achieved by using kzalloc() and vzalloc().


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 memcontrol.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9a99cfa..90da698 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4199,14 +4199,13 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
 
 	/* Can be very big if MAX_NUMNODES is very big */
 	if (size < PAGE_SIZE)
-		mem = kmalloc(size, GFP_KERNEL);
+		mem = kzalloc(size, GFP_KERNEL);
 	else
-		mem = vmalloc(size);
+		mem = vzalloc(size);
 
 	if (!mem)
 		return NULL;
 
-	memset(mem, 0, size);
 	mem->stat = alloc_percpu(struct mem_cgroup_stat_cpu);
 	if (!mem->stat) {
 		if (size < PAGE_SIZE)


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

