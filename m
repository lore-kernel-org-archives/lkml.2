Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750974Ab2AYFPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 00:15:20 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:63049 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab2AYFPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 00:15:19 -0500
Date: Wed, 25 Jan 2012 00:12:54 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, annie.li@oracle.com,
        xen-devel@lists.xensource.com,
        Ian Campbell <Ian.Campbell@eu.citrix.com>
Subject: Re: Regressions in v3.3-rc1 introduced by "xen/granttable: Grant
 tables V2 implementation"
Message-ID: <20120125051253.GA15501@phenom.dumpdata.com>
References: <20120125044949.GB29759@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120125044949.GB29759@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090204.4F1F8FE0.006F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 11:49:49PM -0500, Konrad Rzeszutek Wilk wrote:
> When I try to bootup a PVonHVM guest with Xen 4.1 I get this:

.. snip..
> 
> and with this little patch I can get it to work:

I get the domU to boot but the network stops being responsive.
I see this in the Dom0:


(XEN) grant_table.c:362:d0 Bad flags (0) or dom (0). (expected dom 0, flags 103)
[ 6834.488816] vif vif-12-0: 1 mapping in shared page 768 from domain 12
[ 6834.490235] vif vif-12-0: 1 mapping shared-frames 768/769 port 15

Replacing the patch with:

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 1cd94da..b4d4eac 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -948,9 +948,12 @@ static void gnttab_request_version(void)
 	int rc;
 	struct gnttab_set_version gsv;
 
-	gsv.version = 2;
+	if (xen_hvm_domain())
+		gsv.version = 1;
+	else
+		gsv.version = 2;
 	rc = HYPERVISOR_grant_table_op(GNTTABOP_set_version, &gsv, 1);
-	if (rc == 0) {
+	if (rc == 0 && gsv.version == 2) {
 		grant_table_version = 2;
 		gnttab_interface = &gnttab_v2_ops;
 	} else if (grant_table_version == 2) {

Gets me back to how it worked in Linux v3.2.

But that is just a band-aid fix...
