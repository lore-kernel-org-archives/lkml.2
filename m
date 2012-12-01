Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab2LAOZy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 09:25:54 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:37232
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087Ab2LAOXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 09:23:40 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 16/28] Drivers: hv: Setup a mapping for Hyper-V's notion cpu ID
Date: Sat,  1 Dec 2012 06:46:47 -0800
Message-Id: <1354373219-31374-16-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354373219-31374-1-git-send-email-kys@microsoft.com>
References: <1354373160-31332-1-git-send-email-kys@microsoft.com>
 <1354373219-31374-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On win8 (ws2012), incoming vmbus interrupt load can be spread across all
available VCPUs in the guest. On a per-channel basis, the interrupts can
be bound to specific CPUs. The Linux notion of cpu ID may be different
from that of the hypervisor's. Setup a mapping structure.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/hv.c           |   11 +++++++++++
 drivers/hv/hyperv_vmbus.h |   10 ++++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index dd0af89..76304a6 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -137,6 +137,8 @@ int hv_init(void)
 	memset(hv_context.synic_event_page, 0, sizeof(void *) * NR_CPUS);
 	memset(hv_context.synic_message_page, 0,
 	       sizeof(void *) * NR_CPUS);
+	memset(hv_context.vp_index, 0,
+	       sizeof(int) * NR_CPUS);
 
 	max_leaf = query_hypervisor_info();
 
@@ -296,6 +298,7 @@ void hv_synic_init(void *irqarg)
 	union hv_synic_siefp siefp;
 	union hv_synic_sint shared_sint;
 	union hv_synic_scontrol sctrl;
+	u64 vp_index;
 
 	u32 irq_vector = *((u32 *)(irqarg));
 	int cpu = smp_processor_id();
@@ -355,6 +358,14 @@ void hv_synic_init(void *irqarg)
 	wrmsrl(HV_X64_MSR_SCONTROL, sctrl.as_uint64);
 
 	hv_context.synic_initialized = true;
+
+	/*
+	 * Setup the mapping between Hyper-V's notion
+	 * of cpuid and Linux' notion of cpuid.
+	 * This array will be indexed using Linux cpuid.
+	 */
+	rdmsrl(HV_X64_MSR_VP_INDEX, vp_index);
+	hv_context.vp_index[cpu] = (u32)vp_index;
 	return;
 
 cleanup:
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 1bc7500..6bbc197 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -502,6 +502,16 @@ struct hv_context {
 
 	void *synic_message_page[NR_CPUS];
 	void *synic_event_page[NR_CPUS];
+	/*
+	 * Hypervisor's notion of virtual processor ID is different from
+	 * Linux' notion of CPU ID. This information can only be retrieved
+	 * in the context of the calling CPU. Setup a map for easy access
+	 * to this information:
+	 *
+	 * vp_index[a] is the Hyper-V's processor ID corresponding to
+	 * Linux cpuid 'a'.
+	 */
+	u32 vp_index[NR_CPUS];
 };
 
 extern struct hv_context hv_context;
-- 
1.7.4.1

