Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab2JNOww (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:52:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46661 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932277Ab2JNOnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:49 -0400
Message-Id: <20121014143540.784377689@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:24 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 051/147] [SCSI] ibmvscsi: Fix host config length field overflow
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 225c56960fcafeccc2b6304f96cd3f0dbf42a16a upstream.

The length field in the host config packet is only 16-bit long, so
passing it 0x10000 (64K which is our standard PAGE_SIZE) doesn't
work and result in an empty config from the server.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Robert Jennings <rcj@linux.vnet.ibm.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index a846217..ef9a54c 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1851,6 +1851,9 @@ static int ibmvscsi_do_host_config(struct ibmvscsi_host_data *hostdata,
 
 	host_config = &evt_struct->iu.mad.host_config;
 
+	/* The transport length field is only 16-bit */
+	length = min(0xffff, length);
+
 	/* Set up a lun reset SRP command */
 	memset(host_config, 0x00, sizeof(*host_config));
 	host_config->common.type = VIOSRP_HOST_CONFIG_TYPE;


