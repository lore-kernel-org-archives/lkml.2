Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab0EOVAG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 17:00:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59616 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab0EOVAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 17:00:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <gregkh@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 03/10] tty: fix console_sem lock order
Date: Sat, 15 May 2010 22:59:49 +0200
Message-Id: <1273957196-13768-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1273957196-13768-1-git-send-email-arnd@arndb.de>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/1uvfQ0GN6BO+PLHRlYzxKPJzC14UBf5n3Ura
 bYzwqS04/mWTbCMzBlMvdAtiRxu/5bjEytwvC7yun2BiiCFHXm
 fknQ4CdR4XJhXnXp8Ba6w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vgacon_do_font_op releases and reacquires the BTM while holding
console_sem. This violates the rule that BTM has to be the
outer lock whenever we hold both.

There does not seem to be any reason to give up the BTM here,
so just stop doing that.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/video/console/vgacon.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index 7197005..54e32c5 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -1108,7 +1108,6 @@ static int vgacon_do_font_op(struct vgastate *state,char *arg,int set,int ch512)
 		charmap += 4 * cmapsz;
 #endif
 
-	tty_unlock();
 	spin_lock_irq(&vga_lock);
 	/* First, the Sequencer */
 	vga_wseq(state->vgabase, VGA_SEQ_RESET, 0x1);
@@ -1192,7 +1191,6 @@ static int vgacon_do_font_op(struct vgastate *state,char *arg,int set,int ch512)
 		vga_wattr(state->vgabase, VGA_AR_ENABLE_DISPLAY, 0);	
 	}
 	spin_unlock_irq(&vga_lock);
-	tty_lock();
 	return 0;
 }
 
-- 
1.7.0.4

