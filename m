Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab2AYUtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 15:49:15 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:25065 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab2AYUtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 15:49:13 -0500
Date: Wed, 25 Jan 2012 15:46:52 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "annie.li@oracle.com" <annie.li@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: Regressions in v3.3-rc1 introduced by "xen/granttable: Grant
 tables V2 implementation"
Message-ID: <20120125204652.GA21284@phenom.dumpdata.com>
References: <20120125044949.GB29759@phenom.dumpdata.com>
 <20120125051253.GA15501@phenom.dumpdata.com>
 <1327485333.24561.232.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327485333.24561.232.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4F206AC6.00AD,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 09:55:33AM +0000, Ian Campbell wrote:
> On Wed, 2012-01-25 at 05:12 +0000, Konrad Rzeszutek Wilk wrote:
> > On Tue, Jan 24, 2012 at 11:49:49PM -0500, Konrad Rzeszutek Wilk wrote:
> > > When I try to bootup a PVonHVM guest with Xen 4.1 I get this:
> > 
> > .. snip..
> > > 
> > > and with this little patch I can get it to work:
> > 
> > I get the domU to boot but the network stops being responsive.
> > I see this in the Dom0:
> 
> Your original patch would set the version to two in the hypervisor and
> then ignore that and continue to use v1 so that isn't surprising.
> 
> > (XEN) grant_table.c:362:d0 Bad flags (0) or dom (0). (expected dom 0, flags 103)
> > [ 6834.488816] vif vif-12-0: 1 mapping in shared page 768 from domain 12
> > [ 6834.490235] vif vif-12-0: 1 mapping shared-frames 768/769 port 15
> > 
> > Replacing the patch with:
> > 
> > diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> > index 1cd94da..b4d4eac 100644
> > --- a/drivers/xen/grant-table.c
> > +++ b/drivers/xen/grant-table.c
> > @@ -948,9 +948,12 @@ static void gnttab_request_version(void)
> >  	int rc;
> >  	struct gnttab_set_version gsv;
> >  
> > -	gsv.version = 2;
> > +	if (xen_hvm_domain())
> > +		gsv.version = 1;
> > +	else
> > +		gsv.version = 2;
> >  	rc = HYPERVISOR_grant_table_op(GNTTABOP_set_version, &gsv, 1);
> > -	if (rc == 0) {
> > +	if (rc == 0 && gsv.version == 2) {
> >  		grant_table_version = 2;
> >  		gnttab_interface = &gnttab_v2_ops;
> >  	} else if (grant_table_version == 2) {
> > 
> > Gets me back to how it worked in Linux v3.2.
> > 
> > But that is just a band-aid fix...
> 
> The real bug is presumably either that the Linux v2 code is buggy for
> use in an HVM guest or that Xen's support for v2 in HVM guests is either
> buggy or explicitly disabled (in which case set_version should fail for
> version=2).
> 
> Is the set_version with version=1 succeeding or failing? Likewise for
> the version=2 call?

Both return 0. But version=2 returns the error in the hypervisor:

 (XEN) grant_table.c:362:d0 Bad flags (0) or dom (0). (expected dom 0, flags 103)

> 
> The original error was an "unable to handle kernel NULL pointer
> dereference at" gnttab_end_foreign_access_ref_v2+0x29/0x40. The only
> plausible candidates for such an error are the array access into to
> either the gnttab_shared or grstatus arrays. Do you know which one the
> IP corresponds to?

Didn't look deeper into this than just enought to send this hastily crafted
email. Will check shortly.
> 
> On HVM for gnttab_shared we make an add_to_physmap call with
> XENMAPSPACE_grant_table (in gnttab_map). I don't see any support call to
> do something similar for the status array though and I don't see a
> XENMAPSPACE_* specifically for that case either in the hypervisor
> either.
> 
> Ian.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
