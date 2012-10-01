Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab2JAW7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 18:59:42 -0400
Received: from 1wt.eu ([62.212.114.60]:34991 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932474Ab2JAW7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:59:40 -0400
Message-Id: <20121001225158.844516867@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:26 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Xiaotian Feng <dfeng@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 029/180] tty_audit: fix tty_audit_add_data live lock on audit disabled
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaotian Feng <dfeng@redhat.com>

commit 00bff392c81e4fb1901e5160fdd5afdb2546a6ab upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/char/tty_audit.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tty_audit.c b/drivers/char/tty_audit.c
index ac16fbe..dd4691a 100644
--- a/drivers/char/tty_audit.c
+++ b/drivers/char/tty_audit.c
@@ -94,8 +94,10 @@ static void tty_audit_buf_push(struct task_struct *tsk, uid_t loginuid,
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
1.7.2.1.45.g54fbc



