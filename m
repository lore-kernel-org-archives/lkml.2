Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274Ab1C3VHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:07:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:60385 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964830Ab1C3VHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673447593"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: kashyap.desai@lsi.com, James.Bottomley@suse.de, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [112/275] mptfusion: Fix Incorrect return value in mptscsih_dev_reset
Message-Id: <20110330210551.9800C3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/message/fusion/mptscsih.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6.35.y/drivers/message/fusion/mptscsih.c
===================================================================
--- linux-2.6.35.y.orig/drivers/message/fusion/mptscsih.c	2011-03-29 22:51:23.974109732 -0700
+++ linux-2.6.35.y/drivers/message/fusion/mptscsih.c	2011-03-29 23:03:00.520286858 -0700
@@ -1848,8 +1848,9 @@
 	}
 
  out:
-	printk(MYIOC_s_INFO_FMT "task abort: %s (sc=%p)\n",
-	    ioc->name, ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), SCpnt);
+	printk(MYIOC_s_INFO_FMT "task abort: %s (rv=%04x) (sc=%p) (sn=%ld)\n",
+	    ioc->name, ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), retval,
+	    SCpnt, SCpnt->serial_number);
 
 	return retval;
 }
@@ -1886,7 +1887,7 @@
 
 	vdevice = SCpnt->device->hostdata;
 	if (!vdevice || !vdevice->vtarget) {
-		retval = SUCCESS;
+		retval = 0;
 		goto out;
 	}
 
