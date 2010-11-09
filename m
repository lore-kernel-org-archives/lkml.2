Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab0KIBOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 20:14:12 -0500
Received: from smtp-out.google.com ([216.239.44.51]:42686 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab0KIBOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 20:14:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=X5e2BD25MyETywiKYtjaZnacZoELScnr0vlLeMmTwllUnyvfiSDoH4IM+8IoPSdUTe
         sUuv18kYa+04VPBTh/8w==
MIME-Version: 1.0
Date: Mon, 8 Nov 2010 17:14:08 -0800
Message-ID: <AANLkTi=JKizQkRgY-ev21Cv_33hhxx7U9kpF_OQmp4ou@mail.gmail.com>
Subject: [patch] fix per task latencytop accumulator
From: Ken Chen <kenchen@google.com>
To: linux-kernel@vger.kernel.org, arjan@linux.intel.com,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per task latencytop accumulator prematurely terminate due to erroneous
placement on latency_record_count.  It should be incremented whenever a
new record is allocated instead of increment on every latencytop event.

Also fix search iterator to only search known record events instead of
blindly search all pre-allocated space.

Signed-off-by: Ken Chen <kenchen@google.com>


diff --git a/kernel/latencytop.c b/kernel/latencytop.c
index 877fb30..17110a4 100644
--- a/kernel/latencytop.c
+++ b/kernel/latencytop.c
@@ -194,14 +194,7 @@ __account_scheduler_latency(

 	account_global_scheduler_latency(tsk, &lat);

-	/*
-	 * short term hack; if we're > 32 we stop; future we recycle:
-	 */
-	tsk->latency_record_count++;
-	if (tsk->latency_record_count >= LT_SAVECOUNT)
-		goto out_unlock;
-
-	for (i = 0; i < LT_SAVECOUNT; i++) {
+	for (i = 0; i < tsk->latency_record_count; i++) {
 		struct latency_record *mylat;
 		int same = 1;

@@ -227,8 +220,14 @@ __account_scheduler_latency(
 		}
 	}

+	/*
+	 * short term hack; if we're > 32 we stop; future we recycle:
+	 */
+	if (tsk->latency_record_count >= LT_SAVECOUNT)
+		goto out_unlock;
+
 	/* Allocated a new one: */
-	i = tsk->latency_record_count;
+	i = tsk->latency_record_count++;
 	memcpy(&tsk->latency_record[i], &lat, sizeof(struct latency_record));

 out_unlock:
