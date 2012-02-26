Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab2BZN6r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 08:58:47 -0500
Received: from mail.windriver.com ([147.11.1.11]:53139 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab2BZN6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 08:58:46 -0500
Message-ID: <4F4A3A8D.7030700@windriver.com>
Date: Sun, 26 Feb 2012 07:58:37 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Andrei Warkentin <andreiw@vmware.com>
CC: <kgdb-bugreport@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KDB: Fix usability issues relating to the 'enter' key.
References: <1329522773-21359-1-git-send-email-andreiw@vmware.com> <4F4A2F60.1060700@windriver.com>
In-Reply-To: <4F4A2F60.1060700@windriver.com>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/mixed;
	boundary="------------050806090300030907070201"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------050806090300030907070201
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

On 02/26/2012 07:10 AM, Jason Wessel wrote:
> On 02/17/2012 05:52 PM, Andrei Warkentin wrote:
>> This fixes the following problems:
>> 1) Typematic-repeat of 'enter' gives warning message.
>> 2) Use of 'keypad enter' gives warning message.
>> 3) Lag on the order of seconds between "break" and "make" when
>>    expecting the enter "break" code. Seen under virtualized
>>    environments such as VMware ESX.
>>
>> Explanations:
>> 1) Holding down 'enter' will not set a repeating sequence
>>    of 0x1c(make)-0x9c(make), but a repeating sequence
>>    of make codes, followed by one break code when the key
>>    is released. Thus, it's wrong to expect the break code
>>    after seeing the 'enter' make code.
>> 2) Keypad enter generates different make/break, namely
>>    0xe0 0x1c and 0xe0 0x9c. The 'generic' logic handles
>>    the 0xe0 escape already, but the special 'enter' logic
>>    always expects '0x9c' and not '0xe0 0x9c', so you get
>>    a warning message, again.
>> 3) When expecting the 'enter' break code, the code polls
>>    the status register in a tight loop, like so -
>>    >  while ((inb(KBD_STATUS_REG) & KBD_STAT_OBF) == 0);
>>
>>    However, it really should do something like -
>>    >  while ((inb(KBD_STATUS_REG) & KBD_STAT_OBF) == 0)
>>    >     cpu_relax(); /* pause */
>>
>>    Basically, it's a common optimization to have a fast
>>    path for accessing often accessed and slow changing I/O
>>    in a virtualized environment. The tight spinning in KDB
>>    seems to run against the logic by ESX keyboard virtualization
>>    code to detect when the fast path or the slow path should
>>    be used to satisfy the keyboard status read, leading to
>>    multi-second timeouts before the 'real' status comes through.
>>    Without knowing ESX internals, it's hard to say if this is
>>    an ESX bug or not, but letting the VM be explicitely descheduled
>>    seems to resolve the problem. I've seen something similar with
>>    shared MMIO buffers with VMs on Hyper-V.
>>
>>    Anyway, given (3), (2) and (1), we might as well blow away the
>>    entire special casing for 'enter'. The break codes will already
>>    be handled correctly, and we get rid of the bugs with repeat
>>    enters and keypad enter key. And of course, there is no
>>    need to AND with 0x7f when checking for 'enter', because we'll
>>    never ever get to this code with a break code (checked for much
>>    earlier).
>>
>>    I tried to figure out the history behind the 'enter' key special
>>    casing code, and it seems to have come from whatever the original
>>    KDB patch was. Perhaps someone can chime in.
>>
> 


Andrei, if you agree with the attached patch, I'll put it in the merge queue.  If you find problems we can go another iteration. :-)

Cheers,
Jason.

--------------050806090300030907070201
Content-Type: text/x-diff;
	name="0001-From-Andrei-Warkentin-andreiw-vmware.com.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0001-From-Andrei-Warkentin-andreiw-vmware.com.patch"

>From 797a228abdd5d560dddf217572d984b1dce97154 Mon Sep 17 00:00:00 2001
From: Jason Wessel <jason.wessel@windriver.com>
Date: Sun, 26 Feb 2012 07:49:16 -0600
Subject: [PATCH 1/1] From: Andrei Warkentin <andreiw@vmware.com> Subject:
 [PATCH] KDB: Fix usability issues relating to the
 'enter' key. Date: Sun Feb 26 07:51:01 CST 2012

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

Signed-off-by: Andrei Warkentin <andreiw@vmware.com>
[jason.wessel@windriver.com: use cpu_relax() and remove expected msg]
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/kdb/kdb_keyboard.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/kernel/debug/kdb/kdb_keyboard.c b/kernel/debug/kdb/kdb_keyboard.c
index 4bca634..0351d0c 100644
--- a/kernel/debug/kdb/kdb_keyboard.c
+++ b/kernel/debug/kdb/kdb_keyboard.c
@@ -183,7 +183,7 @@ int kdb_get_kbd_char(void)
 		 * enter key.  All done.  Absorb the release scancode.
 		 */
 		while ((inb(KBD_STATUS_REG) & KBD_STAT_OBF) == 0)
-			;
+			cpu_relax();
 
 		/*
 		 * Fetch the scancode
@@ -192,18 +192,11 @@ int kdb_get_kbd_char(void)
 		scanstatus = inb(KBD_STATUS_REG);
 
 		while (scanstatus & KBD_STAT_MOUSE_OBF) {
+			cpu_relax();
 			scancode = inb(KBD_DATA_REG);
 			scanstatus = inb(KBD_STATUS_REG);
 		}
 
-		if (scancode != 0x9c) {
-			/*
-			 * Wasn't an enter-release,  why not?
-			 */
-			kdb_printf("kdb: expected enter got 0x%x status 0x%x\n",
-			       scancode, scanstatus);
-		}
-
 		return 13;
 	}
 
-- 
1.7.5.4


--------------050806090300030907070201--
