Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab1G0Vxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:53:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:36390 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031Ab1G0VtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="35258438"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: arnd@arndb.de, f6bvp@free.fr, ralf@linux-mips.org, davem@davemloft.net,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [82/99] 6pack,mkiss: fix lock inconsistency
Message-Id: <20110727214921.C193E2403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:49:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/hamradio/6pack.c |    4 ++--
 drivers/net/hamradio/mkiss.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.35.y/drivers/net/hamradio/6pack.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/hamradio/6pack.c
+++ linux-2.6.35.y/drivers/net/hamradio/6pack.c
@@ -692,10 +692,10 @@ static void sixpack_close(struct tty_str
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
 
Index: linux-2.6.35.y/drivers/net/hamradio/mkiss.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/hamradio/mkiss.c
+++ linux-2.6.35.y/drivers/net/hamradio/mkiss.c
@@ -813,10 +813,10 @@ static void mkiss_close(struct tty_struc
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
