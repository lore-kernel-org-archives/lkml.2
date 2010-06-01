Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab0FAU6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:58:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56484 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757374Ab0FAUxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:53:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 23/31] tty: fix console_sem lock order
Date: Tue,  1 Jun 2010 22:53:03 +0200
Message-Id: <1275425591-8803-24-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275425591-8803-1-git-send-email-arnd@arndb.de>
References: <1275425591-8803-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18RT5D090YCta7see81RuLvBB8z3ClSDLuIDC+
 JBvUMDaA7v2Ex3wY32nbZ9JryYorx1sA71/X7TKSwFbOwpHuu1
 0Dn37d1l94Y3QuJFbfg7g==
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

