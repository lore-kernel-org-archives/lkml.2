Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab0J1LMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 07:12:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34637 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab0J1LMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 07:12:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=dYTWgfOYrmJn9NuyIYSiBo4rqxf/MDCuXVibwCpzlp14AxwsafNF80XN7s5nnvkGOk
         o5gkUU20lcBiFhQAlquzSvVxh6fBnfoS0m8rE72l5qUe1dQvhoUM6TgZnXcfczTdQ0sj
         5kZdf0vRQOrrL+p/hgHnGGN9ba37l4Ljw2irE=
Date: Thu, 28 Oct 2010 13:12:41 +0200
From: Dan Carpenter <error27@gmail.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] memcg: null dereference on allocation failure
Message-ID: <20101028111241.GC6062@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original code had a null dereference if alloc_percpu() failed.
This was introduced in 711d3d2c9bc3 "memcg: cpu hotplug aware percpu
count updates"

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9a99cfa..2efa8ea 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4208,15 +4208,17 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
 
 	memset(mem, 0, size);
 	mem->stat = alloc_percpu(struct mem_cgroup_stat_cpu);
-	if (!mem->stat) {
-		if (size < PAGE_SIZE)
-			kfree(mem);
-		else
-			vfree(mem);
-		mem = NULL;
-	}
+	if (!mem->stat)
+		goto out_free;
 	spin_lock_init(&mem->pcp_counter_lock);
 	return mem;
+
+out_free:
+	if (size < PAGE_SIZE)
+		kfree(mem);
+	else
+		vfree(mem);
+	return NULL;
 }
 
 /*
