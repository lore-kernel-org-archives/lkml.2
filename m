Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960Ab1IJOQS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 10:16:18 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:3585 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201Ab1IJOQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 10:16:16 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 18/25] Staging: hv: storvsc: Eliminate the usage of ext
 field in struct  hv_device
Thread-Topic: [PATCH 18/25] Staging: hv: storvsc: Eliminate the usage of ext
 field in struct  hv_device
Thread-Index: AQHMbjARQYMNjgM550iKe9fLrUtEVZVF+5yAgACvKsA=
Date: Sat, 10 Sep 2011 14:16:14 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081DC4A1@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1315491843-9513-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-18-git-send-email-kys@microsoft.com>
 <20110909204451.GH19127@kroah.com>
In-Reply-To: <20110909204451.GH19127@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Friday, September 09, 2011 4:45 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> Subject: Re: [PATCH 18/25] Staging: hv: storvsc: Eliminate the usage of ext field in
> struct hv_device
> 
> On Thu, Sep 08, 2011 at 07:24:29AM -0700, K. Y. Srinivasan wrote:
> > Now, eliminate the usage of ext field in struct  hv_device for storvsc driver.
> > We do this by registering pointer to struct storvsc_device as the driver
> > specific data and eliminating the current usage of driver specific data to
> > save and retrieve the pointer to struct Scsi_Host.
> > Additionally, all access to the driver specific data is through
> > the vmbus wrapper functions.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  drivers/staging/hv/storvsc_drv.c |   24 +++++++++++++++---------
> >  1 files changed, 15 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
> > index 57c1035..98d47cd 100644
> > --- a/drivers/staging/hv/storvsc_drv.c
> > +++ b/drivers/staging/hv/storvsc_drv.c
> > @@ -266,6 +266,7 @@ struct storvsc_device {
> >  	bool	 destroy;
> >  	bool	 drain_notify;
> >  	atomic_t num_outstanding_req;
> > +	struct Scsi_Host *host;
> 
> You are properly reference counting this pointer, right?

The scsi_host_alloc() which we use to allocate the host structure, gives us
the needed reference.
> 
> > @@ -306,7 +307,8 @@ static inline struct storvsc_device
> *get_out_stor_device(
> >  {
> >  	struct storvsc_device *stor_device;
> >
> > -	stor_device = (struct storvsc_device *)device->ext;
> > +	stor_device =
> > +		(struct storvsc_device *)hv_get_drvdata(device);
> 
> Casting is not needed at all.
> 
> > @@ -1366,7 +1371,8 @@ static int storvsc_probe(struct hv_device *device,
> >  	stor_device->destroy = false;
> >  	init_waitqueue_head(&stor_device->waiting_to_drain);
> >  	stor_device->device = device;
> > -	device->ext = stor_device;
> > +	stor_device->host = host;
> > +	hv_set_drvdata(device, stor_device);
> 
> Lookie there, no reference count incremented, right?  Or did I miss it
> somewhere else?

We are stashing the pointer to a structure on which we already have a reference
(that was established at the point of allocating the host).

Regards,

K. Y
