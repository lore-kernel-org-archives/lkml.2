Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab1C0AFO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 20:05:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51384 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab1C0AFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 20:05:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=prv96BkUNuVB8gOILES6BIxBuG3vsLK2Ig7nkdZQq0RqU5/RFZ37UlpANbM6KmRMv/
         83AddG+iT/4iRoLfteuAGgosGvyqrcuavQeEabcyf2EqfVRQ6F+VjwgMw8duKEOK06dB
         lm7Q9HwEKgAakNpguLYwKNUWkIAOK9cnF3SnA=
From: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
To: linux-serial@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, stable@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tty/n_gsm: fix bug in CRC calculation for gsm1 mode
Date: Sun, 27 Mar 2011 04:05:00 +0400
Message-Id: <1301184300-9158-1-git-send-email-mikhail.kshevetskiy@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Problem description:
  gsm_queue() calculate a CRC for arrived frames. As a last step of
  CRC calculation it call

    gsm->fcs = gsm_fcs_add(gsm->fcs, gsm->received_fcs);

  This work perfectly for the case of GSM0 mode as gsm->received_fcs
  contain the last piece of data required to generate final CRC.

  gsm->received_fcs is not used for GSM1 mode. Thus we put an
  additional byte to CRC calculation. As result we get a wrong CRC
  and reject incoming frame.

Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
---
 drivers/tty/n_gsm.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 176f632..4806276 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1658,8 +1658,12 @@ static void gsm_queue(struct gsm_mux *gsm)
 
 	if ((gsm->control & ~PF) == UI)
 		gsm->fcs = gsm_fcs_add_block(gsm->fcs, gsm->buf, gsm->len);
-	/* generate final CRC with received FCS */
-	gsm->fcs = gsm_fcs_add(gsm->fcs, gsm->received_fcs);
+	if (gsm->encoding == 0){
+		/* WARNING: gsm->received_fcs is used for gsm->encoding = 0 only.
+		            In this case it contain the last piece of data
+		            required to generate final CRC */
+		gsm->fcs = gsm_fcs_add(gsm->fcs, gsm->received_fcs);
+	}
 	if (gsm->fcs != GOOD_FCS) {
 		gsm->bad_fcs++;
 		if (debug & 4)
-- 
1.7.4.1

