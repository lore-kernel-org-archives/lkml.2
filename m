Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab1IAJ4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 05:56:24 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:33015 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab1IAJ4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 05:56:23 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Liu Gang <Gang.Liu@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <r58472@freescale.com>, <B11780@freescale.com>, <r61911@freescale.com>,
        Liu Gang <Gang.Liu@freescale.com>
Subject: [PATCH] fsl-rio: Release rapidio port I/O region resource if port failed to initialize
Date: Thu, 1 Sep 2011 17:52:24 +0800
Message-ID: <1314870744-27325-1-git-send-email-Gang.Liu@freescale.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "struct rio_mport" contains a member of master port I/O memory resource structure
"struct resource iores". This resource will be read from device tree and be used for
rapidio R/W transaction memory space. Rapidio requests the port I/O memory resource
under the root resource "iomem_resource".
			
			struct rio_mport *port;
			port = kzalloc(sizeof(struct rio_mport), GFP_KERNEL);

			request_resource(&iomem_resource, &port->iores);

When port failed to initialize, allocated "rio_mport" structure memory will be freed,
and the port I/O memory resource structure pointer "&port->iores" will be invalid. If
other requests resource under "iomem_resource", "&port->iores" node may be operated in
the child resources list and this will cause the system to crash.

So the requested port I/O memory resource should be released before freeing allocated
"rio_mport" structure.

Signed-off-by: Liu Gang <Gang.Liu@freescale.com>
---
 arch/powerpc/sysdev/fsl_rio.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index c65f75a..22ffccd 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -1608,6 +1608,7 @@ int fsl_rio_setup(struct platform_device *dev)
 	return 0;
 err:
 	iounmap(priv->regs_win);
+	release_resource(&port->iores);
 err_res:
 	kfree(priv);
 err_priv:
-- 
1.7.3.1


