Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752Ab1CBBkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 20:40:21 -0500
Received: from mailb.microsoft.com ([131.107.115.215]:41398 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631Ab1CBBkT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 20:40:19 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Hank Janssen" <hjanssen@microsoft.com>
Subject: RE: [PATCH 1/6] Staging: hv: Unify hyper-v device abstractions
Thread-Topic: [PATCH 1/6] Staging: hv: Unify hyper-v device abstractions
Thread-Index: AQHL1VhrHb+LNqEePk278h0j8A42rZQYTeOAgADhvzA=
Date: Wed, 2 Mar 2011 01:40:17 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0480165E6@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1298685930-30806-1-git-send-email-kys@microsoft.com>
 <20110301023449.GC1663@kroah.com>
In-Reply-To: <20110301023449.GC1663@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.72]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Monday, February 28, 2011 9:35 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang; Hank
> Janssen
> Subject: Re: [PATCH 1/6] Staging: hv: Unify hyper-v device abstractions
> 
> On Fri, Feb 25, 2011 at 06:05:30PM -0800, K. Y. Srinivasan wrote:
> > Hyper-V drivers have supported two device abstractions.
> > This patch implements a single device abstraction.
> 
> "This patch" or "This patch series"?

Greg, If you recall, last week I had sent a single patch that did what these 6 patches do.
While I agree, the description could have been more informative; I have tried to 
follow the guidelines I got in terms of what should  go into each patch:

The first set of 3 patches (1 through 3) deal with the device related issues:
Patch 1: Combines the state in hv_device into vm_device to create a 
single device abstraction called vm_device.
Patch 2: Changes the name of vm_device to hyperv_device.
Patch 3: Cleanup the names of variables that refer to hyperv_device
 
  
Next set of 3 patches (4 through 6) deal with the driver related issues:

Patch 4: Combines the state maintained in  hv_driver into driver_context to
Create a single driver abstraction called driver_context.

Patch 5: Renames the driver context to hyperv_driver.

Patch 6: Cleanup the names of variables that refer to hyperv_driver.

I am beginning to wonder if perhaps I chose the wrong granularity in splitting
up these patches.

Regards,

K. Y 

> 
> > This simplifies the code and avoids duplication
> > of state.
> 
> This patch is confusing, you are renaming structures (from hv_ to vm_)
> which I didn't think you wanted to do.
> 
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> >
> > ---
> >  drivers/staging/hv/blkvsc.c        |   17 ++++---
> >  drivers/staging/hv/blkvsc_drv.c    |   14 +++---
> >  drivers/staging/hv/channel_mgmt.c  |    1 +
> >  drivers/staging/hv/channel_mgmt.h  |    2 +-
> >  drivers/staging/hv/netvsc.c        |   55 ++++++++++++-----------
> >  drivers/staging/hv/netvsc.h        |    2 +-
> >  drivers/staging/hv/netvsc_api.h    |   12 +++---
> >  drivers/staging/hv/netvsc_drv.c    |   28 +++++-------
> >  drivers/staging/hv/rndis_filter.c  |   19 ++++----
> >  drivers/staging/hv/storvsc.c       |   37 ++++++++--------
> >  drivers/staging/hv/storvsc_api.h   |    4 +-
> >  drivers/staging/hv/storvsc_drv.c   |   21 ++++-----
> >  drivers/staging/hv/vmbus.h         |   13 +++---
> >  drivers/staging/hv/vmbus_api.h     |   29 ++----------
> >  drivers/staging/hv/vmbus_drv.c     |   84 +++++++++++++++---------------------
> >  drivers/staging/hv/vmbus_private.h |   12 +++---
> >  16 files changed, 157 insertions(+), 193 deletions(-)
> >
> > diff --git a/drivers/staging/hv/blkvsc.c b/drivers/staging/hv/blkvsc.c
> > index 7c8729b..ecface3 100644
> > --- a/drivers/staging/hv/blkvsc.c
> > +++ b/drivers/staging/hv/blkvsc.c
> > @@ -35,7 +35,8 @@ static const struct hv_guid g_blk_device_type = {
> >  	}
> >  };
> >
> > -static int blk_vsc_on_device_add(struct hv_device *device, void
> *additional_info)
> > +static int blk_vsc_on_device_add(struct vm_device *device,
> > +				void *additional_info)
> 
> Huh?  What was this change for?  80 column issues for function
> definitions is not a big deal, if any, and should not be burried in a
> patch that claims to do something else.
> 
> Still totally confused,
> 
> greg k-h

