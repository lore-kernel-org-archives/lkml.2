Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab2KENDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:03:24 -0500
Received: from service87.mimecast.com ([91.220.42.44]:60386 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab2KENDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:03:23 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: Lee Jones <lee.jones@linaro.org>, Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH] virtio-mmio: Fix irq parsing in command line parameter
Date: Mon,  5 Nov 2012 13:02:52 +0000
Message-Id: <1352120572-16256-1-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1352120454.10947.5.camel@hornet>
References: <1352120454.10947.5.camel@hornet>
X-OriginalArrivalTime: 05 Nov 2012 13:03:21.0760 (UTC) FILETIME=[EEDBAA00:01CDBB55]
X-MC-Unique: 112110513032104201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id qA5D3R8u007974

On 64-bit machines resource_size_t is a 64-bit value, while
sscanf() format for this argument was defined as "%u". Fixed
by using an intermediate local value of a known length.

Also added cleaned up the resource creation and adde extra
comments to make the parameters parsing easier to follow.

Reported-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 drivers/virtio/virtio_mmio.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 6b1b7e1..0d08843 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -521,25 +521,35 @@ static int vm_cmdline_set(const char *device,
 	int err;
 	struct resource resources[2] = {};
 	char *str;
-	long long int base;
+	long long int base, size;
+	unsigned int irq;
 	int processed, consumed = 0;
 	struct platform_device *pdev;
 
-	resources[0].flags = IORESOURCE_MEM;
-	resources[1].flags = IORESOURCE_IRQ;
-
-	resources[0].end = memparse(device, &str) - 1;
+	/* Get "size" part of the command line parameter */
+	size = memparse(device, &str) - 1;
 
+	/* Get "@<base>:<irq>[:<id>]" chunks */
 	processed = sscanf(str, "@%lli:%u%n:%d%n",
-			&base, &resources[1].start, &consumed,
+			&base, &irq, &consumed,
 			&vm_cmdline_id, &consumed);
 
+	/*
+	 * sscanf() processes 3 chunks if "<id>" is given, 2 if not;
+	 * also there must be no extra characters after the last
+	 * chunk, so str[consumed] should be '\0'
+	 */
 	if (processed < 2 || processed > 3 || str[consumed])
 		return -EINVAL;
 
+	/* Memory resource */
+	resources[0].flags = IORESOURCE_MEM;
 	resources[0].start = base;
-	resources[0].end += base;
-	resources[1].end = resources[1].start;
+	resources[0].end = base + size;
+
+	/* Interrupt resource */
+	resources[1].flags = IORESOURCE_IRQ;
+	resources[1].start = resources[1].end = irq;
 
 	if (!vm_cmdline_parent_registered) {
 		err = device_register(&vm_cmdline_parent);
-- 
1.7.10.4


