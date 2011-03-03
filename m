Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab1CCKIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 05:08:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135Ab1CCKIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 05:08:39 -0500
From: Xiaotian Feng <dfeng@redhat.com>
To: linux-kernel@vger.kernel.org, gregkh@suse.de
Cc: Xiaotian Feng <dfeng@redhat.com>
Subject: [PATCH] tty_audit: fix tty_audit_add_data live lock on audit disabled
Date: Thu,  3 Mar 2011 18:08:24 +0800
Message-Id: <1299146904-17150-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current tty_audit_add_data code:

        do {
                size_t run;

                run = N_TTY_BUF_SIZE - buf->valid;
                if (run > size)
                        run = size;
                memcpy(buf->data + buf->valid, data, run);
                buf->valid += run;
                data += run;
                size -= run;
                if (buf->valid == N_TTY_BUF_SIZE)
                        tty_audit_buf_push_current(buf);
        } while (size != 0);

If the current buffer is full, kernel will then call tty_audit_buf_push_current
to empty the buffer. But if we disabled audit at the same time, tty_audit_buf_push()
returns immediately if audit_enabled is zero.  Without emptying the buffer.
With obvious effect on tty_audit_add_data() that ends up spinning in that loop,
copying 0 bytes at each iteration and attempting to push each time without any effect.
Holding the lock all along.

Suggested-by: Alexander Viro <aviro@redhat.com> 
Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/tty_audit.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/tty_audit.c b/drivers/tty/tty_audit.c
index f64582b..7c58669 100644
--- a/drivers/tty/tty_audit.c
+++ b/drivers/tty/tty_audit.c
@@ -95,8 +95,10 @@ static void tty_audit_buf_push(struct task_struct *tsk, uid_t loginuid,
 {
 	if (buf->valid == 0)
 		return;
-	if (audit_enabled == 0)
+	if (audit_enabled == 0) {
+		buf->valid = 0;
 		return;
+	}
 	tty_audit_log("tty", tsk, loginuid, sessionid, buf->major, buf->minor,
 		      buf->data, buf->valid);
 	buf->valid = 0;
-- 
1.7.1

