Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab0DBSem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 14:34:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614Ab0DBSe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 14:34:27 -0400
Date: Fri, 2 Apr 2010 20:32:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: anfei <anfei.zhou@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       nishimura@mxp.nes.nec.co.jp,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 2/4] oom: select_bad_process: PF_EXITING check should
	take ->mm into account
Message-ID: <20100402183216.GC31723@redhat.com>
References: <alpine.DEB.2.00.1003291302170.14859@chino.kir.corp.google.com> <20100330154659.GA12416@redhat.com> <alpine.DEB.2.00.1003301320020.5234@chino.kir.corp.google.com> <20100331175836.GA11635@redhat.com> <20100331204718.GD11635@redhat.com> <alpine.DEB.2.00.1004010133190.6285@chino.kir.corp.google.com> <20100401135927.GA12460@redhat.com> <alpine.DEB.2.00.1004011210380.30661@chino.kir.corp.google.com> <20100402111406.GA4432@redhat.com> <20100402183057.GA31723@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100402183057.GA31723@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

select_bad_process() checks PF_EXITING to detect the task which
is going to release its memory, but the logic is very wrong.

	- a single process P with the dead group leader disables
	  select_bad_process() completely, it will always return
	  ERR_PTR() while P can live forever

	- if the PF_EXITING task has already released its ->mm
	  it doesn't make sense to expect it is goiing to free
	  more memory (except task_struct/etc)

Change the code to ignore the PF_EXITING tasks without ->mm.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- MM/mm/oom_kill.c~2_FIX_PF_EXITING	2010-04-02 18:51:05.000000000 +0200
+++ MM/mm/oom_kill.c	2010-04-02 18:58:37.000000000 +0200
@@ -322,7 +322,7 @@ static struct task_struct *select_bad_pr
 		 * the process of exiting and releasing its resources.
 		 * Otherwise we could get an easy OOM deadlock.
 		 */
-		if (p->flags & PF_EXITING) {
+		if ((p->flags & PF_EXITING) && p->mm) {
 			if (p != current)
 				return ERR_PTR(-1UL);
 

