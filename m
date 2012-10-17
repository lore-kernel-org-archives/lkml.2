Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab2JQAJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 20:09:09 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:17552 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755718Ab2JQAJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 20:09:08 -0400
Date: Tue, 16 Oct 2012 17:09:00 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH V2 6/7]: PVH: balloon and grant changes
Message-ID: <20121016170900.665acf55@mantra.us.oracle.com>
In-Reply-To: <1350032817.14806.58.camel@zakaz.uk.xensource.com>
References: <20121011150113.4d525407@mantra.us.oracle.com>
	<1350032817.14806.58.camel@zakaz.uk.xensource.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2012 10:06:57 +0100
Ian Campbell <Ian.Campbell@citrix.com> wrote:

> On Thu, 2012-10-11 at 23:01 +0100, Mukesh Rathor wrote:
> > PVH: balloon and grant changes. For balloon changes we skip setting
> > of local p2m as it's updated in xen. For grant, the shared grant
> > frame is the pfn and not mfn, hence its mapped via the same code
> > path as HVM
> > 
> > Signed-off-by: Mukesh R <mukesh.rathor@oracle.com>
> > ---
> >  drivers/xen/balloon.c     |   18 +++++++++++-------
> >  drivers/xen/gntdev.c      |    3 ++-
> >  drivers/xen/grant-table.c |   25 +++++++++++++++++++++----
> >  3 files changed, 34 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
> > index 31ab82f..9b895ad 100644
> > --- a/drivers/xen/balloon.c
> > +++ b/drivers/xen/balloon.c
> > @@ -358,10 +358,13 @@ static enum bp_state
> > increase_reservation(unsigned long nr_pages)
> > BUG_ON(!xen_feature(XENFEAT_auto_translated_physmap) &&
> > phys_to_machine_mapping_valid(pfn)); 
> > -		set_phys_to_machine(pfn, frame_list[i]);
> > +		if (!xen_feature(XENFEAT_auto_translated_physmap))
> > +			set_phys_to_machine(pfn, frame_list[i]);
> 
> set_phys_to_machine is a NOP if XENFEAT_auto_translated_physmap but it
> includes some useful sanity checks (BUG_ON(pfn != mfn && mfn !=
> INVALID_P2M_ENTRY)) so it would be useful to keep calling it I think.

ok, fine, done.

> > +		     !xen_feature(XENFEAT_auto_translated_physmap);
> >  
> >  	err = misc_register(&gntdev_miscdev);
> >  	if (err != 0) {
> > @@ -1055,7 +1060,7 @@ static void gnttab_request_version(void)
> >  	int rc;
> >  	struct gnttab_set_version gsv;
> >  
> > -	if (xen_hvm_domain())
> > +	if (xen_hvm_domain() ||
> > xen_feature(XENFEAT_auto_translated_physmap))
> 
> This is just a case of not yet implemented rather than a fundamental
> problem with v2 grant tables, correct? (i.e. future work)

Right. 

> >  		gsv.version = 1;
> >  	else
> >  		gsv.version = 2;
> > @@ -1083,12 +1088,24 @@ static void gnttab_request_version(void)
> >  int gnttab_resume(void)
> >  {
> >  	unsigned int max_nr_gframes;
> > +	char *kmsg = "Failed to kmalloc pages for pv in hvm grant
> > frames\n"; 
> >  	gnttab_request_version();
> >  	max_nr_gframes = gnttab_max_grant_frames();
> >  	if (max_nr_gframes < nr_grant_frames)
> >  		return -ENOSYS;
> >  
> > +	/* PVH note: xen will free existing kmalloc'd mfn in
> > +	 * XENMEM_add_to_physmap */
> 
> It doesn't leak it?
> We should consider using xenballoon_alloc_pages here.

Well, it's a one time allocation of a dozen (iirc) pages, that are 
returned back to dom heap. We could use xenballoon, but for that we
need to create vma first so we get the contigous VA, then map each pte
since xenballoon_ doesn't return contigous pages, and then populate
physmap. I'm gonna punt it to phase II.  Lets get some working baseline
in asap.

thanks
mukesh

