Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846Ab0KYKAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 05:00:04 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40125 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab0KYKAB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 05:00:01 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: rcu_read_lock/unlock protect find_task_by_vpid call in migrate_pages
Cc: kosaki.motohiro@jp.fujitsu.com, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, tglx <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <1290674541.2072.564.camel@laptop>
References: <20101125095012.F446.A69D9226@jp.fujitsu.com> <1290674541.2072.564.camel@laptop>
Message-Id: <20101125174751.F45C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 25 Nov 2010 18:59:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 2010-11-25 at 09:50 +0900, KOSAKI Motohiro wrote:
> > Hi
> > 
> > > Signed-off-by: Dave Jones <davej@redhat.com>
> > > 
> > > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > > index 4a57f13..2f0f55b 100644
> > > --- a/mm/mempolicy.c
> > > +++ b/mm/mempolicy.c
> > > @@ -1308,6 +1308,7 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pid, unsigned long, maxnode,
> > >  
> > >  	/* Find the mm_struct */
> > >  	read_lock(&tasklist_lock);
> > > +	rcu_read_lock();
> > >  	task = pid ? find_task_by_vpid(pid) : current;
> > >  	if (!task) {
> > >  		read_unlock(&tasklist_lock);
> > > @@ -1315,6 +1316,7 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pid, unsigned long, maxnode,
> > >  		goto out;
> > >  	}
> > >  	mm = get_task_mm(task);
> > > +	rcu_read_unlock();
> > >  	read_unlock(&tasklist_lock);
> > >  
> > >  	err = -EINVAL;
> > 
> > Thanks reporting. but mmotm seems already has the same patch.
> 
> Another one,... again:
> 
> 
> Do we still need the tasklist_lock in this case?
> 
> Also, why is that think complaining, surely the tasklist_lock pins any
> and all PID objects?

(cc to Christoph and Oleg)

Good spotting.

As far as I understand, find_task_by_pid() did required tasklist_lock in
old days. but It isn't now.

So I think we can remove tasklist_lock from here.

===========================================================================
>From 9de9f70f74e55d92b5e9057e22fc629405f63295 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Thu, 16 Dec 2010 17:49:23 +0900
Subject: [PATCH] mempolicy: remove tasklist_lock from migrate_pages

Today, tasklist_lock in migrate_pages doesn't protect anything. 
rcu_read_lock() provide enough protection from pid hash walk.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/mempolicy.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 11ff260..9064945 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1308,16 +1308,13 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pid, unsigned long, maxnode,
 
 	/* Find the mm_struct */
 	rcu_read_lock();
-	read_lock(&tasklist_lock);
 	task = pid ? find_task_by_vpid(pid) : current;
 	if (!task) {
-		read_unlock(&tasklist_lock);
 		rcu_read_unlock();
 		err = -ESRCH;
 		goto out;
 	}
 	mm = get_task_mm(task);
-	read_unlock(&tasklist_lock);
 	rcu_read_unlock();
 
 	err = -EINVAL;
-- 
1.6.5.2






