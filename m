Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab2A1X3J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 18:29:09 -0500
Received: from solo.fdn.fr ([80.67.169.19]:46641 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab2A1X3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 18:29:07 -0500
Date: Sun, 29 Jan 2012 00:28:58 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arthur Taylor <art@ified.ca>, Jiri Slaby <jslaby@suse.cz>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] Fix KDFONTOP 32bit compatibility layer
Message-ID: <20120128232858.GA18484@type.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arthur Taylor <art@ified.ca>, Jiri Slaby <jslaby@suse.cz>,
	Jiri Olsa <jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KDFONTOP(GET) currently fails with EIO when being run in a 32bit
userland with a 64bit kernel if the font width is not 8. This is because
the compatibility layer introduced by e9216651 forces the addition of
the KD_FONT_FLAG_OLD flag, which makes con_font_get return EIO in such
case.  This flag should *not* be set for KDFONTOP, since it's actually
the whole point of this flag (see comment in con_font_set for instance).

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 5e096f4..65447c5 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -1463,7 +1463,6 @@ compat_kdfontop_ioctl(struct compat_console_font_op __user *fontop,
 	if (!perm && op->op != KD_FONT_OP_GET)
 		return -EPERM;
 	op->data = compat_ptr(((struct compat_console_font_op *)op)->data);
-	op->flags |= KD_FONT_FLAG_OLD;
 	i = con_font_op(vc, op);
 	if (i)
 		return i;
