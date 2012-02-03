Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab2BCAxA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 19:53:00 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:44845
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755501Ab2BCAwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 19:52:54 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        ohering@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 4/4] drivers: hv: Increase the number of VCPUs supported in the guest
Date: Thu,  2 Feb 2012 16:56:51 -0800
Message-Id: <1328230611-3315-4-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1328230611-3315-1-git-send-email-kys@microsoft.com>
References: <1328230577-3263-1-git-send-email-kys@microsoft.com>
 <1328230611-3315-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code arbirarily limited the number of CPUs the guest could have.
Change that so that we can support the maximum number of CPUs the guest can
support. While we use NR_CPUS to size the per-cpu state all we are allocating
based on NR_CPUS are the  pointers to per-cpu state that will be allocatted in
the context of the initializing CPU. This patch triggers a checkpatch warning
for the usage of NR_CPU and since all we are allocating a couple of pointers
per CPU, it should be ok.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/hv.c           |    4 ++--
 drivers/hv/hyperv_vmbus.h |    5 ++---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index 12aa97f..15956bd 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -155,9 +155,9 @@ int hv_init(void)
 	union hv_x64_msr_hypercall_contents hypercall_msr;
 	void *virtaddr = NULL;
 
-	memset(hv_context.synic_event_page, 0, sizeof(void *) * MAX_NUM_CPUS);
+	memset(hv_context.synic_event_page, 0, sizeof(void *) * NR_CPUS);
 	memset(hv_context.synic_message_page, 0,
-	       sizeof(void *) * MAX_NUM_CPUS);
+	       sizeof(void *) * NR_CPUS);
 
 	if (!query_hypervisor_presence())
 		goto cleanup;
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 6d7d286..699f0d8 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -457,7 +457,6 @@ static const uuid_le VMBUS_SERVICE_ID = {
 	},
 };
 
-#define MAX_NUM_CPUS	32
 
 
 struct hv_input_signal_event_buffer {
@@ -483,8 +482,8 @@ struct hv_context {
 	/* 8-bytes aligned of the buffer above */
 	struct hv_input_signal_event *signal_event_param;
 
-	void *synic_message_page[MAX_NUM_CPUS];
-	void *synic_event_page[MAX_NUM_CPUS];
+	void *synic_message_page[NR_CPUS];
+	void *synic_event_page[NR_CPUS];
 };
 
 extern struct hv_context hv_context;
-- 
1.7.4.1

