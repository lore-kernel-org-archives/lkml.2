Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379Ab2B1Nxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 08:53:40 -0500
Received: from mail.windriver.com ([147.11.1.11]:33898 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207Ab2B1Nxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 08:53:38 -0500
Message-ID: <4F4CDC50.8070505@windriver.com>
Date: Tue, 28 Feb 2012 07:53:20 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Andrei Warkentin <andrey.warkentin@gmail.com>
CC: <kgdb-bugreport@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        Andrei Warkentin <andreiw@vmware.com>
Subject: Re: [PATCH] KDB: Fix usability issues relating to the 'enter' key.
References: <4F4C1194.4080201@windriver.com> <1330403218-21045-1-git-send-email-andrey.warkentin@gmail.com>
In-Reply-To: <1330403218-21045-1-git-send-email-andrey.warkentin@gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/mixed;
	boundary="------------000001000400070101040201"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------000001000400070101040201
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit


I think we are a lot closer this time.  I attached a new patch based
on your prior version.

On 02/27/2012 10:26 PM, Andrei Warkentin wrote:
> This fixes the following problems:
> 1) Typematic-repeat of 'enter' gives warning message
> and leaks make/break if KDB exits. Repeats
> look something like 0x1c 0x1c .... 0x9c
> 2) Use of 'keypad enter' gives warning message and
> leaks the ENTER break/make code out if KDB exits.
> KP ENTER repeats look someting like 0xe0 0x1c
> 0xe0 0x1c ... 0xe0 0x9c.
> 3) Lag on the order of seconds between "break" and "make" when
> expecting the enter "break" code. Seen under virtualized
> environments such as VMware ESX.
>
> The existing special enter handler tries to glob the
> enter break code, but this fails if the other (KP) enter
> was used, or if there was a key repeat. It also fails
> if you mashed some keys along with enter, and you ended
> up with a non-enter make or non-enter break code coming
> after the enter make code. So first, we modify the handler
> to handle these cases. But performing these actions on
> every enter is annoying since now you can't hold ENTER down
> to scroll <more>d messages in KDB. Since this special
> behaviour is only necessary to handle the exiting KDB
> ('g' + ENTER) without leaking scancodes to the OS, we
> perform the cleanup in kgdboc_post_exp_handler path.

This is the wrong place to do this.  The cleanup needs to get executed
any time you are going to leave kdb_main(), because there are a few
conditions like cpu switch, and transition to kgdb where you would
leak the enter code on to the buffer handler without ever returning to
the OS.  Also if you did not set CONFIG_KDB_KEYBOARD your patch did
not compile properly.  We could have fixed this by moving the code to
the input cleanup in kgdboc, but this is not needed at all if you take
a look at the revised version.

>
>
> Fixed previous regression where if kbd was not used
> to 'g' + ENTER, the cleanup code would hang.


Was this a regression in the out of tree code or something in the
mainline kdb?

> index 4bca634..34a8722 100644
> --- a/kernel/debug/kdb/kdb_keyboard.c
> +++ b/kernel/debug/kdb/kdb_keyboard.c
> +void kdb_kbd_cleanup_state(void)
> +{
> + int scancode, scanstatus;
> +
> + /*
> + * Nothing to clean up, since either
> + * ENTER was never pressed, or has already
> + * gotten cleaned up.
> + */
> + if (!kbd_last_ret)
> + return;


I added kbd_last_ret = 0; right here so this cannot get triggered a
second time if the kdb main loop is entered and exited without going
to the shell (which can happen on a soft single step operation on some archs).


Jason.

PS We can iterate other patches you sent after we settle on this one.
Thanks!

--------------000001000400070101040201
Content-Type: text/x-diff;
	name="0001-KDB-Fix-usability-issues-relating-to-the-enter-key.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0001-KDB-Fix-usability-issues-relating-to-the-enter-key.patc";
	filename*1="h"

From: Andrei Warkentin <andrey.warkentin@gmail.com>
Date: Tue, 28 Feb 2012 06:55:05 -0600
Subject: [PATCH] KDB: Fix usability issues relating to the 'enter' key.

This fixes the following problems:
1) Typematic-repeat of 'enter' gives warning message
   and leaks make/break if KDB exits. Repeats
   look something like 0x1c 0x1c .... 0x9c
2) Use of 'keypad enter' gives warning message and
   leaks the ENTER break/make code out if KDB exits.
   KP ENTER repeats look someting like 0xe0 0x1c
   0xe0 0x1c ... 0xe0 0x9c.
3) Lag on the order of seconds between "break" and "make" when
   expecting the enter "break" code. Seen under virtualized
   environments such as VMware ESX.

The existing special enter handler tries to glob the enter break code,
but this fails if the other (KP) enter was used, or if there was a key
repeat. It also fails if you mashed some keys along with enter, and
you ended up with a non-enter make or non-enter break code coming
after the enter make code. So first, we modify the handler to handle
these cases. But performing these actions on every enter is annoying
since now you can't hold ENTER down to scroll <more>d messages in
KDB. Since this special behaviour is only necessary to handle the
exiting KDB ('g' + ENTER) without leaking scancodes to the OS.  This
cleanup needs to get executed anytime the kdb_main loop exits.

Tested on QEMU. Set a bp on atkbd.c to verify no scan code was leaked.

Cc: Andrei Warkentin <andreiw@vmware.com>
[jason.wessel@windriver.com: move cleanup calls to kdb_main.c]
Signed-off-by: Andrei Warkentin <andrey.warkentin@gmail.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/kdb/kdb_keyboard.c |   95 ++++++++++++++++++++++++++++++---------
 kernel/debug/kdb/kdb_main.c     |    3 +
 kernel/debug/kdb/kdb_private.h  |    7 +++
 3 files changed, 83 insertions(+), 22 deletions(-)

diff --git a/kernel/debug/kdb/kdb_keyboard.c b/kernel/debug/kdb/kdb_keyboard.c
index 4bca634..118527a 100644
--- a/kernel/debug/kdb/kdb_keyboard.c
+++ b/kernel/debug/kdb/kdb_keyboard.c
@@ -25,6 +25,7 @@
 #define KBD_STAT_MOUSE_OBF	0x20	/* Mouse output buffer full */
 
 static int kbd_exists;
+static int kbd_last_ret;
 
 /*
  * Check if the keyboard controller has a keypress for us.
@@ -90,8 +91,11 @@ int kdb_get_kbd_char(void)
 		return -1;
 	}
 
-	if ((scancode & 0x80) != 0)
+	if ((scancode & 0x80) != 0) {
+		if (scancode == 0x9c)
+			kbd_last_ret = 0;
 		return -1;
+	}
 
 	scancode &= 0x7f;
 
@@ -178,35 +182,82 @@ int kdb_get_kbd_char(void)
 		return -1;	/* ignore unprintables */
 	}
 
-	if ((scancode & 0x7f) == 0x1c) {
-		/*
-		 * enter key.  All done.  Absorb the release scancode.
-		 */
+	if (scancode == 0x1c) {
+		kbd_last_ret = 1;
+		return 13;
+	}
+
+	return keychar & 0xff;
+}
+EXPORT_SYMBOL_GPL(kdb_get_kbd_char);
+
+/*
+ * Best effort cleanup of ENTER break codes on leaving KDB. Called on
+ * exiting KDB, when we know we processed an ENTER or KP ENTER scan
+ * code.
+ */
+void kdb_kbd_cleanup_state(void)
+{
+	int scancode, scanstatus;
+
+	/*
+	 * Nothing to clean up, since either
+	 * ENTER was never pressed, or has already
+	 * gotten cleaned up.
+	 */
+	if (!kbd_last_ret)
+		return;
+
+	kbd_last_ret = 0;
+	/*
+	 * Enter key. Need to absorb the break code here, lest it gets
+	 * leaked out if we exit KDB as the result of processing 'g'.
+	 *
+	 * This has several interesting implications:
+	 * + Need to handle KP ENTER, which has break code 0xe0 0x9c.
+	 * + Need to handle repeat ENTER and repeat KP ENTER. Repeats
+	 *   only get a break code at the end of the repeated
+	 *   sequence. This means we can't propagate the repeated key
+	 *   press, and must swallow it away.
+	 * + Need to handle possible PS/2 mouse input.
+	 * + Need to handle mashed keys.
+	 */
+
+	while (1) {
 		while ((inb(KBD_STATUS_REG) & KBD_STAT_OBF) == 0)
-			;
+			cpu_relax();
 
 		/*
-		 * Fetch the scancode
+		 * Fetch the scancode.
 		 */
 		scancode = inb(KBD_DATA_REG);
 		scanstatus = inb(KBD_STATUS_REG);
 
-		while (scanstatus & KBD_STAT_MOUSE_OBF) {
-			scancode = inb(KBD_DATA_REG);
-			scanstatus = inb(KBD_STATUS_REG);
-		}
+		/*
+		 * Skip mouse input.
+		 */
+		if (scanstatus & KBD_STAT_MOUSE_OBF)
+			continue;
 
-		if (scancode != 0x9c) {
-			/*
-			 * Wasn't an enter-release,  why not?
-			 */
-			kdb_printf("kdb: expected enter got 0x%x status 0x%x\n",
-			       scancode, scanstatus);
-		}
+		/*
+		 * If we see 0xe0, this is either a break code for KP
+		 * ENTER, or a repeat make for KP ENTER. Either way,
+		 * since the second byte is equivalent to an ENTER,
+		 * skip the 0xe0 and try again.
+		 *
+		 * If we see 0x1c, this must be a repeat ENTER or KP
+		 * ENTER (and we swallowed 0xe0 before). Try again.
+		 *
+		 * We can also see make and break codes for other keys
+		 * mashed before or after pressing ENTER. Thus, if we
+		 * see anything other than 0x9c, we have to try again.
+		 *
+		 * Note, if you held some key as ENTER was depressed,
+		 * that break code would get leaked out.
+		 */
+		if (scancode != 0x9c)
+			continue;
 
-		return 13;
+		return;
 	}
-
-	return keychar & 0xff;
 }
-EXPORT_SYMBOL_GPL(kdb_get_kbd_char);
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index e2ae734..67b847d 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1400,6 +1400,9 @@ int kdb_main_loop(kdb_reason_t reason, kdb_reason_t reason2, int error,
 	if (KDB_STATE(DOING_SS))
 		KDB_STATE_CLEAR(SSBPT);
 
+	/* Clean up any keyboard devices before leaving */
+	kdb_kbd_cleanup_state();
+
 	return result;
 }
 
diff --git a/kernel/debug/kdb/kdb_private.h b/kernel/debug/kdb/kdb_private.h
index e381d10..47c4e56 100644
--- a/kernel/debug/kdb/kdb_private.h
+++ b/kernel/debug/kdb/kdb_private.h
@@ -246,6 +246,13 @@ extern void debug_kusage(void);
 
 extern void kdb_set_current_task(struct task_struct *);
 extern struct task_struct *kdb_current_task;
+
+#ifdef CONFIG_KDB_KEYBOARD
+extern void kdb_kbd_cleanup_state(void);
+#else /* ! CONFIG_KDB_KEYBOARD */
+#define kdb_kbd_cleanup_state()
+#endif /* ! CONFIG_KDB_KEYBOARD */
+
 #ifdef CONFIG_MODULES
 extern struct list_head *kdb_modules;
 #endif /* CONFIG_MODULES */
-- 
1.7.5.4


--------------000001000400070101040201--
