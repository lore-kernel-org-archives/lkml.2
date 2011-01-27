Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab1A0DOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 22:14:52 -0500
Received: from smtp-out.google.com ([216.239.44.51]:8228 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab1A0DOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 22:14:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=XiF3lGoaVMNoxIN1OJ13gUVK1EdqeEMQadZr9M6gOFApzVu4ZqOC0z11v0TcTm9wy9
         J0GwiHmmmb3im/5car5w==
Date: Wed, 26 Jan 2011 19:14:42 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>, Adam Belay <abelay@mit.edu>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 1/4] pnp: only assign IORESOURCE_DMA if CONFIG_ISA_DMA_API
 is enabled
Message-ID: <alpine.DEB.2.00.1101261912200.7809@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IORESOURCE_DMA cannot be assigned without utilizing the interface
provided by CONFIG_ISA_DMA_API, specifically request_dma() and
free_dma().  Thus, there's a strict dependency on the config option and
limits IORESOURCE_DMA only to architectures that support ISA-style DMA.

ia64 is not one of those architectures, so pnp_check_dma() no longer
needs to be special-cased for that architecture.

pnp_assign_resources() will now return -EINVAL if IORESOURCE_DMA is
attempted on such a kernel.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/pnp/base.h     |    2 ++
 drivers/pnp/manager.c  |    7 ++++++-
 drivers/pnp/resource.c |    7 ++-----
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/pnp/base.h b/drivers/pnp/base.h
--- a/drivers/pnp/base.h
+++ b/drivers/pnp/base.h
@@ -142,7 +142,9 @@ void __pnp_remove_device(struct pnp_dev *dev);
 int pnp_check_port(struct pnp_dev *dev, struct resource *res);
 int pnp_check_mem(struct pnp_dev *dev, struct resource *res);
 int pnp_check_irq(struct pnp_dev *dev, struct resource *res);
+#ifdef CONFIG_ISA_DMA_API
 int pnp_check_dma(struct pnp_dev *dev, struct resource *res);
+#endif
 
 char *pnp_resource_type_name(struct resource *res);
 void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc);
diff --git a/drivers/pnp/manager.c b/drivers/pnp/manager.c
--- a/drivers/pnp/manager.c
+++ b/drivers/pnp/manager.c
@@ -171,6 +171,7 @@ __add:
 	return 0;
 }
 
+#ifdef CONFIG_ISA_DMA_API
 static int pnp_assign_dma(struct pnp_dev *dev, struct pnp_dma *rule, int idx)
 {
 	struct resource *res, local_res;
@@ -210,6 +211,7 @@ __add:
 	pnp_add_dma_resource(dev, res->start, res->flags);
 	return 0;
 }
+#endif /* CONFIG_ISA_DMA_API */
 
 void pnp_init_resources(struct pnp_dev *dev)
 {
@@ -234,7 +236,8 @@ static void pnp_clean_resource_table(struct pnp_dev *dev)
 static int pnp_assign_resources(struct pnp_dev *dev, int set)
 {
 	struct pnp_option *option;
-	int nport = 0, nmem = 0, nirq = 0, ndma = 0;
+	int nport = 0, nmem = 0, nirq = 0;
+	int ndma __maybe_unused = 0;
 	int ret = 0;
 
 	pnp_dbg(&dev->dev, "pnp_assign_resources, try dependent set %d\n", set);
@@ -256,9 +259,11 @@ static int pnp_assign_resources(struct pnp_dev *dev, int set)
 		case IORESOURCE_IRQ:
 			ret = pnp_assign_irq(dev, &option->u.irq, nirq++);
 			break;
+#ifdef CONFIG_ISA_DMA_API
 		case IORESOURCE_DMA:
 			ret = pnp_assign_dma(dev, &option->u.dma, ndma++);
 			break;
+#endif
 		default:
 			ret = -EINVAL;
 			break;
diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
--- a/drivers/pnp/resource.c
+++ b/drivers/pnp/resource.c
@@ -409,9 +409,9 @@ int pnp_check_irq(struct pnp_dev *dev, struct resource *res)
 	return 1;
 }
 
+#ifdef CONFIG_ISA_DMA_API
 int pnp_check_dma(struct pnp_dev *dev, struct resource *res)
 {
-#ifndef CONFIG_IA64
 	int i;
 	struct pnp_dev *tdev;
 	struct resource *tres;
@@ -466,11 +466,8 @@ int pnp_check_dma(struct pnp_dev *dev, struct resource *res)
 	}
 
 	return 1;
-#else
-	/* IA64 does not have legacy DMA */
-	return 0;
-#endif
 }
+#endif /* CONFIG_ISA_DMA_API */
 
 unsigned long pnp_resource_type(struct resource *res)
 {
