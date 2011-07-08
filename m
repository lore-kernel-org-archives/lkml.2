Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab1GIFzA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 01:55:00 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:35654 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753351Ab1GIFyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 01:54:47 -0400
X-Sasl-enc: iY9KbcrvwCvHXY/N1qsc/xNOzKCVkXNVu5/d/0Hi2esc 1310190885
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Jul  8 15:51:20 2011
Message-Id: <20110708225120.665270164@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 08 Jul 2011 15:50:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Arnd Bergmann <arnd@arndb.de>, Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [19/35] 6pack,mkiss: fix lock inconsistency
In-Reply-To: <20110708225343.GA14402@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/hamradio/6pack.c |    4 ++--
 drivers/net/hamradio/mkiss.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -690,10 +690,10 @@ static void sixpack_close(struct tty_str
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
 
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -811,10 +811,10 @@ static void mkiss_close(struct tty_struc
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


