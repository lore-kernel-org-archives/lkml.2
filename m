Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205Ab2I3LID (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 07:08:03 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:4525 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750786Ab2I3LIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 07:08:00 -0400
Message-ID: <1349003274.15306.6.camel@x61.thuisdomein>
Subject: [PATCH] qla2xxx: silence two GCC warnings
From: Paul Bolle <pebolle@tiscali.nl>
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 30 Sep 2012 13:07:54 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 30 Sep 2012 11:07:54.0661 (UTC) FILETIME=[D71D3D50:01CD9EFB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiling qla_gs.o (part of the qla2xxx module) triggers two GCC
warnings:
    drivers/scsi/qla2xxx/qla_gs.c: In function ‘qla2x00_fdmi_rhba’:
    drivers/scsi/qla2xxx/qla_gs.c:1339:7: warning: array subscript is above array bounds [-Warray-bounds]
    drivers/scsi/qla2xxx/qla_gs.c: In function ‘qla2x00_fdmi_register’:
    drivers/scsi/qla2xxx/qla_gs.c:1663:15: warning: array subscript is above array bounds [-Warray-bounds]

It seems that the sequence of a strcpy followed by a strlen confuses GCC
when it is keeping track of array bounds here. (It is not clear to me
which array triggers this warning and by how much GCC thinks the
subscript is above its bounds. Neither is it clear to me why comparable
code in these two functions doesn't trigger this warning.)

The easiest way to silence these warnings is to hardcode the length of
these two strings in the code here. The length used here is the length
of the string, including its NUL terminator, rounded up to the next
multiple of four.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) I noticed this warning while building v3.6-rc7 on current Fedora
17, using Fedora's default config.

1) Compile tested only. 

 drivers/scsi/qla2xxx/qla_gs.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 05260d2..a3ef5d0 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1326,10 +1326,8 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
 	eiter->type = __constant_cpu_to_be16(FDMI_HBA_MANUFACTURER);
 	strcpy(eiter->a.manufacturer, "QLogic Corporation");
-	alen = strlen(eiter->a.manufacturer);
-	alen += (alen & 3) ? (4 - (alen & 3)) : 4;
-	eiter->len = cpu_to_be16(4 + alen);
-	size += 4 + alen;
+	eiter->len = cpu_to_be16(4 + 20);
+	size += 4 + 20;
 
 	ql_dbg(ql_dbg_disc, vha, 0x2026,
 	    "Manufacturer = %s.\n", eiter->a.manufacturer);
@@ -1647,10 +1645,8 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *vha)
 	eiter = (struct ct_fdmi_port_attr *) (entries + size);
 	eiter->type = __constant_cpu_to_be16(FDMI_PORT_OS_DEVICE_NAME);
 	strcpy(eiter->a.os_dev_name, QLA2XXX_DRIVER_NAME);
-	alen = strlen(eiter->a.os_dev_name);
-	alen += (alen & 3) ? (4 - (alen & 3)) : 4;
-	eiter->len = cpu_to_be16(4 + alen);
-	size += 4 + alen;
+	eiter->len = cpu_to_be16(4 + 8);
+	size += 4 + 8;
 
 	ql_dbg(ql_dbg_disc, vha, 0x204b,
 	    "OS_Device_Name=%s.\n", eiter->a.os_dev_name);
-- 
1.7.11.4

