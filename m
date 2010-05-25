Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587Ab0EYJi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 05:38:59 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:49068 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab0EYJi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 05:38:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=ALokPq3KzF4XKlAg9K2ussoOdonwSX1yAPiR1bbb5WSQICMy9jCJsDRDEz9tECqMkm
         CywwFY+IRz2j4sQECFVmgXo0A5q40OjHTRqJrc5JqnGceY6PhiDqI0MKXaajHSzoU7Se
         slorrVUeRisdRq8KxWnv+8aLx8vynSR3oR0oM=
Date: Tue, 25 May 2010 11:37:17 +0200
From: Dan Carpenter <error27@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] TTY/n_gsm: potential double lock
Message-ID: <20100525093717.GC22515@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In gsm_dlci_data_kick() we call gsm_dlci_data_sweep() with the
"gsm->tx_lock" held so we can't lock it again inside
gsm_dlci_data_sweep().  I removed that lock from and added one to 
gsmld_write_wakeup() instead.  The sweep function is only called from
those two places.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/char/n_gsm.c b/drivers/char/n_gsm.c
index c4161d5..e4089c4 100644
--- a/drivers/char/n_gsm.c
+++ b/drivers/char/n_gsm.c
@@ -904,9 +904,7 @@ static void gsm_dlci_data_sweep(struct gsm_mux *gsm)
 	int len;
 	/* Priority ordering: We should do priority with RR of the groups */
 	int i = 1;
-	unsigned long flags;
 
-	spin_lock_irqsave(&gsm->tx_lock, flags);
 	while (i < NUM_DLCI) {
 		struct gsm_dlci *dlci;
 
@@ -927,7 +925,6 @@ static void gsm_dlci_data_sweep(struct gsm_mux *gsm)
 		if (len == 0)
 			i++;
 	}
-	spin_unlock_irqrestore(&gsm->tx_lock, flags);
 }
 
 /**
@@ -2230,12 +2227,16 @@ static int gsmld_open(struct tty_struct *tty)
 static void gsmld_write_wakeup(struct tty_struct *tty)
 {
 	struct gsm_mux *gsm = tty->disc_data;
+	unsigned long flags;
 
 	/* Queue poll */
 	clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
 	gsm_data_kick(gsm);
-	if (gsm->tx_bytes < TX_THRESH_LO)
+	if (gsm->tx_bytes < TX_THRESH_LO) {
+		spin_lock_irqsave(&gsm->tx_lock, flags);
 		gsm_dlci_data_sweep(gsm);
+		spin_unlock_irqrestore(&gsm->tx_lock, flags);
+	}
 }
 
 /**
