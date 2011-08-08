Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab1HHOjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 10:39:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59557 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab1HHOjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 10:39:43 -0400
Message-ID: <4E3FF52A.9040804@gmail.com>
Date: Mon, 08 Aug 2011 16:39:38 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110729 Thunderbird/6.0
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at drivers/tty/tty_ldisc.c:766 tty_ldisc_reinit+0x7d/0x90()
References: <CAOMGZ=HS2EPkYD=5HfkSPpwPqHB5V3q0vaFmoZ8Hh+pMM9phrQ@mail.gmail.com> <201107191953.12923.arnd@arndb.de> <CAOMGZ=GrBLL+EgtG1ZGNquMVNxD=X01vd3sakr7ZKFEh9m7xPA@mail.gmail.com>
In-Reply-To: <CAOMGZ=GrBLL+EgtG1ZGNquMVNxD=X01vd3sakr7ZKFEh9m7xPA@mail.gmail.com>
X-Enigmail-Version: 1.3a1pre
Content-Type: multipart/mixed;
 boundary="------------090907080402080903090704"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090907080402080903090704
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 07/19/2011 09:43 PM, Vegard Nossum wrote:
> On 19 July 2011 19:53, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Tuesday 19 July 2011 13:33:36 Vegard Nossum wrote:
>>> Any ideas?
>>
>> This is the WARN_ON that Jiri added in 92f6fa09b "TTY: ldisc, do not close
>> until there are readers".
>>
>> Is the login process that triggered this running on the USB device you pass
>> through, or do you have vga or serial console?
> 
> I am using console=ttyS0 console=tty0, so I have both vga and serial
> console. The login process was running on the vga console.

Hi, hmm, originally wait_for_idle was there without checking the retval.
I added it back with checking the retval. I really wonder who is the
other user of the port. Or if there is a bug in refcounting somewhere.

Could you attach output of the kernel run with the patch attached?

thanks,
-- 
js

--------------090907080402080903090704
Content-Type: text/x-patch;
 name="0001-TTY-tty_ldisc_wait_idle-debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-TTY-tty_ldisc_wait_idle-debug.patch"

>From 5c6bd3fe6d06b13511f366248052ec789c58b88c Mon Sep 17 00:00:00 2001
From: Jiri Slaby <jslaby@suse.cz>
Date: Mon, 8 Aug 2011 16:00:59 +0200
Subject: [PATCH] TTY: tty_ldisc_wait_idle debug

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/tty_ldisc.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 512c49f..0b90801 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -26,6 +26,7 @@
 #include <linux/bitops.h>
 #include <linux/delay.h>
 #include <linux/seq_file.h>
+#include <linux/ratelimit.h>
 
 #include <linux/uaccess.h>
 #include <asm/system.h>
@@ -758,11 +759,17 @@ static void tty_reset_termios(struct tty_struct *tty)
 static int tty_ldisc_reinit(struct tty_struct *tty, int ldisc)
 {
 	struct tty_ldisc *ld = tty_ldisc_get(ldisc);
+	int ret;
 
 	if (IS_ERR(ld))
 		return -1;
 
-	WARN_ON_ONCE(tty_ldisc_wait_idle(tty));
+	ret = tty_ldisc_wait_idle(tty);
+	if (ret)
+		printk_ratelimited(KERN_DEBUG "%s: refcount of %ps is still %d\n",
+				__func__,
+				tty->ldisc->ops,
+				atomic_read(&tty->ldisc->users));
 
 	tty_ldisc_close(tty, tty->ldisc);
 	tty_ldisc_put(tty->ldisc);
-- 
1.7.6


--------------090907080402080903090704--
