Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509Ab2JDRmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 13:42:54 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:36686
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932279Ab2JDRmw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 13:42:52 -0400
X-Forefront-Antispam-Report: CIP:198.70.193.64;KIP:(null);UIP:(null);IPV:NLI;H:avexcashub1.qlogic.com;RD:avexcashub2.qlogic.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz1432I4015Izz1202h1d1ah1d2ahzz17326ah8275dhz2fh2a8h668h839h946he5bhf0ah107ah1288h12a5h12a9h12bdh137ah13b6h1441h1155h)
From: Saurav Kashyap <saurav.kashyap@qlogic.com>
To: Paul Bolle <pebolle@tiscali.nl>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        Dept-Eng Linux Driver <Linux-Driver@qlogic.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 4 Oct 2012 12:42:42 -0500
Subject: Re: [PATCH v2] qla2xxx: silence two GCC warnings
Thread-Topic: [PATCH v2] qla2xxx: silence two GCC warnings
Thread-Index: Ac2iV6i1HCv8kzYnRUiX5ptpWzD3FA==
Message-ID: <CC93C7DD.EB60%saurav.kashyap@qlogic.com>
In-Reply-To: <1349163768.1414.32.camel@x61.thuisdomein>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.10.0.110310
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: qlogic.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





>Compiling qla_gs.o (part of the qla2xxx module) triggers two GCC
>warnings:
>    drivers/scsi/qla2xxx/qla_gs.c: In function Œqla2x00_fdmi_rhba¹:
>    drivers/scsi/qla2xxx/qla_gs.c:1339:7: warning: array subscript is
>above array bounds [-Warray-bounds]
>    drivers/scsi/qla2xxx/qla_gs.c: In function Œqla2x00_fdmi_register¹:
>    drivers/scsi/qla2xxx/qla_gs.c:1663:15: warning: array subscript is
>above array bounds [-Warray-bounds]
>
>It seems that the sequence of a strcpy followed by a strlen confuses GCC
>when it is keeping track of array bounds here. (It is not clear to me
>which array triggers this warning and by how much GCC thinks the
>subscript is above its bounds. Neither is it clear to me why comparable
>code in these two functions doesn't trigger this warning.)
>
>An easy way to silence these warnings is to use preprocessor macros
>here, as that apparently gives GCC enough information to keep track of
>array bounds.
>
>Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
>---
>0) Rolf suggested to not use magic constants, to make sure things keep
>working when these strings change in the future. A trivial solution is
>to use preprocessor macros. I needed to add one for the manufacturer
>string.
>
>1) Still only compile tested.
>
> drivers/scsi/qla2xxx/qla_def.h | 1 +
> drivers/scsi/qla2xxx/qla_gs.c  | 6 +++---
> 2 files changed, 4 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/scsi/qla2xxx/qla_def.h
>b/drivers/scsi/qla2xxx/qla_def.h
>index 39007f5..8895038 100644
>--- a/drivers/scsi/qla2xxx/qla_def.h
>+++ b/drivers/scsi/qla2xxx/qla_def.h
>@@ -37,6 +37,7 @@
> #include "qla_nx.h"
> #define QLA2XXX_DRIVER_NAME   "qla2xxx"
> #define QLA2XXX_APIDEV                "ql2xapidev"
>+#define QLA2XXX_MANUFACTURER  "QLogic Corporation"
>
> /*
>  * We have MAILBOX_REGISTER_COUNT sized arrays in a few places,
>diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
>index 05260d2..1714035 100644
>--- a/drivers/scsi/qla2xxx/qla_gs.c
>+++ b/drivers/scsi/qla2xxx/qla_gs.c
>@@ -1325,8 +1325,8 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
>       /* Manufacturer. */
>       eiter = (struct ct_fdmi_hba_attr *) (entries + size);
>       eiter->type = __constant_cpu_to_be16(FDMI_HBA_MANUFACTURER);
>-      strcpy(eiter->a.manufacturer, "QLogic Corporation");
>-      alen = strlen(eiter->a.manufacturer);
>+      strcpy(eiter->a.manufacturer, QLA2XXX_MANUFACTURER);
>+      alen = strlen(QLA2XXX_MANUFACTURER);

Hi Paul,
It looks fine except one small thing. Instead of strcpy, strncpy will be
better option something like this

+       alen = strlen(QLA2XXX_MANUFACTURER);
+       strncpy(eiter->a.manufacturer, QLA2XXX_MANUFACTURER, alen);

Thanks,
~Saurav


>       alen += (alen & 3) ? (4 - (alen & 3)) : 4;
>       eiter->len = cpu_to_be16(4 + alen);
>       size += 4 + alen;
>@@ -1647,7 +1647,7 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *vha)
>       eiter = (struct ct_fdmi_port_attr *) (entries + size);
>       eiter->type = __constant_cpu_to_be16(FDMI_PORT_OS_DEVICE_NAME);
>       strcpy(eiter->a.os_dev_name, QLA2XXX_DRIVER_NAME);
>-      alen = strlen(eiter->a.os_dev_name);
>+      alen = strlen(QLA2XXX_DRIVER_NAME);
>       alen += (alen & 3) ? (4 - (alen & 3)) : 4;
>       eiter->len = cpu_to_be16(4 + alen);
>       size += 4 + alen;
>--
>1.7.11.4
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

