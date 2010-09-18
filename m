Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab0IRTPk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:15:40 -0400
Received: from kroah.org ([198.145.64.141]:43578 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756936Ab0IRTPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:34 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:03 2010
Message-Id: <20100918191303.533331686@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@redhat.com>
Subject: [072/129] ahci: fix hang on failed softreset
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit f1f5a807b051eddd3f302e503d39214e5bde0ef2 upstream.

ahci_do_softreset() compared the current time and deadline in reverse
when calculating timeout for SRST issue.  The result is that if
@deadline is in future, SRST is issued with 0 timeout, which hasn't
caused any problem because it later waits for DRDY with the correct
timeout.  If deadline is already exceeded by the time SRST is about to
be issued, the timeout calculation underflows and if the device
doesn't respond, timeout doesn't trigger for a _very_ long time.

Reverse the incorrect comparison order.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Anssi Hannula <anssi.hannula@iki.fi>
Tested-by: Gwendal Grignou <gwendal@google.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libahci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1320,7 +1320,7 @@ int ahci_do_softreset(struct ata_link *l
 	/* issue the first D2H Register FIS */
 	msecs = 0;
 	now = jiffies;
-	if (time_after(now, deadline))
+	if (time_after(deadline, now))
 		msecs = jiffies_to_msecs(deadline - now);
 
 	tf.ctl |= ATA_SRST;


