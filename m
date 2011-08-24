Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab1HXW5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 18:57:21 -0400
Received: from smtp.microsoft.com ([131.107.115.214]:42851 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab1HXW5U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 18:57:20 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 086/117] Staging: hv: storvsc: Leverage the spinlock to
 manage ref_cnt
Thread-Topic: [PATCH 086/117] Staging: hv: storvsc: Leverage the spinlock to
 manage ref_cnt
Thread-Index: AQHMQxTTgKIq9Plk/0mMzxNJa+Ov05UrwuAA//+oJ+CAAJdQgIAAWkTwgADIRYD//6WAsA==
Date: Wed, 24 Aug 2011 22:57:18 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081B2A33@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-86-git-send-email-kys@microsoft.com>
 <20110823231028.GO9641@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081B239E@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110824025737.GA30779@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081B2789@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110824201729.GB28667@kroah.com>
In-Reply-To: <20110824201729.GB28667@kroah.com>
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
> Sent: Wednesday, August 24, 2011 4:17 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> Subject: Re: [PATCH 086/117] Staging: hv: storvsc: Leverage the spinlock to
> manage ref_cnt
> 
> On Wed, Aug 24, 2011 at 04:25:18PM +0000, KY Srinivasan wrote:
> > > > > On Fri, Jul 15, 2011 at 10:47:14AM -0700, K. Y. Srinivasan wrote:
> > > > > > Now that we have a spin lock protecting access to the stor device
> pointer,
> > > > > > use it manage the reference count as well.
> > > > > >
> > > > > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > > > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > > > > ---
> > > > > >  drivers/staging/hv/hyperv_storage.h |    8 ++++----
> > > > > >  drivers/staging/hv/storvsc.c        |   10 +++++-----
> > > > > >  2 files changed, 9 insertions(+), 9 deletions(-)
> > > > > >
> > > > > > diff --git a/drivers/staging/hv/hyperv_storage.h
> > > > > b/drivers/staging/hv/hyperv_storage.h
> > > > > > index 53b65be..d946211 100644
> > > > > > --- a/drivers/staging/hv/hyperv_storage.h
> > > > > > +++ b/drivers/staging/hv/hyperv_storage.h
> > > > > > @@ -265,7 +265,7 @@ struct storvsc_device {
> > > > > >  	struct hv_device *device;
> > > > > >
> > > > > >  	/* 0 indicates the device is being destroyed */
> > > > > > -	atomic_t ref_count;
> > > > > > +	int	 ref_count;
> > > > >
> > > > > Is this really needed?  Can't you rely on the reference count of the
> > > > > hv_device itself?
> > > >
> > > > We don't have a reference count on the hv_device
> > >
> > > Wait, why not?  You shure better have a reference count on that device
> > > if you have a pointer to it, if not, you have a bug, and that needs to
> > > be fixed.  Please reread Documentation/CodingStyle for details.
> >
> > Greg,
> >
> > I am confused here. The model we have is identical to other device/bus
> > abstractions in the kernel. For instance, neither  struct pci_dev nor struct
> > virtio_device have an explicit reference count. However, they both embed
> > struct device which  has the kobject structure embedded to manage
> > the object life cycle. This is exactly the model we have for the vmbus devices -
> > struct hv_device embeds struct device that embeds the struct kobject for
> > managing the lifecycle.
> 
> Yes, that is correct.
> 
> > Like other  bus specific devices in the kernel (pci devices, virtio devices,),
> > class specific vmbus devices - struct storvsc_device and struct netvsc_device
> > embed a pointer to the underlying struct hv_device.
> 
> And when you save that pointer, you ARE incrementing the reference count
> properly, right?  If not, you just caused a bug.

Why do you say that. This assignment is done in the probe function where the 
driver core is invoking the driver specific probe function. In the driver specific
probe function, I allocate class specific device state and embed the bus specific
device pointer. So, I would think the driver core is taking the appropriate reference
count. What I am doing is exactly what other PCI and virtio drivers are doing. For instance,
in virtio_blk.c , virtblk_probe() function, the virtio_device pointer is stashed away in the 
virtio_blk structure in exactly the same way I am doing. I suspect the assumption here is that
if probe succeeded, then the remove() function would be called to let the driver cleanup the state.

> 
> > Furthermore, a pointer to the class specific device structure is
> > stashed in the struct hv_device (the ext pointer).
> > This is identical what is done in the virtio blk device - look at the
> > priv element in struct virtio_device.
> 
> Yes, but the "base" structure of virtio_device does not contain a lock
> that the users of that priv pointer are using to control access to data
> _within_ the priv pointer, right?

True. As I noted in an earlier email, the current hyper-v driver code has logic
to deal with the race conditions I have described. It is just that the current 
implementation is completely bogus - look at for instance the function
must_get_stor_device() in storvsc.c. This function is invoked in the channel
callback code path to process messages coming from the host. I added this lock
to close the window in getting the ext pointer. Clearly the lock protecting the 
ext pointer must be in a structure whose persistence is guaranteed and that is the reason
I put the lock in the struct hv_device.

> 
> That's up to the users within the priv pointer.
> 
> Now I see how you were trying to move the lock "deeper" as it seemed
> that everyone needed it, but you just moved the lock away from the thing
> that it was trying to protect, which might cause problems, and at the
> least, is confusing as heck because you are mixing two different layers
> here, in ways that should not be mixed.
> 
> If you really need a lock to protect some private data within the priv
> pointer, then put it somewhere else,like in the priv pointer, as almost
> all other subsystems do.

What is being protected is the ext pointer that points to the class specific device state.
This state is freed when the driver is unloaded (in the remove function). The typical access
to the class specific device structure occurs given the pointer to bus specific device structure
struct hv_device. In the current code this transformation is done in functions such as
get_stor_device() and must_get_stor_device(). As you can see the logic in these function is 
broken since there are multiple windows. The lock I introduced was to close the windows I saw in 
these functions (similar functions exist on the netvsc side as well - get_inbound_net_device()
and get_outbound_net_device() in netvsc.c). I just tried to cleanup these functions with an easy to
understand logic to ensure the stability of the ext pointer.

Regards,

K. Y

