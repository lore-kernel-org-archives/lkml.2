Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab1JBJsU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 05:48:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994Ab1JBJsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 05:48:15 -0400
Date: Sun, 2 Oct 2011 11:49:21 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] virtio: Support for hibernation (S4)
Message-ID: <20111002094920.GF29706@redhat.com>
References: <cover.1317309123.git.amit.shah@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1317309123.git.amit.shah@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 08:55:56PM +0530, Amit Shah wrote:
> Hello,
> 
> These patches add support for S4 to virtio (pci) and all drivers.  The
> patches are based on the virtio-console patch series in Rusty's queue.
> 
> For each driver, all vqs are removed before hibernation, and then
> re-created after restore.
> 
> All the drivers in testing work fine:
> 
> * virtio-blk is used for the only disk in the VM, IO works fine before
>   and after.
> 
> * virtio-console: port IO keeps working fine before and after.
>   * If a port is waiting for data from the host (blocking read(2)
>     call), this works fine in both the cases: host-side connection is
>     available or unavailable after resume.  In case the host-side
>     connection isn't available, the blocking call is terminated.  If
>     it is available, the call continues to remain in blocked state
>     till further data arrives.
> 
> * virtio-net: ping remains active across S4.  One packet is lost.
>   (Current qemu.git has a regression in slirp code causing qemu
>   segfault, commit 1ab74cea060 is the offender).
> 
> * virtio-balloon: Works fine before and after.  Forgets the ballooned
>   value across S4.  If it's desirable to maintain the ballooned value,
>   a new config option can be created to do this.
> 
> All in all, this looks pretty good.
> 
> Please review and apply.

So a general comment is that we need to make sure
VQs are not used by guest or host while
they are deleted.

For example remove path in exiting virtio net does:
        vdev->config->reset(vdev);
        unregister_netdev(vi->dev);
        cancel_delayed_work_sync(&vi->refill);

        /* Free unused buffers in both send and recv, if any. */
        free_unused_bufs(vi);

        vdev->config->del_vqs(vi->vdev);


unregister_netdev is done before del_vqs
which makes sure guest leaves the device alone, including
napi and tx. PM will need something like this too if it
removes the VQs, otherwise any use of 'vq->' might cause a crash.

As a side note: above code is not 100% robust in theory as guest could
try using VQs after reset, and we never documented that it's ok to
access such VQs, but in practice it's safe with existing hosts, accesses
are simnply discarded.  Maybe we should just document this assumption in
the spec?

Another theoretical concern with existing code is that interrupt
handler for the device might be in progress while we do
unregister_netdev, since these are not ordered wrt
io write that does the reset.
Probably reset in virtio pci should also flush all interrupt handlers?

Any thoughts?

> Amit Shah (11):
>   virtio: pci: switch to new PM API
>   virtio-pci: add PM notification handlers for restore, freeze, thaw,
>     poweroff
>   virtio: console: Move out vq and vq buf removal into separate
>     functions
>   virtio: console: Add freeze and restore handlers to support S4
>   virtio: blk: Move out vq initialization to separate function
>   virtio: blk: Add freeze, restore handlers to support S4
>   virtio: net: Move out vq initialization into separate function
>   virtio: net: Move out vq and vq buf removal into separate function
>   virtio: net: Add freeze, restore handlers to support S4
>   virtio: balloon: Move out vq initialization into separate function
>   virtio: balloon: Add freeze, restore handlers to support S4
> 
>  drivers/block/virtio_blk.c      |   36 ++++++++++--
>  drivers/char/virtio_console.c   |  124 ++++++++++++++++++++++++++++++---------
>  drivers/net/virtio_net.c        |   98 ++++++++++++++++++++++---------
>  drivers/virtio/virtio_balloon.c |   65 +++++++++++++++------
>  drivers/virtio/virtio_pci.c     |   57 +++++++++++++++++-
>  include/linux/virtio.h          |    4 +
>  6 files changed, 301 insertions(+), 83 deletions(-)
> 
> -- 
> 1.7.6.2
