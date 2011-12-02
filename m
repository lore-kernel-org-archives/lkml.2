Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab1LBIFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 03:05:51 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58669 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab1LBIFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 03:05:50 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4ED886DC.1000608@jp.fujitsu.com>
Date: Fri, 02 Dec 2011 17:05:48 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: axboe@kernel.dk, vgoyal@redhat.com
CC: linux-kernel@vger.kernel.org
Subject: [patch]cfq-iosched: fix cfq_cic_link() race confition
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cfq_cic_link() has race condition. When some processes which shared ioc
issue I/O to same block device simultaneously, cfq_cic_link() returns -EEXIST
sometimes. The race condition might stop I/O by following steps:

step  1: Process A: Issue an I/O to /dev/sda
step  2: Process A: Get an ioc (iocA here) in get_io_context() which does not
		    linked with a cic for the device
step  3: Process A: Get a new cic for the device (cicA here) in
		    cfq_alloc_io_context()

step  4: Process B: Issue an I/O to /dev/sda
step  5: Process B: Get iocA in get_io_context() since process A and B share the
		    same ioc
step  6: Process B: Get a new cic for the device (cicB here) in
		    cfq_alloc_io_context() since iocA has not been linked with a
		    cic for the device yet

step  7: Process A: Link cicA to iocA in cfq_cic_link()
step  8: Process A: Dispatch I/O to driver and finish it

step  9: Process B: Try to link cicB to iocA in cfq_cic_link()
		    But it fails with showing "cfq: cic link failed!" kernel
		    message, since iocA has already linked with cicA at step 7.
step 10: Process B: Wait for finishig I/O in get_request_wait()
		    The function does not wake up, when there is no I/O to the
		    device.

When cfq_cic_link() returns -EEXIST, it means ioc has already linked with cic.
So when cfq_cic_link() return -EEXIST, retry cfq_cic_lookup().

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---
 block/cfq-iosched.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Index: linux-3.2-rc3-fix/block/cfq-iosched.c
===================================================================
--- linux-3.2-rc3-fix.orig/block/cfq-iosched.c	2011-11-30 18:32:28.000000000 +0900
+++ linux-3.2-rc3-fix/block/cfq-iosched.c	2011-11-30 18:24:02.000000000 +0900
@@ -3184,7 +3184,7 @@
 		}
 	}

-	if (ret)
+	if (ret && ret != -EEXIST)
 		printk(KERN_ERR "cfq: cic link failed!\n");

 	return ret;
@@ -3200,6 +3200,7 @@
 {
 	struct io_context *ioc = NULL;
 	struct cfq_io_context *cic;
+	int ret;

 	might_sleep_if(gfp_mask & __GFP_WAIT);

@@ -3207,6 +3208,7 @@
 	if (!ioc)
 		return NULL;

+retry:
 	cic = cfq_cic_lookup(cfqd, ioc);
 	if (cic)
 		goto out;
@@ -3215,7 +3217,12 @@
 	if (cic == NULL)
 		goto err;

-	if (cfq_cic_link(cfqd, ioc, cic, gfp_mask))
+	ret = cfq_cic_link(cfqd, ioc, cic, gfp_mask);
+	if (ret == -EEXIST) {
+		/* someone has linked cic to ioc already */
+		cfq_cic_free(cic);
+		goto retry;
+	} else if (ret)
 		goto err_free;

 out:

