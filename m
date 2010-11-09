Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab0KIKQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 05:16:15 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:50709 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab0KIKQM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 05:16:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Subject: Re: known vboxgetty/isdn issue in 2.6.35.3?
Date: Tue, 9 Nov 2010 11:15:16 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Karsten Keil <isdn@linux-pingi.de>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Tilman Schmidt <tilman@imap.cc>
References: <4C864143.5090803@xs4all.nl> <201009072145.10946.arnd@arndb.de> <4CD56087.9000009@xs4all.nl>
In-Reply-To: <4CD56087.9000009@xs4all.nl>
MIME-Version: 1.0
Message-Id: <201011091115.16351.arnd@arndb.de>
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Provags-ID: V02:K0:PO90h7Nm7ubAjqibsuHh9fUDK4J/o6gipFA9m3KsH9f
 ZwYvTThKNuOFXm86LzIKwZv3Y+QjX13P4GoBx3HUKtOKU6Y66Q
 jhzz0SbsDFl8h2ckT+NV4e2oIXdIf6pBSMnjYxxTwwvmqBKa78
 1d3R9gsvbZK6dv7vfvR4oMWmLN/nVXXgJub+zlX4H+AwpzD+Ih
 g/qIO+CkGTE8uihotv25w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 November 2010, Udo van den Heuvel wrote:
> ==> /proc/16758/stack <==
> [<c118731a>] tty_unthrottle+0x13/0x3a
> [<c1185f4e>] reset_buffer_flags+0xd4/0xd9
> [<c1185f60>] n_tty_flush_buffer+0xd/0x63
> [<c11888a7>] tty_ldisc_flush+0x1f/0x34
> [<c120797c>] isdn_tty_modem_result+0x342/0x37c
> [<c1209c5e>] isdn_tty_modem_hup+0x76/0x176
> [<c120a66b>] isdn_tty_change_speed+0xa2/0xd4
> [<c120a6da>] isdn_tty_set_termios+0x3d/0x5a
> [<c118789b>] set_termios+0x318/0x397
> [<c1187b41>] tty_mode_ioctl+0x178/0x2db
> [<c1187de8>] n_tty_ioctl_helper+0x144/0x154
> [<c11854d9>] n_tty_ioctl+0x97/0xa0
> [<c1183ccd>] tty_ioctl+0x699/0x6d3
> [<c108557c>] vfs_ioctl+0x27/0x91
> [<c1085ade>] do_vfs_ioctl+0x44b/0x47f
> [<c1085b53>] sys_ioctl+0x41/0x61
> [<c10027d3>] sysenter_do_call+0x12/0x2d
> [<ffffffff>] 0xffffffff

Ok, so it seems that set_termios calls change_termios, which holds the
termios_mutex while calling isdn_tty_set_termios. This ends up
calling tty_unthrottle, which tries to take the same mutex, and that fails.

As far as I can tell, the problem got introduced in this commit:

commit 38db89799bdf11625a831c5af33938dcb11908b6
Author: Alan Cox <alan@linux.intel.com>
Date:   Thu Jun 11 12:44:17 2009 +0100
Subject: tty: throttling race fix

However, a fix has recently gone into the kernel that should fix it. As
far as I can tell, 2.6.36 and later should not call tty_ldisc_flush
from isdn_tty_modem_result any more, which avoids the original problem.

Please apply the patch below to see if it helps. We should probably
have it in 2.6.32-stable and 2.6.35-stable, if there is another one.

	Arnd
---
>From bc10f96757bd6ab3721510df8defa8f21c32f974 Mon Sep 17 00:00:00 2001
From: Tilman Schmidt <tilman@imap.cc>
Date: Mon, 5 Jul 2010 14:18:27 +0000
Subject: [PATCH] isdn: avoid calling tty_ldisc_flush() in atomic context

Remove the call to tty_ldisc_flush() from the RESULT_NO_CARRIER
branch of isdn_tty_modem_result(), as already proposed in commit
00409bb045887ec5e7b9e351bc080c38ab6bfd33.
This avoids a "sleeping function called from invalid context" BUG
when the hardware driver calls the statcallb() callback with
command==ISDN_STAT_DHUP in atomic context, which in turn calls
isdn_tty_modem_result(RESULT_NO_CARRIER, ~), and from there,
tty_ldisc_flush() which may sleep.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index fc8454d..51dc60d 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -2636,12 +2636,6 @@ isdn_tty_modem_result(int code, modem_info * info)
 		if ((info->flags & ISDN_ASYNC_CLOSING) || (!info->tty)) {
 			return;
 		}
-#ifdef CONFIG_ISDN_AUDIO
-		if ( !info->vonline )
-			tty_ldisc_flush(info->tty);
-#else
-		tty_ldisc_flush(info->tty);
-#endif
 		if ((info->flags & ISDN_ASYNC_CHECK_CD) &&
 		    (!((info->flags & ISDN_ASYNC_CALLOUT_ACTIVE) &&
 		       (info->flags & ISDN_ASYNC_CALLOUT_NOHUP)))) {
