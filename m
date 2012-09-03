Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab2ICURf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 16:17:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756371Ab2ICURe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 16:17:34 -0400
Date: Mon, 3 Sep 2012 23:18:47 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sjur =?iso-8859-1?Q?Br=E6ndeland?= <sjurbren@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        "Guzman Lugo, Fernadndo" <fernando.lugo@ti.com>,
        virtualization@lists.linux-foundation.org,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [PATCH] virtio: Don't access device data after unregistration.
Message-ID: <20120903201847.GC6181@redhat.com>
References: <1346680242-5717-1-git-send-email-sjur.brandeland@stericsson.com>
 <20120903141445.GA5054@redhat.com>
 <CAJK669aRsbOOmjmT+K8OHYvenOhkYWuSOx6nBM7hxC_C4mmw-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJK669aRsbOOmjmT+K8OHYvenOhkYWuSOx6nBM7hxC_C4mmw-g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2012 at 04:50:10PM +0200, Sjur Brændeland wrote:
> Hi Michael,
> 
> >> Fix panic in virtio.c when CONFIG_DEBUG_SLAB is set.
> >
> > What's the root cause of the panic?
> 
> I believe the cause of the panic is calling
> ida_simple_remove(&virtio_index_ida, dev->index);
> when the dev structure is "poisoned" after kfree.
> It might be the "BUG_ON((int)id < 0)" that bites...
> 
> >> Use device_del() and put_device() instead of
> >> device_unregister(), and access device data before
> >> calling put_device().
> 
> > Why does this help? Does device_unregister free the
> > device so dev->index access crashes?
> 
> Yes, if device ref-count is one when calling unregister
> the device is freed.

Interesting. Where exactly? Note that:

struct rproc_vdev {
        struct list_head node;
        struct rproc *rproc;
        struct virtio_device vdev;
        struct rproc_vring vring[RVDEV_NUM_VRINGS];
        unsigned long dfeatures;
        unsigned long gfeatures;
};              

kfree(&proc_vdev->vdev) is unlikely to be the right thing to do.

> > If yes virtio_pci_remove will crash too
> > as it accesses the device after the
> > call to unregister_virtio_device so the
> > fix won't be effective.
> 
> I discovered this using the remoteproc framework.
> It might be that device is unregistered with ref-count greater
> than one normally, in that case this bug will not show up.
> 
> Regards,
> Sjur

It might be remoteproc has an unrelated bug?

-- 
MST
