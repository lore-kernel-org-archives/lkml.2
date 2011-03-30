Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964854Ab1C3V6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:58:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:13486 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964801Ab1C3VGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727132978"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: gmsoft@tuxicoman.be, James.Bottomley@suse.de, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [67/275] parisc : Remove broken line wrapping handling pdc_iodc_print()
Message-Id: <20110330210504.3909B3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Guy Martin <gmsoft@tuxicoman.be>

commit fbea668498e93bb38ac9226c7af9120a25957375 upstream.

Remove the broken line wrapping handling in pdc_iodc_print().
It is broken in 3 ways :
  - It doesn't keep track of the current screen position, it just
    assumes that the new buffer will be printed at the begining of the
    screen.
  - It doesn't take in account that non printable characters won't
    increase the current position on the screen.
  - And last but not least, it triggers a kernel panic if a backspace
    is the first char in the provided buffer :

 Backtrace:
  [<0000000040128ec4>] pdc_console_write+0x44/0x78
  [<0000000040128f18>] pdc_console_tty_write+0x20/0x38
  [<000000004032f1ac>] n_tty_write+0x2a4/0x550
  [<000000004032b158>] tty_write+0x1e0/0x2d8
  [<00000000401bb420>] vfs_write+0xb8/0x188
  [<00000000401bb630>] sys_write+0x68/0xb8
  [<0000000040104eb8>] syscall_exit+0x0/0x14

Most terminals handle the line wrapping just fine. I've confirmed that
it works correctly on a C8000 with both vga and serial output.

Signed-off-by: Guy Martin <gmsoft@tuxicoman.be>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/parisc/kernel/firmware.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

Index: linux-2.6.35.y/arch/parisc/kernel/firmware.c
===================================================================
--- linux-2.6.35.y.orig/arch/parisc/kernel/firmware.c	2011-03-29 22:51:43.187618105 -0700
+++ linux-2.6.35.y/arch/parisc/kernel/firmware.c	2011-03-29 23:02:59.573311089 -0700
@@ -1126,15 +1126,13 @@
 	unsigned int i;
 	unsigned long flags;
 
-	for (i = 0; i < count && i < 79;) {
+	for (i = 0; i < count;) {
 		switch(str[i]) {
 		case '\n':
 			iodc_dbuf[i+0] = '\r';
 			iodc_dbuf[i+1] = '\n';
 			i += 2;
 			goto print;
-		case '\b':	/* BS */
-			i--; /* overwrite last */
 		default:
 			iodc_dbuf[i] = str[i];
 			i++;
@@ -1142,15 +1140,6 @@
 		}
 	}
 
-	/* if we're at the end of line, and not already inserting a newline,
-	 * insert one anyway. iodc console doesn't claim to support >79 char
-	 * lines. don't account for this in the return value.
-	 */
-	if (i == 79 && iodc_dbuf[i-1] != '\n') {
-		iodc_dbuf[i+0] = '\r';
-		iodc_dbuf[i+1] = '\n';
-	}
-
 print:
         spin_lock_irqsave(&pdc_lock, flags);
         real32_call(PAGE0->mem_cons.iodc_io,
