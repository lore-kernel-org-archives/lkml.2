Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934211Ab2JXADW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 20:03:22 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:50523 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933579Ab2JXADV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 20:03:21 -0400
X-Greylist: delayed 938 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Oct 2012 20:03:20 EDT
Date: Tue, 23 Oct 2012 17:03:10 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Mukesh Rathor <mukesh.rathor@oracle.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH 4/6] xen/pvh: bootup and setup related
 changes.
Message-ID: <20121023170310.3b2a7e20@mantra.us.oracle.com>
In-Reply-To: <20121023164729.0ed51a1d@mantra.us.oracle.com>
References: <1350695882-12820-1-git-send-email-konrad.wilk@oracle.com>
	<1350695882-12820-5-git-send-email-konrad.wilk@oracle.com>
	<alpine.DEB.2.02.1210221428050.2689@kaball.uk.xensource.com>
	<20121022155717.GB25200@phenom.dumpdata.com>
	<alpine.DEB.2.02.1210231406490.2689@kaball.uk.xensource.com>
	<20121023164729.0ed51a1d@mantra.us.oracle.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2012 16:47:29 -0700
Mukesh Rathor <mukesh.rathor@oracle.com> wrote:

> On Tue, 23 Oct 2012 14:07:06 +0100
> Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> 
> > On Mon, 22 Oct 2012, Konrad Rzeszutek Wilk wrote:
> > > On Mon, Oct 22, 2012 at 02:34:44PM +0100, Stefano Stabellini
> > > wrote:
> > > > On Sat, 20 Oct 2012, Konrad Rzeszutek Wilk wrote:
> > > > > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > > > > 
> > > > >  	for (pfn = PFN_DOWN(start); pfn < xen_max_p2m_pfn;
> > > > > pfn++) { unsigned long mfn = pfn_to_mfn(pfn);
> > > > > @@ -100,6 +104,7 @@ static unsigned long __init
> > > > > xen_do_chunk(unsigned long start, .domid        = DOMID_SELF
> > > > >  	};
> > > > >  	unsigned long len = 0;
> > > > > +	int xlated_phys =
> > > > > xen_feature(XENFEAT_auto_translated_physmap); unsigned long
> > > > > pfn; int ret;
> > > > >  
> > > > > @@ -113,7 +118,7 @@ static unsigned long __init
> > > > > xen_do_chunk(unsigned long start, continue;
> > > > >  			frame = mfn;
> > > > >  		} else {
> > > > > -			if (mfn != INVALID_P2M_ENTRY)
> > > > > +			if (!xlated_phys && mfn !=
> > > > > INVALID_P2M_ENTRY) continue;
> > > > >  			frame = pfn;
> > > > >  		}
> > > > 
> > > > Shouldn't we add a "!xlated_phys &&" to the other case as well?
> > > 
> > > No. That is handled in xen_pvh_identity_map_chunk which
> > > just does a xen_set_clr_mmio_pvh_pte call for the "released"
> > > pages. But that is a bit of ... well, extra logic. I think
> > > if we did this it would work and look much nicer:
> > 
> > Yes, I think that this version looks better
> 
> But doesn't boot:
> 
> (XEN) vmx_hybrid.c:710:d0 Dom:0 EPT violation 0x181 (r--/---), gpa
> 0x000000bf421e1c, mfn 0xffffffffffffffff, type 4. (XEN)
> p2m-ept.c:642:d0 Walking EPT tables for domain 0 gfn bf421 (XEN)
> p2m-ept.c:648:d0  gfn exceeds max_mapped_pfn 4b062 (XEN)
> vmx_hybrid.c:717:d0  --- GLA 0xffffffffff477e1c
> 
> 
> I'll have to debug it, or we can go back to the prev version, which
> I don't think is that un-pretty :).
> 

The reason being:
xen_set_identity_and_release_chunk():
NEW : > for (pfn = start_pfn; pfn <= max_pfn_mapped && pfn < end_pfn; pfn++) {

xen_pvh_identity_map_chunk():
OLD: for (pfn = start_pfn; pfn < end_pfn; pfn++)

IOW, for PVH we need to avoid testing for max_pfn_mapped, as we are
mapping the entire IO space. 

thanks
mukesh

