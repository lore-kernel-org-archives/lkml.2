Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab2HOWQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 18:16:36 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:27888 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab2HOWQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 18:16:34 -0400
Date: Thu, 16 Aug 2012 00:16:33 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Kent Yoder <key@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        Sirrix AG <tpmdd@sirrix.com>, Marcel Selhorst <tpmdd@selhorst.net>,
        Rajiv Andrade <mail@srajiv.net>, Seiji Munetoh <munetoh@jp.ibm.com>,
        Stefan Berger <stefanb@us.ibm.com>,
        Reiner Sailer <sailer@watson.ibm.com>, Kylene Hall <kjhall@us.ibm.com>
Subject: [PATCH] tpm: Do not dereference NULL pointer if acpi_os_map_memory()
 fails.
In-Reply-To: <alpine.LNX.2.00.1208160001080.7818@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1208160011160.7818@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1208072247490.3227@swampdragon.chaosbits.net> <20120808180750.GA24016@linux.vnet.ibm.com> <20120815201527.GC27618@linux.vnet.ibm.com> <alpine.LNX.2.00.1208160001080.7818@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/char/tpm/tpm_acpi.c::read_log() we call
acpi_os_map_memory(). That call may fail for a number of reasons
(invalid address, out of memory etc). If the call fails it returns
NULL and we just pass that to memcpy() unconditionally, which will go
bad when it tries to dereference the pointer.

Unfortunately we just get NULL back, so we can't really tell the user
exactely what went wrong, but we can at least avoid crashing and
return an error (-EIO seemed more generic and more suitable here than
-ENOMEM or something else, so I picked that).

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/char/tpm/tpm_acpi.c | 5 +++++
 1 file changed, 5 insertions(+)

 note: this patch is against git://github.com/shpedoikal/linux.git v3.6-rc1-tpmdd-staging

diff --git a/drivers/char/tpm/tpm_acpi.c b/drivers/char/tpm/tpm_acpi.c
index a1bb5a18..fe3fa94 100644
--- a/drivers/char/tpm/tpm_acpi.c
+++ b/drivers/char/tpm/tpm_acpi.c
@@ -96,6 +96,11 @@ int read_log(struct tpm_bios_log *log)
 	log->bios_event_log_end = log->bios_event_log + len;
 
 	virt = acpi_os_map_memory(start, len);
+	if (!virt) {
+		kfree(log->bios_event_log);
+		printk("%s: ERROR - Unable to map memory\n", __func__);
+		return -EIO;
+	}
 
 	memcpy(log->bios_event_log, virt, len);
 
-- 
1.7.11.4


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

