Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab1BPAj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:39:29 -0500
Received: from kroah.org ([198.145.64.141]:49493 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757720Ab1BPAXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:23:45 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:45 2011
Message-Id: <20110216001445.142884257@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Guy Martin <gmsoft@tuxicoman.be>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [200/272] parisc : Remove broken line wrapping handling pdc_iodc_print()
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

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

---
 arch/parisc/kernel/firmware.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

--- a/arch/parisc/kernel/firmware.c
+++ b/arch/parisc/kernel/firmware.c
@@ -1126,15 +1126,13 @@ int pdc_iodc_print(const unsigned char *
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
@@ -1142,15 +1140,6 @@ int pdc_iodc_print(const unsigned char *
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


