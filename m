Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab1HCX0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:26:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33438 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756028Ab1HCX0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:26:24 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:47 2011
Message-Id: <20110803221247.209427219@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:00:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bart Van Assche <bvanassche@acm.org>, David Dillow <dillowda@ornl.gov>,
        Roland Dreier <roland@purestorage.com>
Subject: [032/102] IB/srp: Avoid duplicate devices from LUN scan
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit fd1b6c4a693c9cac59375ffb36ffe5d7c079037c upstream.

SCSI scanning of a channel:id:lun triplet in Linux works as follows
(function scsi_scan_target() in drivers/scsi/scsi_scan.c):

- If lun == SCAN_WILD_CARD, send a REPORT LUNS command to the target
  and process the result.

- If lun != SCAN_WILD_CARD, send an INQUIRY command to the LUN
  corresponding to the specified channel:id:lun triplet to verify
  whether the LUN exists.

So a SCSI driver must either take the channel and target id values in
account in its quecommand() function or it should declare that it only
supports one channel and one target id.

Currently the ib_srp driver does neither.  As a result scanning the
SCSI bus via e.g. rescan-scsi-bus.sh causes many duplicate SCSI
devices to be created. For each 0:0:L device, several duplicates are
created with the same LUN number and with (C:I) != (0:0). Fix this by
declaring that the ib_srp driver only supports one channel and one
target id.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: David Dillow <dillowda@ornl.gov>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/infiniband/ulp/srp/ib_srp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2127,6 +2127,8 @@ static ssize_t srp_create_target(struct
 		return -ENOMEM;
 
 	target_host->transportt  = ib_srp_transport_template;
+	target_host->max_channel = 0;
+	target_host->max_id      = 1;
 	target_host->max_lun     = SRP_MAX_LUN;
 	target_host->max_cmd_len = sizeof ((struct srp_cmd *) (void *) 0L)->cdb;
 


