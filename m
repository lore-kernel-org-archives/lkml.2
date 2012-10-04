Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab2JDWJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 18:09:35 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36877 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933055Ab2JDVS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:18:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 44/56] SCSI: ibmvscsi: Fix host config length field overflow
Date: Thu,  4 Oct 2012 14:16:05 -0700
Message-Id: <20121004211157.134940545@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004211152.101901246@linuxfoundation.org>
References: <20121004211152.101901246@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 225c56960fcafeccc2b6304f96cd3f0dbf42a16a upstream.

The length field in the host config packet is only 16-bit long, so
passing it 0x10000 (64K which is our standard PAGE_SIZE) doesn't
work and result in an empty config from the server.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Robert Jennings <rcj@linux.vnet.ibm.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/ibmvscsi/ibmvscsi.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1541,6 +1541,9 @@ static int ibmvscsi_do_host_config(struc
 
 	host_config = &evt_struct->iu.mad.host_config;
 
+	/* The transport length field is only 16-bit */
+	length = min(0xffff, length);
+
 	/* Set up a lun reset SRP command */
 	memset(host_config, 0x00, sizeof(*host_config));
 	host_config->common.type = VIOSRP_HOST_CONFIG_TYPE;


