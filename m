Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab1DKJMD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 05:12:03 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:49700 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab1DKJMB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 05:12:01 -0400
Date: Mon, 11 Apr 2011 05:11:28 -0400 (EDT)
From: Takuma Umeya <tumeya@redhat.com>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: virtualization@lists.linux-foundation.org,
        Stephen Hemminger <shemminger@vyatta.com>,
        linux-kernel@vger.kernel.org
Message-ID: <1526578879.12280.1302513088278.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
In-Reply-To: <BANLkTi=DGfKuapLhvt62UVG_h7fzsRRo3g@mail.gmail.com>
Subject: Re: [PATCH] virtio: decrement dev_index when device is unregistered
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 6.0.9_GA_2686 (ZimbraWebClient - FF3.0 (Linux)/6.0.9_GA_2686)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> On Tue, Apr 5, 2011 at 5:49 AM, Takuma Umeya <tumeya@redhat.com>
> wrote:
> > When virtio device is removed, dev_index does not get decremented.
> > The next device hotplug event results in consuming the next pci to
> > the one that is suppose to be available.
> >
> > Signed-off-by: Takuma Umeya <tumeya@redhat.com>
> >
> > diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> > index efb35aa..67fe71d 100644
> > --- a/drivers/virtio/virtio.c
> > +++ b/drivers/virtio/virtio.c
> > @@ -216,6 +216,7 @@ EXPORT_SYMBOL_GPL(register_virtio_device);
> >  void unregister_virtio_device(struct virtio_device *dev)
> >  {
> >        device_unregister(&dev->dev);
> > + dev_index--;
> 
> I don't think there is any guarantee that virtio devices are
> added/removed in first-in-last-out order.
> 
> That means I could add a virtio-net device (index 0) followed by a
> virtio-blk device (index 1). Now I remove the virtio-net device
> (index 0) which causes me to decrement dev_index and hand index 1 out
> again to the next device. This leaves us with virtio-blk (index 1)
> and the new device with index 1, which is not unique.
> 
> Perhaps I missed a constraint which prevents this from occurring?
I believe the address is assigned up to 1f so using u32 value 
to track use/free. This should make the code immune to the scenario. 
Would this be adequate? 

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index efb35aa..0c73507 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -3,7 +3,7 @@
 #include <linux/virtio_config.h>
 
 /* Unique numbering for virtio devices. */
-static unsigned int dev_index;
+static u32 dev_index;
 
 static ssize_t device_show(struct device *_d,
                           struct device_attribute *attr, char *buf)
@@ -187,12 +187,23 @@ EXPORT_SYMBOL_GPL(unregister_virtio_driver);
 
 int register_virtio_device(struct virtio_device *dev)
 {
-       int err;
+       int err, count;
+       u32 testbit;
+
+       count = 0; 
 
        dev->dev.bus = &virtio_bus;
 
        /* Assign a unique device index and hence name. */
-       dev->index = dev_index++;
+       while (count < 32){
+            testbit = 1UL << count;
+            if(!(dev_index & testbit)){
+                dev->index = count;
+                dev_index |= testbit;
+                break;
+            }
+            count++;
+        }
        dev_set_name(&dev->dev, "virtio%u", dev->index);
 
        /* We always start by resetting the device, in case a previous
@@ -215,7 +226,13 @@ EXPORT_SYMBOL_GPL(register_virtio_device);
 
 void unregister_virtio_device(struct virtio_device *dev)
 {
+       u32 removebit;
+
+        removebit = 1UL << (dev->index);
+
        device_unregister(&dev->dev);
+
+       dev_index ^= removebit;
 }
 EXPORT_SYMBOL_GPL(unregister_virtio_device);
 
> 
> Stefan
