Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab1BPAUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:20:15 -0500
Received: from kroah.org ([198.145.64.141]:38988 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757018Ab1BPAUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:20:00 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:32 2011
Message-Id: <20110216001432.542175530@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:12:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kashyap Desai <kashyap.desai@lsi.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [074/272] [SCSI] mpt2sas: fix internal device reset for older firmware prior to MPI Rev K
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kashyap, Desai <kashyap.desai@lsi.com>

commit efe82a16bc0f9f9e1fc8fa706eb0309fcd57770a upstream.

The "internal device reset complete" event is not supported
for older firmware prior to MPI Rev K We added
a check in the driver so the "internal device reset" event is
ignored for older firmware.  When ignored, the tm_busy flag doesn't
get set nor cleared.  Without this fix, IO queues would be froozen
indefinetly after the "internal device reset" event, as the "complete" event
never sent to clear the flag.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -4939,6 +4939,12 @@ _scsih_sas_device_status_change_event(st
 		     event_data);
 #endif
 
+	/* In MPI Revision K (0xC), the internal device reset complete was
+	 * implemented, so avoid setting tm_busy flag for older firmware.
+	 */
+	if ((ioc->facts.HeaderVersion >> 8) < 0xC)
+		return;
+
 	if (event_data->ReasonCode !=
 	    MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET &&
 	   event_data->ReasonCode !=


