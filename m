Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811Ab1GFHlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 03:41:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52427 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab1GFHlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 03:41:31 -0400
Date: Wed, 6 Jul 2011 10:40:24 +0300
From: Dan Carpenter <error27@gmail.com>
To: Jing Huang <huangj@brocade.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        "open list:BROCADE BFA FC SC..." <linux-scsi@vger.kernel.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 2/2] [SCSI] bfa: test is always false in bfa_sfp_media_get()
Message-ID: <20110706074024.GE18655@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

e10g.r.e10g_unall is only 1 bit so "if (e10g.r.e10g_unall & 0x80)"
is always false.  e10g is a union between an unsigned char and named
bitfields.  The intent here was to test the named bitfield by
itself.

We can change the previous tests as well.  That improves the
readability and it looks like it fixes a endian bug as well.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
I don't understand where __BIGENDIAN is defined.  Only this driver
references it.  How does that work?

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 052373b..090a19d 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -3589,11 +3589,11 @@ bfa_sfp_media_get(struct bfa_sfp_s *sfp)
 			 (xmtr_tech & SFP_XMTR_TECH_SA))
 			*media = BFA_SFP_MEDIA_SW;
 		/* Check 10G Ethernet Compilance code */
-		else if (e10g.b & 0x10)
+		else if (e10g.r.e10g_sr)
 			*media = BFA_SFP_MEDIA_SW;
-		else if (e10g.b & 0x60)
+		else if (e10g.r.e10g_lr && e10g.r.e10g_lrm)
 			*media = BFA_SFP_MEDIA_LW;
-		else if (e10g.r.e10g_unall & 0x80)
+		else if (e10g.r.e10g_unall)
 			*media = BFA_SFP_MEDIA_UNKNOWN;
 		else
 			bfa_trc(sfp, 0);
