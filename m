Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab1CNTNg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 15:13:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754788Ab1CNTNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 15:13:35 -0400
Date: Mon, 14 Mar 2011 20:04:46 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrey Vagin <avagin@openvz.org>, David Rientjes <rientjes@google.com>,
        Frantisek Hrbata <fhrbata@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3 for 2.6.38] oom: oom_kill_process: don't set TIF_MEMDIE
	if !p->mm
Message-ID: <20110314190446.GB21845@redhat.com>
References: <20110303100030.B936.A69D9226@jp.fujitsu.com> <20110308134233.GA26884@redhat.com> <alpine.DEB.2.00.1103081549530.27910@chino.kir.corp.google.com> <20110309151946.dea51cde.akpm@linux-foundation.org> <alpine.DEB.2.00.1103111142260.30699@chino.kir.corp.google.com> <20110312123413.GA18351@redhat.com> <20110312134341.GA27275@redhat.com> <AANLkTinHGSb2_jfkwx=Wjv96phzPCjBROfCTFCKi4Wey@mail.gmail.com> <20110313212726.GA24530@redhat.com> <20110314190419.GA21845@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314190419.GA21845@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oom_kill_process() simply sets TIF_MEMDIE and returns if PF_EXITING.
This is very wrong by many reasons. In particular, this thread can
be the dead group leader. Check p->mm != NULL.

Note: this is _not_ enough. Just a minimal fix.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 38/mm/oom_kill.c~1_kill_fix_pf_exiting	2011-03-14 17:53:05.000000000 +0100
+++ 38/mm/oom_kill.c	2011-03-14 18:51:49.000000000 +0100
@@ -470,7 +470,7 @@ static int oom_kill_process(struct task_
 	 * If the task is already exiting, don't alarm the sysadmin or kill
 	 * its children or threads, just set TIF_MEMDIE so it can die quickly
 	 */
-	if (p->flags & PF_EXITING) {
+	if (p->flags & PF_EXITING && p->mm) {
 		set_tsk_thread_flag(p, TIF_MEMDIE);
 		boost_dying_task_prio(p, mem);
 		return 0;

