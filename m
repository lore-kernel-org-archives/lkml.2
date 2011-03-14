Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab1CNTN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 15:13:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755145Ab1CNTN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 15:13:58 -0400
Date: Mon, 14 Mar 2011 20:05:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrey Vagin <avagin@openvz.org>, David Rientjes <rientjes@google.com>,
        Frantisek Hrbata <fhrbata@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3 for 2.6.38] oom: select_bad_process: ignore TIF_MEMDIE
	zombies
Message-ID: <20110314190508.GC21845@redhat.com>
References: <20110303100030.B936.A69D9226@jp.fujitsu.com> <20110308134233.GA26884@redhat.com> <alpine.DEB.2.00.1103081549530.27910@chino.kir.corp.google.com> <20110309151946.dea51cde.akpm@linux-foundation.org> <alpine.DEB.2.00.1103111142260.30699@chino.kir.corp.google.com> <20110312123413.GA18351@redhat.com> <20110312134341.GA27275@redhat.com> <AANLkTinHGSb2_jfkwx=Wjv96phzPCjBROfCTFCKi4Wey@mail.gmail.com> <20110313212726.GA24530@redhat.com> <20110314190419.GA21845@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314190419.GA21845@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

select_bad_process() assumes that a TIF_MEMDIE process should go away.
But it can only go away it its parent does wait(). Change this check to
ignore the TIF_MEMDIE zombies.

Note: this is _not_ enough. Just a minimal fix.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 mm/oom_kill.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- 38/mm/oom_kill.c~2_tif_memdie_zombie	2011-03-14 18:51:49.000000000 +0100
+++ 38/mm/oom_kill.c	2011-03-14 18:52:39.000000000 +0100
@@ -311,7 +311,8 @@ static struct task_struct *select_bad_pr
 		 * blocked waiting for another task which itself is waiting
 		 * for memory. Is there a better alternative?
 		 */
-		if (test_tsk_thread_flag(p, TIF_MEMDIE))
+		if (test_tsk_thread_flag(p, TIF_MEMDIE) &&
+		    !p->exit_state && thread_group_empty(p))
 			return ERR_PTR(-1UL);
 
 		/*

