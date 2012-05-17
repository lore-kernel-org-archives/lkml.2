Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761422Ab2EQJVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 05:21:04 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:63973 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759500Ab2EQJVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 05:21:00 -0400
From: Liu Ping Fan <kernelfans@gmail.com>
To: kvm@vger.kernel.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, qemu-devel@nongnu.org,
        Avi Kivity <avi@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Ryan Harper <ryanh@us.ibm.com>, Shirley Ma <xma@us.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Tom Lendacky <toml@us.ibm.com>
Subject: [RFC:kvm] export host NUMA info to guest & make emulated device NUMA attr
Date: Thu, 17 May 2012 17:20:52 +0800
Message-Id: <1337246456-30909-1-git-send-email-kernelfans@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the guest can not know the NUMA info of the vcpu, which will
result in performance drawback.

This is the discovered and experiment by
        Shirley Ma <xma@us.ibm.com>
        Krishna Kumar <krkumar2@in.ibm.com>
        Tom Lendacky <toml@us.ibm.com>
Refer to - http://www.mail-archive.com/kvm@vger.kernel.org/msg69868.html
we can see the big perfermance gap between NUMA aware and unaware.

Enlightened by their discovery, I think, we can do more work -- that is to
export NUMA info of host to guest.

So here comes the idea:
1. export host numa info through guest's sched domain to its scheduler
  Export vcpu's NUMA info to guest scheduler(I think mem NUMA problem
  has been handled by host).  So the guest's lb will consider the cost.
  I am still working on this, and my original idea is to export these info
  through "static struct sched_domain_topology_level *sched_domain_topology"
  to guest.

2. Do a better emulation of virt mach exported to guest.
  In real world, the devices are limited by kinds of reasons to own the NUMA
  property. But as to Qemu, the device is emulated by thread, which inherit
  the NUMA attr in nature.  We can implement the device as components of many
  logic units, each of the unit is backed by a thread in different host node.
  Currently, I want to start the work on vhost. But I think, maybe in
  future, the iothread in Qemu can also has such attr.


Forgive me, for the limited time, I can not have more better understand of
vhost/virtio_net drivers. These patches are just draft, _FAR_, _FAR_ from work.
I will do more detail work for them in future.

To easy the review, the following is the sum up of the 2nd point of the idea.
As for the 1st point of the idea, it is not reflected in the patches.

--spread/shrink the vhost_workers over the host nodes as demanded from Qemu.
  And we can consider each vhost_worker as an independent net logic device
  embeded in physical device "vhost_net".  At the meanwhile, we spread vcpu
  threads over the host node. 
  The vrings on guest are allocated PAGE_SIZE align separately, so they can 
  will only be mapped into different host node, so vhost_worker in the same
  node can access it with the least cost. So does the vq on guest.

--virtio_net driver will changes and talk with the logic device. And which
  logic device it will talk to is determined by on which vcpu it is scheduled.

--the binding of vcpus and vhost_worker is implemented by: 
  for call direction, vq-a in the node-A will have a dedicated irq-a. And 
  we set the irq-a's affinity to vcpus in node-A.
  for kick direction, kick register-b trigger different eventfd-b which wake up
  vhost_worker-b.


Please give some comments and suggestion.

Thanks and regards,
pingfan

