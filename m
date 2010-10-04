Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab0JDSON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:14:13 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31634 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756324Ab0JDSOG (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 4 Oct 2010 14:14:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 08/22] xen: statically initialize cpu_evtchn_mask_p
Date: Mon,  4 Oct 2010 14:13:21 -0400
Message-Id: <1286216015-9710-9-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286216015-9710-1-git-send-email-konrad.wilk@oracle.com>
References: <1286216015-9710-1-git-send-email-konrad.wilk@oracle.com>
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
index a98e720..e1bd0be 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -104,7 +104,12 @@ static int *evtchn_to_irq;
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
1.7.0.4

