Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab1CGXnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 18:43:17 -0500
Received: from smtp-out.google.com ([74.125.121.67]:1929 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab1CGXnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 18:43:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=pREvCPCo7Qj9xP8GdbA+Qej4RETU/tO/blBl4ZU6QI7aG7LjHdiF/jUH9GODuFYBni
         U2C+s5s4YG0/Gq9/Tkxg==
Date: Mon, 7 Mar 2011 15:43:03 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>,
        Andrey Vagin <avagin@openvz.org>
cc: Andrew Vagin <avagin@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: skip zombie in OOM-killer
In-Reply-To: <20110307135228.aad5a97d.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1103071537270.21964@chino.kir.corp.google.com>
References: <1299286307-4386-1-git-send-email-avagin@openvz.org> <20110306193519.49DD.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1103061400170.23737@chino.kir.corp.google.com> <AANLkTi=d+eZxg_NgNWa7roo=1YQS06=EaWJzjseL_Hhs@mail.gmail.com>
 <alpine.DEB.2.00.1103071234480.10264@chino.kir.corp.google.com> <20110307135228.aad5a97d.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Mar 2011, Andrew Morton wrote:

> Andrew's v2 doesn't apply on top of
> oom-prevent-unnecessary-oom-kills-or-kernel-panics.patch and I'm
> disinclined to fix that up and merge some untested patch combination.
> 

Ok.  Andrey, I rebased your patch on top of the latest -mm tree 
(mmotm-2011-03-02-16-52 with 
oom-prevent-unnecessary-oom-kills-or-kernel-panics.patch from 
http://marc.info/?l=linux-mm-commits&m=129953480527038&q=raw) and rewrote 
the changelog.  They'll both apply on top of Linus' -git even without 
mmotm.  Could you try this out on your testcase?

Thanks!


oom: skip zombies when iterating tasklist

From: Andrey Vagin <avagin@openvz.org>

We shouldn't defer oom killing if a thread has already detached its ->mm
and still has TIF_MEMDIE set.  Memory needs to be freed, so find kill
other threads that pin the same ->mm or find another task to kill.

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/oom_kill.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -299,6 +299,8 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
 	do_each_thread(g, p) {
 		unsigned int points;
 
+		if (!p->mm)
+			continue;
 		if (oom_unkillable_task(p, mem, nodemask))
 			continue;
 
@@ -324,7 +326,7 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
 		 * the process of exiting and releasing its resources.
 		 * Otherwise we could get an easy OOM deadlock.
 		 */
-		if ((p->flags & PF_EXITING) && p->mm) {
+		if (p->flags & PF_EXITING) {
 			if (p != current)
 				return ERR_PTR(-1UL);
 
