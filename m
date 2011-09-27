Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab1I0IMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 04:12:09 -0400
Received: from cernmx30.cern.ch ([137.138.144.177]:8102 "EHLO CERNMX30.cern.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079Ab1I0IMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 04:12:07 -0400
Date: Tue, 27 Sep 2011 10:08:24 +0200
From: Manohar Vanga <manohar.vanga@cern.ch>
To: "Emilio G. Cota" <cota@braap.org>
CC: <gregkh@suse.de>, <martyn.welch@ge.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] staging: vme: make match() driver specific to
 improve non-VME64x support
Message-ID: <20110927080824.GB17775@becoht-mvanga>
Mail-Followup-To: "Emilio G. Cota" <cota@braap.org>, gregkh@suse.de,
	martyn.welch@ge.com, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1317029238-13357-1-git-send-email-manohar.vanga@cern.ch>
 <1317029238-13357-3-git-send-email-manohar.vanga@cern.ch>
 <20110926232906.GB13175@flamenco.cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110926232906.GB13175@flamenco.cs.columbia.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
> > index 76e08f3..9cb6938 100644
> > --- a/drivers/staging/vme/vme.c
> > +++ b/drivers/staging/vme/vme.c
> > @@ -1317,6 +1317,7 @@ static int vme_add_bus(struct vme_bridge *bridge)
> >  		if ((vme_bus_numbers & (1 << i)) == 0) {
> >  			vme_bus_numbers |= (1 << i);
> >  			bridge->num = i;
> > +			INIT_LIST_HEAD(&bridge->devices);
> >  			list_add_tail(&bridge->bus_list, &vme_bus_list);
> 
> Just realised that vme_buses_lock also protects vme_bus_list; appending
> to this list here should be protected by the mutex, otherwise
> vme_add_bus (ie this function) could race with __vme_register_driver,
> which might access a corrupt copy of the list.
> 
> Note that vme_remove_bus does the right thing though; it acquires
> the lock before unpinning the bridge from vme_bus_list.

It _does_ acquire the lock. The patch here doesn't show it:

	mutex_lock(&vme_buses_lock);
	for (i = 0; i < sizeof(vme_bus_numbers) * 8; i++) {
		if ((vme_bus_numbers & (1 << i)) == 0) {
			vme_bus_numbers |= (1 << i);
			bridge->num = i;
			INIT_LIST_HEAD(&bridge->devices);
			list_add_tail(&bridge->bus_list, &vme_bus_list);
			ret = 0;
			break;
		}
	}
	mutex_unlock(&vme_buses_lock);

This was submitted and acknowledged by Martyn in a previous patch:
	https://lkml.org/lkml/2011/8/12/107

Thanks!

-- 
/manohar
