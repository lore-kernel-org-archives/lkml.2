Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab1B1Qgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:36:52 -0500
Received: from kroah.org ([198.145.64.141]:41157 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143Ab1B1Qgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:36:50 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:06 2011
Message-Id: <20110228162405.984747466@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:22:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kashyap Desai <kashyap.desai@lsi.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [03/68] [SCSI] mptfusion: Fix Incorrect return value in mptscsih_dev_reset
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Kashyap, Desai <kashyap.desai@lsi.com>

commit bcfe42e98047f1935c5571c8ea77beb2d43ec19d upstream.

There's a branch at the end of this function that
is supposed to normalize the return value with what
the mid-layer expects. In this one case, we get it wrong.

Also increase the verbosity of the INFO level printk
at the end of mptscsih_abort to include the actual return value
and the scmd->serial_number. The reason being success
or failure is actually determined by the state of
the internal tag list when a TMF is issued, and not the
return value of the TMF cmd. The serial_number is also
used in this decision, thus it's useful to know for debugging
purposes.

Reported-by: Peter M. Petrakis <peter.petrakis@canonical.com>
Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/message/fusion/mptscsih.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1835,8 +1835,9 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 	}
 
  out:
-	printk(MYIOC_s_INFO_FMT "task abort: %s (sc=%p)\n",
-	    ioc->name, ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), SCpnt);
+	printk(MYIOC_s_INFO_FMT "task abort: %s (rv=%04x) (sc=%p) (sn=%ld)\n",
+	    ioc->name, ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), retval,
+	    SCpnt, SCpnt->serial_number);
 
 	return retval;
 }
@@ -1873,7 +1874,7 @@ mptscsih_dev_reset(struct scsi_cmnd * SC
 
 	vdevice = SCpnt->device->hostdata;
 	if (!vdevice || !vdevice->vtarget) {
-		retval = SUCCESS;
+		retval = 0;
 		goto out;
 	}
 


