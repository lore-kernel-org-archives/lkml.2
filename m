Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab1HYCqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 22:46:34 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:59632 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753251Ab1HYCq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 22:46:28 -0400
X-Sasl-enc: 2qj61oV+08Y/uxmFpB+nu7+2ZTURDnuLUQlX3OKGWVWH 1314240387
Date: Wed, 24 Aug 2011 19:45:13 -0700
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 086/117] Staging: hv: storvsc: Leverage the spinlock to
 manage ref_cnt
Message-ID: <20110825024513.GC6131@kroah.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-86-git-send-email-kys@microsoft.com>
 <20110823231028.GO9641@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081B239E@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110824025737.GA30779@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081B2789@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110824201729.GB28667@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081B2A33@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E048081B2A33@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 10:57:18PM +0000, KY Srinivasan wrote:
> > > Like other  bus specific devices in the kernel (pci devices, virtio devices,),
> > > class specific vmbus devices - struct storvsc_device and struct netvsc_device
> > > embed a pointer to the underlying struct hv_device.
> > 
> > And when you save that pointer, you ARE incrementing the reference count
> > properly, right?  If not, you just caused a bug.
> 
> Why do you say that. This assignment is done in the probe function where the 
> driver core is invoking the driver specific probe function.

But if you save a pointer, you HAVE to increment the reference count.

> In the driver specific probe function, I allocate class specific
> device state and embed the bus specific device pointer. So, I would
> think the driver core is taking the appropriate reference count. What
> I am doing is exactly what other PCI and virtio drivers are doing. For
> instance, in virtio_blk.c , virtblk_probe() function, the
> virtio_device pointer is stashed away in the virtio_blk structure in
> exactly the same way I am doing. I suspect the assumption here is that
> if probe succeeded, then the remove() function would be called to let
> the driver cleanup the state.

Yes, but that's a bug, the pointer reference count should be
incremented.

Look at drivers/usb/usb-skeleton.c for a well-documented way to handle a
driver that works with a bus that has devices that could go away at any
point in time.  It handles the reference count, and the locking
correctly, and has been audited by lots of people.

> > > Furthermore, a pointer to the class specific device structure is
> > > stashed in the struct hv_device (the ext pointer).
> > > This is identical what is done in the virtio blk device - look at the
> > > priv element in struct virtio_device.
> > 
> > Yes, but the "base" structure of virtio_device does not contain a lock
> > that the users of that priv pointer are using to control access to data
> > _within_ the priv pointer, right?
> 
> True. As I noted in an earlier email, the current hyper-v driver code has logic
> to deal with the race conditions I have described. It is just that the current 
> implementation is completely bogus - look at for instance the function
> must_get_stor_device() in storvsc.c. This function is invoked in the channel
> callback code path to process messages coming from the host. I added this lock
> to close the window in getting the ext pointer. Clearly the lock protecting the 
> ext pointer must be in a structure whose persistence is guaranteed and that is the reason
> I put the lock in the struct hv_device.

But no, that's not the way to do it, put it in the structure that has
the data you are trying to protect.

greg k-h
