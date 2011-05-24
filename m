Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933288Ab1EXXxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 19:53:55 -0400
Received: from smtp-out.google.com ([216.239.44.51]:38534 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933201Ab1EXXxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 19:53:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=hyQdZjO6VkuxCbWU1ziazbvX7Y+N0ZtFCL1Ku4jtZrBxryEQ5RTIpmngdW5SIPc3YS
         GQ10/AehvWPmpGqjNiAg==
Date: Tue, 24 May 2011 16:53:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 2/6] scsi: warn and avoid creating dma caches if DMA support
 is disabled
In-Reply-To: <alpine.DEB.2.00.1105241650230.29780@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1105241650480.29780@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1105241650230.29780@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__GFP_DMA may not be passed to scsi_{get,put}_host_cmd_pool() if
CONFIG_ZONE_DMA is disabled, which is now possible on x86.  If passed,
emit a warning and return.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/scsi/scsi.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -359,6 +359,11 @@ EXPORT_SYMBOL(scsi_put_command);
 static struct scsi_host_cmd_pool *scsi_get_host_cmd_pool(gfp_t gfp_mask)
 {
 	struct scsi_host_cmd_pool *retval = NULL, *pool;
+
+#ifndef CONFIG_ZONE_DMA
+	if (WARN_ON_ONCE(gfp_mask & __GFP_DMA))
+		return NULL;
+#endif
 	/*
 	 * Select a command slab for this host and create it if not
 	 * yet existent.
@@ -393,6 +398,10 @@ static void scsi_put_host_cmd_pool(gfp_t gfp_mask)
 {
 	struct scsi_host_cmd_pool *pool;
 
+#ifndef CONFIG_ZONE_DMA
+        if (WARN_ON_ONCE(gfp_mask & __GFP_DMA))
+                return;
+#endif
 	mutex_lock(&host_cmd_pool_mutex);
 	pool = (gfp_mask & __GFP_DMA) ? &scsi_cmd_dma_pool :
 		&scsi_cmd_pool;
