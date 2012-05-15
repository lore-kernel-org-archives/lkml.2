Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965099Ab2EOCw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:52:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:49629 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965085Ab2EOCRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:16 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 093/179] 6pack,mkiss: fix lock inconsistency
Date: Mon, 14 May 2012 22:13:09 -0400
Message-ID: <1337048075-6132-94-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 6e4e2f811bade330126d4029c88c831784a7efd9 upstream.

Lockdep found a locking inconsistency in the mkiss_close function:

> kernel: [ INFO: inconsistent lock state ]
> kernel: 2.6.39.1 #3
> kernel: ---------------------------------
> kernel: inconsistent {IN-SOFTIRQ-R} -> {SOFTIRQ-ON-W} usage.
> kernel: ax25ipd/2813 [HC0[0]:SC0[0]:HE1:SE1] takes:
> kernel: (disc_data_lock){+++?.-}, at: [<ffffffffa018552b>] mkiss_close+0x1b/0x90 [mkiss]
> kernel: {IN-SOFTIRQ-R} state was registered at:

The message hints that disc_data_lock is aquired with softirqs disabled,
but does not itself disable softirqs, which can in rare circumstances
lead to a deadlock.
The same problem is present in the 6pack driver, this patch fixes both
by using write_lock_bh instead of write_lock.

Reported-by: Bernard F6BVP <f6bvp@free.fr>
Tested-by: Bernard F6BVP <f6bvp@free.fr>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Ralf Baechle<ralf@linux-mips.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/hamradio/6pack.c |    4 ++--
 drivers/net/hamradio/mkiss.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 4b52c76..26843e2 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -692,10 +692,10 @@ static void sixpack_close(struct tty_struct *tty)
 {
 	struct sixpack *sp;
 
-	write_lock(&disc_data_lock);
+	write_lock_bh(&disc_data_lock);
 	sp = tty->disc_data;
 	tty->disc_data = NULL;
-	write_unlock(&disc_data_lock);
+	write_unlock_bh(&disc_data_lock);
 	if (!sp)
 		return;
 
diff --git a/drivers/net/hamradio/mkiss.c b/drivers/net/hamradio/mkiss.c
index 66e88bd..bb94407 100644
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -813,10 +813,10 @@ static void mkiss_close(struct tty_struct *tty)
 {
 	struct mkiss *ax;
 
-	write_lock(&disc_data_lock);
+	write_lock_bh(&disc_data_lock);
 	ax = tty->disc_data;
 	tty->disc_data = NULL;
-	write_unlock(&disc_data_lock);
+	write_unlock_bh(&disc_data_lock);
 
 	if (!ax)
 		return;
-- 
1.7.9.6

