Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab2BQXw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 18:52:59 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:49997 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751389Ab2BQXw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 18:52:58 -0500
From: Andrei Warkentin <andreiw@vmware.com>
To: kgdb-bugreport@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, jason.wessel@windriver.com,
        andreiw@vmware.com
Subject: [PATCH] KDB: Fix usability issues relating to the 'enter' key.
Date: Fri, 17 Feb 2012 18:52:53 -0500
Message-Id: <1329522773-21359-1-git-send-email-andreiw@vmware.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following problems:
1) Typematic-repeat of 'enter' gives warning message.
2) Use of 'keypad enter' gives warning message.
3) Lag on the order of seconds between "break" and "make" when
   expecting the enter "break" code. Seen under virtualized
   environments such as VMware ESX.

Explanations:
1) Holding down 'enter' will not set a repeating sequence
   of 0x1c(make)-0x9c(make), but a repeating sequence
   of make codes, followed by one break code when the key
   is released. Thus, it's wrong to expect the break code
   after seeing the 'enter' make code.
2) Keypad enter generates different make/break, namely
   0xe0 0x1c and 0xe0 0x9c. The 'generic' logic handles
   the 0xe0 escape already, but the special 'enter' logic
   always expects '0x9c' and not '0xe0 0x9c', so you get
   a warning message, again.
3) When expecting the 'enter' break code, the code polls
   the status register in a tight loop, like so -
   >  while ((inb(KBD_STATUS_REG) & KBD_STAT_OBF) == 0);

   However, it really should do something like -
   >  while ((inb(KBD_STATUS_REG) & KBD_STAT_OBF) == 0)
   >     cpu_relax(); /* pause */

   Basically, it's a common optimization to have a fast
   path for accessing often accessed and slow changing I/O
   in a virtualized environment. The tight spinning in KDB
   seems to run against the logic by ESX keyboard virtualization
   code to detect when the fast path or the slow path should
   be used to satisfy the keyboard status read, leading to
   multi-second timeouts before the 'real' status comes through.
   Without knowing ESX internals, it's hard to say if this is
   an ESX bug or not, but letting the VM be explicitely descheduled
   seems to resolve the problem. I've seen something similar with
   shared MMIO buffers with VMs on Hyper-V.

   Anyway, given (3), (2) and (1), we might as well blow away the
   entire special casing for 'enter'. The break codes will already
   be handled correctly, and we get rid of the bugs with repeat
   enters and keypad enter key. And of course, there is no
   need to AND with 0x7f when checking for 'enter', because we'll
   never ever get to this code with a break code (checked for much
   earlier).

   I tried to figure out the history behind the 'enter' key special
   casing code, and it seems to have come from whatever the original
   KDB patch was. Perhaps someone can chime in.

Tested on ESX 5.0 and QEMU.

Signed-off-by: Andrei Warkentin <andreiw@vmware.com>
---
 kernel/debug/kdb/kdb_keyboard.c |   28 +---------------------------
 1 files changed, 1 insertions(+), 27 deletions(-)

diff --git a/kernel/debug/kdb/kdb_keyboard.c b/kernel/debug/kdb/kdb_keyboard.c
index 4bca634..ed4a2f9 100644
--- a/kernel/debug/kdb/kdb_keyboard.c
+++ b/kernel/debug/kdb/kdb_keyboard.c
@@ -178,34 +178,8 @@ int kdb_get_kbd_char(void)
 		return -1;	/* ignore unprintables */
 	}
 
-	if ((scancode & 0x7f) == 0x1c) {
-		/*
-		 * enter key.  All done.  Absorb the release scancode.
-		 */
-		while ((inb(KBD_STATUS_REG) & KBD_STAT_OBF) == 0)
-			;
-
-		/*
-		 * Fetch the scancode
-		 */
-		scancode = inb(KBD_DATA_REG);
-		scanstatus = inb(KBD_STATUS_REG);
-
-		while (scanstatus & KBD_STAT_MOUSE_OBF) {
-			scancode = inb(KBD_DATA_REG);
-			scanstatus = inb(KBD_STATUS_REG);
-		}
-
-		if (scancode != 0x9c) {
-			/*
-			 * Wasn't an enter-release,  why not?
-			 */
-			kdb_printf("kdb: expected enter got 0x%x status 0x%x\n",
-			       scancode, scanstatus);
-		}
-
+	if (scancode == 0x1c)
 		return 13;
-	}
 
 	return keychar & 0xff;
 }
-- 
1.7.4.1

