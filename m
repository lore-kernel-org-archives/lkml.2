Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab1C2Myl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 08:54:41 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:37862 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab1C2Myi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 08:54:38 -0400
Message-Id: <20110329125433.258166605@linux.vnet.ibm.com>
User-Agent: quilt/0.47-1
Date: Tue, 29 Mar 2011 14:48:26 +0200
From: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
To: robert.richter@amd.com
Cc: mingo@elte.hu, oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: [patch 1/1] Do not unregister_cpu_notifier in case of wrong state 
References: <20110329124825.027309213@linux.vnet.ibm.com>
Content-Disposition: inline; filename=hwsampler-shutdown.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heinz Graalfs <graalfs@linux.vnet.ibm.com>

This patch avoids calling unregister_cpu_notifier() in case
hwsampler_shutdown() is invoked in wrong state. 
---
 arch/s390/oprofile/hwsampler.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: 2.6.39/arch/s390/oprofile/hwsampler.c
===================================================================
--- 2.6.39.orig/arch/s390/oprofile/hwsampler.c
+++ 2.6.39/arch/s390/oprofile/hwsampler.c
@@ -1143,11 +1143,14 @@ int hwsampler_shutdown()
 
 		unregister_external_interrupt(0x1407, hws_ext_handler);
 		hws_state = HWS_INIT;
+
+		mutex_unlock(&hws_sem);
+		unregister_cpu_notifier(&hws_cpu_notifier);
+
 		rc = 0;
+	} else {
+		mutex_unlock(&hws_sem);
 	}
-	mutex_unlock(&hws_sem);
-
-	unregister_cpu_notifier(&hws_cpu_notifier);
 
 	return rc;
 }

