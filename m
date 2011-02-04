Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab1BDDjl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 22:39:41 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:55623 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591Ab1BDDjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 22:39:40 -0500
Date: Fri, 4 Feb 2011 12:35:55 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [patch] memcg: add memcg sanity checks at allocating and
 freeing pages
Message-Id: <20110204123555.d272dcda.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20110203141533.GH2286@cmpxchg.org>
References: <20110203141533.GH2286@cmpxchg.org>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Feb 2011 15:15:33 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 
> This patch add checks at allocating or freeing a page whether the page is used
> (iow, charged) from the view point of memcg.
> 
> This check may be useful in debugging a problem and we did similar checks
> before the commit 52d4b9ac(memcg: allocate all page_cgroup at boot).
> 
> This patch adds some overheads at allocating or freeing memory, so it's enabled
> only when CONFIG_DEBUG_VM is enabled.
> 
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Thank you for picking up this patch. You actually remind me about this patch :)

I have one comment.

> +void mem_cgroup_print_bad_page(struct page *page)
> +{
> +	struct page_cgroup *pc;
> +
> +	pc = lookup_page_cgroup_used(page);
> +	if (pc)
> +		printk(KERN_ALERT "pc:%p pc->flags:%ld pc->mem_cgroup:%p\n",
> +		       pc, pc->flags, pc->mem_cgroup);
> +}
> +#endif
> +
When I posted this patch before, I received a comment that showing the path of
the cgroup would be better.
This is a additional patch to show the path.

===
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Let's try to show the path name of the cgroup too.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
---
 mm/memcontrol.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2ed1b33..3c14d20 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3040,9 +3040,25 @@ void mem_cgroup_print_bad_page(struct page *page)
 	struct page_cgroup *pc;
 
 	pc = lookup_page_cgroup_used(page);
-	if (pc)
-		printk(KERN_ALERT "pc:%p pc->flags:%ld pc->mem_cgroup:%p\n",
+	if (pc) {
+		int ret = -1;
+		char *path;
+
+		printk(KERN_ALERT "pc:%p pc->flags:%ld pc->mem_cgroup:%p",
 		       pc, pc->flags, pc->mem_cgroup);
+
+		path = kmalloc(PATH_MAX, GFP_KERNEL);
+		if (path) {
+			rcu_read_lock();
+			ret = cgroup_path(pc->mem_cgroup->css.cgroup,
+							path, PATH_MAX);
+			rcu_read_unlock();
+		}
+
+		printk(KERN_ALERT "(%s)\n",
+				(ret < 0) ? "cannot get the path" : path);
+		kfree(path);
+	}
 }
 #endif
 
-- 
1.7.1

