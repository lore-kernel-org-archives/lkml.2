Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab2BGGtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 01:49:43 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61195 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab2BGGtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 01:49:42 -0500
Date: Tue, 7 Feb 2012 10:49:39 +0400
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
Subject: [PATCH 1/8] sysrq: Fix possible race with exiting task
Message-ID: <20120207064939.GA1496@oksana.dev.rtsoft.ru>
References: <20120207064809.GA29061@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120207064809.GA29061@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysrq should grab the tasklist lock, otherwise calling force_sig() is
not safe, as it might race with exiting task, which ->sighand might be
set to NULL already.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 drivers/tty/sysrq.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index 7867b7c..a1bcad7 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -322,11 +322,13 @@ static void send_sig_all(int sig)
 {
 	struct task_struct *p;
 
+	read_lock(&tasklist_lock);
 	for_each_process(p) {
 		if (p->mm && !is_global_init(p))
 			/* Not swapper, init nor kernel thread */
 			force_sig(sig, p);
 	}
+	read_unlock(&tasklist_lock);
 }
 
 static void sysrq_handle_term(int key)
-- 
1.7.7.6

