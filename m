Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761104Ab2FDXbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 19:31:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64777 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab2FDXa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 19:30:59 -0400
Date: Mon, 4 Jun 2012 16:30:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: oomkillers gone wild.
In-Reply-To: <20120604152710.GA1710@redhat.com>
Message-ID: <alpine.DEB.2.00.1206041629500.7769@chino.kir.corp.google.com>
References: <20120604152710.GA1710@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2012, Dave Jones wrote:

> we picked this..
> 
> [21623.066911] [  588]     0   588    22206        1   2       0             0 dhclient
> 
> over say..
> 
> [21623.116597] [ 7092]  1000  7092  1051124    31660   3       0             0 trinity-child3
> 
> What went wrong here ?
> 
> And why does that score look so.. weird.
> 

It sounds like it's because pid 588 has uid=0 and the adjustment for root 
processes is causing an overflow.  I assume this fixes it?
---
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -183,7 +183,7 @@ static bool oom_unkillable_task(struct task_struct *p,
 unsigned long oom_badness(struct task_struct *p, struct mem_cgroup *memcg,
 			  const nodemask_t *nodemask, unsigned long totalpages)
 {
-	unsigned long points;
+	long points;
 
 	if (oom_unkillable_task(p, memcg, nodemask))
 		return 0;
@@ -223,7 +223,7 @@ unsigned long oom_badness(struct task_struct *p, struct mem_cgroup *memcg,
 	 * Never return 0 for an eligible task regardless of the root bonus and
 	 * oom_score_adj (oom_score_adj can't be OOM_SCORE_ADJ_MIN here).
 	 */
-	return points ? points : 1;
+	return points > 0 ? points : 1;
 }
 
 /*
