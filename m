Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab1JLJmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 05:42:06 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:56997 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab1JLJmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 05:42:05 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com, stable@kernel.org,
        Sukadev Bhattiprolu <sukadev@us.ibm.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/4] TTY: drop driver reference in tty_open fail path
Date: Wed, 12 Oct 2011 11:32:42 +0200
Message-Id: <1318411965-23917-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <4E8C6836.1090601@suse.cz>
References: <4E8C6836.1090601@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When tty_driver_lookup_tty fails in tty_open, we forget to drop a
reference to the tty driver. This was added by commit 4a2b5fddd5 (Move
tty lookup/reopen to caller).

Fix that by adding tty_driver_kref_put to the fail path.

I will refactor the code later. This is for the ease of backporting to
stable.

Introduced-in: v2.6.28-rc2
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: stable@kernel.org
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/tty_io.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 4f1fc81..54b3cc4 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1872,6 +1872,7 @@ got_driver:
 		if (IS_ERR(tty)) {
 			tty_unlock();
 			mutex_unlock(&tty_mutex);
+			tty_driver_kref_put(driver);
 			return PTR_ERR(tty);
 		}
 	}
-- 
1.7.7


