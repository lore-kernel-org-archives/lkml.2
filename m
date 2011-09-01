Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab1IAHtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 03:49:25 -0400
Received: from cernmx31.cern.ch ([137.138.144.179]:30972 "EHLO
	CERNMX31.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab1IAHtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 03:49:23 -0400
Date: Thu, 1 Sep 2011 09:46:01 +0200
From: Manohar Vanga <manohar.vanga@cern.ch>
To: "Emilio G. Cota" <cota@braap.org>
CC: <gregkh@suse.de>, <martyn.welch@ge.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] staging: vme: make match() driver specific to
 improve non-VME64x support
Message-ID: <20110901074601.GA3820@becoht-mvanga>
Mail-Followup-To: "Emilio G. Cota" <cota@braap.org>, gregkh@suse.de,
	martyn.welch@ge.com, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1314785146-19163-1-git-send-email-manohar.vanga@cern.ch>
 <1314785146-19163-4-git-send-email-manohar.vanga@cern.ch>
 <20110831212047.GB5339@flamenco.cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110831212047.GB5339@flamenco.cs.columbia.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Emilio,

On Wed, Aug 31, 2011 at 05:20:47PM -0400, Emilio G. Cota wrote:
> This was hard to review. There are references to functions that
> are not committed in Greg's tree yet ("staging" tree @ git.kernel.org).
> 
> I assume this patch was applied before you wrote the v4 patchset:
> 
> 	https://lkml.org/lkml/2011/8/12/107
>

I believe Greg has acked this patch (I received a confirmation mail from him).

> On Wed, Aug 31, 2011 at 12:05:46 +0200, Manohar Vanga wrote:
> (snip)
> > Another change introduced in this patch is that devices are now created
> > within the VME driver structure rather than in the VME bridge structure.
> > This way, things don't go haywire if the bridge driver is removed while
> > a driver is using it (this is also additionally prevented by having
> > reference counting of used bridge modules).
> 
> The mention to refcounting seems outdated. As I stated in my reply
> to v0, we should just safely remove devices under the bus when
> vme_unregister_bus() is called.

Ah right need to reword that.

> > -void vme_unregister_bridge(struct vme_bridge *bridge)
> > {
> > -	int i;
> > -	struct vme_dev *vdev;
> > -
> > -
> > -	for (i = 0; i < VME_SLOTS_MAX; i++) {
> > -		vdev = bridge->dev[i];
> > -		device_unregister(&vdev->dev);
> > - 	}
> > 	vme_remove_bus(bridge);
> > }
> 
> So we're essentially leaving the devices there, even though the
> bridge they're under will be removed. This doesn't seem right.
> btw with the removal of the array of vme_dev's from struct vme_bridge,
> the bridge cannot know which devices are under it.
> 
> We have to bear in mind that the drv->devices list needs to be
> updated when devices come and go; possibly a bridge->devices list
> could also be kept.
> 
> Helpers around device_register and _unregister may simplify the lists'
> housekeeping.

I was going to add a separate patch for this but I'll just integrate into this
one (makes more sense anyway).

And yes, I also noticed that the bridge no longer has track of its devices and
bridges will need to keep a list of them.

> > -	return retval;
> > +		if (vdev->dev.platform_data) {
> > +			list_add_tail(&vdev->list, &drv->devices);
> > +			drv->ndev++;
> 
> Ok, so drv->ndev can only increase. In case a device is removed (when
> a bus driver is removed) this may need to be decreased, which isn't
> done in the corresponding list_del() calls (I've marked them).
> 
> In fact I wonder whether it is useful at all to have drv->ndev. What's
> its purpose?

I'm not sure why I added that now...
It can be removed.

-- 
/manohar
