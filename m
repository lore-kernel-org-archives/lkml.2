Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab2G0JCs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 05:02:48 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:47685
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752235Ab2G0JCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 05:02:16 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M7TAFL-02-6OC-02
X-M-MSG: 
From: Aaron Lu <aaron.lu@amd.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jeff Garzik <jgarzik@pobox.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Oliver Neukum <oneukum@suse.de>
CC: Jeff Wu <jeff.wu@amd.com>, Lin Ming <minggr@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@amd.com>
Subject: [PATCH v4 1/7] scsi: sr: check support for device busy class events
Date: Fri, 27 Jul 2012 17:00:44 +0800
Message-ID: <1343379650-2867-2-git-send-email-aaron.lu@amd.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1343379650-2867-1-git-send-email-aaron.lu@amd.com>
References: <1343379650-2867-1-git-send-email-aaron.lu@amd.com>
X-OriginalArrivalTime: 27 Jul 2012 09:01:59.0220 (UTC) FILETIME=[7ADEAF40:01CD6BD6]
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Aaron Lu <aaron.lu@amd.com>
---
 drivers/scsi/sr.c     | 23 +++++++++++++++++++++++
 drivers/scsi/sr.h     |  1 +
 include/linux/cdrom.h | 43 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 67 insertions(+)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 5fc97d2..abfefab 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -101,6 +101,7 @@ static DEFINE_MUTEX(sr_ref_mutex);
 static int sr_open(struct cdrom_device_info *, int);
 static void sr_release(struct cdrom_device_info *);
 
+static void check_dbml(struct scsi_cd *);
 static void get_sectorsize(struct scsi_cd *);
 static void get_capabilities(struct scsi_cd *);
 
@@ -728,6 +729,28 @@ fail:
 	return error;
 }
 
+static void check_dbml(struct scsi_cd *cd)
+{
+	struct packet_command cgc;
+	unsigned char buffer[16];
+	struct rm_feature_desc *rfd;
+
+	init_cdrom_command(&cgc, buffer, sizeof(buffer), CGC_DATA_READ);
+	cgc.cmd[0] = GPCMD_GET_CONFIGURATION;
+	cgc.cmd[3] = CDF_RM;
+	cgc.cmd[8] = sizeof(buffer);
+	cgc.quiet = 1;
+
+	if (cd->cdi.ops->generic_packet(&cd->cdi, &cgc))
+		return;
+
+	rfd = (struct rm_feature_desc *)&buffer[sizeof(struct feature_header)];
+	if (be16_to_cpu(rfd->feature_code) != CDF_RM)
+		return;
+
+	if (rfd->dbml)
+		cd->dbml = 1;
+}
 
 static void get_sectorsize(struct scsi_cd *cd)
 {
diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
index 37c8f6b..7cc40ad 100644
--- a/drivers/scsi/sr.h
+++ b/drivers/scsi/sr.h
@@ -41,6 +41,7 @@ typedef struct scsi_cd {
 	unsigned readcd_known:1;	/* drive supports READ_CD (0xbe) */
 	unsigned readcd_cdda:1;	/* reading audio data using READ_CD */
 	unsigned media_present:1;	/* media is present */
+	unsigned dbml:1;	/* generates device busy class events */
 
 	/* GET_EVENT spurious event handling, blk layer guarantees exclusion */
 	int tur_mismatch;		/* nr of get_event TUR mismatches */
diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
index dfd7f18..962be39 100644
--- a/include/linux/cdrom.h
+++ b/include/linux/cdrom.h
@@ -727,6 +727,7 @@ struct request_sense {
 /*
  * feature profile
  */
+#define CDF_RM		0x0003	/* "Removable Medium" */
 #define CDF_RWRT	0x0020	/* "Random Writable" */
 #define CDF_HWDM	0x0024	/* "Hardware Defect Management" */
 #define CDF_MRW 	0x0028
@@ -739,6 +740,48 @@ struct request_sense {
 #define CDM_MRW_BGFORMAT_ACTIVE		2
 #define CDM_MRW_BGFORMAT_COMPLETE	3
 
+/* Removable medium feature descriptor */
+struct rm_feature_desc {
+	__be16 feature_code;
+#if defined(__BIG_ENDIAN_BITFIELD)
+	__u8 reserved1		: 2;
+	__u8 feature_version	: 4;
+	__u8 persistent		: 1;
+	__u8 curr		: 1;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+	__u8 curr		: 1;
+	__u8 persistent		: 1;
+	__u8 feature_version	: 4;
+	__u8 reserved1		: 2;
+#endif
+	__u8 add_len;
+#if defined(__BIG_ENDIAN_BITFIELD)
+	__u8 mech_type		: 3;
+	__u8 load		: 1;
+	__u8 eject		: 1;
+	__u8 pvnt_jmpr		: 1;
+	__u8 dbml		: 1;
+	__u8 lock		: 1;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+	__u8 lock		: 1;
+	__u8 dbml		: 1;
+	__u8 pvnt_jmpr		: 1;
+	__u8 eject		: 1;
+	__u8 load		: 1;
+	__u8 mech_type		: 3;
+#endif
+	__u8 reserved2;
+	__u8 reserved3;
+	__u8 reserved4;
+};
+
+struct device_busy_event_desc {
+	__u8 device_busy_event	: 4;
+	__u8 reserved1		: 4;
+	__u8 device_busy_status;
+	__u8 time;
+};
+
 /*
  * mrw address spaces
  */
-- 
1.7.11.3


