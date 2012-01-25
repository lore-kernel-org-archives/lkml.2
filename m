Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab2AYJzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 04:55:36 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:54347 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab2AYJzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 04:55:35 -0500
X-IronPort-AV: E=Sophos;i="4.71,567,1320624000"; 
   d="scan'208";a="10267552"
Subject: Re: Regressions in v3.3-rc1 introduced by "xen/granttable: Grant
 tables V2 implementation"
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "annie.li@oracle.com" <annie.li@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Date: Wed, 25 Jan 2012 09:55:33 +0000
In-Reply-To: <20120125051253.GA15501@phenom.dumpdata.com>
References: <20120125044949.GB29759@phenom.dumpdata.com>
	 <20120125051253.GA15501@phenom.dumpdata.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1327485333.24561.232.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-25 at 05:12 +0000, Konrad Rzeszutek Wilk wrote:
> On Tue, Jan 24, 2012 at 11:49:49PM -0500, Konrad Rzeszutek Wilk wrote:
> > When I try to bootup a PVonHVM guest with Xen 4.1 I get this:
> 
> .. snip..
> > 
> > and with this little patch I can get it to work:
> 
> I get the domU to boot but the network stops being responsive.
> I see this in the Dom0:

Your original patch would set the version to two in the hypervisor and
then ignore that and continue to use v1 so that isn't surprising.

> (XEN) grant_table.c:362:d0 Bad flags (0) or dom (0). (expected dom 0, flags 103)
> [ 6834.488816] vif vif-12-0: 1 mapping in shared page 768 from domain 12
> [ 6834.490235] vif vif-12-0: 1 mapping shared-frames 768/769 port 15
> 
> Replacing the patch with:
> 
> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> index 1cd94da..b4d4eac 100644
> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
> @@ -948,9 +948,12 @@ static void gnttab_request_version(void)
>  	int rc;
>  	struct gnttab_set_version gsv;
>  
> -	gsv.version = 2;
> +	if (xen_hvm_domain())
> +		gsv.version = 1;
> +	else
> +		gsv.version = 2;
>  	rc = HYPERVISOR_grant_table_op(GNTTABOP_set_version, &gsv, 1);
> -	if (rc == 0) {
> +	if (rc == 0 && gsv.version == 2) {
>  		grant_table_version = 2;
>  		gnttab_interface = &gnttab_v2_ops;
>  	} else if (grant_table_version == 2) {
> 
> Gets me back to how it worked in Linux v3.2.
> 
> But that is just a band-aid fix...

The real bug is presumably either that the Linux v2 code is buggy for
use in an HVM guest or that Xen's support for v2 in HVM guests is either
buggy or explicitly disabled (in which case set_version should fail for
version=2).

Is the set_version with version=1 succeeding or failing? Likewise for
the version=2 call?

The original error was an "unable to handle kernel NULL pointer
dereference at" gnttab_end_foreign_access_ref_v2+0x29/0x40. The only
plausible candidates for such an error are the array access into to
either the gnttab_shared or grstatus arrays. Do you know which one the
IP corresponds to?

On HVM for gnttab_shared we make an add_to_physmap call with
XENMAPSPACE_grant_table (in gnttab_map). I don't see any support call to
do something similar for the status array though and I don't see a
XENMAPSPACE_* specifically for that case either in the hypervisor
either.

Ian.

