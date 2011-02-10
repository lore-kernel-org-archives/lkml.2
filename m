Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab1BJRLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:11:30 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:17210 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1BJRL3 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 10 Feb 2011 12:11:29 -0500
Date: Thu, 10 Feb 2011 12:10:20 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: jeremy@goop.org, xen-devel@lists.xensource.com, ian.campbell@citrix.com,
        haicheng.li@linux.intel.com, linux-kernel@vger.kernel.org,
        dan.magenheimer@oracle.com, v.tolstov@selfip.ru,
        dave@linux.vnet.ibm.com, linux-mm@kvack.org, rientjes@google.com,
        andi.kleen@intel.com, akpm@linux-foundation.org,
        fengguang.wu@intel.com, wdauchy@gmail.com
Subject: Re: [Xen-devel] Re: [PATCH R3 5/7] xen/balloon: Protect against
 CPU exhaust by event/x proces
Message-ID: <20110210171020.GB3993@dumpdata.com>
References: <20110203162851.GH1364@router-fw-old.local.net-space.pl>
 <20110210155142.GC12087@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110210155142.GC12087@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D541C23.0022:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 10:51:42AM -0500, Konrad Rzeszutek Wilk wrote:
> On Thu, Feb 03, 2011 at 05:28:51PM +0100, Daniel Kiper wrote:
> > Protect against CPU exhaust by event/x process during
> > errors by adding some delays in scheduling next event.
> > 
> > Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
> > ---
> >  drivers/xen/balloon.c |   99 +++++++++++++++++++++++++++++++++++++++---------
> >  1 files changed, 80 insertions(+), 19 deletions(-)
> > 
> > diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
> > index 4223f64..ed103d4 100644
> > --- a/drivers/xen/balloon.c
> > +++ b/drivers/xen/balloon.c
> > @@ -66,6 +66,20 @@
> >  
> >  #define BALLOON_CLASS_NAME "xen_memory"
> >  
> > +/*
> > + * balloon_process() state:
> > + *
> > + * BP_ERROR: error, go to sleep,
> > + * BP_DONE: done or nothing to do,
> > + * BP_HUNGRY: hungry.
> > + */
> > +
> > +enum bp_state {
> > +	BP_ERROR,
> 
> BP_EAGAIN?
> 
> So if we fail to increase the first hour, we would keep on trying to
> increase forever (with a 32 second delay between each call). Do you
> think it makes sense (as a future patch, not tied in with this patchset)
> to printout a printk(KERN_INFO that we have been trying to increase
> for the last X hours, seconds and have not gone anywhere (and perhaps
> stop trying to allocate more memory?).

Duh, you did that in the next patch with the mh_policy.
