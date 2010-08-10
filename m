Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933443Ab0HJWAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:00:35 -0400
Received: from kroah.org ([198.145.64.141]:44921 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933296Ab0HJWAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 18:00:16 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 37/68] tty: fix console_sem lock order
Date: Tue, 10 Aug 2010 14:58:59 -0700
Message-Id: <1281477570-18944-37-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100810214425.GB17385@kroah.com>
References: <20100810214425.GB17385@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

vgacon_do_font_op releases and reacquires the BTM while holding
console_sem. This violates the rule that BTM has to be the
outer lock whenever we hold both.

There does not seem to be any reason to give up the BTM here,
so just stop doing that.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.2

