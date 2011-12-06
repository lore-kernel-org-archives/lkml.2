Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933264Ab1LFK52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:57:28 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:28596 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933089Ab1LFK51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:57:27 -0500
From: annie.li@oracle.com
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jeremy@goop.org
Cc: kurt.hackel@oracle.com, paul.durrant@citrix.com, Ian.Campbell@citrix.com,
        annie.li@oracle.com
Subject: [PATCH 2/2] xen/granttable: Support transitive grants
Date: Tue,  6 Dec 2011 18:57:23 +0800
Message-Id: <1323169043-4470-1-git-send-email-annie.li@oracle.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <4EDDF41E.8070200@oracle.com>
References: <4EDDF41E.8070200@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090204.4EDDF514.0037,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Annie Li <annie.li@oracle.com>

These allow a domain A which has been granted access on a page of domain B's
memory to issue domain C with a copy-grant on the same page.  This is useful
e.g. for forwarding packets between domains.

Signed-off-by: Annie Li <annie.li@oracle.com>
---
 drivers/xen/grant-table.c |   33 +++++++++++++++++++++++++++++++++
 include/xen/grant_table.h |    6 ++++++
 2 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 7a0f4d1..d64b7c5 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -296,6 +296,39 @@ void gnttab_grant_foreign_access_ref_subpage_v2(grant_ref_t ref, domid_t domid,
 }
 EXPORT_SYMBOL_GPL(gnttab_grant_foreign_access_ref_subpage_v2);
 
+int gnttab_grant_foreign_access_trans_v2(domid_t domid, int flags,
+					 domid_t trans_domid,
+					 grant_ref_t trans_gref)
+{
+	int ref;
+
+	ref = get_free_entries(1);
+	if (unlikely(ref < 0))
+		return -ENOSPC;
+
+	gnttab_grant_foreign_access_ref_trans_v2(ref, domid, flags,
+						 trans_domid, trans_gref);
+
+	return ref;
+}
+EXPORT_SYMBOL_GPL(gnttab_grant_foreign_access_trans_v2);
+
+void gnttab_grant_foreign_access_ref_trans_v2(grant_ref_t ref, domid_t domid,
+					      int flags, domid_t trans_domid,
+					      grant_ref_t trans_gref)
+{
+	BUG_ON(flags & (GTF_accept_transfer | GTF_reading |
+			GTF_writing | GTF_sub_page));
+	BUG_ON(grant_table_version == 1);
+	gnttab_shared.v2[ref].transitive.trans_domid = trans_domid;
+	gnttab_shared.v2[ref].transitive.gref = trans_gref;
+	gnttab_shared.v2[ref].hdr.domid = domid;
+	wmb();
+	gnttab_shared.v2[ref].hdr.flags =
+				GTF_permit_access | GTF_transitive | flags;
+}
+EXPORT_SYMBOL_GPL(gnttab_grant_foreign_access_ref_trans_v2);
+
 bool gnttab_subpage_trans_grants_available(void)
 {
 	return grant_table_version == 2;
diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
index 7e43652..35a8c73 100644
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -65,6 +65,9 @@ int gnttab_grant_foreign_access(domid_t domid, unsigned long frame,
 int gnttab_grant_foreign_access_subpage_v2(domid_t domid, unsigned long frame,
 					   int flags, unsigned page_off,
 					   unsigned length);
+int gnttab_grant_foreign_access_trans_v2(domid_t domid, int flags,
+					 domid_t trans_domid,
+					 grant_ref_t trans_gref);
 
 /*
  * Are sub-page or transitive grants available on this version of Xen?  Returns
@@ -121,6 +124,9 @@ void gnttab_grant_foreign_access_ref_subpage_v2(grant_ref_t ref, domid_t domid,
 						unsigned long frame, int flags,
 						unsigned page_off,
 						unsigned length);
+void gnttab_grant_foreign_access_ref_trans_v2(grant_ref_t ref, domid_t domid,
+					      int flags, domid_t trans_domid,
+					      grant_ref_t trans_gref);
 
 void gnttab_grant_foreign_transfer_ref(grant_ref_t, domid_t domid,
 				       unsigned long pfn);
-- 
1.7.6.4

