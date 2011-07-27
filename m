Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab1G0DPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 23:15:18 -0400
Received: from nm4-vm0.bullet.mail.ne1.yahoo.com ([98.138.90.253]:44603 "HELO
	nm4-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752347Ab1G0DPQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 23:15:16 -0400
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jul 2011 23:15:16 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 120697.55989.bm@omp1058.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=UfhAtLE2ZkD2qR8c7S+JmMdDAAOK6eldCtx3hq0/ne0UfhUUt/eyO8IR0hTHxrbkLyTRkmFEpQ2q/W1SOoARSNdGulyrPOfPPvqc7PXK094G6b+71fK9KRuih9G0Gfpz4sOpfkQjey7gxwbkfaMXOdvyvaUiMO9+3sJF+VwuA4E=;
X-YMail-OSG: vihf76UVM1mrZHDUMh4AQM2oiW5L_ThfAX4DtWreDxWP.4x
 n3FFaYKYcWZN13eMSb1wQ7SRxvrflXNDZrvLvLwB1diC9NMj3eTLz2TSjoRF
 cYf.uGpiNwt2mPZrtLMpgeJGZk6eZD38x4mZlnNCfyAJDyKyoxks6UJocXLd
 ZQAa3RafagSnEQTS0Dgh4GmdhQ.CWpVrfeod3DR5wEmGlpYLYGhDBEWyDoyK
 Lhox8TGCUHDWSoIcazPwrnnQSaUM6y1ObAVJryGdZ077qQmfBUGp6e3PWafP
 mXz9d9gR_jqIYivDpXZGnMjgET6wuAd.P6iTa.OelLl1Hk43Q_HY_l0fjgH7
 EyOoBnpYYfQJlmlQnKy6LDzqCe2g4c4.OjADpblC_Y2k0R_Eod7dDdwjhmnG
 VekPpqVWCIVtR
X-Mailer: YahooMailWebService/0.8.113.313619
Message-ID: <1311736140.88961.YahooMailNeo@web31805.mail.mud.yahoo.com>
Date: Tue, 26 Jul 2011 20:09:00 -0700 (PDT)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: Luben Tuikov <ltuikov@yahoo.com>
Subject: [PATCH] [SCSI] libsas: remove expander from dev list on error
To: James Bottomley <James.Bottomley@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If expander discovery fails (sas_discover_expander()),
remove the expander from the port device list
(sas_ex_discover_expander()), before freeing it. Else
the list is corrupted and, e.g., when we attempt to send
SMP commands to other devices, the kernel oopses.

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
---
 drivers/scsi/libsas/sas_expander.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 874e29d..f84084b 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -849,6 +849,9 @@ static struct domain_device *sas_ex_discover_expander(
 
     res = sas_discover_expander(child);
     if (res) {
+        spin_lock_irq(&parent->port->dev_list_lock);
+        list_del(&child->dev_list_node);
+        spin_unlock_irq(&parent->port->dev_list_lock);
         kfree(child);
         return NULL;
     }
-- 
1.7.2.2.165.gbc382
