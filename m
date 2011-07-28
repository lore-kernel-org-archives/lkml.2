Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab1G1E0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 00:26:12 -0400
Received: from nm28.bullet.mail.bf1.yahoo.com ([98.139.212.187]:48865 "HELO
	nm28.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751007Ab1G1E0E convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 00:26:04 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jul 2011 00:26:04 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 671047.25867.bm@omp1003.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=mSwy/CCkhdNGQEv8LilYNbrxIhmfkUlQDIkBm+dQN8MKr/234s6HE4+3uwxiqtpRG2AIngmIlxPuWw6d8E8mTw7BQ0AyIfq3buxQAyFTJ/kTZGBjIIqke6794fomD5Z/5Z80KtfdffaEJ+5rlk7Y3BBB3QAcWfvabLZRBG7qDxc=;
X-YMail-OSG: mNL57poVM1kSo0Ak559.45cYQH1tStmBMZ2b_2z.wra0BEN
 fB1E9myubOFmWO5akdwnpX3wMwxWy0etVb0zNqLLHFmpvRZV6_DBeB9nl2F.
 LMostVUj_ZqOIF.hHRpxgdjajb5KwJMLOWsNVSX9_7Fm7gPGg.8VpSx50kfy
 pSjl1FcBFh1pZYHyFcZDkdbCuprlpOimvnW4kVJWEK85EbYVgX8m90uz997E
 3FNlZrToqCDL_JYyYOXTtQf_wAp9KJBYvt0qyyxAegp8Q6HyQ6V2Z0E3OpcR
 HrO8bFqLbpGZrKbd6HmWN41RwdY_I0LEsQjgYcQ9PEKQ71iG3Hm_FoBVQdns
 o4MSEiXAHlfmwc6EIb_7iSgSA_CYAC9BZwkRuP1owfdX6O88QEVAtQLVBeNJ
 yAkJGVipGHsbT
X-Mailer: YahooMailWebService/0.8.113.313619
Message-ID: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com>
Date: Wed, 27 Jul 2011 21:19:52 -0700 (PDT)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: Luben Tuikov <ltuikov@yahoo.com>
Subject: [PATCH] [SCSI] libsas: Allow expander T-T attachments
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "JBottomley@Parallels.com" <JBottomley@Parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
