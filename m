Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab2BGGtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 01:49:55 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61195 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519Ab2BGGtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 01:49:53 -0500
Date: Tue, 7 Feb 2012 10:49:51 +0400
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
Subject: [PATCH 2/8] sysrq: Properly check for kernel threads
Message-ID: <20120207064951.GB1496@oksana.dev.rtsoft.ru>
References: <20120207064809.GA29061@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120207064809.GA29061@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a real possibility of killing kernel threads that might
have issued use_mm(), so kthread's mm might become non-NULL.

This patch fixes the issue by checking for PF_KTHREAD (just as
get_task_mm()).

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 drivers/tty/sysrq.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index a1bcad7..8db9125 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -324,9 +324,12 @@ static void send_sig_all(int sig)
 
 	read_lock(&tasklist_lock);
 	for_each_process(p) {
-		if (p->mm && !is_global_init(p))
-			/* Not swapper, init nor kernel thread */
-			force_sig(sig, p);
+		if (p->flags & PF_KTHREAD)
+			continue;
+		if (is_global_init(p))
+			continue;
+
+		force_sig(sig, p);
 	}
 	read_unlock(&tasklist_lock);
 }
-- 
1.7.7.6

