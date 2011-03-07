Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab1CGUnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 15:43:18 -0500
Received: from smtp-out.google.com ([74.125.121.67]:53844 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab1CGUnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 15:43:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=JW/Jp3nMLM4sMkbRCdPY+BCrk3GJSYu8FKeBJVmggT6PDMcqd6aQrDgb8jjKPVErr9
         QDhIFW1S0xMNu67s6x2A==
Date: Mon, 7 Mar 2011 12:36:49 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Vagin <avagin@gmail.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: skip zombie in OOM-killer
In-Reply-To: <AANLkTi=d+eZxg_NgNWa7roo=1YQS06=EaWJzjseL_Hhs@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1103071234480.10264@chino.kir.corp.google.com>
References: <1299286307-4386-1-git-send-email-avagin@openvz.org> <20110306193519.49DD.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1103061400170.23737@chino.kir.corp.google.com> <AANLkTi=d+eZxg_NgNWa7roo=1YQS06=EaWJzjseL_Hhs@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531368966-1855919177-1299530211=:10264"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531368966-1855919177-1299530211=:10264
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 7 Mar 2011, Andrew Vagin wrote:

> > Andrey is patching the case where an eligible TIF_MEMDIE process is found
> > but it has already detached its ->mm.  In combination with the patch
> > posted to linux-mm, oom: prevent unnecessary oom kills or kernel panics,
> > which makes select_bad_process() iterate over all threads, it is an
> > effective solution.
> 
> Probably you said about the first version of my patch.
> This version is incorrect because of
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=dd8e8f405ca386c7ce7cbb996ccd985d283b0e03
> 
> but my first patch is correct and it has a simple reproducer(I
> attached it). You can execute it and your kernel hangs up, because the
> parent doesn't wait children, but the one child (zombie) will have
> flag TIF_MEMDIE, oom_killer will kill nobody
> 

The second version of your patch works fine in combination with the 
pending "oom: prevent unnecessary oom kills or kernel panics" patch from 
linux-mm (included below).  Try your test case with both this patch and 
the second version of your patch.

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -292,11 +292,11 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
 		unsigned long totalpages, struct mem_cgroup *mem,
 		const nodemask_t *nodemask)
 {
-	struct task_struct *p;
+	struct task_struct *g, *p;
 	struct task_struct *chosen = NULL;
 	*ppoints = 0;
 
-	for_each_process(p) {
+	do_each_thread(g, p) {
 		unsigned int points;
 
 		if (oom_unkillable_task(p, mem, nodemask))
@@ -324,7 +324,7 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
 		 * the process of exiting and releasing its resources.
 		 * Otherwise we could get an easy OOM deadlock.
 		 */
-		if (thread_group_empty(p) && (p->flags & PF_EXITING) && p->mm) {
+		if ((p->flags & PF_EXITING) && p->mm) {
 			if (p != current)
 				return ERR_PTR(-1UL);
 
@@ -337,7 +337,7 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
 			chosen = p;
 			*ppoints = points;
 		}
-	}
+	} while_each_thread(g, p);
 
 	return chosen;
 }
--531368966-1855919177-1299530211=:10264--
