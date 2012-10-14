Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542Ab2JNOqc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:46:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46795 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932467Ab2JNOoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:44:19 -0400
Message-Id: <20121014143537.351271985@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:35:59 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 026/147] [SCSI] hpsa: Use LUN reset instead of target reset
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

commit 21e89afd325849eb38adccf382df16cc895911f9 upstream.

It turns out Smart Array logical drives do not support target
reset and when the target reset fails, the logical drive will
be taken off line.  Symptoms look like this:

hpsa 0000:03:00.0: Abort request on C1:B0:T0:L0
hpsa 0000:03:00.0: resetting device 1:0:0:0
hpsa 0000:03:00.0: cp ffff880037c56000 is reported invalid (probably means target device no longer present)
hpsa 0000:03:00.0: resetting device failed.
sd 1:0:0:0: Device offlined - not ready after error recovery
sd 1:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sdb1): read_block_bitmap:

LUN reset is supported though, and is what we should be using.
Target reset is also disruptive in shared SAS situations,
for example, an external MSA1210m which does support target
reset attached to Smart Arrays in multiple hosts -- a target
reset from one host is disruptive to other hosts as all LUNs
on the target will be reset and will abort all outstanding i/os
back to all the attached hosts.  So we should use LUN reset,
not target reset.

Tested this with Smart Array logical drives and with tape drives.
Not sure how this bug survived since 2009, except it must be very
rare for a Smart Array to require more than 30s to complete a request.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/hpsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 796482b..015a6c8 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3265,7 +3265,7 @@ static void fill_cmd(struct CommandList *c, u8 cmd, struct ctlr_info *h,
 			c->Request.Timeout = 0; /* Don't time out */
 			memset(&c->Request.CDB[0], 0, sizeof(c->Request.CDB));
 			c->Request.CDB[0] =  cmd;
-			c->Request.CDB[1] = 0x03;  /* Reset target above */
+			c->Request.CDB[1] = HPSA_RESET_TYPE_LUN;
 			/* If bytes 4-7 are zero, it means reset the */
 			/* LunID device */
 			c->Request.CDB[4] = 0x00;


