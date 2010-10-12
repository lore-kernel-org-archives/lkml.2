Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703Ab0JLPqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:46:35 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27843 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932645Ab0JLPqc (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 12 Oct 2010 11:46:32 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 08/23] xen: statically initialize cpu_evtchn_mask_p
Date: Tue, 12 Oct 2010 11:44:16 -0400
Message-Id: <1286898271-32018-9-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
References: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
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

