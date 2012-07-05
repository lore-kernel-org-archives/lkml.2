Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab2GEJk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 05:40:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47074 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415Ab2GEJkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 05:40:55 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH v2 1/2] ata: support MODE SENSE request for changeable and default parameters
Date: Thu,  5 Jul 2012 11:40:34 +0200
Message-Id: <1341481235-12708-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1341481235-12708-1-git-send-email-pbonzini@redhat.com>
References: <1341481235-12708-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the next patch will introduce support for MODE SELECT, it
makes sense to start advertising which bits are actually changeable.
For now, the answer is none.

Default parameters can also be reported, they are simply the same
as the current parameters.

Cc: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/ata/libata-scsi.c |   59 ++++++++++++++++++++++++++++++++------------
 1 files changed, 43 insertions(+), 16 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 41cde45..d5aeb26 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2206,9 +2206,33 @@ static unsigned int ata_scsiop_noop(struct ata_scsi_args *args, u8 *rbuf)
 }
 
 /**
+ *	modecpy - Prepare response for MODE SENSE
+ *	@dest: output buffer
+ *	@src: data being copied
+ *	@n: length of mode page
+ *	@changeable: whether changeable parameters are requested
+ *
+ *	Generate a generic MODE SENSE page for either current or changeable
+ *	parameters.
+ *
+ *	LOCKING:
+ *	None.
+ */
+static void modecpy(u8 *dest, const u8 *src, int n, bool changeable)
+{
+	if (changeable) {
+		memcpy(dest, src, 2);
+		memset(dest + 2, 0, n - 2);
+	} else {
+		memcpy(dest, src, n);
+	}
+}
+
+/**
  *	ata_msense_caching - Simulate MODE SENSE caching info page
  *	@id: device IDENTIFY data
  *	@buf: output buffer
+ *	@changeable: whether changeable parameters are requested
  *
  *	Generate a caching info page, which conditionally indicates
  *	write caching to the SCSI layer, depending on device
@@ -2217,12 +2241,12 @@ static unsigned int ata_scsiop_noop(struct ata_scsi_args *args, u8 *rbuf)
  *	LOCKING:
  *	None.
  */
-static unsigned int ata_msense_caching(u16 *id, u8 *buf)
+static unsigned int ata_msense_caching(u16 *id, u8 *buf, bool changeable)
 {
-	memcpy(buf, def_cache_mpage, sizeof(def_cache_mpage));
-	if (ata_id_wcache_enabled(id))
+	modecpy(buf, def_cache_mpage, sizeof(def_cache_mpage), changeable);
+	if (!changeable && ata_id_wcache_enabled(id))
 		buf[2] |= (1 << 2);	/* write cache enable */
-	if (!ata_id_rahead_enabled(id))
+	if (!changeable && !ata_id_rahead_enabled(id))
 		buf[12] |= (1 << 5);	/* disable read ahead */
 	return sizeof(def_cache_mpage);
 }
@@ -2230,30 +2254,33 @@ static unsigned int ata_msense_caching(u16 *id, u8 *buf)
 /**
  *	ata_msense_ctl_mode - Simulate MODE SENSE control mode page
  *	@buf: output buffer
+ *	@changeable: whether changeable parameters are requested
  *
  *	Generate a generic MODE SENSE control mode page.
  *
  *	LOCKING:
  *	None.
  */
-static unsigned int ata_msense_ctl_mode(u8 *buf)
+static unsigned int ata_msense_ctl_mode(u8 *buf, bool changeable)
 {
-	memcpy(buf, def_control_mpage, sizeof(def_control_mpage));
+	modecpy(buf, def_control_mpage, sizeof(def_control_mpage), changeable);
 	return sizeof(def_control_mpage);
 }
 
 /**
  *	ata_msense_rw_recovery - Simulate MODE SENSE r/w error recovery page
  *	@buf: output buffer
+ *	@changeable: whether changeable parameters are requested
  *
  *	Generate a generic MODE SENSE r/w error recovery page.
  *
  *	LOCKING:
  *	None.
  */
-static unsigned int ata_msense_rw_recovery(u8 *buf)
+static unsigned int ata_msense_rw_recovery(u8 *buf, bool changeable)
 {
-	memcpy(buf, def_rw_recovery_mpage, sizeof(def_rw_recovery_mpage));
+	modecpy(buf, def_rw_recovery_mpage, sizeof(def_rw_recovery_mpage),
+		changeable);
 	return sizeof(def_rw_recovery_mpage);
 }
 
@@ -2317,11 +2344,11 @@ static unsigned int ata_scsiop_mode_sense(struct ata_scsi_args *args, u8 *rbuf)
 	page_control = scsicmd[2] >> 6;
 	switch (page_control) {
 	case 0: /* current */
+	case 1: /* changeable */
+	case 2: /* defaults */
 		break;  /* supported */
 	case 3: /* saved */
 		goto saving_not_supp;
-	case 1: /* changeable */
-	case 2: /* defaults */
 	default:
 		goto invalid_fld;
 	}
@@ -2342,21 +2369,21 @@ static unsigned int ata_scsiop_mode_sense(struct ata_scsi_args *args, u8 *rbuf)
 
 	switch(pg) {
 	case RW_RECOVERY_MPAGE:
-		p += ata_msense_rw_recovery(p);
+		p += ata_msense_rw_recovery(p, page_control == 1);
 		break;
 
 	case CACHE_MPAGE:
-		p += ata_msense_caching(args->id, p);
+		p += ata_msense_caching(args->id, p, page_control == 1);
 		break;
 
 	case CONTROL_MPAGE:
-		p += ata_msense_ctl_mode(p);
+		p += ata_msense_ctl_mode(p, page_control == 1);
 		break;
 
 	case ALL_MPAGES:
-		p += ata_msense_rw_recovery(p);
-		p += ata_msense_caching(args->id, p);
-		p += ata_msense_ctl_mode(p);
+		p += ata_msense_rw_recovery(p, page_control == 1);
+		p += ata_msense_caching(args->id, p, page_control == 1);
+		p += ata_msense_ctl_mode(p, page_control == 1);
 		break;
 
 	default:		/* invalid page code */
-- 
1.7.1


