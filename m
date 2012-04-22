Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751122Ab2DVQyH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 12:54:07 -0400
Received: from jim.sh ([75.150.123.25]:42815 "EHLO psychosis.jim.sh"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017Ab2DVQyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 12:54:04 -0400
Date: Sun, 22 Apr 2012 12:54:01 -0400
From: Jim Paris <jim@jtan.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: udev missing events?
Message-ID: <20120422165401.GA16163@psychosis.jim.sh>
References: <20120422043655.GA27861@psychosis.jim.sh>
 <ef67a489-94bc-4f97-903d-907ab974537c@email.android.com>
 <20120422141106.GA3021@psychosis.jim.sh>
 <m14nsbwy1c.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m14nsbwy1c.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> > I'm not using them on purpose, but it's caused by a probing clone() in
> > libvirt's lxcContainerAavilable, followed by a "ip link set lo netns -1"
> > in lxcCheckNetNsSupport.  It can be recreated with just:
> >
> >   #include <unistd.h>
> >   #include <sched.h>
> >   static int dummy(void *argv) { _exit(0); }
> >   main() {
> >           char stack[4096];
> >           clone(dummy, stack+4096, CLONE_NEWNET, NULL);
> >           wait();
> >           system("ip link set lo netns -1");
> >   }
> >
> > Running that program causes "udevadm settle" to stop working due to
> > the filtered events.
> 
> By stop working you mean "udevadm settle" waits because it thinks there
> are unprocessed events but those events are never found, and eventually
> "udevadm settle" times out?

Yeah.

> I'm sorry I don't see the problem.
> 
> I think the most we could do would be to have a per network namespace
> sequence number, but I don't get see the problem with skipping a sequence
> number or two.  Does that cause udev to explode or something?  It
> doesn't sound like udev has problems.
> 
> It does look like we aren't filtering all of the events for the new
> loopback device properly.  We should be filtering the events for
> /sys/devices/virtual/net/lo/queues/rx-0 and friends.  But fixing that
> problem looks like it will only make the gap in sequence numbers
> larger, and if anything make the "udevadm settle" problem worse.
> 
> What precisely is the problem you are seeing?

The specific problem is that virt-manager loses its connection to
libvirt.  Libvirt triggers this situation, and then later executes
"udevadm settle" after some of virt-manager's storage requests.  I
think that happens in one thread, while another libvirt thread then
kills the virt-manager connection for stalling for so long.

I can certainly ask the libvirt guys to add a shorter --timeout
parameter, at the very least, if this isn't considered a bug from the
udev point of view.  But libvirt isn't the only thing that calls
"udevadm settle" -- having to wait 2-3 minutes for each settle call
during an initramfs build or similar would also be annoying.

> Of course in this instance I can't see how the version of libvirt you
> are playing with would ever have worked.  It is relying on features to
> act in a way the simply don't act.

I upgraded libvirt and the kernel lately, so either some of this lxc
probing code in libvirt is new, or maybe my kernel didn't support net
namespaces before.  Libvirt has called udevadm settle for a while,
though.

Thanks,
-jim
