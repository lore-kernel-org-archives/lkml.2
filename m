Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769Ab0HDSUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 14:20:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:54590 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757500Ab0HDSUU (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 4 Aug 2010 14:20:20 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: alex.williamson@redhat.com,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 08/20] xen: statically initialize cpu_evtchn_mask_p
Date: Wed,  4 Aug 2010 14:19:03 -0400
Message-Id: <1280945955-14229-9-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1280945955-14229-1-git-send-email-konrad.wilk@oracle.com>
References: <1280945955-14229-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4C59AF57.021D:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Sometimes cpu_evtchn_mask_p can get used early, before it has been
allocated.  Statically initialize it with an initdata version to catch
any early references.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/events.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 64cde24..35718db 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -99,7 +99,12 @@ static int *evtchn_to_irq;
 struct cpu_evtchn_s {
 	unsigned long bits[NR_EVENT_CHANNELS/BITS_PER_LONG];
 };
-static struct cpu_evtchn_s *cpu_evtchn_mask_p;
+
+static __initdata struct cpu_evtchn_s init_evtchn_mask = {
+	.bits[0 ... (NR_EVENT_CHANNELS/BITS_PER_LONG)-1] = ~0ul,
+};
+static struct cpu_evtchn_s *cpu_evtchn_mask_p = &init_evtchn_mask;
+
 static inline unsigned long *cpu_evtchn_mask(int cpu)
 {
 	return cpu_evtchn_mask_p[cpu].bits;
-- 
1.7.0.1

