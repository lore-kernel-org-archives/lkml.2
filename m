Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab2LAO2x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 09:28:53 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:41692
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565Ab2LAO2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 09:28:40 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 20/28] Drivers: hv: Get rid of the unused global signaling state
Date: Sat,  1 Dec 2012 06:46:51 -0800
Message-Id: <1354373219-31374-20-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354373219-31374-1-git-send-email-kys@microsoft.com>
References: <1354373160-31332-1-git-send-email-kys@microsoft.com>
 <1354373219-31374-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have implemented a per-connection signaling mechanism, get rid
of the global signaling state. For hosts that don't support per-connection
signaling handle, we have moved the global state to be a per-channel state.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/hv.c           |   24 ------------------------
 drivers/hv/hyperv_vmbus.h |    8 --------
 2 files changed, 0 insertions(+), 32 deletions(-)

diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index 76304a6..e989c6fd 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -34,8 +34,6 @@
 struct hv_context hv_context = {
 	.synic_initialized	= false,
 	.hypercall_page		= NULL,
-	.signal_event_param	= NULL,
-	.signal_event_buffer	= NULL,
 };
 
 /*
@@ -170,24 +168,6 @@ int hv_init(void)
 
 	hv_context.hypercall_page = virtaddr;
 
-	/* Setup the global signal event param for the signal event hypercall */
-	hv_context.signal_event_buffer =
-			kmalloc(sizeof(struct hv_input_signal_event_buffer),
-				GFP_KERNEL);
-	if (!hv_context.signal_event_buffer)
-		goto cleanup;
-
-	hv_context.signal_event_param =
-		(struct hv_input_signal_event *)
-			(ALIGN((unsigned long)
-				  hv_context.signal_event_buffer,
-				  HV_HYPERCALL_PARAM_ALIGN));
-	hv_context.signal_event_param->connectionid.asu32 = 0;
-	hv_context.signal_event_param->connectionid.u.id =
-						VMBUS_EVENT_CONNECTION_ID;
-	hv_context.signal_event_param->flag_number = 0;
-	hv_context.signal_event_param->rsvdz = 0;
-
 	return 0;
 
 cleanup:
@@ -215,10 +195,6 @@ void hv_cleanup(void)
 	/* Reset our OS id */
 	wrmsrl(HV_X64_MSR_GUEST_OS_ID, 0);
 
-	kfree(hv_context.signal_event_buffer);
-	hv_context.signal_event_buffer = NULL;
-	hv_context.signal_event_param = NULL;
-
 	if (hv_context.hypercall_page) {
 		hypercall_msr.as_uint64 = 0;
 		wrmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 6bbc197..9135a6f 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -492,14 +492,6 @@ struct hv_context {
 
 	bool synic_initialized;
 
-	/*
-	 * This is used as an input param to HvCallSignalEvent hypercall. The
-	 * input param is immutable in our usage and must be dynamic mem (vs
-	 * stack or global). */
-	struct hv_input_signal_event_buffer *signal_event_buffer;
-	/* 8-bytes aligned of the buffer above */
-	struct hv_input_signal_event *signal_event_param;
-
 	void *synic_message_page[NR_CPUS];
 	void *synic_event_page[NR_CPUS];
 	/*
-- 
1.7.4.1

