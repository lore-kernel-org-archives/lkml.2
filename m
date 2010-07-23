Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab0GWHEb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 03:04:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63710 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab0GWHE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 03:04:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QSElKoBm2L0qczmvUhRjLKUzUoxxkPakiDm+wQz6ZuqDpA3MWxo6e/Rl8DmBmO55dl
         /UQGPCOmuTmt+dUqUQy8cAZwzY49NyeV5Xwrpk2z0nuE8TFqX9h5eyHGP/9ACCTWsYdS
         eyU3Cg3iM9BO8/q3OwSvA4rqwvDxCd1mZYz9o=
From: Stephen Boyd <bebarino@gmail.com>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Nir Tzachar <nir.tzachar@gmail.com>
Subject: [PATCH] nconfig: Fix segfault when help contains special characters
Date: Fri, 23 Jul 2010 00:04:14 -0700
Message-Id: <1279868654-15743-1-git-send-email-bebarino@gmail.com>
X-Mailer: git-send-email 1.7.2.rc3.57.g77b5b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nconfig segfaults when help text contains the character '%'. For a quick
example, navigate to the kernel compression options and get the help for
bzip2. Doing so triggers a call to mvwprintw() with a string containing
'%' and no extra arguments to fill in the specifier's value. Fix this
case by printing the literal string retrieved from the kconfig.

 #0  0x00002b52b6b11d83 in vfprintf () from /lib/libc.so.6
 #1  0x00002b52b6bad010 in __vsnprintf_chk () from /lib/libc.so.6
 #2  0x00002b52b623991b in _nc_printf_string () from
 /lib/libncursesw.so.5
 #3  0x00002b52b6234cff in vwprintw () from /lib/libncursesw.so.5
 #4  0x00002b52b6234db9 in mvwprintw () from /lib/libncursesw.so.5
 #5  0x00000000004151d8 in fill_window (win=0x21b64c0,
     text=0x21b62b0 "CONFIG_KERNEL_BZIP2:\n\nIts compression ratio and
     speed is intermediate.\nDecompression speed is slowest among the
     three.  The kernel\nsize is about 10% smaller with bzip2, in
     comparison to gzip.\nBzip2 us"...)
     at scripts/kconfig/nconf.gui.c:229
 #6  0x0000000000416335 in show_scroll_win (main_window=0x21a5630,
         title=0x157fa30 "Bzip2",
 	    text=0x21b62b0 "CONFIG_KERNEL_BZIP2:\n\nIts compression
 	    ratio and speed is intermediate.\nDecompression speed is
 	    slowest among the three.  The kernel\nsize is about 10%
 	    smaller with bzip2, in comparison to gzip.\nBzip2 us"...)
     at scripts/kconfig/nconf.gui.c:535
 #7  0x00000000004055b2 in show_help (menu=0x157f9d0)
         at scripts/kconfig/nconf.c:1257
 #8  0x0000000000405897 in conf_choice (menu=0x157f130)
 	    at scripts/kconfig/nconf.c:1321
 #9  0x0000000000405326 in conf (menu=0x157d130) at
 	    scripts/kconfig/nconf.c:1208
 #10 0x00000000004052e8 in conf (menu=0xb434a0) at
 	    scripts/kconfig/nconf.c:1203
 #11 0x0000000000406092 in main (ac=2, av=0x7fff96a93c38)

Cc: Michal Marek <mmarek@suse.cz>
Cc: Nir Tzachar <nir.tzachar@gmail.com>
Signed-off-by: Stephen Boyd <bebarino@gmail.com>
---
 scripts/kconfig/nconf.gui.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/nconf.gui.c b/scripts/kconfig/nconf.gui.c
index 115edb4..a9d9344 100644
--- a/scripts/kconfig/nconf.gui.c
+++ b/scripts/kconfig/nconf.gui.c
@@ -226,7 +226,7 @@ void fill_window(WINDOW *win, const char *text)
 		int len = get_line_length(line);
 		strncpy(tmp, line, min(len, x));
 		tmp[len] = '\0';
-		mvwprintw(win, i, 0, tmp);
+		mvwprintw(win, i, 0, "%s", tmp);
 	}
 }
 
-- 
1.7.2.rc3.57.g77b5b

