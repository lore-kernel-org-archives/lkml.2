Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab0EaJfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 05:35:43 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44552 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab0EaJfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 05:35:42 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: [PATCH 2/5] oom: select_bad_process: PF_EXITING check should take ->mm into account
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100531182526.1843.A69D9226@jp.fujitsu.com>
References: <20100531182526.1843.A69D9226@jp.fujitsu.com>
Message-Id: <20100531183335.1846.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 31 May 2010 18:35:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>
Subject: oom: select_bad_process: PF_EXITING check should take ->mm into account

select_bad_process() checks PF_EXITING to detect the task which is going
to release its memory, but the logic is very wrong.

	- a single process P with the dead group leader disables
	  select_bad_process() completely, it will always return
	  ERR_PTR() while P can live forever

	- if the PF_EXITING task has already released its ->mm
	  it doesn't make sense to expect it is goiing to free
	  more memory (except task_struct/etc)

Change the code to ignore the PF_EXITING tasks without ->mm.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [rebase to latest -mm]
---
 mm/oom_kill.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 070b713..c87a6f4 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -287,7 +287,7 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
 		 * the process of exiting and releasing its resources.
 		 * Otherwise we could get an easy OOM deadlock.
 		 */
-		if (p->flags & PF_EXITING) {
+		if ((p->flags & PF_EXITING) && p->mm) {
 			if (p != current)
 				return ERR_PTR(-1UL);
 
-- 
1.6.5.2



