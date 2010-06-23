Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab0FWIff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 04:35:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61015 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab0FWIfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 04:35:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Subject: tty: fix switching consoles during suspend
Date: Wed, 23 Jun 2010 10:35:21 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-00069-gc502b38-dirty; KDE/4.4.85; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201006231035.22131.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19fYjOcr315ej16Z8kbSdbWAs5CAB9KyDf/3wy
 2RRgJRnxC9NmhPXLnzLcFDQdSBPeYg2ZHfCPDfPRsAUFcissT7
 u/B9RfQbZdGG7wNI+QNGw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vt_waitactive now expects to be called with the big tty mutex, which
it tries to release before going to sleep.

This fixes the only caller that does not hold the BTM already.
---

Greg, please apply to the tty series or fold into
"tty: introduce wait_event_interruptible_tty", which introduces
the problem.

diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index 45410c8..2bbeaae 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -1761,10 +1761,13 @@ int vt_move_to_console(unsigned int vt, int alloc)
 		return -EIO;
 	}
 	release_console_sem();
+	tty_lock();
 	if (vt_waitactive(vt + 1)) {
 		pr_debug("Suspend: Can't switch VCs.");
+		tty_unlock();
 		return -EINTR;
 	}
+	tty_unlock();
 	return prev;
 }
 
