Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab2DBKyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 06:54:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab2DBKya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 06:54:30 -0400
Date: Mon, 2 Apr 2012 16:24:17 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 0/2 v3] kvm: notify host when guest panicked
Message-ID: <20120402105417.GG15713@amit.redhat.com>
References: <4F58664D.1070800@cn.fujitsu.com>
 <4F66E14F.3040809@cn.fujitsu.com>
 <4F7979F9.4060509@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F7979F9.4060509@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Mon) 02 Apr 2012 [18:05:45], Wen Congyang wrote:
> At 03/19/2012 03:33 PM, Wen Congyang Wrote:
> > At 03/08/2012 03:57 PM, Wen Congyang Wrote:
> >> We can know the guest is paniced when the guest runs on xen.
> >> But we do not have such feature on kvm.
> >>
> >> Another purpose of this feature is: management app(for example:
> >> libvirt) can do auto dump when the guest is crashed. If management
> >> app does not do auto dump, the guest's user can do dump by hand if
> >> he sees the guest is paniced.
> >>
> >> I touch the hypervisor instead of using virtio-serial, because
> >> 1. it is simple
> >> 2. the virtio-serial is an optional device, and the guest may
> >>    not have such device.
> >>
> >> Changes from v2 to v3:
> >> 1. correct spelling
> >>
> >> Changes from v1 to v2:
> >> 1. split up host and guest-side changes
> >> 2. introduce new request flag to avoid changing return values.
> > 
> > Hi all:
> > 
> > we neet this feature, but we don't decide how to implement it.
> > We have two solution:
> > 1. use vmcall
> > 2. use virtio-serial.
> 
> Hi, all
> 
> There are three solutions now:
> 1. use vmcall
> 2. use I/O port
> 3. use virtio-serial.
> 
> I think 1 and 2 are more simple than 3.
> 
> I am reading virtio-serial's driver recent days. It seems that
> if the virtio serial port is not opened at the host side, the
> data writen into this port will be discarded, and we will have
> no chance to know the guest is panicked.

The qemu-side implementation should exist within qemu itself; i.e. the
consumer of the data from the kernel-side will always have a
listener.  In this case, you don't have to worry about port not being
opened on the host side.

> To Amit:
> 
> Can we write message to a virtio serial port like this directly in
> the kernel space?

As I had mentioned earlier, an in-kernel API is currently missing, but
it will be very simple to add one.

> send_buf(panicked_port, message, message's length, true);
> 
> if port->outvq_full is true, is it OK to do this?

port->outvq_full means guest has sent out data to the host, but the
host has not consumed the data yet, and has not released the buffers
back to the guest.

If you indeed reach such a situation (essentially you should never,
there are enough buffers already to account for scheduling delays),
then newer data will be discarded, or you will have to wait to write
the newer data till the host-side frees up buffers in the virtqueues.

This isn't really different from other approaches -- if you use a
shared buffer between guest and host, and if the guest has new data
before the host has had a chance to read off the older buffer
contents, you either overwrite or wait for the host to read the older
stuff.


		Amit
