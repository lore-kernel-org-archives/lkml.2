Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760743Ab2BJXJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:09:20 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45193 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932675Ab2BJWnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:43:02 -0500
MIME-Version: 1.0
Message-Id: <20120210222951.441483415@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:30:31 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [patch 72/86] target: Fail INQUIRY commands with EVPD==0 but PAGE CODE!=0
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit bf0053550aebe56f3bb5dd793e9de69238b5b945 upstream.

My draft of SPC-4 says:

    If the PAGE CODE field is not set to zero when the EVPD bit is set
    to zero, the command shall be terminated with CHECK CONDITION
    status, with the sense key set to ILLEGAL REQUEST, and the
    additional sense code set to INVALID FIELD IN CDB.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_cdb.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -701,6 +701,13 @@ int target_emulate_inquiry(struct se_tas
 	int p, ret;
 
 	if (!(cdb[1] & 0x1)) {
+		if (cdb[2]) {
+			pr_err("INQUIRY with EVPD==0 but PAGE CODE=%02x\n",
+			       cdb[2]);
+			cmd->scsi_sense_reason = TCM_INVALID_CDB_FIELD;
+			return -EINVAL;
+		}
+
 		ret = target_emulate_inquiry_std(cmd);
 		goto out;
 	}


