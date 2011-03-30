Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab1C3IJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 04:09:29 -0400
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:41792 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab1C3IJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 04:09:26 -0400
Message-Id: <20110330080923.413595315@linux.vnet.ibm.com>
User-Agent: quilt/0.47-1
Date: Wed, 30 Mar 2011 10:06:38 +0200
From: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
To: robert.richter@amd.com
Cc: mingo@elte.hu, oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: v2 [patch 1/1] Do not unregister_cpu_notifier in case of wrong state 
References: <20110330080637.110679740@linux.vnet.ibm.com>
Content-Disposition: inline; filename=hwsampler-shutdown.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heinz Graalfs <graalfs@linux.vnet.ibm.com>

This patch avoids calling unregister_cpu_notifier() in case
hwsampler_shutdown() is invoked in wrong state. 
---
 arch/s390/oprofile/hwsampler.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

Index: 2.6.39/arch/s390/oprofile/hwsampler.c
===================================================================
--- 2.6.39.orig/arch/s390/oprofile/hwsampler.c
+++ 2.6.39/arch/s390/oprofile/hwsampler.c
@@ -1142,12 +1142,15 @@ int hwsampler_shutdown()
 		}
 
 		unregister_external_interrupt(0x1407, hws_ext_handler);
-		hws_state = HWS_INIT;
+		hws_state = 0;
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

