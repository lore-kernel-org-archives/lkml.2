Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab1HXUSF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 16:18:05 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:45429 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752668Ab1HXURw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 16:17:52 -0400
X-Sasl-enc: Dsvjv5AxF+9qlfCztdDpZMuXaVNA+XhUNeRllHIs6P07 1314217071
Date: Wed, 24 Aug 2011 13:17:29 -0700
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 086/117] Staging: hv: storvsc: Leverage the spinlock to
 manage ref_cnt
Message-ID: <20110824201729.GB28667@kroah.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-86-git-send-email-kys@microsoft.com>
 <20110823231028.GO9641@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081B239E@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110824025737.GA30779@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081B2789@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E048081B2789@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 04:25:18PM +0000, KY Srinivasan wrote:
> > > > On Fri, Jul 15, 2011 at 10:47:14AM -0700, K. Y. Srinivasan wrote:
> > > > > Now that we have a spin lock protecting access to the stor device pointer,
> > > > > use it manage the reference count as well.
> > > > >
> > > > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > > > ---
> > > > >  drivers/staging/hv/hyperv_storage.h |    8 ++++----
> > > > >  drivers/staging/hv/storvsc.c        |   10 +++++-----
> > > > >  2 files changed, 9 insertions(+), 9 deletions(-)
> > > > >
> > > > > diff --git a/drivers/staging/hv/hyperv_storage.h
> > > > b/drivers/staging/hv/hyperv_storage.h
> > > > > index 53b65be..d946211 100644
> > > > > --- a/drivers/staging/hv/hyperv_storage.h
> > > > > +++ b/drivers/staging/hv/hyperv_storage.h
> > > > > @@ -265,7 +265,7 @@ struct storvsc_device {
> > > > >  	struct hv_device *device;
> > > > >
> > > > >  	/* 0 indicates the device is being destroyed */
> > > > > -	atomic_t ref_count;
> > > > > +	int	 ref_count;
> > > >
> > > > Is this really needed?  Can't you rely on the reference count of the
> > > > hv_device itself?
> > >
> > > We don't have a reference count on the hv_device
> > 
> > Wait, why not?  You shure better have a reference count on that device
> > if you have a pointer to it, if not, you have a bug, and that needs to
> > be fixed.  Please reread Documentation/CodingStyle for details.
> 
> Greg,
> 
> I am confused here. The model we have is identical to other device/bus
> abstractions in the kernel. For instance, neither  struct pci_dev nor struct
> virtio_device have an explicit reference count. However, they both embed
> struct device which  has the kobject structure embedded to manage
> the object life cycle. This is exactly the model we have for the vmbus devices -
> struct hv_device embeds struct device that embeds the struct kobject for
> managing the lifecycle.

Yes, that is correct.

> Like other  bus specific devices in the kernel (pci devices, virtio devices,),  
> class specific vmbus devices - struct storvsc_device and struct netvsc_device 
> embed a pointer to the underlying struct hv_device.

And when you save that pointer, you ARE incrementing the reference count
properly, right?  If not, you just caused a bug.

> Furthermore, a pointer to the class specific device structure is
> stashed in the struct hv_device (the ext pointer).
> This is identical what is done in the virtio blk device - look at the
> priv element in struct virtio_device.

Yes, but the "base" structure of virtio_device does not contain a lock
that the users of that priv pointer are using to control access to data
_within_ the priv pointer, right?

That's up to the users within the priv pointer.

Now I see how you were trying to move the lock "deeper" as it seemed
that everyone needed it, but you just moved the lock away from the thing
that it was trying to protect, which might cause problems, and at the
least, is confusing as heck because you are mixing two different layers
here, in ways that should not be mixed.

If you really need a lock to protect some private data within the priv
pointer, then put it somewhere else,like in the priv pointer, as almost
all other subsystems do.

greg k-h
