Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab1IVQ42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 12:56:28 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:39905 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751370Ab1IVQ4Z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 12:56:25 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [RESEND] [PATCH] [SCSI] libsas: Allow expander T-T attachments
Date: Thu, 22 Sep 2011 09:55:39 -0700
Message-ID: <FC1F9E38C0703341A1A750524E2525A9018AE2EB@XYUS-EX22.xyus.xyratex.com>
In-Reply-To: <1316709696.61028.YahooMailNeo@web31812.mail.mud.yahoo.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RESEND] [PATCH] [SCSI] libsas: Allow expander T-T attachments
Thread-Index: Acx5R2d9nLiZ8fsjSAKrbbIydYg8nwAAJAJA
References: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com> <1316691000.10571.6.camel@dabdike> <1316709696.61028.YahooMailNeo@web31812.mail.mud.yahoo.com>
From: "Mark Salyzyn" <mark_salyzyn@us.xyratex.com>
To: "Luben Tuikov" <ltuikov@yahoo.com>,
        "James Bottomley" <jbottomley@parallels.com>
Cc: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Except for the fact the patch as located in the attachment is still not in compliance, the patch works for me.

Sincerely -- Mark Salyzyn
 
> scsi-misc-2.6/scripts/checkpatch.pl 0001-SCSI-libsas-Allow-expander-T-T-attachments.patch
WARNING: line over 80 characters
#57: FILE: drivers/scsi/libsas/sas_expander.c:1245:
+                               if (child_phy->routing_attr == SUBTRACTIVE_ROUTING ||

WARNING: line over 80 characters
#59: FILE: drivers/scsi/libsas/sas_expander.c:1247:
+                                    child_ex->t2t_supp && parent_ex->t2t_supp)) {

WARNING: line over 80 characters
#62: FILE: drivers/scsi/libsas/sas_expander.c:1250:
+                                       sas_print_parent_topology_bug(child, parent_phy, child_phy);

total: 0 errors, 3 warnings, 82 lines checked

0001-SCSI-libsas-Allow-expander-T-T-attachments.patch has style problems, please
 review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Luben Tuikov
Sent: Thursday, September 22, 2011 12:42 PM
To: James Bottomley
Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: [RESEND] [PATCH] [SCSI] libsas: Allow expander T-T attachments

Allow expander table-to-table attachments for
expanders that support it.

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
---
 drivers/scsi/libsas/sas_expander.c |   20 ++++++++++++++------
 include/scsi/libsas.h              |    3 +++
 include/scsi/sas.h                 |   14 ++++++++++++--
 3 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index f84084b..e8d0115 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -329,6 +329,7 @@ static void ex_assign_report_general(struct domain_device *dev,
     dev->ex_dev.ex_change_count = be16_to_cpu(rg->change_count);
     dev->ex_dev.max_route_indexes = be16_to_cpu(rg->route_indexes);
     dev->ex_dev.num_phys = min(rg->num_phys, (u8)MAX_EXPANDER_PHYS);
+    dev->ex_dev.t2t_supp = rg->t2t_supp;
     dev->ex_dev.conf_route_table = rg->conf_route_table;
     dev->ex_dev.configuring = rg->configuring;
     memcpy(dev->ex_dev.enclosure_logical_id, rg->enclosure_logical_id, 8);
@@ -1133,15 +1134,17 @@ static void sas_print_parent_topology_bug(struct domain_device *child,
     };
     struct domain_device *parent = child->parent;
 
-    sas_printk("%s ex %016llx phy 0x%x <--> %s ex %016llx phy 0x%x "
-           "has %c:%c routing link!\n",
+    sas_printk("%s ex %016llx (T2T supp:%d) phy 0x%x <--> %s ex %016llx "
+           "(T2T supp:%d) phy 0x%x has %c:%c routing link!\n",
 
            ex_type[parent->dev_type],
            SAS_ADDR(parent->sas_addr),
+           parent->ex_dev.t2t_supp,
            parent_phy->phy_id,
 
            ex_type[child->dev_type],
            SAS_ADDR(child->sas_addr),
+           child->ex_dev.t2t_supp,
            child_phy->phy_id,
 
            ra_char[parent_phy->routing_attr],
@@ -1238,10 +1241,15 @@ static int sas_check_parent_topology(struct domain_device *child)
                     sas_print_parent_topology_bug(child, parent_phy, child_phy);
                     res = -ENODEV;
                 }
-            } else if (parent_phy->routing_attr == TABLE_ROUTING &&
-                   child_phy->routing_attr != SUBTRACTIVE_ROUTING) {
-                sas_print_parent_topology_bug(child, parent_phy, child_phy);
-                res = -ENODEV;
+            } else if (parent_phy->routing_attr == TABLE_ROUTING) {
+                if (child_phy->routing_attr == SUBTRACTIVE_ROUTING ||
+                    (child_phy->routing_attr == TABLE_ROUTING &&
+                     child_ex->t2t_supp && parent_ex->t2t_supp)) {
+                    /* All good */;
+                } else {
+                    sas_print_parent_topology_bug(child, parent_phy, child_phy);
+                    res = -ENODEV;
+                }
             }
             break;
         case FANOUT_DEV:
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index ee86606..793f80b 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -142,8 +142,11 @@ struct expander_device {
     u16    ex_change_count;
     u16    max_route_indexes;
     u8     num_phys;
+
+    u8     t2t_supp:1;
     u8     configuring:1;
     u8     conf_route_table:1;
+
     u8     enclosure_logical_id[8];
 
     struct ex_phy *ex_phy;
diff --git a/include/scsi/sas.h b/include/scsi/sas.h
index e9fd022..f59f182 100644
--- a/include/scsi/sas.h
+++ b/include/scsi/sas.h
@@ -341,7 +341,12 @@ struct report_general_resp {
 
     u8      conf_route_table:1;
     u8      configuring:1;
-    u8      _r_b:6;
+    u8    config_others:1;
+    u8    orej_retry_supp:1;
+    u8    stp_cont_awt:1;
+    u8    self_config:1;
+    u8    zone_config:1;
+    u8    t2t_supp:1;
 
     u8      _r_c;
 
@@ -528,7 +533,12 @@ struct report_general_resp {
     u8      _r_a;
     u8      num_phys;
 
-    u8      _r_b:6;
+    u8    t2t_supp:1;
+    u8    zone_config:1;
+    u8    self_config:1;
+    u8    stp_cont_awt:1;
+    u8    orej_retry_supp:1;
+    u8    config_others:1;
     u8      configuring:1;
     u8      conf_route_table:1;
 
-- 
1.7.2.2.165.gbc382
______________________________________________________________________
This email may contain privileged or confidential information, which should only be used for the purpose for which it was sent by Xyratex. No further rights or licenses are granted to use such information. If you are not the intended recipient of this message, please notify the sender by return and delete it. You may not use, copy, disclose or rely on the information contained in it.
 
Internet email is susceptible to data corruption, interception and unauthorised amendment for which Xyratex does not accept liability. While we have taken reasonable precautions to ensure that this email is free of viruses, Xyratex does not accept liability for the presence of any computer viruses in this email, nor for any losses caused as a result of viruses.
 
Xyratex Technology Limited (03134912), Registered in England & Wales, Registered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
 
The Xyratex group of companies also includes, Xyratex Ltd, registered in Bermuda, Xyratex International Inc, registered in California, Xyratex (Malaysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co Ltd registered in The People's Republic of China and Xyratex Japan Limited registered in Japan.
______________________________________________________________________
 

