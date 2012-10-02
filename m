Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab2JBHmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 03:42:51 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:1512 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752957Ab2JBHmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 03:42:50 -0400
Message-ID: <1349163768.1414.32.camel@x61.thuisdomein>
Subject: [PATCH v2] qla2xxx: silence two GCC warnings
From: Paul Bolle <pebolle@tiscali.nl>
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 02 Oct 2012 09:42:48 +0200
In-Reply-To: <3591681.K68OpP9yPi@eto>
References: <1349003274.15306.6.camel@x61.thuisdomein>
	 <3591681.K68OpP9yPi@eto>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 02 Oct 2012 07:42:48.0440 (UTC) FILETIME=[84DC6F80:01CDA071]
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

An easy way to silence these warnings is to use preprocessor macros
here, as that apparently gives GCC enough information to keep track of
array bounds.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Rolf suggested to not use magic constants, to make sure things keep
working when these strings change in the future. A trivial solution is
to use preprocessor macros. I needed to add one for the manufacturer
string.

1) Still only compile tested.

 drivers/scsi/qla2xxx/qla_def.h | 1 +
 drivers/scsi/qla2xxx/qla_gs.c  | 6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 39007f5..8895038 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -37,6 +37,7 @@
 #include "qla_nx.h"
 #define QLA2XXX_DRIVER_NAME	"qla2xxx"
 #define QLA2XXX_APIDEV		"ql2xapidev"
+#define QLA2XXX_MANUFACTURER	"QLogic Corporation"
 
 /*
  * We have MAILBOX_REGISTER_COUNT sized arrays in a few places,
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 05260d2..1714035 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1325,8 +1325,8 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 	/* Manufacturer. */
 	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
 	eiter->type = __constant_cpu_to_be16(FDMI_HBA_MANUFACTURER);
-	strcpy(eiter->a.manufacturer, "QLogic Corporation");
-	alen = strlen(eiter->a.manufacturer);
+	strcpy(eiter->a.manufacturer, QLA2XXX_MANUFACTURER);
+	alen = strlen(QLA2XXX_MANUFACTURER);
 	alen += (alen & 3) ? (4 - (alen & 3)) : 4;
 	eiter->len = cpu_to_be16(4 + alen);
 	size += 4 + alen;
@@ -1647,7 +1647,7 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *vha)
 	eiter = (struct ct_fdmi_port_attr *) (entries + size);
 	eiter->type = __constant_cpu_to_be16(FDMI_PORT_OS_DEVICE_NAME);
 	strcpy(eiter->a.os_dev_name, QLA2XXX_DRIVER_NAME);
-	alen = strlen(eiter->a.os_dev_name);
+	alen = strlen(QLA2XXX_DRIVER_NAME);
 	alen += (alen & 3) ? (4 - (alen & 3)) : 4;
 	eiter->len = cpu_to_be16(4 + alen);
 	size += 4 + alen;
-- 
1.7.11.4

