Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab1LHJhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 04:37:36 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:65183 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab1LHJhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 04:37:33 -0500
From: annie.li@oracle.com
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jeremy@goop.org, paul.durrant@citrix.com,
        Ian.Campbell@citrix.com
Cc: kurt.hackel@oracle.com, annie.li@oracle.com
Subject: [PATCH V2 1/2] xen/granttable: Support sub-page grants
Date: Thu,  8 Dec 2011 17:37:28 +0800
Message-Id: <1323337048-5426-1-git-send-email-annie.li@oracle.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1323336940-5382-1-git-send-email-annie.li@oracle.com>
References: <1323336940-5382-1-git-send-email-annie.li@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A02020B.4EE0855A.002F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    -- They can't be used to map the page (so can only be used in a GNTTABOP_copy
       hypercall).
    -- It's possible to grant access with a finer granularity than whole pages.
    -- Xen guarantees that they can be revoked quickly (a normal map grant can
       only be revoked with the cooperation of the domain which has been granted
       access).

Signed-off-by: Annie Li <annie.li@oracle.com>
---
 drivers/xen/grant-table.c |   74 +++++++++++++++++++++++++++++++++++++++++++++
 include/xen/grant_table.h |   13 ++++++++
 2 files changed, 87 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index bd325fd..4a10e3f 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -120,6 +120,16 @@ struct gnttab_ops {
 	 * by bit operations.
 	 */
 	int (*query_foreign_access)(grant_ref_t);
+	/*
+	 * Grant a domain to access a range of bytes within the page referred by
+	 * an available grant entry. First parameter is grant entry reference
+	 * number, second one is id of grantee domain, third one is frame
+	 * address of subpage grant, forth one is grant type and flag
+	 * information, fifth one is offset of the range of bytes, and last one
+	 * is length of bytes to be accessed.
+	 */
+	void (*update_subpage_entry)(grant_ref_t, domid_t, unsigned long, int,
+				     unsigned, unsigned);
 };
 
 static struct gnttab_ops *gnttab_interface;
@@ -261,6 +271,69 @@ int gnttab_grant_foreign_access(domid_t domid, unsigned long frame,
 }
 EXPORT_SYMBOL_GPL(gnttab_grant_foreign_access);
 
+void gnttab_update_subpage_entry_v2(grant_ref_t ref, domid_t domid,
+				    unsigned long frame, int flags,
+				    unsigned page_off,
+				    unsigned length)
+{
+	gnttab_shared.v2[ref].sub_page.frame = frame;
+	gnttab_shared.v2[ref].sub_page.page_off = page_off;
+	gnttab_shared.v2[ref].sub_page.length = length;
+	gnttab_shared.v2[ref].hdr.domid = domid;
+	wmb();
+	gnttab_shared.v2[ref].hdr.flags =
+				GTF_permit_access | GTF_sub_page | flags;
+}
+
+int gnttab_grant_foreign_access_subpage_ref(grant_ref_t ref, domid_t domid,
+					    unsigned long frame, int flags,
+					    unsigned page_off,
+					    unsigned length)
+{
+	if (flags & (GTF_accept_transfer | GTF_reading |
+		     GTF_writing | GTF_transitive))
+		return -EPERM;
+
+	if (gnttab_interface->update_subpage_entry == NULL)
+		return -ENOSYS;
+
+	gnttab_interface->update_subpage_entry(ref, domid, frame, flags,
+					       page_off, length);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(gnttab_grant_foreign_access_subpage_ref);
+
+int gnttab_grant_foreign_access_subpage(domid_t domid, unsigned long frame,
+					int flags, unsigned page_off,
+					unsigned length)
+{
+	int ref;
+
+	if (flags & (GTF_accept_transfer | GTF_reading |
+		     GTF_writing | GTF_transitive))
+		return -EPERM;
+
+	if (gnttab_interface->update_subpage_entry == NULL)
+		return -ENOSYS;
+
+	ref = get_free_entries(1);
+	if (unlikely(ref < 0))
+		return -ENOSPC;
+
+	gnttab_interface->update_subpage_entry(ref, domid, frame, flags,
+					       page_off, length);
+
+	return ref;
+}
+EXPORT_SYMBOL_GPL(gnttab_grant_foreign_access_subpage);
+
+bool gnttab_subpage_grants_available(void)
+{
+	return gnttab_interface->update_subpage_entry != NULL;
+}
+EXPORT_SYMBOL_GPL(gnttab_subpage_grants_available);
+
 static int gnttab_query_foreign_access_v1(grant_ref_t ref)
 {
 	return gnttab_shared.v1[ref].flags & (GTF_reading|GTF_writing);
@@ -813,6 +886,7 @@ static struct gnttab_ops gnttab_v2_ops = {
 	.end_foreign_access_ref		= gnttab_end_foreign_access_ref_v2,
 	.end_foreign_transfer_ref	= gnttab_end_foreign_transfer_ref_v2,
 	.query_foreign_access		= gnttab_query_foreign_access_v2,
+	.update_subpage_entry		= gnttab_update_subpage_entry_v2,
 };
 
 static void gnttab_request_version(void)
diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
index fea4954..2b492b9 100644
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -62,6 +62,15 @@ int gnttab_resume(void);
 
 int gnttab_grant_foreign_access(domid_t domid, unsigned long frame,
 				int readonly);
+int gnttab_grant_foreign_access_subpage(domid_t domid, unsigned long frame,
+					int flags, unsigned page_off,
+					unsigned length);
+
+/*
+ * Are sub-page grants available on this version of Xen?  Returns true if they
+ * are, and false if they're not.
+ */
+bool gnttab_subpage_grants_available(void);
 
 /*
  * End access through the given grant reference, iff the grant entry is no
@@ -108,6 +117,10 @@ void gnttab_cancel_free_callback(struct gnttab_free_callback *callback);
 
 void gnttab_grant_foreign_access_ref(grant_ref_t ref, domid_t domid,
 				     unsigned long frame, int readonly);
+int gnttab_grant_foreign_access_subpage_ref(grant_ref_t ref, domid_t domid,
+					    unsigned long frame, int flags,
+					    unsigned page_off,
+					    unsigned length);
 
 void gnttab_grant_foreign_transfer_ref(grant_ref_t, domid_t domid,
 				       unsigned long pfn);
-- 
1.7.6.4

