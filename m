Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511Ab1KCCRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 22:17:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50400 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153Ab1KCBdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:33:44 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:53 2011
Message-Id: <20111102221453.222863192@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:14:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [034/107] hvc_console: Improve tty/console put_chars handling
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/hvc_console.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -162,8 +162,10 @@ static void hvc_console_print(struct con
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
@@ -447,7 +449,7 @@ static int hvc_push(struct hvc_struct *h
 
 	n = hp->ops->put_chars(hp->vtermno, hp->outbuf, hp->n_outbuf);
 	if (n <= 0) {
-		if (n == 0) {
+		if (n == 0 || n == -EAGAIN) {
 			hp->do_wakeup = 1;
 			return 0;
 		}


