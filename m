Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759055Ab2DZSgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 14:36:25 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:34287 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758889Ab2DZSfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 14:35:09 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/4] xen/acpi: Workaround broken BIOSes exporting non-existing C-states.
Date: Thu, 26 Apr 2012 14:29:25 -0400
Message-Id: <1335464965-24767-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1335464965-24767-1-git-send-email-konrad.wilk@oracle.com>
References: <1335464965-24767-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We did a similar check for the P-states but did not do it for
the C-states. What we want to do is ignore cases where the DSDT
has definition for sixteen CPUs, but the machine only has eight
CPUs and we get:
xen-acpi-processor: (CX): Hypervisor error (-22) for ACPI CPU14

Reported-by: Tobias Geiger <tobias.geiger@vido.info>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-acpi-processor.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/xen-acpi-processor.c b/drivers/xen/xen-acpi-processor.c
index 174b565..0b48579 100644
--- a/drivers/xen/xen-acpi-processor.c
+++ b/drivers/xen/xen-acpi-processor.c
@@ -128,7 +128,10 @@ static int push_cxx_to_hypervisor(struct acpi_processor *_pr)
 			pr_debug("     C%d: %s %d uS\n",
 				 cx->type, cx->desc, (u32)cx->latency);
 		}
-	} else
+	} else if (ret != -EINVAL)
+		/* EINVAL means the ACPI ID is incorrect - meaning the ACPI
+		 * table is referencing a non-existing CPU - which can happen
+		 * with broken ACPI tables. */
 		pr_err(DRV_NAME "(CX): Hypervisor error (%d) for ACPI CPU%u\n",
 		       ret, _pr->acpi_id);
 
-- 
1.7.7.5

