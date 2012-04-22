Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab2DVQDL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 12:03:11 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53155 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab2DVQDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 12:03:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jim Paris <jim@jtan.com>
Cc: linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20120422043655.GA27861@psychosis.jim.sh>
	<ef67a489-94bc-4f97-903d-907ab974537c@email.android.com>
	<20120422141106.GA3021@psychosis.jim.sh>
Date: Sun, 22 Apr 2012 09:07:11 -0700
In-Reply-To: <20120422141106.GA3021@psychosis.jim.sh> (Jim Paris's message of
	"Sun, 22 Apr 2012 10:11:06 -0400")
Message-ID: <m14nsbwy1c.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19ffldKEjV7jYti64DX1NX1toCnnx6vDv0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0282]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 T_XMDrugObfuBody_14 obfuscated drug references
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jim Paris <jim@jtan.com>
X-Spam-Relay-Country: **
Subject: Re: udev missing events?
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Paris <jim@jtan.com> writes:

> Eric W. Biederman wrote:
>> Jim Paris <jim@jtan.com> wrote:
>> 
>> >(cc'd Eric and Milan because 5f71a296 and ebf4127c might be related)
>> >
>> >I'm trying to track down a problem that started with virt-manager not
>> >being able to connect to libvirtd.  Long story short, the problem is
>> >that "udevadm settle" is timing out, with no events in the udev queue.
>> >
>> >(I know it's bad for libvirt to rely on "udevadm settle", but it seems
>> >that this is exposing some other problem).
>> >
>> >This is with 3.2.14 from Debian.
>> >
>> >I can trigger the problem easily by just starting libvirtd and killing
>> >it.  Then, the counters are stuck here:
>> >
>> >  # cat /sys/kernel/uevent_seqnum
>> >  13593
>> >  # od -t d2 /dev/.udev/queue.bin | head -1
>> >  0000000  13592
>> >
>> >During the libvirtd startup, I ran "udevadm monitor", which seems to
>> >indicate that 13593 never made it to udev:
>> >
>> > # udevadm monitor --kernel --property
>> >  monitor will print the received events for:
>> >  KERNEL - the kernel uevent
>> >  
>> >KERNEL[537903.765581] add      /devices/virtual/net/lo/queues/rx-0
>> >(queues)
>> >  ACTION=add
>> >  DEVPATH=/devices/virtual/net/lo/queues/rx-0
>> >  SEQNUM=13589
>> >  SUBSYSTEM=queues
>> >  UDEV_LOG=3
>> >  
>> >KERNEL[537903.765683] add      /devices/virtual/net/lo/queues/tx-0
>> >(queues)
>> >  ACTION=add
>> >  DEVPATH=/devices/virtual/net/lo/queues/tx-0
>> >  SEQNUM=13590
>> >  SUBSYSTEM=queues
>> >  UDEV_LOG=3
>> >  
>> >KERNEL[537903.844154] remove   /devices/virtual/net/lo/queues/rx-0
>> >(queues)
>> >  ACTION=remove
>> >  DEVPATH=/devices/virtual/net/lo/queues/rx-0
>> >  SEQNUM=13591
>> >  SUBSYSTEM=queues
>> >  UDEV_LOG=3
>> >  
>> >KERNEL[537903.844192] remove   /devices/virtual/net/lo/queues/tx-0
>> >(queues)
>> >  ACTION=remove
>> >  DEVPATH=/devices/virtual/net/lo/queues/tx-0
>> >  SEQNUM=13592
>> >  SUBSYSTEM=queues
>> >  UDEV_LOG=3
>> >
>> >To try to track it further, I wrote a systemtap script (available at
>> >http://jim.sh/~jim/tmp/monitor.stp).  It dumps the result of
>> >netlink_broadcast_filtered at lib/kobject_uevent.c:248, and then dumps
>> >the uevent_seqnum and environment at the end of the same function.
>> >It seems to show that netlink_broadcast_filter is failing to send out
>> >the event, with -ESRCH:
>> >
>> >  $ sudo ./monitor.stp 
>> >  begin
>> >  -----
>> >  netlink_broadcast_filtered: -3 (ESRCH)
>> >  netlink_broadcast_filtered: -3 (ESRCH)
>> >  event was:
>> >    uevent_seqnum: 13588
>> >    "ACTION=add"
>> >    "DEVPATH=/devices/virtual/net/lo"
>> >    "SUBSYSTEM=net"
>> >    "INTERFACE=lo"
>> >    "IFINDEX=68"
>> >    "SEQNUM=13588"
>> >  -----
>> >  netlink_broadcast_filtered: 0x0
>> >  netlink_broadcast_filtered: -3 (ESRCH)
>> >  event was:
>> >    uevent_seqnum: 13589
>> >    "ACTION=add"
>> >    "DEVPATH=/devices/virtual/net/lo/queues/rx-0"
>> >    "SUBSYSTEM=queues"
>> >    "SEQNUM=13589"
>> >  -----
>> >  netlink_broadcast_filtered: 0x0
>> >  netlink_broadcast_filtered: -3 (ESRCH)
>> >  event was:
>> >    uevent_seqnum: 13590
>> >    "ACTION=add"
>> >    "DEVPATH=/devices/virtual/net/lo/queues/tx-0"
>> >    "SUBSYSTEM=queues"
>> >    "SEQNUM=13590"
>> >  -----
>> >  netlink_broadcast_filtered: 0x0
>> >  netlink_broadcast_filtered: -3 (ESRCH)
>> >  event was:
>> >    uevent_seqnum: 13591
>> >    "ACTION=remove"
>> >    "DEVPATH=/devices/virtual/net/lo/queues/rx-0"
>> >    "SUBSYSTEM=queues"
>> >    "SEQNUM=13591"
>> >  -----
>> >  netlink_broadcast_filtered: 0x0
>> >  netlink_broadcast_filtered: -3 (ESRCH)
>> >  event was:
>> >    uevent_seqnum: 13592
>> >    "ACTION=remove"
>> >    "DEVPATH=/devices/virtual/net/lo/queues/tx-0"
>> >    "SUBSYSTEM=queues"
>> >    "SEQNUM=13592"
>> >  -----
>> >  netlink_broadcast_filtered: -3 (ESRCH)
>> >  netlink_broadcast_filtered: -3 (ESRCH)
>> >  event was:
>> >    uevent_seqnum: 13593
>> >    "ACTION=remove"
>> >    "DEVPATH=/devices/virtual/net/lo"
>> >    "SUBSYSTEM=net"
>> >    "INTERFACE=lo"
>> >    "IFINDEX=68"
>> >    "SEQNUM=13593"
>> >  -----
>> >  ^Cend
>> >
>> >
>> >Is it expected that those events would not be sent like that?
>> 
>> Roughly. Events for network devices are only delivered to sockets in the same netwoerk namespace.
>> 
>> So you really shouldn't see much of an event for the creationof a network namespace.
>> 
>> >If not, is there something else I can do to track this further?
>> 
>> >Or, if that's expected behavior, is there anything "udevadm settle"
>> >can do to avoid the timeout?
>> 
>> I don't think so.  Udev for the host should not see events for things that happen inside a container.
>>
>> I am a little mystified that you see as much of the add of lo as you do in the udem monitor command.
>> 
>> I am infering what is going on with libvirt and your machine and assuming containers are involved because of the additions and removals of lo.
>
> I'm not using them on purpose, but it's caused by a probing clone() in
> libvirt's lxcContainerAavilable, followed by a "ip link set lo netns -1"
> in lxcCheckNetNsSupport.  It can be recreated with just:
>
>   #include <unistd.h>
>   #include <sched.h>
>   static int dummy(void *argv) { _exit(0); }
>   main() {
>           char stack[4096];
>           clone(dummy, stack+4096, CLONE_NEWNET, NULL);
>           wait();
>           system("ip link set lo netns -1");
>   }
>
> Running that program causes "udevadm settle" to stop working due to
> the filtered events.

By stop working you mean "udevadm settle" waits because it thinks there
are unprocessed events but those events are never found, and eventually
"udevadm settle" times out?

I'm sorry I don't see the problem.

I think the most we could do would be to have a per network namespace
sequence number, but I don't get see the problem with skipping a sequence
number or two.  Does that cause udev to explode or something?  It
doesn't sound like udev has problems.

It does look like we aren't filtering all of the events for the new
loopback device properly.  We should be filtering the events for
/sys/devices/virtual/net/lo/queues/rx-0 and friends.  But fixing that
problem looks like it will only make the gap in sequence numbers
larger, and if anything make the "udevadm settle" problem worse.

What precisely is the problem you are seeing?

Of course in this instance I can't see how the version of libvirt you
are playing with would ever have worked.  It is relying on features to
act in a way the simply don't act.

Eric
