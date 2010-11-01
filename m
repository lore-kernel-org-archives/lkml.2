Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab0KASed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:34:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092Ab0KASeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:34:31 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: ebiederm@xmission.com, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] tty: prevent SAK to kill init process
Date: Mon,  1 Nov 2010 19:34:26 +0100
Message-Id: <1288636466-9775-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

hitting "Secure Attention Key" on console that's openned
by init process, causing panic due to an attempt to kill
the init process.

Fixing this by skipping the init process in the loop.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 drivers/char/tty_io.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index c05c5af..1b85d37 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2746,6 +2746,8 @@ void __do_SAK(struct tty_struct *tty)
 	read_lock(&tasklist_lock);
 	/* Kill the entire session */
 	do_each_pid_task(session, PIDTYPE_SID, p) {
+		if (is_global_init(p))
+			continue;
 		printk(KERN_NOTICE "SAK: killed process %d"
 			" (%s): task_session(p)==tty->session\n",
 			task_pid_nr(p), p->comm);
@@ -2755,6 +2757,8 @@ void __do_SAK(struct tty_struct *tty)
 	 * tty open.
 	 */
 	do_each_thread(g, p) {
+		if (is_global_init(p))
+			continue;
 		if (p->signal->tty == tty) {
 			printk(KERN_NOTICE "SAK: killed process %d"
 			    " (%s): task_session(p)==tty->session\n",
-- 
1.7.1

