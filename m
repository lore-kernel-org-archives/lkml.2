Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933269Ab1LFK4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:56:53 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:28283 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933118Ab1LFK4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:56:52 -0500
From: annie.li@oracle.com
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jeremy@goop.org
Cc: kurt.hackel@oracle.com, paul.durrant@citrix.com, Ian.Campbell@citrix.com,
        annie.li@oracle.com
Subject: [PATCH 1/2] xen/granttable: Support sub-page grants
Date: Tue,  6 Dec 2011 18:56:39 +0800
Message-Id: <1323168999-4434-1-git-send-email-annie.li@oracle.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <4EDDF41E.8070200@oracle.com>
References: <4EDDF41E.8070200@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090205.4EDDF4EF.00A4,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Annie Li <annie.li@oracle.com>

    -- They can't be used to map the page (so can only be used in a GNTTABOP_copy
       hypercall).
    -- It's possible to grant access with a finer granularity than whole pages.
    -- Xen guarantees that they can be revoked quickly (a normal map grant can
       only be revoked with the cooperation of the domain which has been granted
       access).

Signed-off-by: Annie Li <annie.li@oracle.com>
---
 drivers/xen/grant-table.c |   41 +++++++++++++++++++++++++++++++++++++++++
 include/xen/grant_table.h |   13 +++++++++++++
 2 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index bd325fd..7a0f4d1 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -261,6 +261,47 @@ int gnttab_grant_foreign_access(domid_t domid, unsigned long frame,
 }
 EXPORT_SYMBOL_GPL(gnttab_grant_foreign_access);
 
+int gnttab_grant_foreign_access_subpage_v2(domid_t domid, unsigned long frame,
+					   int flags, unsigned page_off,
+					   unsigned length)
+{
+	int ref;
+
+	ref = get_free_entries(1);
+	if (unlikely(ref < 0))
+		return -ENOSPC;
+
+	gnttab_grant_foreign_access_ref_subpage_v2(ref, domid, frame, flags,
+						   page_off, length);
+
+	return ref;
+}
+EXPORT_SYMBOL_GPL(gnttab_grant_foreign_access_subpage_v2);
+
+void gnttab_grant_foreign_access_ref_subpage_v2(grant_ref_t ref, domid_t domid,
+						unsigned long frame, int flags,
+						unsigned page_off,
+						unsigned length)
+{
+	BUG_ON(flags & (GTF_accept_transfer | GTF_reading |
+			GTF_writing | GTF_transitive));
+	BUG_ON(grant_table_version == 1);
+	gnttab_shared.v2[ref].sub_page.frame = frame;
+	gnttab_shared.v2[ref].sub_page.page_off = page_off;
+	gnttab_shared.v2[ref].sub_page.length = length;
+	gnttab_shared.v2[ref].hdr.domid = domid;
+	wmb();
+	gnttab_shared.v2[ref].hdr.flags =
+				GTF_permit_access | GTF_sub_page | flags;
+}
+EXPORT_SYMBOL_GPL(gnttab_grant_foreign_access_ref_subpage_v2);
+
+bool gnttab_subpage_trans_grants_available(void)
+{
+	return grant_table_version == 2;
+}
+EXPORT_SYMBOL_GPL(gnttab_subpage_trans_grants_available);
+
 static int gnttab_query_foreign_access_v1(grant_ref_t ref)
 {
 	return gnttab_shared.v1[ref].flags & (GTF_reading|GTF_writing);
diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
index fea4954..7e43652 100644
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -62,6 +62,15 @@ int gnttab_resume(void);
 
 int gnttab_grant_foreign_access(domid_t domid, unsigned long frame,
 				int readonly);
+int gnttab_grant_foreign_access_subpage_v2(domid_t domid, unsigned long frame,
+					   int flags, unsigned page_off,
+					   unsigned length);
+
+/*
+ * Are sub-page or transitive grants available on this version of Xen?  Returns
+ * true if they are, and false if they're not.
+ */
+bool gnttab_subpage_trans_grants_available(void);
 
 /*
  * End access through the given grant reference, iff the grant entry is no
@@ -108,6 +117,10 @@ void gnttab_cancel_free_callback(struct gnttab_free_callback *callback);
 
 void gnttab_grant_foreign_access_ref(grant_ref_t ref, domid_t domid,
 				     unsigned long frame, int readonly);
+void gnttab_grant_foreign_access_ref_subpage_v2(grant_ref_t ref, domid_t domid,
+						unsigned long frame, int flags,
+						unsigned page_off,
+						unsigned length);
 
 void gnttab_grant_foreign_transfer_ref(grant_ref_t, domid_t domid,
 				       unsigned long pfn);
-- 
1.7.6.4

