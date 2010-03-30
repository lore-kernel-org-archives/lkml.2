Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab0C3U6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 16:58:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50462 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808Ab0C3U54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 16:57:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd@relay.de.ibm.com>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 6/9] tty: never hold tty_lock() while getting tty_mutex
Date: Tue, 30 Mar 2010 22:56:17 +0200
Message-Id: <1269982580-9361-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1269982580-9361-1-git-send-email-arnd@arndb.de>
References: <1269982580-9361-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19mfYsYNRRdh7+4mxE+YJl98/+tFT+XD/c+5cn
 8Cru99YhxoFEGh2hQPs0a5LQLbF+8C39AA3Czt9cVcEDf6Dlu5
 8cweCQdmfZlQgXu91LPQA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@relay.de.ibm.com>

This avoids having to annotate every mutex_lock(&tty_mutex)
as mutex_lock_tty.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/pty.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 72fb501..0a87b52 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -638,9 +638,11 @@ static int __ptmx_open(struct inode *inode, struct file *filp)
 	if (index < 0)
 		return index;
 
+	tty_unlock();
 	mutex_lock(&tty_mutex);
 	tty = tty_init_dev(ptm_driver, index, 1);
 	mutex_unlock(&tty_mutex);
+	tty_lock();
 
 	if (IS_ERR(tty)) {
 		retval = PTR_ERR(tty);
-- 
1.7.0

