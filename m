Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749Ab1GAV3Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 17:29:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55469 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757690Ab1GAV3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 17:29:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Bernard F6BVP <f6bvp@free.fr>, David Miller <davem@davemloft.net>
Subject: [PATCH] 6pack,mkiss: fix lock inconsistency
Date: Fri, 1 Jul 2011 23:28:46 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Ralf Baechle DL5RB <ralf@linux-mips.org>, linux-kernel@vger.kernel.org,
        Linux Netdev List <netdev@vger.kernel.org>, linux-hams@vger.kernel.org
References: <4B2CD772.1030106@upmc.fr> <20110625163942.GB20976@linux-mips.org> <4E0DC4F3.6010203@free.fr>
In-Reply-To: <4E0DC4F3.6010203@free.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107012328.46256.arnd@arndb.de>
X-Provags-ID: V02:K0:qWTxtINPCn5uHXwqPhIcTgVgFnHRI0mSyNxOWvrW1v/
 7mGoZKB+UpeHkgZOjnIqtG+DqHcmcwkuvSuOVnaWJB3VyXgj9S
 nI1M6AHgqUcKztNcXETchId0TiAW9RyFX4BqRczwxuunYdr88H
 sZseaCmSlI7MlIQoM2b3ReGyPu2Z8XFWA3tqT3xPFeCxF1e47K
 sC0PqngB83Xn9FhcInLxA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: stable@kernel.org
---
On Friday 01 July 2011 15:00:35 Bernard F6BVP wrote:
> 
> Now, who is going to commit this mkiss patch and the equivalent one for 
> sixpack.c ?

Here's a formal patch with all the right tags, I assume that David Miller
will apply that to the netdev tree.

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 9624cbf..fea7cb4 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -694,10 +694,10 @@ static void sixpack_close(struct tty_struct *tty)
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
index 9f84c83..324f7bf 100644
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
