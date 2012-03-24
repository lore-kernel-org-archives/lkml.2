Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab2CXKcA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 06:32:00 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63878 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510Ab2CXKb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 06:31:58 -0400
Date: Sat, 24 Mar 2012 14:30:50 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Russell King <linux@arm.linux.org.uk>, Mike Frysinger <vapier@gentoo.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Weinberger <richard@nod.at>, Paul Mundt <lethal@linux-sh.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        linux-mm@kvack.org
Subject: [PATCH 08/10] um: Fix possible race on task->mm
Message-ID: <20120324103050.GH29067@lizard>
References: <20120324102609.GA28356@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120324102609.GA28356@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking for task->mm is dangerous as ->mm might disappear (exit_mm()
assigns NULL under task_lock(), so tasklist lock is not enough).

We can't use get_task_mm()/mmput() pair as mmput() might sleep,
so let's take the task lock while we care about its mm.

Note that we should also use find_lock_task_mm() to check all process'
threads for a valid mm, but for uml we'll do it in a separate patch.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 arch/um/kernel/reboot.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/um/kernel/reboot.c b/arch/um/kernel/reboot.c
index 66d754c..1411f4e 100644
--- a/arch/um/kernel/reboot.c
+++ b/arch/um/kernel/reboot.c
@@ -25,10 +25,13 @@ static void kill_off_processes(void)
 
 		read_lock(&tasklist_lock);
 		for_each_process(p) {
-			if (p->mm == NULL)
+			task_lock(p);
+			if (!p->mm) {
+				task_unlock(p);
 				continue;
-
+			}
 			pid = p->mm->context.id.u.pid;
+			task_unlock(p);
 			os_kill_ptraced_process(pid, 1);
 		}
 		read_unlock(&tasklist_lock);
-- 
1.7.9.2

