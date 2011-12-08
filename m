Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab1LHJiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 04:38:05 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:49972 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab1LHJiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 04:38:03 -0500
From: annie.li@oracle.com
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jeremy@goop.org, paul.durrant@citrix.com,
        Ian.Campbell@citrix.com
Cc: kurt.hackel@oracle.com, annie.li@oracle.com
Subject: [PATCH V2 2/2] xen/granttable: Support transitive grants
Date: Thu,  8 Dec 2011 17:37:57 +0800
Message-Id: <1323337077-5457-1-git-send-email-annie.li@oracle.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1323336940-5382-1-git-send-email-annie.li@oracle.com>
References: <1323336940-5382-1-git-send-email-annie.li@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090202.4EE08577.0047,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These allow a domain A which has been granted access on a page of domain B's
memory to issue domain C with a copy-grant on the same page.  This is useful
e.g. for forwarding packets between domains.

Signed-off-by: Annie Li <annie.li@oracle.com>
---
 drivers/xen/grant-table.c |   73 +++++++++++++++++++++++++++++++++++++++++++++
 include/xen/grant_table.h |   12 +++++++
 2 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 4a10e3f..db3e7c0 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -130,6 +130,18 @@ struct gnttab_ops {
 	 */
 	void (*update_subpage_entry)(grant_ref_t, domid_t, unsigned long, int,
 				     unsigned, unsigned);
+	/*
+	 * Redirect an available grant entry on domain A to another grant
+	 * reference of domain B, then allow domain C to use grant reference
+	 * of domain B transitively. First parameter is an available grant entry
+	 * reference on domain A, second one is id of domain C which accesses
+	 * grant entry transitively, third one is grant type and flag
+	 * information, forth one is id of domain B whose grant entry is finally
+	 * accessed transitively, last one is grant entry transitive reference
+	 * of domain B.
+	 */
+	void (*update_trans_entry)(grant_ref_t, domid_t, int, domid_t,
+				   grant_ref_t);
 };
 
 static struct gnttab_ops *gnttab_interface;
@@ -334,6 +346,66 @@ bool gnttab_subpage_grants_available(void)
 }
 EXPORT_SYMBOL_GPL(gnttab_subpage_grants_available);
 
+void gnttab_update_trans_entry_v2(grant_ref_t ref, domid_t domid,
+				  int flags, domid_t trans_domid,
+				  grant_ref_t trans_gref)
+{
+	gnttab_shared.v2[ref].transitive.trans_domid = trans_domid;
+	gnttab_shared.v2[ref].transitive.gref = trans_gref;
+	gnttab_shared.v2[ref].hdr.domid = domid;
+	wmb();
+	gnttab_shared.v2[ref].hdr.flags =
+				GTF_permit_access | GTF_transitive | flags;
+}
+
+int gnttab_grant_foreign_access_trans_ref(grant_ref_t ref, domid_t domid,
+					  int flags, domid_t trans_domid,
+					  grant_ref_t trans_gref)
+{
+	if (flags & (GTF_accept_transfer | GTF_reading |
+		     GTF_writing | GTF_sub_page))
+		return -EPERM;
+
+	if (gnttab_interface->update_trans_entry == NULL)
+		return -ENOSYS;
+
+	gnttab_interface->update_trans_entry(ref, domid, flags, trans_domid,
+					     trans_gref);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(gnttab_grant_foreign_access_trans_ref);
+
+int gnttab_grant_foreign_access_trans(domid_t domid, int flags,
+				      domid_t trans_domid,
+				      grant_ref_t trans_gref)
+{
+	int ref;
+
+	if (flags & (GTF_accept_transfer | GTF_reading |
+		     GTF_writing | GTF_sub_page))
+		return -EPERM;
+
+	if (gnttab_interface->update_trans_entry == NULL)
+		return -ENOSYS;
+
+	ref = get_free_entries(1);
+	if (unlikely(ref < 0))
+		return -ENOSPC;
+
+	gnttab_interface->update_trans_entry(ref, domid, flags, trans_domid,
+					     trans_gref);
+
+	return ref;
+}
+EXPORT_SYMBOL_GPL(gnttab_grant_foreign_access_trans);
+
+bool gnttab_trans_grants_available(void)
+{
+	return gnttab_interface->update_trans_entry != NULL;
+}
+EXPORT_SYMBOL_GPL(gnttab_trans_grants_available);
+
 static int gnttab_query_foreign_access_v1(grant_ref_t ref)
 {
 	return gnttab_shared.v1[ref].flags & (GTF_reading|GTF_writing);
@@ -887,6 +959,7 @@ static struct gnttab_ops gnttab_v2_ops = {
 	.end_foreign_transfer_ref	= gnttab_end_foreign_transfer_ref_v2,
 	.query_foreign_access		= gnttab_query_foreign_access_v2,
 	.update_subpage_entry		= gnttab_update_subpage_entry_v2,
+	.update_trans_entry		= gnttab_update_trans_entry_v2,
 };
 
 static void gnttab_request_version(void)
diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
index 2b492b9..f1e17b7 100644
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -65,6 +65,9 @@ int gnttab_grant_foreign_access(domid_t domid, unsigned long frame,
 int gnttab_grant_foreign_access_subpage(domid_t domid, unsigned long frame,
 					int flags, unsigned page_off,
 					unsigned length);
+int gnttab_grant_foreign_access_trans(domid_t domid, int flags,
+				      domid_t trans_domid,
+				      grant_ref_t trans_gref);
 
 /*
  * Are sub-page grants available on this version of Xen?  Returns true if they
@@ -73,6 +76,12 @@ int gnttab_grant_foreign_access_subpage(domid_t domid, unsigned long frame,
 bool gnttab_subpage_grants_available(void);
 
 /*
+ * Are transitive grants available on this version of Xen?  Returns true if they
+ * are, and false if they're not.
+ */
+bool gnttab_trans_grants_available(void);
+
+/*
  * End access through the given grant reference, iff the grant entry is no
  * longer in use.  Return 1 if the grant entry was freed, 0 if it is still in
  * use.
@@ -121,6 +130,9 @@ int gnttab_grant_foreign_access_subpage_ref(grant_ref_t ref, domid_t domid,
 					    unsigned long frame, int flags,
 					    unsigned page_off,
 					    unsigned length);
+int gnttab_grant_foreign_access_trans_ref(grant_ref_t ref, domid_t domid,
+					  int flags, domid_t trans_domid,
+					  grant_ref_t trans_gref);
 
 void gnttab_grant_foreign_transfer_ref(grant_ref_t, domid_t domid,
 				       unsigned long pfn);
-- 
1.7.6.4

