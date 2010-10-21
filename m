Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab0JUBQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 21:16:31 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38012 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338Ab0JUBQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 21:16:29 -0400
Date: Thu, 21 Oct 2010 12:16:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Alexander Graf <agraf@suse.de>
Subject: linux-next: manual merge of the kvm tree with the s390 tree
Message-Id: <20101021121623.fedb389e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the kvm tree got a conflict in
drivers/s390/kvm/kvm_virtio.c between commit
b154e491c5d11f44a4804ec6d073312db06e97ef ("[S390] cleanup lowcore access
from external interrupts") from the s390 tree and commit
d9ca0637f9ab805ab7b23b0dc8362bf68f22fed0 ("KVM: S390: take a full byte as
ext_param indicator") from the kvm tree.

I fixed it up (hopefully - see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/s390/kvm/kvm_virtio.c
index a264e1c,5a46b8c..0000000
--- a/drivers/s390/kvm/kvm_virtio.c
+++ b/drivers/s390/kvm/kvm_virtio.c
@@@ -328,27 -329,68 +329,69 @@@ static void scan_devices(void
  }
  
  /*
+  * match for a kvm device with a specific desc pointer
+  */
+ static int match_desc(struct device *dev, void *data)
+ {
+ 	if ((ulong)to_kvmdev(dev_to_virtio(dev))->desc == (ulong)data)
+ 		return 1;
+ 
+ 	return 0;
+ }
+ 
+ /*
+  * hotplug_device tries to find changes in the device page.
+  */
+ static void hotplug_devices(struct work_struct *dummy)
+ {
+ 	unsigned int i;
+ 	struct kvm_device_desc *d;
+ 	struct device *dev;
+ 
+ 	for (i = 0; i < PAGE_SIZE; i += desc_size(d)) {
+ 		d = kvm_devices + i;
+ 
+ 		/* end of list */
+ 		if (d->type == 0)
+ 			break;
+ 
+ 		/* device already exists */
+ 		dev = device_find_child(kvm_root, d, match_desc);
+ 		if (dev) {
+ 			/* XXX check for hotplug remove */
+ 			put_device(dev);
+ 			continue;
+ 		}
+ 
+ 		/* new device */
+ 		printk(KERN_INFO "Adding new virtio device %p\n", d);
+ 		add_kvm_device(d, i);
+ 	}
+ }
+ 
+ /*
   * we emulate the request_irq behaviour on top of s390 extints
   */
 -static void kvm_extint_handler(u16 code)
 +static void kvm_extint_handler(unsigned int ext_int_code,
 +			       unsigned int param32, unsigned long param64)
  {
  	struct virtqueue *vq;
  	u16 subcode;
- 	int config_changed;
+ 	u32 param;
  
 -	subcode = S390_lowcore.cpu_addr;
 +	subcode = ext_int_code >> 16;
  	if ((subcode & 0xff00) != VIRTIO_SUBCODE_64)
  		return;
  
  	/* The LSB might be overloaded, we have to mask it */
 -	vq = (struct virtqueue *)(S390_lowcore.ext_params2 & ~1UL);
 +	vq = (struct virtqueue *)(param64 & ~1UL);
  
- 	/* We use the LSB of extparam, to decide, if this interrupt is a config
- 	 * change or a "standard" interrupt */
- 	config_changed = param32 & 1;
+ 	/* We use ext_params to decide what this interrupt means */
 -	param = S390_lowcore.ext_params & VIRTIO_PARAM_MASK;
++	param = param32 & VIRTIO_PARAM_MASK;
  
- 	if (config_changed) {
+ 	switch (param) {
+ 	case VIRTIO_PARAM_CONFIG_CHANGED:
+ 	{
  		struct virtio_driver *drv;
  		drv = container_of(vq->vdev->dev.driver,
  				   struct virtio_driver, driver);
