Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab0HXNxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 09:53:25 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55751 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab0HXNxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 09:53:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
        linux-input@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH v2] input: use PIT_TICK_RATE in vt beep ioctl
Date: Tue, 24 Aug 2010 15:53:11 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        David Yang <david.yangshuai@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Emmanuel Colbus <emmanuel.colbus@ensimag.imag.fr>,
        Andrew Morton <akpm@osdl.org>
References: <AANLkTi=T5QP_MbUgh4EfLjtW_be49vw2eLgXNNUCiTb7@mail.gmail.com> <AANLkTinbttBSuTHqFN5X75kqCkDGXvGXb-c-Yv9xdWXw@mail.gmail.com> <201008241521.23459.arnd@arndb.de>
In-Reply-To: <201008241521.23459.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008241553.11219.arnd@arndb.de>
X-Provags-ID: V02:K0:FDteDgfLuXCcsfrJ4hZE1EwuifzVRC4FNaRYcyZr9lN
 4kYFVcHrqKmzKu2g4E1+LfSm7ui3HwJIDlfqTBZpiVYaLMfWWJ
 IKkIZ/sTJGSsuqH4cxdbVAHsowenohY/an8kXdN1PTdcgWn7Oq
 xoqhV722NpL2JPty84Tm7ZdAdgdkbkiYb3twRMq9Y9svDmJOPK
 gBAGCzV1ro0BLEcPvXTvg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The KIOCSOUND and KDMKTONE ioctls are based on the
CLOCK_TICK_RATE, which is architecture and sometimes
configuration specific.
 
In practice, most user applications assume that it
is actually defined as the i8253 PIT base clock of
1193182 Hz, which is true on some architectures
but not on others.
 
This patch makes the vt code use the PIT frequency
on all architectures, which is much more well-defined.
It will change the behavior of user applications
sending the beep ioctl on all architectures that
define CLOCK_TICK_RATE different from PIT_TICK_RATE.

The original breakage was introduced in commit bcc8ca099
"Adapt drivers/char/vt_ioctl.c to non-x86".
Hopefully, reverting this change will make the frequency
correct in more cases than it will make it incorrect.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>

diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index cb19dbc..592d8d1 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -533,11 +533,14 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 	case KIOCSOUND:
 		if (!perm)
 			goto eperm;
-		/* FIXME: This is an old broken API but we need to keep it
-		   supported and somehow separate the historic advertised
-		   tick rate from any real one */
+		/*
+		 * The use of PIT_TICK_RATE is historic, it used to be
+		 * the platform-dependent CLOCK_TICK_RATE between 2.6.12
+		 * and 2.6.36, which was a minor but unfortunate ABI
+		 * change.
+		 */
 		if (arg)
-			arg = CLOCK_TICK_RATE / arg;
+			arg = PIT_TICK_RATE / arg;
 		kd_mksound(arg, 0);
 		break;
 
@@ -553,11 +556,8 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 		 */
 		ticks = HZ * ((arg >> 16) & 0xffff) / 1000;
 		count = ticks ? (arg & 0xffff) : 0;
-		/* FIXME: This is an old broken API but we need to keep it
-		   supported and somehow separate the historic advertised
-		   tick rate from any real one */
 		if (count)
-			count = CLOCK_TICK_RATE / count;
+			count = PIT_TICK_RATE / count;
 		kd_mksound(count, ticks);
 		break;
 	}
