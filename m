Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165Ab2DFVRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 17:17:17 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:41463 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758098Ab2DFVRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 17:17:15 -0400
Date: Fri, 6 Apr 2012 14:17:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: James Bottomley <JBottomley@parallels.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 1/2] sysfs: handle 'parent deleted before child added'
Message-ID: <20120406211711.GA12075@kroah.com>
References: <20120406203619.22624.69445.stgit@dwillia2-linux.jf.intel.com>
 <20120406204514.GA20237@kroah.com>
 <CABE8wwuMyH7nrPZWarWw1Z8=oM_Z4eUcupnsyxA9NF=Y1R_Apw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABE8wwuMyH7nrPZWarWw1Z8=oM_Z4eUcupnsyxA9NF=Y1R_Apw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2012 at 02:06:50PM -0700, Williams, Dan J wrote:
> On Fri, Apr 6, 2012 at 1:45 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Fri, Apr 06, 2012 at 01:41:06PM -0700, Dan Williams wrote:
> >> In scsi at least two cases of the parent device being deleted before the
> >> child is added have been observed.
> >>
> >> 1/ scsi is performing async scans and the device is removed prior to the
> >>    async can thread running (can happen with an in-opportune / unlikely
> >>    unplug during initial scan).
> >
> > That sounds like a bug in the scsi code, doesn't it?
> >
> >> 2/ libsas discovery event running after the parent port has been torn
> >>    down (this is a bug in libsas).
> >
> > Is this fixed somewhere?
> 
> Yes, these two issues have pending fixes that are posted to linux-scsi:
> 
> http://marc.info/?l=linux-scsi&m=133239707903443&w=2
> http://marc.info/?l=linux-scsi&m=133239709603452&w=2
> 
> > I don't want to paper over bugs like this by changing the sysfs core.
> > We went through this a lot years ago when scsi changed to use the driver
> > core, and I thought we had fixed all of these types of errors properly.
> 
> Hotplug lifetime rules are still transport specific.  So in this case
> scsi-core is innocent these are bugs from libsas and
> scsi_transport_sas.

Ok, thanks for the explaination.

> > So, any chance to fix these properly as well?
> 
> This patch doesn't really paper over anything.  It turns a NULL
> pointer crash into an explicit warning from kobject_add_internal.  For
> the libsas/scsi case this device_add() failure is still fatal.
> Regardless of whether sysfs changes the above two fixes are still
> required.
> 
> Since the -EEXIST case is just a KERN_ERR and not a BUG_ON I figured
> it was worthwhile to post a patch to do the same for this 'parent
> deleted' case.  But if crashing is the expectation then this patch can
> be dropped.

No, crashing is not the expectation :)

But, without that crash, would the above fixes ever have been noticed
and fixed?  The device_add() most likely would have quietly failed and
no one would have been the wiser.

Or would something else have caused this to be an obvious problem?

thanks,

greg k-h
