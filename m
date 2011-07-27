Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab1G0GKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 02:10:51 -0400
Received: from nm8.bullet.mail.ac4.yahoo.com ([98.139.52.205]:29991 "HELO
	nm8.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751684Ab1G0GKt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 02:10:49 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 876004.61034.bm@omp1014.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=opUA4gKY3APbav200ey/hR4SybeczAPOjbBZm2iEysX6KRabpqPjO2pmrX9ubcAqEwU9OCDw5g29eTIISrvoLFXVc3UZX7VVt5ZlyG6vJk2O/2vpGD3RicQIKgCpnodU1Bq/uy4WykeTsTNzXvwv31b89DrxlkdbcFk5srZUUB0=;
X-YMail-OSG: IPWGjBIVM1kjaqmrOXGOmBoBlR0nfoiJRHv3j6fQsMZQFWO
 WwRvbAH3AZO0971.zMmU9AZMBhfA80UYFD9oovWxAgOThSeiwYpvRtTInIzW
 uiXZfzWROiNvrwFN3SxMvO8Su.ixkx_L7LKAMF6Pj2P3mFd91WXxbXFo70s6
 JD5HnlNJYpeSpowGPWS2bIuOTnbhRm9CzzIjqP5Cq4lGGFl8pTpbrt0qDbQI
 ytcaJZWZA8ipnWEgqZ03OsjPFQeT1Ole44kvf4MKzd1w7dDf1OZLES4WvNkC
 Yq3fU2dkO6o5U2Yi3S8JMbVRWny9x8OHhUVLxH.bOWJl2xtDO99uXgndF9Fe
 lFwgnCRgbVD2ISuMADqxRuf0.b_kG3cHPQocB33GkvXHtMQ3w5AP7EvyLzkb
 TJVBFKBq6sA24
X-Mailer: YahooMailWebService/0.8.113.313619
Message-ID: <1311747048.72460.YahooMailNeo@web31810.mail.mud.yahoo.com>
Date: Tue, 26 Jul 2011 23:10:48 -0700 (PDT)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: Luben Tuikov <ltuikov@yahoo.com>
Subject: [PATCH] [SCSI] libsas: remove expander from dev list on error
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "JBottomley@Parallels.com" <JBottomley@Parallels.com>,
        Jack Wang <jack_wang@usish.com>
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
Reviewed-by: Jack Wang <jack_wang@usish.com>
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
+               spin_lock_irq(&parent->port->dev_list_lock);
+               list_del(&child->dev_list_node);
+               spin_unlock_irq(&parent->port->dev_list_lock);
                kfree(child);
                return NULL;
        }
-- 
1.7.2.2.165.gbc382
