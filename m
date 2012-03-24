Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab2CXKbp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 06:31:45 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63878 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798Ab2CXKbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 06:31:44 -0400
Date: Sat, 24 Mar 2012 14:30:30 +0400
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
Subject: [PATCH 07/10] um: Should hold tasklist_lock while traversing
 processes
Message-ID: <20120324103030.GG29067@lizard>
References: <20120324102609.GA28356@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120324102609.GA28356@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Traversing the tasks requires holding tasklist_lock, otherwise it
is unsafe.

p.s. However, I'm not sure that calling os_kill_ptraced_process()
in the atomic context is correct. It seem to work, but please
take a closer look.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 arch/um/kernel/reboot.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/um/kernel/reboot.c b/arch/um/kernel/reboot.c
index 4d93dff..66d754c 100644
--- a/arch/um/kernel/reboot.c
+++ b/arch/um/kernel/reboot.c
@@ -4,6 +4,7 @@
  */
 
 #include "linux/sched.h"
+#include "linux/spinlock.h"
 #include "linux/slab.h"
 #include "kern_util.h"
 #include "os.h"
@@ -22,6 +23,7 @@ static void kill_off_processes(void)
 		struct task_struct *p;
 		int pid;
 
+		read_lock(&tasklist_lock);
 		for_each_process(p) {
 			if (p->mm == NULL)
 				continue;
@@ -29,6 +31,7 @@ static void kill_off_processes(void)
 			pid = p->mm->context.id.u.pid;
 			os_kill_ptraced_process(pid, 1);
 		}
+		read_unlock(&tasklist_lock);
 	}
 }
 
-- 
1.7.9.2

