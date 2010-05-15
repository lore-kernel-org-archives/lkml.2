Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab0EOVBy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 17:01:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53663 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab0EOVAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 17:00:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <gregkh@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 06/10] tty: annotate tty_write_lock
Date: Sat, 15 May 2010 22:59:52 +0200
Message-Id: <1273957196-13768-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1273957196-13768-1-git-send-email-arnd@arndb.de>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19US2fxw50h74ffRrfo/kF4o1rj7Fh6dVFfLbS
 GXhydEqiRbYjYVAfAyiNIdjU30p3DysN+tqu/dJa2ZGu94xc7+
 34jPD+4vDt6v9SFBF5Gwg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

atomic_write_lock never nests below BTM, so
there are no lock order problems between the
two.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/tty_io.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index d51993b..36aecba 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -912,6 +912,11 @@ void tty_write_unlock(struct tty_struct *tty)
 
 int tty_write_lock(struct tty_struct *tty, int ndelay)
 {
+	/*
+	 * code inspection has shown that this is never called
+	 * with the BTM held. Make sure this stays that way.
+	 */
+	WARN_ON_ONCE(tty_locked());
 	if (!mutex_trylock(&tty->atomic_write_lock)) {
 		if (ndelay)
 			return -EAGAIN;
-- 
1.7.0.4

