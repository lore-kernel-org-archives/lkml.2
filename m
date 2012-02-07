Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab2BGGvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 01:51:45 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61195 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537Ab2BGGvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 01:51:44 -0500
Date: Tue, 7 Feb 2012 10:51:41 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] um: Fix possible race on task->mm
Message-ID: <20120207065141.GH1496@oksana.dev.rtsoft.ru>
References: <20120207064809.GA29061@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120207064809.GA29061@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking for task->mm is dangerous as ->mm might disappear (exit_mm()
assigns NULL under task_lock(), so tasklist lock is not enough).

We can't use get_task_mm()/mmput() pair as mmput() might sleep,
so let's take the task lock while we care about its mm.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 arch/um/kernel/reboot.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

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
1.7.7.6
