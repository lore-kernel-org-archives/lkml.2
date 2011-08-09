Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab1HISuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 14:50:05 -0400
Received: from statler.bytemark.co.uk ([212.110.162.18]:44376 "EHLO
	statler.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab1HISuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 14:50:03 -0400
Date: Tue, 9 Aug 2011 14:49:44 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] staging: vme: add functions for bridge module
 refcounting
Message-ID: <20110809184944.GA28746@flamenco.cs.columbia.edu>
References: <4E39555C.30507@ge.com>
 <20110803140630.GA29460@becoht-mvanga>
 <20110803152317.GA21903@flamenco.cs.columbia.edu>
 <4E3A4904.3040007@ge.com>
 <20110804163451.GA18422@flamenco.cs.columbia.edu>
 <4E3B9FA2.3060303@ge.com>
 <20110805090416.GA4806@becoht-mvanga>
 <4E3BB6E7.6020809@ge.com>
 <20110809132413.GA9762@becoht-mvanga>
 <4E414381.7070808@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E414381.7070808@ge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 15:26:09 +0100, Martyn Welch wrote:
> On 09/08/11 14:24, Manohar Vanga wrote:
> > If we really don't want explicit module refcounting by drivers, can we perhaps use
> > the return value of the probe to automatically do this? eg. in vme_bus_probe() like
> > below:
> > 
> >     int ret = 0;
> >     ...
> >     vme_bridge_get(bridge);
> >     if (driver->probe)
> >             ret = driver->probe(vdev);
> >     if (ret)
> >         vme_bridge_put(bridge);
> >     return ret;
> > 
> > Just a thought. Feel free to shoot it down if you think it's the incorrect
> > approach :P
> > 
> 
> After looking at the PCI and RapidIO subsystems, I think this is probably the
> correct approach. I guess the only quiestion then is at which point is
> vme_bridge_put() called assuming the probe is successful. I guess at module
> unload time, though I haven't checked in the PCI and RapidIO code.

This works as long as all devices are tied to the driver
loading; i.e. when the devices can only be removed when the
driver is removed.  A device might go away while the driver
still manages other devices of the same kin; this is why
particular drivers explicitly manage the get/put in
.probe/.release.

In vme we may one day have hotplug (VME64x supports it IIRC),
but we're not quite there yet. One can remove devices from
sysfs anytime though.

I still think the original patch is the sane way to go.

		Emilio
