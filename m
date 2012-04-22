Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601Ab2DVEn7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 00:43:59 -0400
Received: from jim.sh ([75.150.123.25]:43901 "EHLO psychosis.jim.sh"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab2DVEn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 00:43:57 -0400
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Apr 2012 00:43:57 EDT
Date: Sun, 22 Apr 2012 00:36:55 -0400
From: Jim Paris <jim@jtan.com>
To: linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Milan Broz <mbroz@redhat.com>
Subject: udev missing events?
Message-ID: <20120422043655.GA27861@psychosis.jim.sh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'd Eric and Milan because 5f71a296 and ebf4127c might be related)

I'm trying to track down a problem that started with virt-manager not
being able to connect to libvirtd.  Long story short, the problem is
that "udevadm settle" is timing out, with no events in the udev queue.

(I know it's bad for libvirt to rely on "udevadm settle", but it seems
that this is exposing some other problem).

This is with 3.2.14 from Debian.

I can trigger the problem easily by just starting libvirtd and killing
it.  Then, the counters are stuck here:

  # cat /sys/kernel/uevent_seqnum
  13593
  # od -t d2 /dev/.udev/queue.bin | head -1
  0000000  13592

During the libvirtd startup, I ran "udevadm monitor", which seems to
indicate that 13593 never made it to udev:

 # udevadm monitor --kernel --property
  monitor will print the received events for:
  KERNEL - the kernel uevent
  
  KERNEL[537903.765581] add      /devices/virtual/net/lo/queues/rx-0 (queues)
  ACTION=add
  DEVPATH=/devices/virtual/net/lo/queues/rx-0
  SEQNUM=13589
  SUBSYSTEM=queues
  UDEV_LOG=3
  
  KERNEL[537903.765683] add      /devices/virtual/net/lo/queues/tx-0 (queues)
  ACTION=add
  DEVPATH=/devices/virtual/net/lo/queues/tx-0
  SEQNUM=13590
  SUBSYSTEM=queues
  UDEV_LOG=3
  
  KERNEL[537903.844154] remove   /devices/virtual/net/lo/queues/rx-0 (queues)
  ACTION=remove
  DEVPATH=/devices/virtual/net/lo/queues/rx-0
  SEQNUM=13591
  SUBSYSTEM=queues
  UDEV_LOG=3
  
  KERNEL[537903.844192] remove   /devices/virtual/net/lo/queues/tx-0 (queues)
  ACTION=remove
  DEVPATH=/devices/virtual/net/lo/queues/tx-0
  SEQNUM=13592
  SUBSYSTEM=queues
  UDEV_LOG=3

To try to track it further, I wrote a systemtap script (available at
http://jim.sh/~jim/tmp/monitor.stp).  It dumps the result of
netlink_broadcast_filtered at lib/kobject_uevent.c:248, and then dumps
the uevent_seqnum and environment at the end of the same function.
It seems to show that netlink_broadcast_filter is failing to send out
the event, with -ESRCH:

  $ sudo ./monitor.stp 
  begin
  -----
  netlink_broadcast_filtered: -3 (ESRCH)
  netlink_broadcast_filtered: -3 (ESRCH)
  event was:
    uevent_seqnum: 13588
    "ACTION=add"
    "DEVPATH=/devices/virtual/net/lo"
    "SUBSYSTEM=net"
    "INTERFACE=lo"
    "IFINDEX=68"
    "SEQNUM=13588"
  -----
  netlink_broadcast_filtered: 0x0
  netlink_broadcast_filtered: -3 (ESRCH)
  event was:
    uevent_seqnum: 13589
    "ACTION=add"
    "DEVPATH=/devices/virtual/net/lo/queues/rx-0"
    "SUBSYSTEM=queues"
    "SEQNUM=13589"
  -----
  netlink_broadcast_filtered: 0x0
  netlink_broadcast_filtered: -3 (ESRCH)
  event was:
    uevent_seqnum: 13590
    "ACTION=add"
    "DEVPATH=/devices/virtual/net/lo/queues/tx-0"
    "SUBSYSTEM=queues"
    "SEQNUM=13590"
  -----
  netlink_broadcast_filtered: 0x0
  netlink_broadcast_filtered: -3 (ESRCH)
  event was:
    uevent_seqnum: 13591
    "ACTION=remove"
    "DEVPATH=/devices/virtual/net/lo/queues/rx-0"
    "SUBSYSTEM=queues"
    "SEQNUM=13591"
  -----
  netlink_broadcast_filtered: 0x0
  netlink_broadcast_filtered: -3 (ESRCH)
  event was:
    uevent_seqnum: 13592
    "ACTION=remove"
    "DEVPATH=/devices/virtual/net/lo/queues/tx-0"
    "SUBSYSTEM=queues"
    "SEQNUM=13592"
  -----
  netlink_broadcast_filtered: -3 (ESRCH)
  netlink_broadcast_filtered: -3 (ESRCH)
  event was:
    uevent_seqnum: 13593
    "ACTION=remove"
    "DEVPATH=/devices/virtual/net/lo"
    "SUBSYSTEM=net"
    "INTERFACE=lo"
    "IFINDEX=68"
    "SEQNUM=13593"
  -----
  ^Cend


Is it expected that those events would not be sent like that?
If not, is there something else I can do to track this further?

Or, if that's expected behavior, is there anything "udevadm settle"
can do to avoid the timeout?

-jim
