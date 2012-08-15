Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab2HOU22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:28:28 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62850 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756414Ab2HOTuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:04 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 048/165] hvc_console: Improve tty/console put_chars handling
Date: Wed, 15 Aug 2012 15:46:32 -0400
Message-ID: <1345060109-9187-49-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 8c2381af0d3ef62a681dac5a141b6dabb27bf2e1 upstream.

Currently, the hvc_console_print() function drops console output if the
hvc backend's put_chars() returns 0.  This patch changes this behavior
to allow a retry through returning -EAGAIN.

This change also affects the hvc_push() function.  Both functions are
changed to handle -EAGAIN and to retry the put_chars() operation.

If a hvc backend returns -EAGAIN, the retry handling differs:

  - hvc_console_print() spins to write the complete console output.
  - hvc_push() behaves the same way as for returning 0.

Now hvc backends can indirectly control the way how console output is
handled through the hvc console layer.

Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Acked-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
[PG: map drivers/tty/hvc/ --> drivers/char for v2.6.34 baseline]

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/char/hvc_console.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hvc_console.c b/drivers/char/hvc_console.c
index 35cca4c..8417efe 100644
--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -163,8 +163,10 @@ static void hvc_console_print(struct console *co, const char *b,
 		} else {
 			r = cons_ops[index]->put_chars(vtermnos[index], c, i);
 			if (r <= 0) {
-				/* throw away chars on error */
-				i = 0;
+				/* throw away characters on error
+				 * but spin in case of -EAGAIN */
+				if (r != -EAGAIN)
+					i = 0;
 			} else if (r > 0) {
 				i -= r;
 				if (i > 0)
@@ -448,7 +450,7 @@ static int hvc_push(struct hvc_struct *hp)
 
 	n = hp->ops->put_chars(hp->vtermno, hp->outbuf, hp->n_outbuf);
 	if (n <= 0) {
-		if (n == 0) {
+		if (n == 0 || n == -EAGAIN) {
 			hp->do_wakeup = 1;
 			return 0;
 		}
-- 
1.7.12.rc2

