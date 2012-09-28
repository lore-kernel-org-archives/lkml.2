Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab2I1JYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 05:24:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab2I1JYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 05:24:33 -0400
Date: Fri, 28 Sep 2012 11:26:00 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Thomas Lendacky <tahm@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Sasha Levin <levinsasha928@gmail.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 0/3] virtio-net: inline header support
Message-ID: <cover.1348824232.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thinking about Sasha's patches, we can reduce ring usage
for virtio net small packets dramatically if we put
virtio net header inline with the data.
This can be done for free in case guest net stack allocated
extra head room for the packet, and I don't see
why would this have any downsides.

Even though with my recent patches qemu
no longer requires header to be the first s/g element,
we need a new feature bit to detect this.
A trivial qemu patch will be sent separately.

We could get rid of an extra s/g for big packets too,
but since in practice everyone enables mergeable buffers,
I don't see much of a point.

Rusty, if you decide to pick this up I'll send a
(rather trivial) spec patch shortly afterwards, but holidays
are beginning here. Considering how simple
the guest patch is, I hope it can make it in 3.7?

Also note that patch 1 and 2 are IMO a good
idea without patch 3. If you decide to defer patch 3
pls consider 1/2 separately.

Before:
[root@virtlab203 qemu]# ssh robin ./netperf/bin/netperf -t TCP_RR -H
11.0.0.4
TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to
11.0.0.4 (11.0.0.4) port 0 AF_INET : demo
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate         
bytes  Bytes  bytes    bytes   secs.    per sec   

16384  87380  1        1       10.00    2992.88   
16384  87380 

After:
[root@virtlab203 qemu]# ssh robin ./netperf/bin/netperf -t TCP_RR -H
11.0.0.4
TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to
11.0.0.4 (11.0.0.4) port 0 AF_INET : demo
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate         
bytes  Bytes  bytes    bytes   secs.    per sec   

16384  87380  1        1       10.00    3195.57   
16384  87380 

Michael S. Tsirkin (3):
  virtio: add API to query ring capacity
  virtio-net: correct capacity math on ring full
  virtio-net: put virtio net header inline with data

 drivers/net/virtio_net.c     | 57 +++++++++++++++++++++++++++++++-------------
 drivers/virtio/virtio_ring.c | 19 +++++++++++++++
 include/linux/virtio.h       |  2 ++
 include/linux/virtio_net.h   |  5 +++-
 4 files changed, 66 insertions(+), 17 deletions(-)

-- 
MST
