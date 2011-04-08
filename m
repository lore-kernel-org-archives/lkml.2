Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392Ab1DHWy4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 18:54:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:55743 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943Ab1DHWyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 18:54:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,326,1299484800"; 
   d="scan'208";a="625779996"
Date: Sat, 9 Apr 2011 00:54:52 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andres Salomon <dilinger@queued.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC] [PATCH] mfd: Fetch cell pointer from
 platform_device->mfd_cell
Message-ID: <20110408225451.GC30969@sortiz-mobl>
References: <20110408004007.GC3923@sortiz-mobl>
 <20110407193855.1e9182bb@debxo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110407193855.1e9182bb@debxo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andres,

On Thu, Apr 07, 2011 at 07:38:55PM -0700, Andres Salomon wrote:
> > diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> > index f051cff..6c3a2bd 100644
> > --- a/drivers/base/platform.c
> > +++ b/drivers/base/platform.c
> > @@ -149,6 +149,7 @@ static void platform_device_release(struct device
> > *dev) 
> >  	of_device_node_put(&pa->pdev.dev);
> >  	kfree(pa->pdev.dev.platform_data);
> > +	kfree(pa->pdev.mfd_cell);
> 
> Hm, given that most platform devices won't be mfd devices (and thus
> mfd_cell will be NULL), is it better to rely on kfree's
> unlikely(ZERO_OR_NULL_PTR(...)), or have this be "if
> (pa->pdev.mfd_cell) kfree(pa->pdev.mfd_cell);"?
I'd say the former (obviously), unless Greg wants it to be otherwise.

> > --- a/include/linux/mfd/core.h
> > +++ b/include/linux/mfd/core.h
> > @@ -86,16 +86,20 @@ extern int mfd_clone_cell(const char *cell, const
> > char **clones, */
> >  static inline const struct mfd_cell *mfd_get_cell(struct
> > platform_device *pdev) {
> > -	return pdev->dev.platform_data;
> > +	return pdev->mfd_cell;
> >  }
> >  
> >  /*
> >   * Given a platform device that's been created by mfd_add_devices(),
> > fetch
> >   * the .mfd_data entry from the mfd_cell that created it.
> > + * Otherwise just return the platform_data pointer.
> 
> I'd also suggest describing why we fall back to
> platform_data; to the casual reader, it would be confusing.  Perhaps
> something to the effect of, "This maintains compatibility with
> platform drivers whose devices aren't created by the mfd layer, and
> expect platform_data to contain what would've otherwise been in
> mfd_data."
Right. I'll add that.

 
> >   */
> >  static inline void *mfd_get_data(struct platform_device *pdev)
> >  {
> > -	return mfd_get_cell(pdev)->mfd_data;
> > +	if (pdev->mfd_cell)
> > +		return mfd_get_cell(pdev)->mfd_data;
> > +	else
> > +		return pdev->dev.platform_data;
> 
> Not much point checking pdev->mfd_cell and then using an abstraction.
That's right as well. I'll send v1 next with those 2 fixes.

Thanks for the review.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
