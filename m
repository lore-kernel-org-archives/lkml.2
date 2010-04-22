Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab0DVTor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:44:47 -0400
Received: from kroah.org ([198.145.64.141]:41207 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756690Ab0DVT3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:14 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:19 2010
Message-Id: <20100422190919.056293367@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:09:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mike Christie <michaelc@cs.wisc.edu>,
       James Smart <james.smart@emulex.com>,
       James Bottomley <James.Bottomley@suse.de>,
       maximilian attems <max@stro.at>
Subject: [131/197] [SCSI] fc class: fail fast bsg requests
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Christie <michaelc@cs.wisc.edu>

commit 2bc1c59dbdefdb6f9767e06efb86bbdb2923a8be upstream.

If the port state is blocked and the fast io fail tmo has
fired then this patch will fail bsg requests immediately.
This is needed if userspace is sending IOs to test the transport
like with fcping, so it will not have to wait for the dev loss tmo.
With this patch he bsg req fast io fail code behaves like the normal
and sg io/passthrough fast io fail.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Acked-By: James Smart <james.smart@emulex.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/scsi_transport_fc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3796,8 +3796,9 @@ fc_bsg_request_handler(struct request_qu
 		return;
 
 	while (!blk_queue_plugged(q)) {
-		if (rport && (rport->port_state == FC_PORTSTATE_BLOCKED))
-				break;
+		if (rport && (rport->port_state == FC_PORTSTATE_BLOCKED) &&
+		    !(rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT))
+			break;
 
 		req = blk_fetch_request(q);
 		if (!req)


