Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab1G1XzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:55:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:7365 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756113Ab1G1XoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="33559435"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: brueckner@linux.vnet.ibm.com, anton@samba.org, benh@kernel.crashing.org,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [15/50] hvc_console: Improve tty/console put_chars handling
Message-Id: <20110728234419.8FD482403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>

[ upstream commit 8c2381af0d3ef62a681dac5a141b6dabb27bf2e1 ]

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
Cc: <stable@kernel.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/drivers/char/hvc_console.c
===================================================================
--- linux-2.6.35.y.orig/drivers/char/hvc_console.c
+++ linux-2.6.35.y/drivers/char/hvc_console.c
@@ -163,8 +163,10 @@ static void hvc_console_print(struct con
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
@@ -448,7 +450,7 @@ static int hvc_push(struct hvc_struct *h
 
 	n = hp->ops->put_chars(hp->vtermno, hp->outbuf, hp->n_outbuf);
 	if (n <= 0) {
-		if (n == 0) {
+		if (n == 0 || n == -EAGAIN) {
 			hp->do_wakeup = 1;
 			return 0;
 		}
