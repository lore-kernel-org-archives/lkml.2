Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933247Ab1EXXxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 19:53:52 -0400
Received: from smtp-out.google.com ([216.239.44.51]:38466 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab1EXXxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 19:53:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=SMlzuYSqFqc3yTH0bZdXRx2eolrbKgabjdtJlv6XBdWKRKom1ysWRvauvMPMMmjSxq
         pVHKWYD1rhpYFPVZ+/pg==
Date: Tue, 24 May 2011 16:53:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 1/6] s390, block: disable fixed buffer mode when DMA support
 is disabled
Message-ID: <alpine.DEB.2.00.1105241650230.29780@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dasd=fixedbuffers must create a SLAB_CACHE_DMA cache, which is not
possible if CONFIG_ZONE_DMA is disabled (a supported configuration
without 64-bit support).

If passed, emit a warning and disable fixed buffer mode.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/s390/block/dasd_devmap.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/s390/block/dasd_devmap.c b/drivers/s390/block/dasd_devmap.c
--- a/drivers/s390/block/dasd_devmap.c
+++ b/drivers/s390/block/dasd_devmap.c
@@ -282,6 +282,11 @@ dasd_parse_keyword( char *parsestring ) {
 		return residual_str;
 	}
 	if (strncmp("fixedbuffers", parsestring, length) == 0) {
+#ifndef CONFIG_ZONE_DMA
+		DBF_EVENT(DBF_WARNING, "%s", "DMA support disabled, "
+					"fixed buffer mode disabled.");
+		return residual_str;
+#endif
 		if (dasd_page_cache)
 			return residual_str;
 		dasd_page_cache =
