Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238Ab0FBNyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 09:54:08 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43685 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab0FBNyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 09:54:04 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 3/5] oom: Fix child process iteration properly
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <20100601192726.GA19120@redhat.com>
References: <20100601144810.2440.A69D9226@jp.fujitsu.com> <20100601192726.GA19120@redhat.com>
Message-Id: <20100602200323.F515.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  2 Jun 2010 22:53:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 06/01, KOSAKI Motohiro wrote:
> >
> > @@ -88,6 +88,7 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
> >  {
> >  	unsigned long points, cpu_time, run_time;
> >  	struct task_struct *c;
> > +	struct task_struct *t = p;
> 
> This initialization should be moved down to
> 
> > +	do {
> > +		list_for_each_entry(c, &t->children, sibling) {
> > +			child = find_lock_task_mm(c);
> > +			if (child) {
> > +				if (child->mm != p->mm)
> > +					points += child->mm->total_vm/2 + 1;
> > +				task_unlock(child);
> > +			}
> >  		}
> > -	}
> > +	} while_each_thread(p, t);
> 
> this loop. We have "p = find_lock_task_mm(p)" in between which can change p.
> 
> Apart from this, I think the whole series is nice.

Nich catch!

simple incremental patch is here.

========================================================
Subject: [PATCH] Fix oom: Fix child process iteration properly

p can be changed by find_lock_task_mm()

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/oom_kill.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 9631f1b..9e7f0f9 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -88,7 +88,7 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
 {
 	unsigned long points, cpu_time, run_time;
 	struct task_struct *c;
-	struct task_struct *t = p;
+	struct task_struct *t;
 	struct task_struct *child;
 	int oom_adj = p->signal->oom_adj;
 	struct task_cputime task_time;
@@ -126,6 +126,7 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
 	 * child is eating the vast majority of memory, adding only half
 	 * to the parents will make the child our kill candidate of choice.
 	 */
+	t = p;
 	do {
 		list_for_each_entry(c, &t->children, sibling) {
 			child = find_lock_task_mm(c);
-- 
1.6.5.2





